<?php
class ProgramActions {
    private $userActions;
    private $program = null;

    private $statusProgramma = array(
        'Attivo e Visibile',
        'Attivo e Non Visibile',
        'Non Attivo e Visibile',
        'Disattivato'
    );

    private $roles = array(
        'SPEAKER'   => 'Speaker',
        'TECNICO'   => 'Tecnico',
        'REDAZIONE' => 'Redazione'
    );

    public function __construct($userActions) {
        $this->userActions = $userActions;
        $this->validateUserActions();
    }

    public function isUserLoggedForRedaction($granularity = 0) {
        if($granularity == 0) {
            return $this->getCurrentProgram() == null && ($this->userActions->getCurrentUser()->accessoredazione == 1 || $this->userActions->isUnelevatedUserAbleTo('DIRETTORE_REDAZIONE'));
        } else {
            return $this->getCurrentProgram() == null && $this->userActions->isUnelevatedUserAbleTo('DIRETTORE_REDAZIONE');
        }
    }

    public function programLogin($id) {
        $program = Programmi::first($id);
        $this->validateProgram($program);
        if($this->userActions->isUserAbleTo('DIRETTORE_PROGRAMMI')) {
            goto validLogin;
        }
        if($program->status == 3) {
                        $this->programLogout();
                        throw new Exception('Impossibile accedere all\'amministrazione del programma: programma disabilitato!');
                }
        $currentUser = $this->userActions->getCurrentUser();
        $staff = $program->utenti;
        foreach($staff as $member) {
            if($member->id == $currentUser->id) {
                goto validLogin;
            }
        }
        $this->programLogout();
        throw new Exception("Impossibile accedere a quest'area!");
        validLogin:
        $_SESSION['programID'] = $program->id;
        $this->program = $program;
    }

    public function checkProgramSession() {
        if(!isset($_SESSION['programID']) || $_SESSION['programID'] < 0) {
            if($this->isUserLoggedForRedaction() && defined('REDAZIONEOK')) {
                $program = null;
                goto validCheck;
            }
            throw new Exception("Devi effettuare il login con un programma per accedere a quest'area!");            
        }
        $program = Programmi::first($_SESSION['programID']);
        $this->validateProgram($program);
        if($this->userActions->isUserAbleTo('DIRETTORE_PROGRAMMI')) {
            goto validCheck;
        }
        $currentUser = $this->userActions->getCurrentUser();
        $staff = $program->utenti;
        foreach($staff as $member) {
            if($member->id == $currentUser->id) {
                goto validCheck;
            }
        }
        $this->programLogout();
        throw new Exception("Non hai i permessi per accedere a quest'area!");
        validCheck:
        $this->program = $program;
    }

    public function programLogout() {
        $this->program = null;
        $_SESSION['programID'] = -1;
    }

    public function getCurrentProgram() {
        return $this->program;
    }

    public function getRole($id = '') {
        if(isset($this->roles[$id])) {
            return $this->roles[$id];
        }
        return $this->roles;
    }

    public function validateUserActions() {
        if(get_class($this->userActions) != 'UserActions') {
            throw new Exception("UserActions reference not valid!");            
        }
    }

    public function getStatusProgramma($id = '') {
        if(isset($this->statusProgramma[$id])) {
            return $this->statusProgramma[$id];
        }
        return $this->statusProgramma;
    }

    public function deleteProgram($id) {
        $this->onlyAdministrator();
        $program = Programmi::first($id);
        if(!$program) {
            throw new Exception("Programma non trovato!");
        }
        /*maiuxmod
        elseif($program->id == 2) {
            throw new Exception("Impossibile eliminare NERD! Questo tentativo verr&agrave; notificato e saranno presi <b>SERI</b> provvedimenti!");
        }*/
        else {
            $nome = $program->nome;
            $data = $program->to_json();
            $data = json_decode($data, true);
            $data['adminId'] = $this->userActions->getCurrentUser()->id;
            $data['adminNome'] = $this->userActions->getCurrentUser()->nome;
            $data['adminCognome'] = $this->userActions->getCurrentUser()->cognome;
            $data = json_encode($data);
            $program->delete();
            EventLogger::log('deleteProgram()', $data, '');
            return hfix($nome);
        }
    }

