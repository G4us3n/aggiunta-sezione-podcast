<?php
require_once dirname(__FILE__) . '/hashingsystem.class.php';
require_once dirname(__FILE__) . '/poliradiomailer.class.php';
require_once dirname(__FILE__) . '/eventlogger.class.php';
require_once dirname(__FILE__) . '/GoogleAuthenticator.php';

class UserActions {
    private $user;
    private $dataTableActions;

    private $sessoValue = array(
        1 => 'Femmina',
        2 => 'Maschio',
        3 => 'Altro'
    );

    private $mesiValue  = array(
        1  => 'Gennaio',
        2  => 'Febbraio',
        3  => 'Marzo',
        4  => 'Aprile',
        5  => 'Maggio',
        6  => 'Giugno',
        7  => 'Luglio',
        8  => 'Agosto',
        9  => 'Settembre',
        10 => 'Ottobre',
        11 => 'Novembre',
        12 => 'Dicembre'
    );



    private $eventCode = array(
        'LOGIN'            => 'LOGIN',
        'PASSWORD_CHANGED'  => 'PASSWORD_CHANGED',
        'PASSWORD_CHANGED_BY_ADMIN' => 'PASSWORD_CHANGED_BY_ADMIN',
        'EMAIL_CHANGED'     => 'EMAIL_CHANGED',
        'EMAIL_CHANGED_BY_ADMIN'     => 'EMAIL_CHANGED_BY_ADMIN',
        'TELEPHONE_CHANGED' => 'TELEPHONE_CHANGED',
        'TELEPHONE_CHANGED_BY_ADMIN' => 'TELEPHONE_CHANGED_BY_ADMIN'
    );

    // livello -> comandato_da
    private $direttivo = array(
        'PRESIDENTE'                    => array(''),
        'VICE_PRESIDENTE'               => array('PRESIDENTE'),
        'STATION_MANAGER'               => array('PRESIDENTE', 'VICE_PRESIDENTE'),
        'DIRETTORE_ARTISTICO'           => array('STATION_MANAGER', 'PRESIDENTE', 'VICE_PRESIDENTE'),
        'DIRETTORE_TECNICO'             => array('STATION_MANAGER', 'PRESIDENTE', 'VICE_PRESIDENTE'),
        'DIRETTORE_INFORMATICO'         => array('STATION_MANAGER', 'PRESIDENTE', 'VICE_PRESIDENTE'),
        'DIRETTORE_EVENTI'              => array('STATION_MANAGER', 'PRESIDENTE', 'VICE_PRESIDENTE', 'DIRETTORE_ARTISTICO', 'DIRETTORE_TECNICO'),
        'DIRETTORE_MUSICALE'            => array('STATION_MANAGER', 'PRESIDENTE', 'VICE_PRESIDENTE', 'DIRETTORE_ARTISTICO'),
        'DIRETTORE_REDAZIONE'           => array('STATION_MANAGER', 'PRESIDENTE', 'VICE_PRESIDENTE', 'DIRETTORE_ARTISTICO'),
        'DIRETTORE_PROGRAMMI'           => array('STATION_MANAGER', 'PRESIDENTE', 'VICE_PRESIDENTE', 'DIRETTORE_ARTISTICO'),
        'DIRETTORE_COMUNICAZIONE'       => array('STATION_MANAGER', 'PRESIDENTE', 'VICE_PRESIDENTE', 'DIRETTORE_ARTISTICO'),
        'WEBMASTER'                     => array('STATION_MANAGER', 'PRESIDENTE', 'VICE_PRESIDENTE', 'DIRETTORE_INFORMATICO'),
        'DIRETTIVO'                     => array(
                                            'STATION_MANAGER', 'PRESIDENTE', 'VICE_PRESIDENTE', 'DIRETTORE_EVENTI', 'DIRETTORE_ARTISTICO',
                                            'DIRETTORE_TECNICO', 'DIRETTORE_INFORMATICO', 'DIRETTORE_MUSICALE',
                                            'DIRETTORE_REDAZIONE', 'DIRETTORE_PROGRAMMI', 'DIRETTORE_COMUNICAZIONE', 'WEBMASTER'
                                        )
    );

    private $nameOfLevel = array(
        'PRESIDENTE'                    => 'Presidente',
        'VICE_PRESIDENTE'               => 'Vice Presidente',
        'STATION_MANAGER'               => 'Station Manager',
        'DIRETTORE_EVENTI'              => 'Responsabile Eventi',
        'DIRETTORE_ARTISTICO'           => 'Responsabile Artistico',
        'DIRETTORE_TECNICO'             => 'Responsabile Tecnico',
        'DIRETTORE_INFORMATICO'         => 'Responsabile IT',
        'DIRETTORE_COMUNICAZIONE'       => 'Responsabile Comunicazione',
        'DIRETTORE_MUSICALE'            => 'Responsabile Musicale',
        'DIRETTORE_REDAZIONE'           => 'Responsabile Redazione',
        'DIRETTORE_PROGRAMMI'           => 'Responsabile Programmi',
        'WEBMASTER'                     => 'Webmaster',
        'MEMBRO'                        => 'Membro'
    );

    private $nameOfType = array(
        'SOCIO_ORDINARIO' => 'Socio Ordinario',
        'SOCIO_ONORARIO'  => 'Socio Onorario',
        'COLLABORATORE'   => 'Collaboratore'
    );

    private $old_name_pattern = '/^[\p{L}\' ]+$/ui';
    private $name_pattern = '/^[A-Za-z\x{00C0}-\x{00FF}][A-Za-z\x{00C0}-\x{00FF}\'\-]+([\ A-Za-z\x{00C0}-\x{00FF}][A-Za-z\x{00C0}-\x{00FF}\'\-]+)*/u';

    public function __construct($dataTableActions) {
        $this->dataTableActions = $dataTableActions;
        $this->validateDataTableActions();
    }

    public function validateDataTableActions() {
        if(get_class($this->dataTableActions) != 'DataTableActions') {
            throw new Exception("DataTableActions reference not valid!");
        }
    }

    public function nameOfLevel($level = '') {
        if(isset($this->nameOfLevel[$level])) {
            return $this->nameOfLevel[$level];
        }
        return $this->nameOfLevel;
    }

    public function nameOfType($type = '') {
        if(isset($this->nameOfType[$type])) {
            return $this->nameOfType[$type];
        }
        return $this->nameOfType;
    }

    public function getSessoValue($id = '') {
        if(isset($this->sessoValue[$id])) {
            return $this->sessoValue[$id];
        }
        return $this->sessoValue;
    }

    public function getSessoDesinenza($user){
      if($user->sesso == 1){
        $desinenza = 'a';
        $articolo = 'La';
      }elseif($user->sesso == 2){
        $desinenza = 'o';
        $articolo = 'Il';
      }else{
        $desinenza = '*';
        $articolo = 'L*';
      }

      return $desinenza;
    }

    public function getSessoArticolo($user){
      if($user->sesso == 1){
        $desinenza = 'a';
        $articolo = 'La';
      }elseif($user->sesso == 2){
        $desinenza = 'o';
        $articolo = 'Il';
      }else{
        $desinenza = '*';
        $articolo = 'L*';
      }

      return $articolo;
    }
    
    public function getSessoPronome($user,$lang){
      if($user->sesso == 1){
        $it = 'lei';
        $eng = '';
      }elseif($user->sesso == 2){
        $it= 'lui';
        $eng = '';
      }else{
        $desinenza = 'l*';
        $eng = '';
      }

      if($lang == 'EN'){
          return $eng;
      }else{
          return $it;
      }

    }
    public function getSessoPronome2($user,$lang){
      if($user->sesso == 1){
        $it = 'la';
        $eng = '';
      }elseif($user->sesso == 2){
        $it= 'lo';
        $eng = '';
      }else{
        $desinenza = 'l*';
        $eng = '';
      }

      if($lang == 'EN'){
          return $eng;
      }else{
          return $it;
      }

    }

