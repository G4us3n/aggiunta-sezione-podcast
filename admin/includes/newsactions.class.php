<?php
class NewsActions {
    private $userActions;
    private $programActions;
    private $tagActions;
    private $news;

    public function __construct($userActions, $programActions) {
        $this->userActions    = $userActions;
        $this->programActions = $programActions;
        $this->validateUserActions();
        $this->validateProgramActions();
    }

    public function initializeTagActions() {
        $this->tagActions = new TagActions($this->programActions);
    }

    public function setNews($news) {
        $this->validateNews($news);
        $this->validateUserEligibility();
        $this->verifyPermissions($news->programmi_id);
        $this->news = $news;
    }

    public function getCurrentNews() {
        return $this->news;
    }

    public function validateCurrentNews() {
        $this->validateNews($this->news);
    }

    public function validateUserActions() {
        if(get_class($this->userActions) != 'UserActions') {
            throw new Exception("UserActions reference not valid!");            
        }
    }

    public function validateProgramActions() {
        if(get_class($this->programActions) != 'ProgramActions') {
            throw new Exception("ProgramActions reference not valid!");         
        }
    }

    public function validateUserEligibility() {
        $this->userActions->validateCurrentUser();
        if(!$this->programActions->isUserLoggedForRedaction()) {
            $this->programActions->validateCurrentProgram();
        }
    }

    public function verifyPermissions($programID) {
        $thisID = $this->programActions->getCurrentProgram() != null ? $this->programActions->getCurrentProgram()->id : null;
        if(!$this->programActions->isUserLoggedForRedaction(1) && $programID != $thisID) {
            throw new Exception("Non hai i permessi per eseguire questa azione!");          
        }
    }

    public function deleteImg($imgName) {
        $this->validateUserEligibility();
        $check = $this->programActions->isUserLoggedForRedaction(1);
        $programTAG = $check ? 'redazione' : $this->programActions->getCurrentProgram()->tag;
        $programID  = $check ? '-1' : $this->programActions->getCurrentProgram()->id;
        $path = dirname(__FILE__).'/../../photos/news/'.$programTAG.'/';
        if(!is_file($path.$imgName)) {
            throw new Exception("Immagine non trovata!");
        }
        if($check) {
            $news = NewsProgrammi::count(array('conditions' => array('global = 1 AND foto = ?', $imgName)));
        }
        else {
            $news = NewsProgrammi::count(array('conditions' => array('programmi_id = ? AND foto = ?', $programID, $imgName)));
        }
        if($news > 0) {
            throw new Exception("Impossibile cancellare questa copertina (&egrave; utilizzata in ".$news." news)");
        }
        unlink($path.$imgName);
        unlink($path.'thumbs/'.$imgName);
    }

    public function creaNews($params) {
        $this->validateUserEligibility();
        $check = $this->programActions->isUserLoggedForRedaction();
        $allow = array('titolo', 'sottotitolo', 'foto', 'testo', 'media', 'tags', 'visibile', 'metatype', 'cover_alignment', 'home_alignment','copyright');
        if(count($allow) != count($params)) {
            throw new Exception("Parametri non validi!");   
        }
        foreach($allow as $key) {
            if(!isset($params[$key])) {
                throw new Exception("Parametri non validi!");               
            }
        }
        $tags = $params['tags'];
        unset($params['tags']);
        if(!$check) {
            $program = $this->programActions->getCurrentProgram();
        }
        $user = $this->userActions->getCurrentUser();
        $params['testo'] = $this->parseText($params['testo']);
        $this->validateTitolo($params['titolo']);
        $this->validateSottotitolo($params['sottotitolo']);
        $this->validateFoto($params['foto']);
        $this->validateTesto($params['testo']);
        $this->validateVisibile($params['visibile']);
        $this->validateCopyright($params['copyright']);
        $this->validateMetaType($params['metatype']);
        $news = new NewsProgrammi();
        foreach($params as $key => $value) {
            $news->$key = $value;
        }
        $news->programmi_id = $check ? null : $program->id;
        $news->global = $check ? 1 : 0;
        $news->utenti_id = $user->id;
        $news->anno = date('Y');
        $news->mese = date('m');
        $news->time = time();
        $news->views = 0;
        $news->visibile = $params['visibile'];
        $news->copyright = $params['copyright'];
        $news->save();
        if($news->is_invalid()) {
            throw new Exception($news->errors->full_messages());
        }
        $this->tagActions->appendTags($tags, $news);
        $data = $news->to_json();
        $data = json_decode($data, true);
        $data['userID']        = $this->userActions->getCurrentUser()->id;
        $data['userNome']      = $this->userActions->getCurrentUser()->nome;
        $data['userCognome']   = $this->userActions->getCurrentUser()->cognome;
        $data['programmaID']   = $check ? 'redazione' : $this->programActions->getCurrentProgram()->id;
        $data['programmaNome'] = $check ? 'redazione' : $this->programActions->getCurrentProgram()->nome;
        $data = json_encode($data);
        EventLogger::log('creaNews()', $data, $this->userActions->getCurrentUser(), $this->programActions->getCurrentProgram());
        return $news->id;
    }