    public function creaProgramma($params) {
        $this->onlyDirettoreProgrammi();
        $allow = array('nome', 'tag', 'descrizione', 'descrizionelunga', 'email', 'facebook', 'instagram', 'twitter', 'youtube', 'mixcloud', 'spotifylink', 'spotifydirect', 'status');
        if(count($allow) != count($params)) {
            throw new Exception("Parametri non validi!");   
        }
        foreach($allow as $key) {
            if(!isset($params[$key])) {
                throw new Exception("Parametri non validi!");               
            }
        }
        $params['email'] = strtolower($params['email']);
        $params['tag']   = strtolower($params['tag']);
        $this->validateNome($params['nome']);
        $this->validateTag($params['tag'], '', true);
        $this->validateDescrizione($params['descrizione']);
        $this->validateDescrizioneLunga($params['descrizionelunga']);
        $this->validateEmail($params['email']);
        $params['facebook']  = $this->validateFacebook($params['facebook']);
        $params['instagram'] = $this->validateInstagram($params['instagram']);
        $params['twitter']   = $this->validateTwitter($params['twitter']);
        $params['youtube']   = $this->validateYoutube($params['youtube']);
        $params['mixcloud']  = $this->validateMixcloud($params['mixcloud']);
        $this->validateSpotifyLink($params['spotifylink']);
        $this->validateSpotifyDirect($params['spotifydirect']);
        $this->validateStato($params['status']);
        $program = new Programmi();
        foreach($params as $key => $value) {
            $program->$key = $value;
        }
        $program->save();
        if($program->is_invalid()) {
            throw new Exception($program->errors->full_messages());
        }
        $data = $program->to_json();
        $data = json_decode($data, true);
        $data['adminId'] = $this->userActions->getCurrentUser()->id;
        $data['adminNome'] = $this->userActions->getCurrentUser()->nome;
        $data['adminCognome'] = $this->userActions->getCurrentUser()->cognome;
        $data = json_encode($data);
        EventLogger::log('creaProgramma()', $data, '', $program->id);
        mkdir(dirname(__FILE__).'/../../podcast/'.$program->tag);
        return $program->id;
    }

    public function editSpotifyLink($spotifyLink, $program) {
        $this->validateProgram($program);
        $this->onlyProgramOwners($program);
        $this->validateSpotifyLink($spotifyLink);
        if($program->spotifylink != $spotifyLink) {
            $this->setProgramData($program, 'spotifylink', $spotifyLink);
        }
    }

    public function editSpotifyDirect($spotifyDirect, $program) {
        $this->validateProgram($program);
        $this->onlyProgramOwners($program);
        $this->validateSpotifyDirect($spotifyDirect);
        if($program->spotifydirect != $spotifyDirect) {
            $this->setProgramData($program, 'spotifydirect', $spotifyDirect);
        }
    }

    public function editNome($nome, $program) {
        $this->validateProgram($program);
        $this->onlyDirettoreProgrammi();
        $this->validateNome($nome, $program->nome);
        if($program->nome != $nome) {
            $this->setProgramData($program, 'nome', $nome);
        }
    }

    public function setOnAir($onair, $program, $day, $directRequest = false) {
        $this->validateProgram($program);
        $this->onlyProgramOwners($program);
        if($day == null) {
            $palinsesto = Palinsesto::first(array('conditions' => array('programmi_id = ?', $program->id)));
            if(count($palinsesto) > 1) {
                throw new Exception("Specificare un giorno in cui non si va in onda!");             
            }
        } else {
            $palinsesto = Palinsesto::first(array('conditions' => array('programmi_id = ? AND giorno = ?', $program->id, $day)));       
        }
        if(!$palinsesto) {
            throw new Exception("Impossibile trovare il programma nel palinsesto!");            
        }
        if($onair == 1) {
            $palinsesto->notonair = '';
            $palinsesto->save();
        } else {
            $days = array('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');
            $reverseDays = array_flip($days);
            $currentDatabaseTime = convertToTime($reverseDays[date('l')], date('H'), date('i'))+date('s');
            $day = $days[$palinsesto->giorno];
            if(strtolower(date("l")) == strtolower($day)) {
                if($directRequest && $this->userActions->isUserAbleTo('DIRETTORE_PROGRAMMI')) {
                    if($currentDatabaseTime < $palinsesto->t_f) {
                        $palinsesto->notonair = date('d-m-Y');
                    } else {
                        goto setnextweek;
                    }
                }
                elseif($currentDatabaseTime < $palinsesto->t_i-30*60) {
                    $palinsesto->notonair = date('d-m-Y');
                }
                elseif($currentDatabaseTime > $palinsesto->t_f+30*60) {
                    setnextweek:
                    $time = strtotime('next '.$day);
                    $palinsesto->notonair = date('d-m-Y', $time);
                }
                else {
                    throw new Exception('Puoi usare questa funzione fino a 30 minuti dall\'inizio della diretta o dopo 30 minuti dalla fine della diretta.');
                }
                $palinsesto->save();
            }
            else {
                goto setnextweek;
            }
        }
        $data = array(
            'currentUserID'      => $this->userActions->getCurrentUser()->id,
            'currentUserNome'    => $this->userActions->getCurrentUser()->nome,
            'currentUserCognome' => $this->userActions->getCurrentUser()->cognome,
            'programid'          => $program->id,
            'programma'          => $program->nome,
            'onair'              => $onair,
            'day'                => (strlen($palinsesto->notonair) > 0 ? $palinsesto->notonair : 'Around '.date('d-m-Y H:i:s'))
        );
        $data = json_encode($data);
        EventLogger::log('setOnAir()', $data, '', $program->id);
    }