    public function getMesiValue($id = '') {
        if(isset($this->mesiValue[$id])) {
            return $this->mesiValue[$id];
        }
        return $this->mesiValue;
    }

    public function getDocumentoValue($id = '') {
        if(isset($this->tipoDocumentoValue[$id])) {
            return $this->tipoDocumentoValue[$id];
        }
        return $this->tipoDocumentoValue;
    }


    public function getEventCode($id = '') {
        if(isset($this->eventCode[$id])) {
            return $this->eventCode[$id];
        }
        return $this->eventCode;
    }

    public function getCurrentUser() {
        return $this->user;
    }

    private function setCurrentUser($user) {
        $this->user = $user;
    }

    public function checkPassword($password, $user = '') {
        if($user == '') {
            $user = $this->getCurrentUser();
        }
        $hs = new HashingSystem();
        return $hs->validatePassword($password, $user->hash, $user->salt);
    }

    public function getFailures() {
        $failure = LoginFailures::first(array('conditions' => "ip = '".$_SERVER['REMOTE_ADDR']."'"));
        if(!$failure)
            return 0;
        if($failure->lastfailure < time()-600) {
            $failure->delete();
            return 0;
        } else {
            return $failure->failed;
        }
    }

    public function incrementFailures() {
        $failure = LoginFailures::first(array('conditions' => "ip = '".$_SERVER['REMOTE_ADDR']."'"));
        if(!$failure) {
            $failure = new LoginFailures();
            $failure->ip = $_SERVER['REMOTE_ADDR'];
            $failure->failed = 0;
        }
        $failure->failed++;
        $failure->lastfailure = time();
        $failure->save();
    }

    public function deleteFailures() {
        LoginFailures::connection()->query("DELETE FROM loginfailures WHERE lastfailure < ".(time()-600));
    }

    public function login_as_user($id) {
        $this->onlyAdministrator();
        $user = Utenti::first($id);
        if($user){
            $this->setCurrentUser($user);
                        $this->checkUserValidity();
                        $this->setNewSession();
                    $_SESSION['login'] = true;
                        $_SESSION['id']    = $user->id;
                        $_SESSION['hash']  = $user->hash;
                        $_SESSION['salt']  = $user->salt;
                        $this->deElevateUser();
        }
    }

    public function login($email, $password) {
        $failures = $this->getFailures();
        if($failures >= 10) {
            throw new Exception('Login disabilitato. Riprova tra 10 minuti!');
        } elseif($failures > 0) {
            sleep($failures);
        }
        $user = Utenti::find("first", array('conditions' => array("email = ?", $email)));
        if($user) {
            $valid = $this->checkPassword($password, $user);
            if($valid) {
                $user->last_login_time = time();
                $user->last_login_ip = $_SERVER['REMOTE_ADDR'];
                $user->login = $user->login + 1;
                $user->save();
                $this->setCurrentUser($user);
                $this->checkUserValidity();
                $this->setNewSession();
                $_SESSION['login'] = true;
                $_SESSION['id']    = $user->id;
                $_SESSION['hash']  = $user->hash;
                $_SESSION['salt']  = $user->salt;
                $this->deElevateUser();
                $logData = array('id' => $user->id, 'nome' => $user->nome, 'cognome' => $user->cognome, 'date' => date('d-m-Y H:i:s'), 'ip' => $_SERVER['REMOTE_ADDR']);
                $logData = json_encode($logData);
                EventLogger::log('login()', $logData);
                $this->allowHTTPAccess();
            } else {
                $this->incrementFailures();
                throw new Exception("Dati errati!");
            }
        } else {
            $this->incrementFailures();
            throw new Exception("Dati errati!");
        }
        return array($this->getSessoDesinenza($user), $user->nome, $user->quota, $user->id);
    }

    public function logout() {
        if(isset($_SESSION['id']) && $_SESSION['id'] > 0) {
            $user = Utenti::first($_SESSION['id']);
            if($user) {
                $logData = array('id' => $user->id, 'nome' => $user->nome, 'cognome' => $user->cognome, 'date' => date('d-m-Y H:i:s'), 'ip' => $_SERVER['REMOTE_ADDR']);
                $logData = json_encode($logData);
                EventLogger::log('logout()', $logData, $user->id);
            }
        }
        $this->denyHTTPAccess();
        $_SESSION['id'] = -1;
        session_unset();
        session_destroy();
        $_SESSION = array();
        $this->setNewSession();
    }

    public function activateUserEmail($code) {
        if(strlen($code) != 32) {
            throw new Exception('Codice non valido!');
        }
        $user = Utenti::find('first', array('conditions' => array('activate_code = ? AND attivo = 0', $code)));
        if($user){
            $user->activate_code = '';
            $user->attivo = 1;
            $user->save();
            $desinenza = $this->getSessoDesinenza($user);
            $email_data_array = array(
                'to'          => $user->email,
                'subject'     => 'Verifica email effettuata',
                'html'        => true,
                'body'        => 'Car'.$desinenza.' '.$user->nome.', il tuo indirizzo email è stato confermato.<br>'.
                             'Prima di poter effettuare l\'accesso al sistema il tuo account deve essere accettato da un <b>Amministratore</b>.<br>'.
                             'Tale operazione verrà effettuata entro e non oltre le prossime 24 ore.',
                'nohtml_body' => 'Car'.$desinenza.' '.$user->nome.', il tuo indirizzo email è stato confermato.'."\n".
                             'Prima di poter effettuare l\'accesso al sistema il tuo account deve essere accettato da un Amministratore.'."\n".
                             'Tale operazione verrà effettuata entro e non oltre le prossime 24 ore.'
            );
            $email = new PoliRadioMailer();
            $email->sendEmail(0, $email_data_array);
            $logData = array('id' => $user->id, 'nome' => $user->nome, 'cognome' => $user->cognome, 'code' => $code, 'date' => date('d-m-Y H:i:s'), 'ip' => $_SERVER['REMOTE_ADDR']);
            $logData = json_encode($logData);
            EventLogger::log('activateUserEmail()', $logData, $user);
        }
        else {
            throw new Exception("Codice non valido!");
        }
    }

    public function confirmUserByAdmin($id) {
        $user = Utenti::first($id);
        if($user) {
            $user->attivo = 2;
            $user->save();
            $desinenza = $this->getSessoDesinenza($user);
            $email_data_array = array(
                'to'          => $user->email,
                'subject'     => 'Registrazione account STAFF',
                'html'        => true,
                'body'        => 'Car'.$desinenza.' '.$user->nome.', il tuo account è stato attivato.<br>'.
                             'Per proseguire con l\'accesso all\'area riservata <a href="http://www.poliradio.it/admin/login.php">clicca qui</a>',
                'nohtml_body' => 'Car'.$desinenza.' '.$user->nome.', il tuo account è stato attivato.'. "\n" .
                             'Per proseguire con l\'accesso all\'area riservata dirigiti al seguente indirizzo: http://www.poliradio.it/admin/login.php'
            );
            $email = new PoliRadioMailer();
            $email->sendEmail(0, $email_data_array);
            $data = array(
                'adminID'      => $this->getCurrentUser()->id,
                'adminNome'    => $this->getCurrentUser()->nome,
                'adminCognome' => $this->getCurrentUser()->cognome,
                'userID'       => $user->id,
                'userNome'     => $user->nome,
                'userCognome'  => $user->cognome
            );
            $data = json_encode($data);
            EventLogger::log('confirmUserByAdmin()', $data, $user);
        }
        else {
            throw new Exception("Utente non trovato!");
        }
    }