    public function validateNews($news) {
        if(!is_object($news)) {
            throw new Exception("Variabile \$news non valida!");
        }
        if(get_class($news) != 'NewsProgrammi') {
            throw new Exception("Variabile \$news non valida!");            
        }
        if(!isset($news->id)) {
            throw new Exception("News non valida!");
        }
    }

    public function parseText($text){
        $text = str_replace(array('<', '>'), array('&lt;', '&gt;'), $text);
        return $text;
    }

    public function validateVisibile($visibile) {
        if(!is_numeric($visibile) || ($visibile != 0 && $visibile != 1)) {
            throw new Exception("Visibilit&agrave; non valida!");
        }
    }
    
    public function validateCopyright($copyright) {
        if(!is_numeric($copyright) || ($copyright != 0 && $copyright != 1)) {
            throw new Exception("Copyright non valido!");
        }
    }


    public function validateAutore($utenti_id) {
        $utente = Utenti::first($utenti_id);
        if(!$utente) {
            throw new Exception("Autore non valido!");
        }
    }

    public function validateTitolo($titolo) {
        if(strlen($titolo) == 0 || strlen($titolo) > 60) {
            throw new Exception("Titolo non valido. Deve essere compreso da 0 e 60 caratteri!");
        }
    }

    public function validateSottotitolo($sottotitolo) {
        if(strlen($sottotitolo) == 0 || strlen($sottotitolo) > 255) {
            throw new Exception("Sottotitolo non valido. Deve essere compreso da 0 e 255 caratteri!");
        }
    }

    public function validateFoto($foto) {
        $tag = $this->programActions->isUserLoggedForRedaction() ? 'redazione' : $this->programActions->getCurrentProgram()->tag;
        if(strlen($foto) == 0 || !is_file(dirname(__FILE__).'/../../photos/news/'.$tag.'/'.$foto)) {
            throw new Exception("Foto non impostata!");
        }
    }

    public function validateMetaType($metaType) {
        if($metaType != 0 && $metaType != 1) {
            throw new Exception("Meta Description non valido!");            
        }
    }

    public function validateCoverAlignment($coverAlignment) {
        if($coverAlignment != 'top' && $coverAlignment != 'center' && $coverAlignment != 'bottom') {
            throw new Exception("Allineamneto cover foto non valido!");
        }
    }

    public function validateHomeAlignment($coverAlignment) {
        if($coverAlignment != 'top' && $coverAlignment != 'center' && $coverAlignment != 'bottom') {
            throw new Exception("Allineamnetohome foto non valido!");
        }
    }

    public function validateTesto($testo) {
        if(strlen($testo) == 0) {
            throw new Exception("Testo vuoto!");
        }
    }

    public function changeVisibility($newsID = '') {
        if($newsID == '') {
            $news = $this->getCurrentNews();
        }
        else {
            $news = NewsProgrammi::first($newsID);
        }
        $this->setNewsData($news, 'visibile', 1-$news->visibile);
        return 'News \'<b>'.hfix($news->titolo).'</b>\' impostata come '.($news->visibile ? 'visibile' : 'non visibile');
    }
    public function changeCopyright($newsID = '') {
        if($newsID == '') {
            $news = $this->getCurrentNews();
        }
        else {
            $news = NewsProgrammi::first($newsID);
        }
        $this->setNewsData($news, 'copyright', 1-$news->copyright);
        return 'News \'<b>'.hfix($news->titolo).'</b>\' copyright impostato come '.($news->copyright ? 'Si' : 'No');
    }

    private function setNewsData($news, $data, $value) {
        $this->validateNews($news);
        $this->validateUserEligibility();
        $this->verifyPermissions($news->programmi_id);
        if($news->programmi_id == null) {
            if($news->utenti_id != $this->userActions->getCurrentUser()->id && !$this->programActions->isUserLoggedForRedaction(1)) {
                throw new Exception('Non hai i permessi per modificare questa news!');
            }
        }
        $news->$data = $value;
        $news->save();
        if($news->is_invalid()) {
            throw new Exception($news->errors->full_messages());
        }
        $check = $this->programActions->isUserLoggedForRedaction();
        $logData = array(
            'userID'      => $this->userActions->getCurrentUser()->id,
            'userNome'    => $this->userActions->getCurrentUser()->nome,
            'userCognome' => $this->userActions->getCurrentUser()->cognome,
            'programID'   => $check ? 'redazione' : $this->programActions->getCurrentProgram()->id,
            'programNome' => $check ? 'redazione' : $this->programActions->getCurrentProgram()->nome,
            'newsID'      => $news->id,
            'newsTitolo'  => $news->titolo,
            $data         => $value,
            'parameter'   => $data
        );
        EventLogger::log('setNewsData()', json_encode($logData), $this->userActions->getCurrentUser());
    }