    public function editTag($tag, $program) {
        $tag = strtolower($tag);
        $this->validateProgram($program);
        $this->onlyDirettoreProgrammi();
        $this->validateTag($tag, $program->tag, true);
        if($program->tag != $tag) {
            $oldTag = $program->tag;
            $this->setProgramData($program, 'tag', $tag);
            rename(dirname(__FILE__).'/../../podcast/'.$oldTag, dirname(__FILE__).'/../../podcast/'.$tag);
            $startFolder = dirname(__FILE__).'/../../photos/news/'.$oldTag;
            if(file_exists($startFolder)) {
                rename($startFolder, dirname(__FILE__).'/../../photos/news/'.$tag);
            }
        }
    }

    public function editDescrizione($descrizione, $program) {
        $this->validateProgram($program);
        $this->onlyProgramOwners($program);
        $this->validateDescrizione($descrizione);
        if($program->descrizione != $descrizione) {
            $this->setProgramData($program, 'descrizione', $descrizione);
        }
    }

    public function editDescrizioneLunga($descrizione, $program) {
        $this->validateProgram($program);
        $this->onlyProgramOwners($program);
        $this->validateDescrizioneLunga($descrizione);
        if($program->descrizionelunga != $descrizione) {
            $this->setProgramData($program, 'descrizionelunga', $descrizione);
        }
    }

    public function editEmail($email, $program) {
        $this->validateProgram($program);
        $this->onlyProgramOwners($program);
        $email = strtolower($email);
        $this->validateEmail($email);
        if($program->email != $email) {
            $this->setProgramData($program, 'email', $email);
        }
    }

    public function editFacebook($facebook, $program) {
        $this->validateProgram($program);
        $this->onlyProgramOwners($program);
        $facebook = $this->validateFacebook($facebook);
        if($program->facebook != $facebook) {
            $this->setProgramData($program, 'facebook', $facebook);
        }
    }

    public function editInstagram($instagram, $program) {
        $this->validateProgram($program);
        $this->onlyProgramOwners($program);
        $facebook = $this->validateInstagram($instagram);
        if($program->instagram != $instagram) {
            $this->setProgramData($program, 'instagram', $instagram);
        }
    }

    public function editTwitter($twitter, $program) {
        $this->validateProgram($program);
        $this->onlyProgramOwners($program);
        $twitter = $this->validateTwitter($twitter);
        if($program->twitter != $twitter) {
            $this->setProgramData($program, 'twitter', $twitter);
        }
    }

    public function editYoutube($youtube, $program) {
        $this->validateProgram($program);
        $this->onlyProgramOwners($program);
        $youtube = $this->validateYoutube($youtube);
        if($program->youtube != $youtube) {
            $this->setProgramData($program, 'youtube', $youtube);
        }
    }

    public function editMixcloud($mixcloud, $program) {
        $this->validateProgram($program);
        $this->onlyProgramOwners($program);
        $mixcloud = $this->validateMixcloud($mixcloud);
        if($program->mixcloud != $mixcloud) {
            $this->setProgramData($program, 'mixcloud', $mixcloud);
        }
    }

    public function editStato($status, $program) {
        $this->validateProgram($program);
        $this->onlyDirettoreProgrammi();
        $this->validateStato($status);
        if($program->status != $status) {
            $this->setProgramData($program, 'status', $status);
        }
    }