    private function setNewSession() {
        $_SESSION = array();
        $_SESSION['login'] = false;
        $_SESSION['id']    = -1;
        $_SESSION['hash']  = null;
        $_SESSION['salt']  = null;
    }

    public function userAuthenticated() {
        $this->initUserSession();
        return $_SESSION['login'] && $_SESSION['id'] > 0;
    }

    public function checkUserSession() {
        if($this->userAuthenticated()) {
            $this->checkCorrectUserSession();
            $this->allowHTTPAccess();
        }
        else {
            throw new Exception("Devi effettuare il login!");
        }
    }

    private function checkCorrectUserSession() {
        $user = Utenti::find('first', array('conditions' => array("id = ? AND hash = ? AND salt = ?", $_SESSION['id'], $_SESSION['hash'], $_SESSION['salt'])));
        $this->setCurrentUser($user);
        $this->checkUserValidity();
    }

    private function checkUserValidity() {
        $user = $this->getCurrentUser();
        if($user) {
            switch ($user->attivo) {
                case 0:
                    $this->logout();
                    throw new Exception("L'indirizzo email non è verificato! Controlla la casella di posta in arrivo / casella di posta indesiderata per confermare la tua email!");
                    break;
                case 1:
                    $this->logout();
                    throw new Exception("Il tuo account deve essere accettato da un amministratore!");
                    break;
                case 2:
                    break;
                default:
                    throw new Exception("Dati errati!");
            }
        }
        else {
            $this->logout();
            throw new Exception("Sessione scaduta. Devi fare nuovamente il login!");
        }
    }

    private function initUserSession() {
        if(!isset($_SESSION['login'])) {
            $this->setNewSession();
        }

    }

    public function creaUtente($params) {
        $allow = array(
            'nome', 'cognome', 'pseudonimo', 'sesso', 'data_nascita','stato_nascita', 'comune_nascita', 'provincia_nascita', 'codice_fiscale', 'residenza_stato',
            'residenza_comune', 'residenza_provincia', 'residenza_cap', 'residenza_indirizzo', 'residenza_civico','domicilio_stato', 'domicilio_comune',
            'domicilio_provincia', 'domicilio_cap', 'domicilio_indirizzo',  'domicilio_civico', 'studente_politecnico' , 'codice_persona', 'email' ,'prefisso',
            'telefono', 'telegram', 'password'
        );
        if(count($allow) != count($params)) {
            throw new Exception("Parametri non validi!");
        }
        foreach($allow as $key) {
            if(!isset($params[$key])) {
                throw new Exception("Parametri non validi!");
            }
        }
        $this->validateNome($params['nome']);
        $this->validateCognome($params['cognome']);
        $this->validateSesso($params['sesso']);
        $this->validateData($params['data_nascita'],'nascita');
        $this->validateStato($params['stato_nascita'], 'nascita');
        $this->validateComune($params['comune_nascita'], 'nascita');
        $this->validateProvincia($params['provincia_nascita'], 'nascita');
        $this->validateCodiceFiscale($params['codice_fiscale']);
        //$this->validateDug($params['residenza_dug'], 'residenza');
        $this->validateComune($params['residenza_comune'], 'residenza');
        $this->validateProvincia($params['residenza_provincia'], 'residenza');
        $this->validateCAP($params['residenza_cap'], 'residenza');
        $this->validateIndirizzo($params['residenza_indirizzo'], 'residenza');
        $this->validateStato($params['residenza_stato'], 'residenza');
        $this->validateCivico($params['residenza_civico'], 'residenza');
        $this->validateStato($params['domicilio_stato'], 'domicilio');
        $this->validateComune($params['domicilio_comune'], 'domicilio');
        $this->validateProvincia($params['domicilio_provincia'], 'domicilio');
        $this->validateCAP($params['domicilio_cap'], 'domicilio');
        $this->validateIndirizzo($params['domicilio_indirizzo'], 'domicilio');
        //$this->validateDug($params['domicilio_dug'], 'domicilio');
        $this->validateCivico($params['domicilio_civico'], 'domicilio');
        $this->validateEmail($params['email']);
        $this->validatePrefisso($params['prefisso']);
        $this->validateTelephone($params['telefono']);
        $this->validateTelegram($params['telegram']);
        $this->validateStudentePolitecnico($params['studente_politecnico']);
        $this->validateCodicePersona($params['codice_persona'],$params['studente_politecnico']);
        $this->validatePassword($params['password']);
        $user = new Utenti();
        foreach($params as $key => $value) {
            if($key == 'password') {
                $hs = new HashingSystem();
                $hs->createHash($params['password']);
                $user->hash = $hs->getHash();
                $user->salt = $hs->getSalt();
            }
            else $user->$key = $value;
        }
        $user->livello = 'MEMBRO';
        $user->tipo = $user->studente_politecnico == 1 ? 'SOCIO_ORDINARIO' : 'COLLABORATORE';
        $user->codice_persona = $user->studente_politecnico == 2 ? NULL : $user->codice_persona;
        //$user->accessoRedazione = 1;
        $user->data_iscrizione = date('Y-m-d');
        $user->save();
        if($user->is_invalid()) {
            throw new Exception($user->errors->full_messages());
        }
        $user->activate_code = $this->generateCodiceAttivazione($user->id);
        $user->save();
        $email_data_array = array(
            'to'          => $user->email,
            'subject'     => 'Registrazione account STAFF',
            'html'        => true,
            'body'        => 'Benvenut'. $this->getSessoDesinenza($user).' '.$user->nome.' nell\'area staff di Poliradio!<br>'.
                             'Puoi confermare la tua registrazione <a href="http://membri.poliradio.it/confirm/'.$user->activate_code.'">cliccando qui</a>.',
            'nohtml_body' => 'Benvenut'. $this->getSessoDesinenza($user).' '.$user->nome.' nell\'area staff di Poliradio!'. "\n" .
                             'Puoi confermare la tua registrazione dirigendoti su http://membri.poliradio.it/confirm/'.$user->activate_code
        );
        $email = new PoliRadioMailer();
        $email->sendEmail(0, $email_data_array);
        EventLogger::log('creaUtente()', $user->to_json(), $user->id);
    }

    public function generateCodiceAttivazione($id) {
        return md5($id.'-poliradio-'.time().'-hashing-'.sha1('xtra-*').rand(10,20));
    }

    public function editPassword($newPassword, $user = '') {
        if($user == '') {
            $user = $this->getCurrentUser();
            $admin_action = 0;
        } else {
            $this->onlyPosition('STATION_MANAGER');
            $admin_action = 1;
        }
        $this->validatePassword($newPassword);
        $hs = new HashingSystem();
        $hs->createHash($newPassword);
        $user->hash = $hs->getHash();
        $user->salt = $hs->getSalt();
        $user->save();
        if($user->is_invalid()) {
            throw new Exception($user->errors->full_messages());
        }
        $data = array(
            'userID'      => $user->id,
            'userNome'    => $user->nome,
            'userCognome' => $user->cognome,
            'date'        => date('d-m-Y H:i:s'),
            'ip'          => $_SERVER['REMOTE_ADDR']
        );
        if(!$admin_action) {
            $email = $user->email;
            $this->setNewSession();
            $_SESSION['pref_email'] = $email;
        }
        else {
            $data['adminID']      = $this->getCurrentUser()->id;
            $data['adminNome']    = $this->getCurrentUser()->nome;
            $data['adminCognome'] = $this->getCurrentUser()->cognome;
        }
        EventLogger::log('editPassword()', json_encode($data), $user);
    }