    public function getNewsOfPage($page = 0, $programID = '', $limit = 10, $admin = 0) {
        $getPage = $page*$limit;
        if($admin) {
            return NewsProgrammi::find('all', array('order' => 'time DESC', 'limit' => $limit, 'offset' => $getPage));
        }
        $check = $this->programActions->isUserLoggedForRedaction();
        if($programID == '' && !$check) {
            $programID = $this->programActions->getCurrentProgram()->id;
        }
        if($check) {
            $news = NewsProgrammi::find('all', array('conditions' => array('global = 1'), 'order' => 'time DESC', 'limit' => $limit, 'offset' => $getPage));
        }
        else {
            $news = NewsProgrammi::find('all', array('conditions' => array('programmi_id = ?', $programID), 'order' => 'time DESC', 'limit' => $limit, 'offset' => $getPage));
        }
        return $news;
    }

    public function getPageNumber($newsCount, $limit = 10) {
        return ceil($newsCount/$limit);
    }

    public function getNewsCount($programID = '', $admin = 0) {
        if($admin) {
            return NewsProgrammi::count();
        }
        $check = $this->programActions->isUserLoggedForRedaction();
        if($programID == '' && !$check) {
            $programID = $this->programActions->getCurrentProgram()->id;
        }
        if($check) {
            return NewsProgrammi::count(array('conditions' => array('global = 1')));
        }
        else {
            return NewsProgrammi::count(array('conditions' => array('programmi_id = ?', $programID)));
        }
    }

    public function deleteNews($id) {
        $news = NewsProgrammi::first($id);
        $this->validateNews($news);
        $this->verifyPermissions($news->programmi_id);
        if($news->programmi_id == null) {
            if(!$this->programActions->isUserLoggedForRedaction(1) && $news->utenti_id != $this->userActions->getCurrentUser()->id) {
                throw new Exception("Non sei abilitato a cancellare una news!");
            }
        }
        $data = $news->to_json();
        $data = json_decode($data, true);
        $data['userID']      = $this->userActions->getCurrentUser()->id;
        $data['userNome']    = $this->userActions->getCurrentUser()->nome;
        $data['userCognome'] = $this->userActions->getCurrentUser()->cognome;
        EventLogger::log('deleteNews()', json_encode($data));
        $title = $news->titolo;
        $news->delete();
        return hfix($title);
    }

    public function getAllTags() {
        if($this->programActions->isUserLoggedForRedaction()) {
            $tags = RedazioneTag::all();
        } else {
            $tags = ProgrammiTag::all(array('conditions' => array('programmi_id = ?', $this->programActions->getCurrentProgram()->id)));
        }
        $returnArray = array();
        foreach($tags as $tag) {
            $returnArray[] = $tag->tag;
        }
        return json_encode($returnArray);
    }

    public function getAllProgramTags() {
        $tags = Programmi::all(array('select' => 'tag'));
        $returnArray = array();
        foreach($tags as $tag) {
            $returnArray[] = $tag->tag;
        }
        return json_encode($returnArray);
    }

    public function getTags($news) {
        return $this->tagActions->getTags($news);
    }

    public function editDate($data) {
        $this->validateCurrentNews();
        $news = $this->getCurrentNews();
        $time = strtotime($data);
        if($news->time == $time) return;
        $this->setNewsData($news, 'mese', date('m', $time));
        $this->setNewsData($news, 'anno', date('Y', $time));
        $this->setNewsData($news, 'time', $time);
    }

    public function editAutore($utenti_id) {
        $this->validateCurrentNews();
        if(!$this->programActions->isUserLoggedForRedaction(1)) {
                        throw new Exception("Non hai i permessi per eseguire questa azione!");
                }
        $news = $this->getCurrentNews();
        if($news->utenti_id == $utenti_id) return;
        $this->validateAutore($utenti_id);
        $this->setNewsData($news, 'utenti_id', $utenti_id);
    }

    public function editTitolo($titolo) {
        $this->validateCurrentNews();
        $news = $this->getCurrentNews();
        if($news->titolo == $titolo) return;
        $this->validateTitolo($titolo);
        $this->setNewsData($news, 'titolo', $titolo);
    }

    public function editCoverAlignment($coverAlignment) {
        $this->validateCurrentNews();
        $news = $this->getCurrentNews();
        if($news->cover_alignment == $coverAlignment) return;
        $this->validateCoverAlignment($coverAlignment);
        $this->setNewsData($news, 'cover_alignment', $coverAlignment);
    }