    public function setLogo($newFoto, $program) {
        $this->validateProgram($program);
        $this->onlyDirettoreProgrammi();
        if($program->logo != $newFoto) {
            $this->setProgramData($program, 'logo', $newFoto);
        }
    }

    public function setBackgroundImage($newImage, $program) {
        $this->validateProgram($program);
        $this->onlyDirettoreProgrammi();
        if($program->background_image != $newImage) {
            $this->setProgramData($program, 'background_image', $newImage);
        }
    }

    public function setColors($colors, $program) {
        $this->validateProgram($program);
        $this->onlyDirettoreProgrammi();
        $allow = array('text', 'background_color',/*'background_image',*/ 'border', 'hover');
        if(count($allow) != count($colors)) {
            throw new Exception("Parametri non validi!");   
        }
        foreach($allow as $key) {
            if(!isset($colors[$key])) {
                throw new Exception("Parametri non validi!");               
            }
        }
        $colors = json_encode($colors);
        if($program->colors != $colors) {
            $this->setProgramData($program, 'colors', $colors);
        }
    }

    public function setLedColor($led_colors, $program) {
        $this->validateProgram($program);
        $this->onlyProgramOwners($program);
        $allow = array('studio', 'on_air', 'tavoli');
        if(count($allow) != count($led_colors)) {
            throw new Exception("Parametri non validi!");   
        }
        foreach($allow as $key) {
            if(!isset($led_colors[$key])) {
                throw new Exception("Parametri non validi!");               
            }
        }
        $led_colors = json_encode($led_colors);
        if($program->led_color != $led_colors) {
            $this->setProgramData($program, 'led_color', $led_colors);
        }
    }

    public function validateNome($nome, $nome2 = '') {
        if($nome2 == $nome) {
            return;
        }
        if(strlen($nome) == 0) {
            throw new Exception('Nome non valido!');
        }
        $this->uniqueProgramName($nome);
    }

    public function validateTag($tag, $tag2 = '', $isProgramTag = false) {
        if($tag2 == $tag) {
            return;
        }
        $regex = $isProgramTag ? '/^[a-z0-9]+$/i' : '/^[a-z0-9 ]+$/i';
        if(strlen($tag) == 0 || !preg_match($regex, $tag)) {
            throw new Exception('Tag non valido!');
        }
        $this->uniqueProgramTag($tag);
    }

    public function validateSpotifyDirect($spotifyDirect) {
        if(strlen($spotifyDirect) == 0) {
            return;
        }
        if(!preg_match('/^spotify:user:poliradio:playlist:(.*)/i', $spotifyDirect)) {
            throw new Exception("Collegamento diretto della playlist di spotify non valido!");          
        }
    }

    public function validateSpotifyLink($spotifyLink) {
        if(strlen($spotifyLink) == 0) {
            return;
        }
        if(!preg_match('/^https:\/\/open\.spotify\.com\/user\/poliradio\/playlist\/(.*)/i', $spotifyLink)) {
            throw new Exception("Collegamento HTTP della playlist di spotify non valido!");         
        }
    }

    public function validateDescrizione($descrizione) {
        if(strlen($descrizione) < 30) {
            throw new Exception('Descrizione breve del programma troppo corta!');
        }
        if(strlen($descrizione) > 80) {
            throw new Exception('Descrizione breve del programma troppo lunga!');
        }
    }

    public function validateDescrizioneLunga($descrizione) {
        if(strlen($descrizione) < 80) {
            throw new Exception('Descrizione lunga del programma troppo corta!');
        }
    }

    public function validateFacebook($link) {
        if(strlen($link) == 0) return;
        if(preg_match('/facebook\.com\/(.*)/i', $link, $matches)) {
            return 'https://www.facebook.com/'.$matches[1];
        } else {
            return 'https://www.facebook.com/'.$link;
        }
    }

    public function validateInstagram($link) {
        if(strlen($link) == 0) return;
        if(preg_match('/instagram\.com\/(.*)/i', $link, $matches)) {
            return 'https://www.instagram.com/'.$matches[1];
        } else {
            return 'https://www.instagram.com/'.$link;
        }
    }

    public function validateTwitter($link) {
        if(strlen($link) == 0) return;
        if($link[0] == '@') {
            return 'https://twitter.com/'.substr($link, 1, strlen($link));
        }
        elseif(preg_match('/twitter\.com\/(.*)/i', $link, $matches)) {
            return 'https://twitter.com/'.$matches[1];

        }
        return 'https://twitter.com/'.$link;
    }