    public function editEmail($newEmail, $user = '') {
        if($user == '') {
            throw new Exception("Function disabled");
            $admin_action = 0;
            $user = $this->getCurrentUser();
        } else {
            $this->onlyPosition('STATION_MANAGER');
            $admin_action = 1;
        }
        $newEmail = strtolower($newEmail);
        if($user->email == $newEmail) return;
        $this->validateEmail($newEmail);
        $this->setUserData($user, 'email', $newEmail);
        if(!$admin_action) {
            $email = $user->email;
            $this->setNewSession();
            $_SESSION['pref_email'] = $email;
        }
    }

    public function setPhoto($newPhoto, $user = '') {
        if($user == '') {
            $admin_action = 0;
            $user = $this->getCurrentUser();
        } else {
            $this->onlyPosition('STATION_MANAGER');
            $admin_action = 1;
        }
        if($user->foto != $newPhoto) {
            $this->setUserData($user, 'foto', $newPhoto);
        } else {
            $data = array(
                'userID'      => $user->id,
                'userNome'    => $user->nome,
                'userCognome' => $user->cognome
            );
            if($admin_action) {
                $data['adminID']      = $this->getCurrentUser()->id;
                $data['adminNome']    = $this->getCurrentUser()->nome;
                $data['adminCognome'] = $this->getCurrentUser()->cognome;
            }
            EventLogger::log('setPhoto()', json_encode($data), $user);
        }
    }

    public function editTelephone($newTelephone, $user = '') {
        if($user == '') {
            $admin_action = 0;
            $user = $this->getCurrentUser();
        } else {
            $this->onlyPosition('STATION_MANAGER');
            $admin_action = 1;
        }
        if($user->telefono == $newTelephone) return;
        $this->validateTelephone($newTelephone);
        $this->setUserData($user, 'telefono', $newTelephone);
    }

    public function editOtherInfo($name, $value, $user = '') {
         if($user == '') {
                        $user = $this->getCurrentUser();
                } else {
                        $this->onlyPosition('STATION_MANAGER');
                }

        if($user->other_infos == '') {
            $infos = array();
        }
        else {
            $infos = json_decode($user->other_infos, true);
        }

        if(isset($infos[$name]) && $infos[$name] == $value) return;

        $infos[$name] = $value;
        $this->setUserData($user, 'other_infos', $infos);
    }

    public function editTelegram($newTelegram, $user = '') {
        if($user == '') {
            $admin_action = 0;
            $user = $this->getCurrentUser();
        } else {
            $this->onlyPosition('STATION_MANAGER');
            $admin_action = 1;
        }
        if($newTelegram[0] == '@') $newTelegram = str_replace('@', '', $newTelegram);
        if($user->telegram == $newTelegram) return;
        $this->validateTelegram($newTelegram);
        $this->setUserData($user, 'telegram', $newTelegram);
    }

    public function editDiscord($newDiscord, $user = '') {
        if($user == '') {
            $admin_action = 0;
            $user = $this->getCurrentUser();
        } else {
            $this->onlyPosition('STATION_MANAGER');
            $admin_action = 1;
        }
        if($user->discord == $newDiscord) return;
        $this->validateDiscord($newDiscord);
        $this->setUserData($user, 'discord', $newDiscord);
    }

