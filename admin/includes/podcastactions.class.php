<?php
class PodcastActions {
    private $userActions;
    private $programActions;
    private $tagActions;
    private $podcast;

    public function __construct($userActions, $programActions) {
        $this->userActions    = $userActions;
        $this->programActions = $programActions;
        $this->validateUserActions();
        $this->validateProgramActions();
    }

    public function initializeTagActions() {
        $this->tagActions = new TagActions($this->programActions);
    }

    public function validateUserActions() {
        if(get_class($this->userActions) != 'UserActions') {
            throw new Exception("UserActions reference not valid!");            
        }
    }

    public function setPodcast($podcast) {
        $this->validatePodcast($podcast);
        $this->validateUserEligibility();
        $this->verifyPermissions($podcast->programmi_id);
        $this->podcast = $podcast;
    }

    public function getCurrentPodcast() {
        return $this->podcast;
    }

    public function validateCurrentPodcast() {
        $this->validatePodcast($this->podcast);
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

    public function creaPodcast($params) {
        $this->validateUserEligibility();
        $check = $this->programActions->isUserLoggedForRedaction();
        //$allow = array('titolo', 'testo', 'link', 'tags', 'visibile', 'giorno', 'mese', 'anno');
        //$allow = array('link', 'tags', 'visibile', 'giorno', 'mese', 'anno');
        //$allow = array('link', 'visibile', 'giorno', 'mese', 'anno', 'link_youtube');
        $allow = array('link', 'visibile', 'data', 'link_youtube');
        if(count($allow) != count($params)) {
            throw new Exception("Parametri non validi!");
        }
        foreach($allow as $key) {
            if(!isset($params[$key])) {
                throw new Exception("Parametri non validi!");
            }
        }
        /*
        $tags = $params['tags'];
        unset($params['tags']);
        */
        if(!$check) {
            $program = $this->programActions->getCurrentProgram();
        }
        $user = $this->userActions->getCurrentUser();
        //$params['testo'] = $this->parseText($params['testo']);
        //$this->validateTitolo($params['titolo']);
        //$this->validateTesto($params['testo']);
        $this->validateLink($params['link']);
        $this->validateLinkYoutube($params['link_youtube']);
        $this->validateVisibile($params['visibile']);
        //$this->validatePodcastDate($params['giorno'], $params['mese'], $params['anno']);
        $date = $this->validatePodcastDate($params['data']);
        $podcast = new PodcastProgrammi();
        unset($params['data']);
        foreach($params as $key => $value) {
            $podcast->$key = $value;
        }
        $podcast->programmi_id = $check ? null : $program->id;
        $podcast->global = $check ? 1 : 0;
        $podcast->utenti_id = $user->id;
        $podcast->anno   = $date[2];
        $podcast->mese   = $date[1];
        $podcast->giorno = $date[0];
        $podcast->time = time();
        //$podcast->views = 0;
        $podcast->visibile = $params['visibile'];
        $podcast->save();
        if($podcast->is_invalid()) {
            throw new Exception($podcast->errors->full_messages());
        }
        /*
        $this->tagActions->appendTags($tags, $podcast);
        */
        $data = $podcast->to_json();
        $data = json_decode($data, true);
        $data['userID']        = $this->userActions->getCurrentUser()->id;
        $data['userNome']      = $this->userActions->getCurrentUser()->nome;
        $data['userCognome']   = $this->userActions->getCurrentUser()->cognome;
        $data['programmaID']   = $check ? 'redazione' : $this->programActions->getCurrentProgram()->id;
        $data['programmaNome'] = $check ? 'redazione' : $this->programActions->getCurrentProgram()->nome;
        $data = json_encode($data);
        EventLogger::log('creapodcast()', $data, $this->userActions->getCurrentUser(), $this->programActions->getCurrentProgram());
        return $podcast->id;
    }

    //public function validatePodcastDate($day, $month, $year) {
    public function validatePodcastDate($date) {
        $date = explode("/", $date);
        if(count($date) != 3) {
            throw new Exception("Data non valida!");
        }

        $day   = (int)$date[0];
        $month = (int)$date[1];
        $year  = (int)$date[2];

        $this->validateGiorno($day);
        $this->validateMese($month);
        $this->validateAnno($year);
        $time = mktime(0, 0, 0, $month, $day, $year);
        if($time > time()) {
            throw new Exception("Data non valida!");
        }

        return array($day, $month, $year);
    }

    public function validateGiorno($day) {
        if($day < 1 || $day > 31) {
            throw new Exception("Giorno non valido");
        }
    }

    public function validateMese($month) {
        if($month < 1 || $month > 12) {
            throw new Exception("Mese non valido");
        }
    }

    public function validateAnno($year) {
        if($year < 2007 || $year > date('Y')) {
            throw new Exception("Anno non valido");
        }
    }

    public function validateVisibile($visibile) {
        if(!is_numeric($visibile) || ($visibile != 0 && $visibile != 1)) {
            throw new Exception("Visibilit&agrave; non valida!");
        }
    }

    /*
    public function validateTitolo($titolo) {
        if(strlen($titolo) == 0 || strlen($titolo) > 40) {
            throw new Exception("Titolo non valido. Deve essere compreso da 0 e 40 caratteri!");
        }
    }
    */
    /*
    public function validateTesto($testo) {
        if(strlen($testo) == 0) {
            throw new Exception("Testo vuoto!");
        }
    }
    */
    public function validateLink($link) {
        if(!preg_match('/(http|https):\/\/(www\.)?mixcloud\.com\/(.*)$/i', $link)) {
            throw new Exception("Link non valido!");
        }
        if(!$this->linkUnique($link)) {
            throw new Exception("Questo podcast &egrave; gi&agrave; stato pubblicato!");
        }
    }

    public function validateLinkYoutube($link) {
        if(!preg_match('/(http|https):\/\/(www\.)?youtube\.com\/(.*)$/i', $link) && strlen($link) > 0) {
            throw new Exception("Link youtube non valido!");
        }
    }

    public function linkUnique($link) {
        $link = PodcastProgrammi::find('first', array('conditions' => array('link = ?', $link)));
        if($link) {
            return false;
        }
        else {
            return true;
        }
    }

    public function validatePodcast($podcast) {
        if(!is_object($podcast)) {
            throw new Exception("Variabile \$podcast non valida!");
        }
        if(get_class($podcast) != 'PodcastProgrammi') {
            throw new Exception("Variabile \$podcast non valida!");
        }
        if(!isset($podcast->id)) {
            throw new Exception("Podcast non valido!");
        }
    }

    public function validateNews($newsID) {
        if($newsID == '') return;
        $news = NewsProgrammi::first($newsID);
        if(!$news) {
            throw new Exception("News non valida!");
        }
    }

    public function parseText($text){
        $text = hfix($text);
        $find = array('[b]','[/b]','[i]','[/i]','[u]','[/u]');
        $replace = array('<b>', '</b>','<i>','</i>','<u>','</u>');
        $text = str_replace($find, $replace, $text);
        $text = str_replace("\n", "<br>\n", $text);
        $text = preg_replace('/\[url=(.*?)\](.*?)\[\/url\]/i', '<a href="$1">$2</a>', $text);
        return $text;
    }

    public function changeVisibility($podcastID = '') {
        if($podcastID == '') {
            $podcast = $this->getCurrentPodcast();
        }
        else {
            $podcast = PodcastProgrammi::first($podcastID);
        }
        $this->setPodcastData($podcast, 'visibile', 1-$podcast->visibile);
        return 'Podcast \'<b>'.hfix($podcast->giorno."-".$podcast->mese."-".$podcast->anno).'</b>\' impostato come '.($podcast->visibile ? 'visibile' : 'non visibile');
    }

    private function setPodcastData($podcast, $data, $value) {
        $this->validatePodcast($podcast);
        $this->validateUserEligibility();
        $this->verifyPermissions($podcast->programmi_id);
        $podcast->$data = $value;
        $podcast->save();
        if($podcast->is_invalid()) {
            throw new Exception($podcast->errors->full_messages());
        }
        $check = $this->programActions->isUserLoggedForRedaction();
        $logData = array(
            'userID'      => $this->userActions->getCurrentUser()->id,
            'userNome'    => $this->userActions->getCurrentUser()->nome,
            'userCognome' => $this->userActions->getCurrentUser()->cognome,
            'programID'   => $check ? 'redazione' : $this->programActions->getCurrentProgram()->id,
            'programNome' => $check ? 'redazione' : $this->programActions->getCurrentProgram()->nome,
            'podcastID'      => $podcast->id,
            //'podcastTitolo'  => $podcast->titolo,
            $data         => $value,
            'parameter'   => $data
        );
        EventLogger::log('setPodcastData()', json_encode($logData), $this->userActions->getCurrentUser());
    }

    public function getPodcastOfPage($page = 0, $programID = '', $limit = 10, $admin = 0) {
        $getPage = $page*$limit;
        if($admin) {
            return PodcastProgrammi::find('all', array('order' => 'anno DESC, mese DESC, giorno DESC', 'limit' => $limit, 'offset' => $getPage));
        }
        $check = $this->programActions->isUserLoggedForRedaction();
        if($programID == '' && !$check) {
            $programID = $this->programActions->getCurrentProgram()->id;
        }
        if($check) {
            $podcast = PodcastProgrammi::find('all', array('conditions' => array('global = 1'), 'order' => 'anno DESC, mese DESC, giorno DESC', 'limit' => $limit, 'offset' => $getPage));
        }
        else {
            $podcast = PodcastProgrammi::find('all', array('conditions' => array('programmi_id = ?', $programID), 'order' => 'anno DESC, mese DESC, giorno DESC', 'limit' => $limit, 'offset' => $getPage));
        }
        return $podcast;
    }

    public function getPageNumber($podcastCount, $limit = 10) {
        return ceil($podcastCount/$limit);
    }

    public function getPodcastCount($programID = '', $admin = 0) {
        if($admin) {
            return PodcastProgrammi::count();
        }
        $check = $this->programActions->isUserLoggedForRedaction();
        if($programID == '' && !$check) {
            $programID = $this->programActions->getCurrentProgram()->id;
        }
        if($check){
            return PodcastProgrammi::count(array('conditions' => array('global = 1')));
        }
        else {
            return PodcastProgrammi::count(array('conditions' => array('programmi_id = ?', $programID)));
        }
    }

    public function deletePodcast($id) {
        $podcast = PodcastProgrammi::first($id);
        $this->validatePodcast($podcast);
        $this->verifyPermissions($podcast->programmi_id);
        if($podcast->programmi_id == null) {
            if(!$this->programActions->isUserLoggedForRedaction(1)) {
                throw new Exception("Non sei abilitato a cancellare un podcast!");
            }
        }
        $data = $podcast->to_json();
        $data = json_decode($data, true);
        $data['userID']      = $this->userActions->getCurrentUser()->id;
        $data['userNome']    = $this->userActions->getCurrentUser()->nome;
        $data['userCognome'] = $this->userActions->getCurrentUser()->cognome;
        EventLogger::log('deletePodcast()', json_encode($data));
        $title = $podcast->giorno."-".$podcast->mese."-".$podcast->anno;
        $podcast->delete();
        return hfix($title);
    }

    public function getAllTags() {
        if($this->programActions->isUserLoggedForRedaction()) {
            $tags = RedazioneTag::all();
        }
        else {
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

    public function getTags($podcast) {
        return $this->tagActions->getTags($podcast);
    }
    /*
    public function editTitolo($titolo) {
        $this->validateCurrentPodcast();
        $podcast = $this->getCurrentPodcast();
        if($podcast->titolo == $titolo) return;
        $this->validateTitolo($titolo);
        $this->setPodcastData($podcast, 'titolo', $titolo);
    }
    */
    /*
    public function editTesto($testo) {
        $this->validateCurrentPodcast();
        $podcast = $this->getCurrentPodcast();
        if($podcast->testo == $testo) return;
        $this->validateTesto($testo);
        $this->setPodcastData($podcast, 'testo', $testo);
    }
    */
    public function editLink($link) {
        $this->validateCurrentPodcast();
        $podcast = $this->getCurrentPodcast();
        if($podcast->link == $link) return;
        $this->validateLink($link);
        $this->setPodcastData($podcast, 'link', $link);
    }

    public function editLinkYoutube($link) {
        $this->validateCurrentPodcast();
        $podcast = $this->getCurrentPodcast();
        if($podcast->link_youtube == $link) return;
        $this->validateLinkYoutube($link);
        $this->setPodcastData($podcast, 'link_youtube', $link);
    }

    public function editVisibile($visibile) {
        $this->validateCurrentPodcast();
        $podcast = $this->getCurrentPodcast();
        if($podcast->visibile == $visibile) return;
        $this->changeVisibility();
    }

    //public function editData($day, $month, $year) {
    public function editData($date) {
        $this->validateCurrentPodcast();
        $podcast = $this->getCurrentPodcast();
        //$this->validatePodcastDate($day, $month, $year);
        $date = $this->validatePodcastDate($date);
        $day   = $date[0];
        $month = $date[1];
        $year  = $date[2];
        if($podcast->giorno != $day) {
            $this->setPodcastData($podcast, 'giorno', $day);
        }
        if($podcast->mese != $month) {
            $this->setPodcastData($podcast, 'mese', $month);
        }
        if($podcast->anno != $year) {
            $this->setPodcastData($podcast, 'anno', $year);
        }

    }

    public function editTags($tags) {
        $this->validateCurrentPodcast();
        $podcast = $this->getCurrentPodcast();
        $podcastTags = $this->getTags($podcast);
        if($podcastTags == $tags) return;
        $this->tagActions->appendTags($tags, $this->getCurrentPodcast());
    }

    public function associateNews($newsID) {
        $this->validateCurrentPodcast();
        $podcast = $this->getCurrentPodcast();
        if($newsID != '') {
            $news = NewsProgrammi::first($newsID);
            if(!$news) {
                throw new Exception("News non trovata!");           
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

    public function removeAssociatedPodcast($newsID) {
        $this->validateCurrentNews();
        $podcast = $this->getCurrentPodcast();
        if($newsID != '') {
            $news = NewsProgrammi::first($newsID);
            if(!$news) {
                throw new Exception("News non trovata!");           
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