    public function validateYoutube($link) {
        if(strlen($link) == 0) return;
        if(!preg_match('/youtube\.com/i', $link) && !preg_match('/youtu\.be/i', $link)) {
            return 'https://www.youtube.com/user/'.$link;
        }
        return $link;
    }

    public function validateMixcloud($link) {
        if(strlen($link) == 0) return;
        if(preg_match('/mixcloud\.com\/(.*)/i', $link, $matches)) {
            return 'https://www.mixcloud.com/'.$matches[1];
        } else {
            return 'https://www.mixcloud.com/'.$link;
        }
    }

    public function validateStato($stato) {
        if($stato < 0 || $stato > 3 || !is_numeric($stato)) {
            throw new Exception('Stato non valido!');
        }
    }

    private function validateLink($link, $baseUrl, $type) {
        if(strlen($link) == 0) {
            return;
        }
        if(substr($link, 0, strlen($baseUrl)) != $baseUrl) {
            throw new Exception("Link di ".$type." non valido: deve iniziare per '".$baseUrl."'");          
        }
    }

    private function uniqueProgramName($name) {
        $program = Programmi::find(array('conditions' => array('nome = ?', $name)));
        if(count($program) > 0) {
            throw new Exception("Un programma con questo nome risulta gi&agrave; esistente!");          
        }
    }

    private function uniqueProgramTag($tag) {
        if($tag == 'redazione' || $tag == 'poliradio') {
            throw new Exception("Impossibile usare questo nome come tag del programma!");
        }
        $program = Programmi::find(array('conditions' => array('tag = ?', $tag)));
        if(count($program) > 0) {
            throw new Exception("Un programma con questo tag risulta gi&agrave; esistente!");           
        }
    }

    private function setProgramData($program, $data, $value) {
        $this->validateProgram($program);
        $program->$data = $value;
        $program->save();
        if($program->is_invalid()) {
            throw new Exception($program->errors->full_messages());
        }
        $logData = array(
            'currentUserID'      => $this->userActions->getCurrentUser()->id,
            'currentUserNome'    => $this->userActions->getCurrentUser()->nome,
            'currentUserCognome' => $this->userActions->getCurrentUser()->cognome,
            'programid'          => $program->id,
            'programma'          => $program->nome,
            $data                => $value,
            'parameter'          => $data
        );
        $logData = json_encode($logData);
        EventLogger::log('setProgramData()', $logData, '', $program->id);
    }

    public function validateProgram($program) {
        if(!is_object($program)) {
            throw new Exception("Variabile \$program non valida!");
        }
        if(get_class($program) != 'Programmi') {
            throw new Exception("Variabile \$program non valida!");         
        }
        if(!isset($program->id)) {
            throw new Exception("Programma non valido!");           
        }
    }

    public function validateCurrentProgram() {
        $this->validateProgram($this->program);
    }

    public function onlyDirettoreProgrammi() {
        if($this->userActions->isUserAbleTo('DIRETTORE_PROGRAMMI')) {
            return;
        }
        throw new Exception("Non sei abilitato a utilizzare questa funzione!"); 
    }

    public function onlyAdministrator() {
        $this->validateUserActions();
        $this->userActions->onlyAdministrator();
    }

    public function onlyProgramOwners($program) {
        $this->validateUserActions();
        if($this->isProgramMember($this->userActions->getCurrentUser(), $program)) {
            return;
        }
        if($this->userActions->isUserAbleTo('DIRETTORE_PROGRAMMI')) {
            return;
        }
        throw new Exception("Non sei abilitato a utilizzare questa funzione!");     
    }

    public function isProgramMember($user, $program) {
        $this->userActions->validateUser($user);
        foreach($user->programmi as $programma) {
            if($programma->id == $program->id) {
                return true;
            }
        }
        return false;
    }