    public function editHomeAlignment($coverAlignment) {
        $this->validateCurrentNews();
        $news = $this->getCurrentNews();
        if($news->home_alignment == $coverAlignment) return;
        $this->validateHomeAlignment($coverAlignment);
        $this->setNewsData($news, 'home_alignment', $coverAlignment);
    }

    public function editMetaType($metaType) {
        $this->validateCurrentNews();
        $news = $this->getCurrentNews();
        if($news->metatype == $metaType) return;
        $this->validateMetaType($metaType);
        $this->setNewsData($news, 'metatype', $metaType);
    }

    public function editSottotitolo($sottotitolo) {
        $this->validateCurrentNews();
        $news = $this->getCurrentNews();
        if($news->sottotitolo == $sottotitolo) return;
        $this->validateSottotitolo($sottotitolo);
        $this->setNewsData($news, 'sottotitolo', $sottotitolo);
    }

    public function editFoto($foto) {
        $this->validateCurrentNews();
        $news = $this->getCurrentNews();
        if($news->foto == $foto) return;
        $this->validateFoto($foto);
        $this->setNewsData($news, 'foto', $foto);
    }

    public function editTesto($testo) {
        $this->validateCurrentNews();
        $news = $this->getCurrentNews();
        if($news->testo == $testo) return;
        $this->validateTesto($testo);
        $this->setNewsData($news, 'testo', $this->parseText($testo));
    }

    public function editMedia($media) {
        $this->validateCurrentNews();
        $news = $this->getCurrentNews();
        if($news->media == $media) return;
        $this->setNewsData($news, 'media', $media);
    }

    public function editVisibile($visibile) {
        $this->validateCurrentNews();
        $news = $this->getCurrentNews();
        if($news->visibile == $visibile) return;
        $this->changeVisibility();
    }

    public function editCopyright($copyright) {
        $this->validateCurrentNews();
        $news = $this->getCurrentNews();
        if($news->copyright == $copyright) return;
        $this->changeCopyright();
    }

    public function editTags($tags) {
        $this->validateCurrentNews();
        $news = $this->getCurrentNews();
        $newsTags = $this->getTags($news);
        if($newsTags == $tags) return;
        $this->tagActions->appendTags($tags, $this->getCurrentNews());
    }

    public function associatePodcast($podcastID) {
        $this->validateCurrentNews();
        $news = $this->getCurrentNews();
        if($podcastID != '') {
            $podcast = PodcastProgrammi::first($podcastID);
            if(!$podcast || $podcast->programmi_id != $news->programmi_id) {
                throw new Exception("Podcast non trovato!");            
            }
            $sel = NewsProgrammiPodcastProgrammi::first(array('conditions' => 'newsprogrammi_id = '.$news->id.' AND podcastprogrammi_id = '.$podcast->id));
            if(!$sel) {
                $assoc = new NewsProgrammiPodcastProgrammi();
                $assoc->newsprogrammi_id = $news->id;
                $assoc->podcastprogrammi_id = $podcast->id;
                $assoc->save();
            }
            else {
                return;
            }
        }
        $logData = array(
            'userID'      => $this->userActions->getCurrentUser()->id,
            'userNome'    => $this->userActions->getCurrentUser()->nome,
            'userCognome' => $this->userActions->getCurrentUser()->cognome,
            'newsID'      => $news->id,
            'newsTitolo'  => $news->titolo,
            'podcastiD'   => $podcast->id
        );
        EventLogger::log('addPodcastNewsAssociation()', json_encode($logData), $this->userActions->getCurrentUser());
    }

    public function removeAssociatedPodcast($podcastID) {
        $this->validateCurrentNews();
        $news = $this->getCurrentNews();
        if($podcastID != '') {
            $podcast = PodcastProgrammi::first($podcastID);
            if(!$podcast) {
                throw new Exception("Podcast non trovato!");            
            }
            $sel = NewsProgrammiPodcastProgrammi::first(array('conditions' => 'newsprogrammi_id = '.$news->id.' AND podcastprogrammi_id = '.$podcast->id));
            if($sel) {
                $sel->delete();
            }
            else {
                return;
            }
        }
        $logData = array(
            'userID'      => $this->userActions->getCurrentUser()->id,
            'userNome'    => $this->userActions->getCurrentUser()->nome,
            'userCognome' => $this->userActions->getCurrentUser()->cognome,
            'newsID'      => $news->id,
            'newsTitolo'  => $news->titolo,
            'podcastiD'   => $podcast->id
        );
        EventLogger::log('removePodcastNewsAssocation()', json_encode($logData), $this->userActions->getCurrentUser());
    }
}
?>