    public function editNome($newName, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->nome == $newName) return;
        $this->validateNome($newName);
        $this->setUserData($user, 'nome', $this->formatDatabaseText($newName));
    }

    public function editPseudonimo($newPseudonimo, $user = '') {
         if($user == '') {
                        $admin_action = 0;
                        $user = $this->getCurrentUser();
                } else {
                        $this->onlyPosition('STATION_MANAGER');
                        $admin_action = 1;
                }
        if($user->pseudonimo == $newPseudonimo) return;
        $this->setUserData($user, 'pseudonimo', $newPseudonimo);
    }

    public function editQrCode($do, $user) {
        if($do != '{{REGEN}}') {
            return;
        }
        $this->onlyAdministrator();
        $ga = new GoogleAuthenticator();
        $secret = $ga->createSecret(32);
        $this->setUserData($user, 'userchecksum', $secret);
    }

    public function editCognome($newSurname, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->cognome == $newSurname) return;
        $this->validateCognome($newSurname);
        $this->setUserData($user, 'cognome', $this->formatDatabaseText($newSurname));
    }

    public function editSesso($newSex, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->sesso == $newSex) return;
        $this->validateSesso($newSex);
        $this->setUserData($user, 'sesso', (int)$newSex);
    }

    public function editDataNascita($newDate, $user) {
        $this->onlyPosition('STATION_MANAGER');
        //print_r($newDate);
        $newDate = substr($newDate,6) .'-'. substr($newDate,3,2) .'-'. substr($newDate,0,2);
        //print_r($newDate);
        if($user->data_nascita == $newDate) return;
        $this->validateData($newDate,'nascita');
        $this->setUserData($user, 'data_nascita', $newDate);
    }

    public function editDataIscrizione($newDate, $user) {
        $this->onlyPosition('STATION_MANAGER'); 
        $newDate = substr($newDate,6) .'-'. substr($newDate,3,2) .'-'. substr($newDate,0,2);
        if($user->data_iscrizione == $newDate) return;
        $this->validateData($newDate,'iscrizione');
        $this->setUserData($user, 'data_iscrizione', $newDate);
      }

    public function editComuneNascita($newComune, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->comune_nascita == $newComune) return;
        $this->validateComune($newComune, 'nascita');
        $this->setUserData($user, 'comune_nascita', $this->formatDatabaseText($newComune));
    }

    public function editProvinciaNascita($newProvincia, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->provincia_nascita == $newProvincia) return;
        $this->validateProvincia($newProvincia, 'nascita');
        $this->setUserData($user, 'provincia_nascita', $newProvincia);
    }

    public function editStatoNascita($newStato, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->stato_nascita == $newStato) return;
        $this->validateStato($newStato, 'nascita');
        $this->setUserData($user, 'stato_nascita', $this->formatDatabaseText($newStato));
        if($newStato != 'Italia') $this->setUserData($user, 'provincia_nascita','ESTERO');
    }

    public function editCodiceFiscale($newCodiceFiscale, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->codice_fiscale == $newCodiceFiscale) return;
        $this->validateCodiceFiscale($newCodiceFiscale);
        $this->setUserData($user, 'codice_fiscale', strtoupper($newCodiceFiscale));
    }
    public function editDocumento($newDocumento, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->tipo_documento == $newDocumento) return;
        $this->validateTipoDocumento($newDocumento);
        $this->setUserData($user, 'tipo_documento', (int)$newDocumento);
    }

    public function editCartaIdentita($newCartaIdentita, $user, $newTipoDocumento) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->carta_identita == $newCartaIdentita) return;
        $this->validateCartaIdentita($newCartaIdentita,$newTipoDocumento);
        $this->setUserData($user, 'carta_identita', strtoupper($newCartaIdentita));
    }

    public function editResidenzaComune($newComune, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->residenza_comune == $newComune) return;
        $this->validateComune($newComune, 'residenza');
        $this->setUserData($user, 'residenza_comune', $this->formatDatabaseText($newComune));
    }

    public function editResidenzaProvincia($newProvincia, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->residenza_provincia == $newProvincia) return;
        $this->validateProvincia($newProvincia, 'residenza');
        $this->setUserData($user, 'residenza_provincia', $newProvincia);
    }

    public function editResidenzaStato($newStato, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->residenza_stato == $newStato) return;
        $this->validateStato($newStato, 'residenza');
        $this->setUserData($user, 'residenza_stato', $this->formatDatabaseText($newStato));
    }

    public function editResidenzaCAP($newCAP, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->residenza_cap == $newCAP) return;
        $this->validateCAP($newCAP, 'residenza');
        $this->setUserData($user, 'residenza_cap', $newCAP);
    }

    public function editResidenzaDug($newDug, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->residenza_dug == $newDug) return;
        $this->validateDug($newDug, 'residenza');
        $this->setUserData($user, 'residenza_Dug', $this->formatDatabaseText($newDug));
    }

    public function editResidenzaIndirizzo($newIndirizzo, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->residenza_indirizzo == $newIndirizzo) return;
        $this->validateIndirizzo($newIndirizzo, 'residenza');
        $this->setUserData($user, 'residenza_indirizzo', $this->formatDatabaseText($newIndirizzo));
    }

    public function editResidenzaCivico($newCivico, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->residenza_civico == $newCivico) return;
        $this->validateCivico($newCivico, 'residenza');
        $this->setUserData($user, 'residenza_civico', strtoupper($newCivico));
    }

    public function editDomicilioComune($newComune, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->domicilio_comune == $newComune) return;
        $this->validateComune($newComune, 'domicilio');
        $this->setUserData($user, 'domicilio_comune', $this->formatDatabaseText($newComune));
    }

    public function editDomicilioProvincia($newProvincia, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->domicilio_provincia == $newProvincia) return;
        $this->validateProvincia($newProvincia, 'domicilio');
        $this->setUserData($user, 'domicilio_provincia',$newProvincia);
    }

    public function editDomicilioStato($newStato, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->domicilio_stato == $newStato) return;
        $this->validateStato($newStato, 'domicilio');
        $this->setUserData($user, 'domicilio_stato', $this->formatDatabaseText($newStato));
    }

    public function editDomicilioCAP($newCAP, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->domicilio_cap == $newCAP) return;
        $this->validateCAP($newCAP, 'domicilio');
        $this->setUserData($user, 'domicilio_cap', $newCAP);
    }

    public function editDomicilioDug($newDug, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->domicilio_dug == $newDug) return;
        $this->validateDug($newDug, 'domicilio');
        $this->setUserData($user, 'domicilio_Dug', $this->formatDatabaseText($newDug));
    }

    public function editDomicilioIndirizzo($newIndirizzo, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->domicilio_indirizzo == $newIndirizzo) return;
        $this->validateIndirizzo($newIndirizzo, 'domicilio');
        $this->setUserData($user, 'domicilio_indirizzo', $this->formatDatabaseText($newIndirizzo));
    }

    public function editDomicilioCivico($newCivico, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->domicilio_civico == $newCivico) return;
        $this->validateCivico($newCivico, 'domicilio');
        $this->setUserData($user, 'domicilio_civico', strtoupper($newCivico));
    }

    public function editPrefisso($newPrefisso, $user = '') {
        if($user == '') {
            $admin_action = 0;
            $user = $this->getCurrentUser();
        } else {
            $this->onlyPosition('STATION_MANAGER');
            $admin_action = 1;
        }
        if($user->prefisso == $newPrefisso) return;
        $this->validatePrefisso($newPrefisso);
        $this->setUserData($user, 'prefisso', (int)$newPrefisso);
    }

    public function editStudentePolitecnico($newStudentePolitecnico, $newCodicePersona, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->studente_politecnico == $newStudentePolitecnico && $user->codice_persona == $newCodicePersona) return;
        //Imposta il valore studente politecnico
        //$this->setUserData($user, 'studente_politecnico', $newStudentePolitecnico);
        //Imposta il codice persona
        if($newStudentePolitecnico == 2){
            $this->setUserData($user, 'studente_politecnico', 2);
            $this->setUserData($user, 'codice_persona', NULL);

        }elseif($newStudentePolitecnico == 1 && $newCodicePersona == ''){
            $this->setUserData($user, 'studente_politecnico', 2);
            throw new Exception("Inserire il Codice Persona!");


        }elseif($newStudentePolitecnico == 1 && $newCodicePersona != ''){
            $this->validateCodicePersona($newCodicePersona,$newStudentePolitecnico);
            $this->setUserData($user, 'codice_persona', $newCodicePersona);
        }

    }

    /*public function editCodicePersona($newCodicePersona, $user) {
        $this->onlyPosition('STATION_MANAGER');
          if($user->studente_politecnico == 2 && $user->codice_persona != NULL){
          $this->setUserData($user, 'codice_persona', NULL);
          throw new Exception("L'utente non è del Politecnico e non può avere un codice persona!");
        }
        if($user->codice_persona == $newCodicePersona) return;
        //echo $newCodicePersona;
        if($newCodicePersona == NULL){
            $this->setUserData($user, 'codice_persona', $newCodicePersona);
            return;
        }
        $this->validateCodicePersona($newCodicePersona);
        $this->setUserData($user, 'codice_persona', $newCodicePersona);
    }*/

    public function editCorsoLaurea($newCorsoLaurea, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->corso_laurea == $newCorsoLaurea) return;
        $this->setUserData($user, 'corso_laurea', $this->formatDatabaseText($newCorsoLaurea));
    }

    public function editQuota($newQuota, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->quota == $newQuota) return;
        $this->validateQuota($newQuota);
        $this->setUserData($user, 'quota', (int)$newQuota);
    }

    public function editFirma($newFirma, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->firma == $newFirma) return;
        $this->validateFirma($newFirma);
        $this->setUserData($user, 'firma', (int)$newFirma);
    }

    public function editLivello($newLevel, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->livello == $newLevel) return;
        $this->validateLivello($newLevel, $user);
        if($newLevel == 'MEMBRO') {
            $this->setUserData($user, 'userchecksum', '');
        }
        $this->setUserData($user, 'livello', $newLevel);
    }

    public function editAccessoOTP($access, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->otp_access == $access) return;
        if($access != 1) {
            $access = 0;
        }
        $this->setUserData($user, 'otp_access', $access);
    }

    public function editAccessoRedazione($access, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->accessoredazione == $access) return;
        if($access != 1) {
            $access = 0;
        }
        $this->setUserData($user, 'accessoredazione', $access);
    }

    public function editAdminRedazione($access, $user) {
        $this->onlyPosition('STATION_MANAGER');
                if($user->adminredazione == $access) return;
                if($access != 1) {
                        $access = 0;
                }
                $this->setUserData($user, 'adminredazione', $access);
        if($access == 1) {
            $this->setUserData($user, 'accessoredazione', 1);
        }
    }

    public function editType($newType, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->tipo == $newType) return;
        $this->validateType($newType, $user);
        $this->setUserData($user, 'tipo', $newType);
    }

    public function enableQuota($id) {
        $this->onlyDirettivo();
        $user = Utenti::first($id);
        $this->setUserData($user, 'quota', 1);
        return hfix($user->nome.' '.$user->cognome);
    }

    public function enableFirma($id) {
        $this->onlyDirettivo();
        $user = Utenti::first($id);
        $this->setUserData($user, 'firma', 1);
        return hfix($user->nome.' '.$user->cognome);
    }

    public function enableUser($id) {
        $this->onlyDirettivo();
        $user = Utenti::first($id);
        if($user->attivo != 1) {
            throw new Exception("L'utente deve confermare l'email per essere abilitato!");
        }
        $this->setUserData($user, 'attivo', 2);
        return hfix($user->nome.' '.$user->cognome);
    }

    public function editAttivo($newAttivo, $user) {
        $this->onlyPosition('STATION_MANAGER');
        if($user->attivo == $newAttivo) return;
        $this->validateAttivo($newAttivo);
        $this->setUserData($user, 'attivo', (int)$newAttivo);
    }

    public function editActivationCode($user) {
        $this->onlyPosition('STATION_MANAGER');
        $this->setUserData($user, 'activate_code', $this->generateCodiceAttivazione($user->id));
    }

    public function setActivationCodeNull($user) {
        $this->onlyPosition('STATION_MANAGER');
        $this->setUserData($user, 'activate_code', '');
    }

    private function isEmailDuplicate($email) {
        $search = Utenti::find('all', array('conditions' => array('email = ?', $email)));
        return count($search) > 0;
    }

    public function isEmailValid($email) {
        if(preg_match('/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/i',$email)) {
            return true;
        }
        return false;
    }

    public function validateEmail($email) {
        $email = strtolower($email);
        if(!$this->isEmailValid($email)){
            throw new Exception('Questo indirizzo email non &egrave; valido!');
        } elseif($this->isEmailDuplicate($email)) {
            throw new Exception('Questo indirizzo email &egrave; gi&agrave; in uso!');
        }
    }

    private function isTelephoneValid($telephone) {
        $len = strlen($telephone);
        if($len > 11 || $len < 8 || !is_numeric($telephone)) {
            return false;
        }
        return true;
    }

    private function isTelegramValid($telegram) {
        $len = strlen($telegram);
        if($len > 0 && $telegram[0] == '@') return false;
        return true;
    }

    private function isTelephoneDuplicate($telephone) {
        $search = Utenti::find('all', array('conditions' => array('telefono = ?', $telephone)));
        return count($search) > 0;
    }

    private function isTelegramDuplicate($telegram) {
        $search = Utenti::find('all', array('conditions' => array('telegram = ?', $telegram)));
        return count($search) > 0;
    }

    public function validatePrefisso($prefisso){
      if(!$this->dataTableActions->isPrefisso($prefisso)){
        throw new Exception('Prefisso Telefonico non valido!');
      }
    }


    public function validateTelephone($telephone) {
        if(!$this->isTelephoneValid($telephone)){
            throw new Exception('Questo numero di telefono non &egrave; valido!');
        } elseif($this->isTelephoneDuplicate($telephone)) {
            throw new Exception('Questo numero di telefono &egrave; gi&agrave; in uso!');
        }
    }

    public function validateTelegram($telegram) {
        if(!$this->isTelegramValid($telegram)){
            throw new Exception('Questo username di telegram non &egrave; valido!');
        } elseif($this->isTelegramDuplicate($telegram)) {
            throw new Exception('Questo username di telegram &egrave; gi&agrave; in uso!');
        }

    }

    public function validatePassword($password, $password2 = '', $password2Check = 0) {
        if($password2Check) {
            if($password != $password2) {
                throw new Exception('Le password non corrispondono!');
            }
        }
        $len = strlen($password);
        if($len < 6) {
            throw new Exception("Password troppo corta! (minimo 6 caratteri)");
        }
    }

    public function validateNome($nome) {
        if(strlen($nome) == 0 || !preg_match($this->name_pattern, $nome)) {
            throw new Exception("Nome non valido!");
        }
    }

    public function validateCognome($cognome) {
        if(strlen($cognome) == 0 || !preg_match($this->name_pattern, $cognome)) {
            throw new Exception("Cognome non valido!");
        }
    }

    public function validateSesso($sesso) {
        if($sesso > 3 && sesso < 1) {
            throw new Exception("Sesso non valido!");
        }
    }

    public function validateData($data,$type) {
        if($type == 'iscrizione'){
            //print_r($data);
            if($data < date('Y-m-d',strtotime('2007-12-14')) || $data > date('Y-m-d')){
            throw new Exception('Data di '.$type.' non valida!');
            }
        }else{
            if($data < date('Y')-99 || $data > date('Y')-16) {
                throw new Exception('Data di '.$type.' non valida!');
            }
        }
    }

    public function validateStato($stato, $type) {
        if(!$this->dataTableActions->isStato($stato)){
        //if(strlen($stato) == 0 || !preg_match('/^[\p{L}\' ]+$/ui', $stato)) {
            throw new Exception("Stato di ".$type." non valido!");
        }
    }

    public function validateComune($comune, $type) {
        if(strlen($comune) == 0 || !preg_match($this->name_pattern, $comune)) {
            throw new Exception("Comune di ".$type." non valido!");
        }
    }

    public function validateProvincia($provincia, $type) {
        if($provincia == 'Estero') $provincia = 'ESTERO';
        if(!$this->dataTableActions->isProvincia($provincia)){
        //if(strlen($provincia) == 0 || !preg_match('/^[\p{L}\' ]+$/ui', $provincia)) {
            throw new Exception("Provincia di ".$type." non valida!");
        }
    }

    public function validateCAP($cap, $type) {
        //throw new Exception("CAP di ".$type." non valido!");
    }

    public function validateDug($dug, $type) {
        if(strlen($dug) == 0 || !preg_match('/^[\p{L}\' ]+$/ui', $dug)) {
            throw new Exception("Dug di ".$type." non valido!");
        }
    }

    public function validateIndirizzo($indirizzo, $type) {
        if(strlen($indirizzo) == 0 || !preg_match($this->name_pattern, $indirizzo)) {
            throw new Exception("Indirizzo di ".$type." non valido!");
        }
    }

    public function validateCivico($civico, $type) {
        if(strlen($civico) == 0 || !preg_match('/^[0-9a-zA-Z\/ ]+$/i', $civico)) {
            throw new Exception("Civico di ".$type." non valido!");
        }
    }

    public function validateCodiceFiscale($codiceFiscale) {
        if(strlen($codiceFiscale) != 16 || !preg_match('/^[0-9a-zA-Z]+$/i', $codiceFiscale)){
            throw new Exception('Codice Fiscale non valido!');
        }
    }

    public function validateStudentePolitecnico($studente_politecnico){
      if($studente_politecnico == 1){
        //è ok
        return true;
      }
      if($studente_politecnico == 2){
        //non è studente politecnico
        return true;
      }else{
        throw new Exception('Studente Politecnico non valido!');
      }
    }

    public function validateCodicePersona($codicePersona,$studentePolitecnico){
        $len = strlen($codicePersona);
        if($codicePersona == '' && $studentePolitecnico == 2){
            return true;
        }elseif($len == 8 && is_numeric($codicePersona) && $studentePolitecnico == 1){
            return true;
        }else{

            throw new Exception('Codice Persona non valido');
        }
    }


    public function validateType($type) {
        if(!in_array($type, array_keys($this->nameOfType))) {
            throw new Exception("Tipo utente non valido!");
        }
    }

    public function validateLivello($livello, $user) {
        if($livello == 'MEMBRO') {
            return;
        }
        if(!in_array($livello, array_keys($this->nameOfLevel))) {
            throw new Exception("Posizione non valida!");
        }
        $anotherUser = Utenti::first(array('conditions' => array('livello = ? AND id <> ?', $livello, $user->id)));
        if($anotherUser) {
            throw new Exception('La posizione '.$this->nameOfLevel($livello).' &egrave; gi&agrave; occupata da '.hfix($anotherUser->nome." ".$anotherUser->cognome));
        }
    }

    public function validateFirma($firma) {
        if($firma != 0 && $firma != 1) {
            throw new Exception("Valore 'liberatoria firmata' non valido!");
        }
    }

    public function validateQuota($quota) {
        if($quota != 0 && $quota != 1) {
            throw new Exception("Valore 'quota associativa pagata' non valido!");
        }
    }

    public function validateAttivo($attivo) {
        if($attivo != 0 && $attivo != 1 && $attivo != 2 && $attivo != -1) {
            throw new Exception("Valore 'account attivo' non valido!");
        }
    }

    public function formatDatabaseText($text) {
        if(strlen($text) == 0) {
            return $text;
        }
        $exp = explode(' ', trim($text));
        for($a = 0; $a < count($exp); $a++) {
            $exp[$a] = strtolower($exp[$a]);
            $exp[$a][0] = strtoupper($exp[$a][0]);
        }
        return implode(' ', $exp);
    }

    private function setUserData($user, $data, $value) {
        $this->validateUser($user);
        $user->$data = $value;
        $user->save();
        if($user->is_invalid()) {
            throw new Exception($user->errors->full_messages());
        }
        $logData = array(
            'userID'      => $user->id,
            'userNome'    => $user->nome,
            'userCognome' => $user->cognome,
            $data         => $value,
            'parameter'   => $data
        );
        if($user->id != $this->getCurrentUser()->id) {
            $logData['adminID']      = $this->getCurrentUser()->id;
            $logData['adminNome']    = $this->getCurrentUser()->nome;
            $logData['adminCognome'] = $this->getCurrentUser()->cognome;
        }
        EventLogger::log('setUserData()', json_encode($logData), $user);
    }

    public function validateUser($user) {
        if(!is_object($user)) {
            throw new Exception("Variabile \$user non valida!");
        }
        if(get_class($user) != 'Utenti') {
            throw new Exception("Variabile \$user non valida!");
        }
        if(!isset($user->id)) {
            throw new Exception("Utente non valido!");
        }
    }

    public function validateCurrentUser() {
        $this->validateUser($this->user);
    }

    public function onlyDirettivo() {
        $user = $this->getCurrentUser();
        if(!$user->administrator && !in_array($user->livello, array_keys($this->direttivo))) {
            throw new Exception("Solo i membri del direttivo possono accedere a questa risorsa!");
        }
    }

    public function onlyAdministrator() {
        if(!$this->getCurrentUser()->administrator) {
            throw new Exception("Solo gli amministratori possono accedere a questa risorsa!");
        }
        if(!$this->isUserElevated()) {
            throw new Exception("Abilita i permessi di accesso per utilizzare questa risorsa!");
        }
    }

    public function deleteUser($id) {
        $this->onlyPosition('STATION_MANAGER');
        $user = Utenti::first($id);
        if(!$user) {
            throw new Exception("Utente non trovato!");
        }
        elseif(!$user->administrator) {
            $dati = $user->nome." ".$user->cognome;
            $data = $user->to_json();
            $data = json_decode($data, true);
            $data['adminID']      = $this->getCurrentUser()->id;
            $data['adminNome']    = $this->getCurrentUser()->nome;
            $data['adminCognome'] = $this->getCurrentUser()->cognome;
            $id = $user->id;
            $user->delete();
            EventLogger::log('deleteUser()', json_encode($data));
            return hfix($dati);
        } else {
            throw new Exception("Impossibile eliminare questo utente!");
        }
    }

    public function whoCanDoThis($level) {
        if(!isset($this->direttivo[$level])) {
            throw new Exception("Posizione ".hfix($level)." non trovata!");
        }
        $return = $this->direttivo[$level];
        $return[] = $level;
        return $return;
    }

    public function canElevate() {
        return $this->userAbleTo('DIRETTIVO');
    }

    // maiux 04/10/2018
    // disabled elevation two-factor auth, impractical
    public function isUserElevated() {
        //$this->checkElevationExpiration();
        //return $_SESSION['two-step'] && !$_SESSION['checksum'];
        return $this->canElevate();
    }

    public function deElevateUser() {
        $_SESSION['two-step'] = false;
        $_SESSION['checksum'] = true;
        $_SESSION['elevation'] = time() - 3600;
    }

    public function userHasQR($id) {
        $this->onlyAdministrator();
        $user = Utenti::first($id);
        if(!$user) {
            return;
        }
        return $user->userchecksum != '';
    }

    public function getUserQR($id) {
        $this->onlyAdministrator();
        $user = Utenti::first($id);
        if(!$user) {
            return;
        }
        $ga = new GoogleAuthenticator();
        return $ga->getQRCodeGoogleUrl('Poli.Radio', $user->userchecksum);
    }

    public function elevateUser($code, $password) {
        if(!$this->canElevate()) {
            return;
        }
        if(!$this->checkPassword($password, $this->getCurrentUser())) {
            return false;
        }
        $user = $this->getCurrentUser();
        $ga = new GoogleAuthenticator();
        if($user->userchecksum == null) {
            $user->userchecksum = $ga->createSecret(32);
            $user->save();
        }
        $_SESSION['two-step'] = $ga->verifyCode($user->userchecksum, $code, 2);
        $_SESSION['checksum'] = !$_SESSION['two-step'];
        $_SESSION['elevation'] = time()+7200; // 2h max
        return $_SESSION['two-step'];
    }

    public function checkElevationExpiration() {
        if($_SESSION['elevation'] < time()) {
            $this->deElevateUser();
        }
    }

    public function special_admin_redazione($level) {
        return $level == 'DIRETTORE_REDAZIONE' && $this->getCurrentUser()->adminredazione == 1;
    }

    public function isUserAbleTo($level) {
        if($this->special_admin_redazione($level)) return true;

        if(!$this->isUserElevated()) {
            return false;
        }
        return $this->userAbleTo($level);
    }

    public function isUnelevatedUserAbleTo($level) {
        return $this->userAbleTo($level);
    }

    private function userAbleTo($level) {
        $who = $this->whoCanDoThis($level);
        $user = $this->getCurrentUser();

        return in_array($user->livello, $who) || $user->administrator || $this->special_admin_redazione($level);
    }

    public function canAccessOTP() {
        return $this->isUserAbleTo('DIRETTIVO') or $this->getCurrentUser()->otp_access == 1;
    }

    public function onlyPosition($level) {
        if($this->special_admin_redazione($level)) return true;

        if(!$this->isUserElevated()) {
            throw new Exception("Abilita i permessi di accesso per utilizzare questa risorsa!");
        }
        if(!$this->isUserAbleTo($level)) {
            throw new Exception("Non sei abilitato ad utilizzare questa risorsa!");
        }
    }

    public function countAdministrators() {
        return Utenti::count(array('conditions' => array('administrator = 1')));
    }

    public function validateAdministrator($administrator, $user) {
        if($administrator != 1 && $administrator != 0) {
            throw new Exception("Valore per administrator non valido!");
        }
        if($user->administrator && $administrator == 0 && $this->countAdministrators() == 1) {
            throw new Exception("Non &egrave; possibile rimuovere l'unico amministratore del sistema!");
        }
    }

    public function editAdministrator($administrator, $user) {
        $this->onlyAdministrator();
        if($user->administrator == $administrator) return;
        $this->validateAdministrator($administrator, $user);
        $this->setUserData($user, 'administrator', $administrator);
        //TODO $this->notifyUpdate();
    }

    public function sendNotifications($titolo, $contenuto, $receivers, $sendemail) {
        $time = time();
        $sent = array();
        foreach ($receivers as $receiver) {
            $sent[] = $this->createNotification($receiver['id'], $receiver['type'], $titolo, $contenuto, $time, $sendemail);
        }
        $this->saveNotificationSent($sent, $titolo, $contenuto, $time);
        return 'Notifiche inviate a: <br>'.implode('<br>', $sent);
    }

    private function saveNotificationSent($receivers, $titolo, $contenuto, $time) {
        $this->onlyDirettivo();
        $notification = new SentNotifications();
        $notification->senderid  = $this->getCurrentUser()->id;
        $notification->titolo    = $titolo;
        $notification->contenuto = $contenuto;
        $notification->time      = $time;
        $notification->receivers = json_encode($receivers);
        $notification->save();
        if($notification->is_invalid()) {
            throw new Exception($notification->errors->full_messages());
        }
    }

    public function sendTelegramNotifications($titolo, $contenuto, $receivers) {
        $this->onlyDirettivo();
        $telegram_ids = array();
        foreach($receivers as $receiver) {
            if($receiver['type'] == 0) {
                $user = Utenti::first($receiver['id']);
                if(strlen($user->telegram) > 0) {
                    $telegram_ids[] = str_replace('@', '', $user->telegram);
                }
            }
            else {
                $prog = Programmi::first($receiver['id']);
                foreach($prog->programmi_utenti as $utente){
                    if($utente->referente) {
                        $user = $utente->utenti;
                        if(strlen($user->telegram) > 0) {
                                                $telegram_ids[] = str_replace('@', '', $user->telegram);
                                        }
                    }
                }
            }
        }
        require_once 'telegram/telegram.php';
        send_telegram_message($telegram_ids, $titolo, $contenuto);
    }

    public function createNotification($receiverID, $receiverType, $titolo, $contenuto, $time, $sendemail) {
        $this->onlyDirettivo();
        $return = '';
        if($receiverType == 0) {
            $return = Utenti::first($receiverID);
            $email = $sendemail ? $return->email : null;
            $return = '[U] '.$return->nome." ".$return->cognome;
        } else {
            $prog = Programmi::first($receiverID);
            $user = null;
            foreach($prog->programmi_utenti as $utente) {
                if($utente->referente) {
                    $user = $utente;
                }
            }
            $user = $user->utenti;
            $email = $sendemail ? $user->email : null;
            $return = '[P] '.$prog->nome.' ('.$user->nome." ".$user->cognome.')';
        }
        if(strlen($return) == 0) {
            return;
        }

        if($receiverType != 0) {
            $notification = new Notification();
            $notification->senderid     = $this->getCurrentUser()->id;
            $notification->receiverid   = $user->id;
            $notification->receivertype = 0;
            $notification->titolo       = $titolo;
            $notification->contenuto    = $contenuto;
            $notification->time         = $time;
            $notification->seentime     = 0;
            $notification->seen         = 0;
            $notification->save();
        }

        $notification = new Notification();
        $notification->senderid     = $this->getCurrentUser()->id;
        $notification->receiverid   = $receiverID;
        $notification->receivertype = $receiverType;
        $notification->titolo       = $titolo;
        $notification->contenuto    = $contenuto;
        $notification->time         = $time;
        $notification->seentime     = 0;
        $notification->seen         = 0;
        $notification->save();

        if($notification->is_invalid()) {
            throw new Exception($notification->errors->full_messages());
        }
        if($email != null) {
            $email_data_array = array(
                'to'          => $email,
                'subject'     => '[POLI.RADIO - Notifica] '.$titolo,
                'html'        => true,
                'body'        => $contenuto,
                'nohtml_body' => $contenuto
            );
            $email = new PoliRadioMailer();
            $email->sendEmail(0, $email_data_array);
        }
        $logData = array('senderid' => $this->getCurrentUser()->id, 'receiverid' => $notification->receiverid, 'receivertype' => $notification->receivertype, 'titolo' => $notification->titolo, 'contenuto' => $notification->contenuto, 'time' => time(), 'date' => date('d-m-Y H:i:s'), 'ip' => $_SERVER['REMOTE_ADDR']);
        $logData = json_encode($logData);
        EventLogger::log('createNotification()', $logData, $this->getCurrentUser()->id);
        return $return;
    }

    public function deleteNotification($notificationID) {
        $notification = Notification::first($notificationID);
        if(!$notification) {
            throw new Exception("Notifica non trovata.");
        }
        /*if($notification->seentime+5*24*3600 > time()) {
            throw new Exception("Per eliminare una notifica devono passare almeno 5 giorni dalla sua visualizzazione.");
        }
         */
        if($notification->seentime > time()) {
            throw new Exception("Per eliminare una notifica devi prima leggerla.");
        }
        if($notification->receivertype != 0 || $notification->receiverid != $this->getCurrentUser()->id) {
            throw new Exception("Non puoi eliminare questa notifica.");
        }
        $notification->delete();
    }

    private function allowHTTPAccess() {
        if($this->getCurrentUser()->administrator == 1) {
            $absPath = '/tmp/admin/';
            @mkdir($absPath);
            $fp = fopen($absPath.session_id(), 'w');
            fclose($fp);
        }

        $absPath = '/tmp/services/';
        @mkdir($absPath);
        $fp = fopen($absPath.session_id(), 'w');
        fclose($fp);
    }

    private function denyHTTPAccess() {
        @unlink('/tmp/admin/'.session_id());
        @unlink('/tmp/services/'.session_id());
    }

    public function forceDeleteNotification($sentNotificationID) {
        $this->onlyDirettivo();
        $notification = SentNotifications::first($sentNotificationID);
        if($notification->senderid != $this->getCurrentUser()->id) {
            throw new Exception("Non hai i permessi per eseguire questa azione!");
        }
        SentNotifications::connection()->query("DELETE FROM notifications WHERE senderid = '".$notification->senderid."' AND time = '".$notification->time."'");
        SentNotifications::connection()->query("DELETE FROM notifications_sent WHERE senderid = '".$notification->senderid."' AND time = '".$notification->time."'");
    }

    public function getSentNotifications($all = false) {
        $this->onlyDirettivo();
        if($all) {
            return SentNotifications::find('all', array('order' => 'id DESC'));
        }
        return SentNotifications::find('all', array('order' => 'id DESC', 'conditions' => array('senderid = ?', $this->getCurrentUser()->id)));
    }

    public function getLastNotification() {
        return Notification::first(array('order' => 'id DESC', 'conditions' => array('seen = 0 AND receivertype = 0 AND receiverid = ?', $this->getCurrentUser()->id)));
    }

    public function getAllNotificatons() {
        return Notification::find('all', array('order' => 'id DESC', 'conditions' => array('receivertype = 0 AND receiverid = ?', $this->getCurrentUser()->id)));
    }

    public function getSeenNotifications() {
        return Notification::find('all', array('order' => 'id DESC', 'conditions' => array('seen = 1 AND receivertype = 0 AND receiverid = ?', $this->getCurrentUser()->id)));
    }

    public function getUnseenNotifications() {
        return Notification::find('all', array('order' => 'id DESC', 'conditions' => array('seen = 0 AND receivertype = 0 AND receiverid = ?', $this->getCurrentUser()->id)));
    }

    public function countNotifications() {
        return Notification::count(array('conditions' => array('receivertype = 0 AND receiverid = ?', $this->getCurrentUser()->id)));
    }

    public function countUnseenNotifications() {
        return Notification::count(array('conditions' => array('seen = 0 AND receivertype = 0 AND receiverid = ?', $this->getCurrentUser()->id)));
    }

    public function setNotificationSeen($notificationID) {
        $notification = Notification::first($notificationID);
        if($notification) {
            if($notification->receivertype == 0 && $notification->receiverid == $this->getCurrentUser()->id) {
                $notification->seen = 1;
                $notification->seentime = time();
                $notification->save();
            }
        }
    }
}

?>