    public function setReferente($user, $program, $check = true) {
        $this->validateProgram($program);
        $this->onlyDirettoreProgrammi();
        $this->userActions->validateUser($user);
        if(!$this->isProgramMember($user, $program) && $check) {
            throw new Exception("Questo utente non &egrave; membro del programma.");            
        }
        $staff = $program->programmi_utenti;
        foreach($staff as $record) {
            if($record->utenti_id == $user->id) {
                $record->referente = 1;
            } else {
                $record->referente = 0;
            }
            $record->save();
        }
        $logData = array(
            'adminid'          => $this->userActions->getCurrentUser()->id,
            'adminNome'        => $this->userActions->getCurrentUser()->nome,
            'adminCognome'     => $this->userActions->getCurrentUser()->cognome,
            'referenteUserid'  => $user->id,
            'referentenome'    => $user->nome,
            'referentecognome' => $user->cognome,
            'programid'        => $program->id,
            'programma'        => $program->nome
        );
        $logData = json_encode($logData);
        EventLogger::log('setReferente()', $logData, '', $program);
    }

    public function validateReferente($referente) {
        if($referente != 1 && $referente != 0) {
            throw new Exception("Valore per 'referente' non valido!");          
        }
    }

    public function validateRuolo($ruolo) {
        if(count($this->getRole($ruolo)) > 1) {
            throw new Exception("Ruolo non valido!");           
        }
    }

    public function validateEmail($email) {
        $email = strtolower($email);
        if(!$this->userActions->isEmailValid($email) && strlen($email) > 0){
            throw new Exception('Questo indirizzo email non &egrave; valido!');
        }
    }

    public function changeProgramMemberVisibility($user, $program) {
        $this->onlyDirettoreProgrammi();
        $progusr = ProgrammiUtenti::find('first', array('conditions' => array('programmi_id = ? AND utenti_id = ?', $program, $user)));
        if($progusr) {
            $progusr->visibile = 1-$progusr->visibile;
            $progusr->save();
            if($progusr->is_invalid()) {
                throw new Exception($progusr->errors->full_messages());
            }
        }
    }

    public function setNewProgramMember($user, $program, $ruolo, $referente) {
        $this->onlyDirettoreProgrammi();
        $this->userActions->validateUser($user);
        $this->validateProgram($program);
        $this->validateReferente($referente);
        $this->validateRuolo($ruolo);
        if($this->isProgramMember($user, $program)) {
            return;
        }
        $progusr = new ProgrammiUtenti();
        $progusr->utenti_id    = $user->id;
        $progusr->programmi_id = $program->id;
        $progusr->ruolo        = $ruolo;
        $progusr->referente    = $referente;
        $progusr->visibile     = 1;
        $progusr->save();
        if($progusr->is_invalid()) {
            throw new Exception($progusr->errors->full_messages());
        }
        if($referente) {
            $this->setReferente($user, $program, false);
        }
        $logData = array(
            'adminid'           => $this->userActions->getCurrentUser()->id,
            'adminNome'         => $this->userActions->getCurrentUser()->nome,
            'adminCognome'      => $this->userActions->getCurrentUser()->cognome,
            'nuovoMembroUserid' => $user->id,
            'nuovoMembroNome'   => $user->nome,
            'nuovoMembroCognome'=> $user->cognome,
            'programid'         => $program->id,
            'programma'         => $program->nome,
            'ruolo'             => $ruolo,
            'referente'         => $referente
        );
        $logData = json_encode($logData);
        EventLogger::log('setNewProgramMember()', $logData, '', $program);
    }

    public function removeProgramMember($user, $program) {
        $this->validateProgram($program);
        $this->onlyDirettoreProgrammi();
        $this->userActions->validateUser($user);
        $this->validateProgram($program);
        $progusr = ProgrammiUtenti::first(array('conditions' => array('utenti_id = ? AND programmi_id = ?', $user->id, $program->id)));
        $progusr->delete();
        $logData = array(
            'adminid'        => $this->userActions->getCurrentUser()->id,
            'adminNome'      => $this->userActions->getCurrentUser()->nome,
            'adminCognome'   => $this->userActions->getCurrentUser()->cognome,
            'removedUserid'  => $user->id,
            'removedNome'    => $user->nome,
            'removedCognome' => $user->cognome,
            'programid'      => $program->id,
            'programma'      => $program->nome
        );
        $logData = json_encode($logData);
        EventLogger::log('removeProgramMember()', $logData, '', $program);
    }

    public function getProgramStaffID($program) {
        $this->validateProgram($program);
        $staff = $program->utenti;
        $staffID = array();
        foreach($staff as $user) {
            $staffID[] = $user->id;
        }
        return $staffID;
    }

    public function editProgramMember($user, $program, $ruolo, $referente) {
        $this->onlyDirettoreProgrammi();
        $this->userActions->validateUser($user);
        $this->validateProgram($program);
        $this->validateReferente($referente);
        $this->validateRuolo($ruolo);
        if(!$this->isProgramMember($user, $program)) {
            throw new Exception("Questo utente non &egrave; membro del programma.");
        }
        $progusr = ProgrammiUtenti::first(array('conditions' => array('utenti_id = ? AND programmi_id = ?', $user->id, $program->id)));
        $progusr->ruolo     = $ruolo;
        $progusr->referente = $referente;
        $progusr->save();
        if($progusr->is_invalid()) {
            throw new Exception($progusr->errors->full_messages());
        }
        if($referente) {
            $this->setReferente($user, $program, false);
        }
        $logData = array(
            'adminid'      => $this->userActions->getCurrentUser()->id,
            'adminNome'    => $this->userActions->getCurrentUser()->nome,
            'adminCognome' => $this->userActions->getCurrentUser()->cognome,
            'userid'       => $user->id,
            'userNome'     => $user->nome,
            'userCognome'  => $user->cognome,
            'newRuolo'     => $ruolo,
            'newReferente' => $referente,
            'programid'    => $program->id,
            'programma'    => $program->nome
        );
        $logData = json_encode($logData);
        EventLogger::log('editProgramMember()', $logData, '', $program);
    }

    public function getReferente($program) {
        $this->validateProgram($program);
        $staff = $program->programmi_utenti;
        if(count($staff) == 0) {
            return;
        }
        foreach($staff as $record) {
            if($record->referente) {
                return $record->utenti;
            }
        }       
    }

    public function deleteNotification($notificationID) {
        $notification = Notification::first($notificationID);
        if(!$notification) {
            throw new Exception("Notifica non trovata.");           
        }
        if($notification->seentime+5*24*3600 > time()) {
            throw new Exception("Per eliminare una notifica devono passare almeno 5 giorni dalla sua visualizzazione.");            
        } 
        if($notification->receivertype != 1 || $notification->receiverid != $this->getCurrentProgram()->id) {
            throw new Exception("Non puoi eliminare questa notifica.");
        }
        $notification->delete();
    }

    public function getLastNotification() {
        if($this->isUserLoggedForRedaction()) {
            return null;
        }
        return Notification::first(array('order' => 'id DESC', 'conditions' => array('seen = 0 AND receivertype = 1 AND receiverid = ?', $this->getCurrentProgram()->id)));
    }
    
    public function getNotifications() {
        if($this->isUserLoggedForRedaction()) {
            return null;
        }
        return Notification::find('all', array('conditions' => array('receivertype = 1 AND receiverid = ?', $this->getCurrentProgram()->id)));
    }
    
    public function getSeenNotifications() {
        if($this->isUserLoggedForRedaction()) {
            return null;
        }
        return Notification::find('all', array('order' => 'id DESC', 'conditions' => array('seen = 1 AND receivertype = 1 AND receiverid = ?', $this->getCurrentProgram()->id)));
    }

    public function getAllNotificatons() {
        if($this->isUserLoggedForRedaction()) {
            return null;
        }
        return Notification::find('all', array('order' => 'id DESC', 'conditions' => array('receivertype = 1 AND receiverid = ?', $this->getCurrentProgram()->id)));
    }

    public function getUnseenNotifications() {
        if($this->isUserLoggedForRedaction()) {
            return null;
        }
        return Notification::find('all', array('conditions' => array('seen = 0 AND receivertype = 1 AND receiverid = ?', $this->getCurrentProgram()->id)));
    }

    public function countNotifications() {
        if($this->isUserLoggedForRedaction()) {
            return null;
        }
        return Notification::count(array('conditions' => array('receivertype = 1 AND receiverid = ?', $this->getCurrentProgram()->id)));
    }

    public function countUnseenNotifications() {
        if($this->isUserLoggedForRedaction()) {
            return null;
        }
        return Notification::count(array('conditions' => array('seen = 0 AND receivertype = 1 AND receiverid = ?', $this->getCurrentProgram()->id)));
    }

    public function setNotificationSeen($notificationID) {
        if($this->isUserLoggedForRedaction()) {
            return null;
        }
        $notification = Notification::first($notificationID);
        if($notification) {
            if($notification->receivertype == 1 && $notification->receiverid == $this->getCurrentProgram()->id) {
                $notification->seen = 1;
                $notification->seentime = time();
                $notification->save();
            }
        }
    }
}
?>
