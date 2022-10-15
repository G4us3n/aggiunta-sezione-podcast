<?php
define('NO_PROGRAM', 1);
include("includes/global.php");

if(isset($_GET['resetquote'])){
    if($userActions->getCurrentUser()->administrator && $userActions->isUserElevated()) {
        Utenti::connection()->query('UPDATE utenti SET quota = 0');
    }
    die();
}

if(isset($_GET['resetfirma'])){
    if($userActions->getCurrentUser()->administrator && $userActions->isUserElevated()){
        Utenti::connection()->query('UPDATE utenti SET firma = 0');
    }
    die();
}

if(isset($_GET['suid'])) {
    if($userActions->getCurrentUser()->administrator && $userActions->isUserElevated()) {
        if(in_array($userActions->getCurrentUser()->id, $enabled_suid)) {
            try{
                    $userActions->login_as_user($_GET['suid']);
                header("location: index.php");
            } catch(Exception $e) {
                print('Impossibile fare il login con questo utente!');
                header("refresh: 2; url=index.php");
            }
        }
    }
    die();
}

if(isset($_GET['slack_invite'])) {
    if($userActions->getCurrentUser()->administrator && $userActions->isUserElevated()) {
        include('includes/slack_invite.php');
        $invite_id = (int)$_GET['slack_invite'];
        $invite_user = Utenti::find($invite_id);

        if($invite_user) {
            $email = $invite_user->email;
            $nome = $invite_user->nome;
            $cognome = $invite_user->cognome;
            $invito = slack_invite($email, $nome, $cognome);
            $invito = json_decode($invito, true);
            if($invito['ok']) {
                echo '<font color="green">Invito spedito con successo!</font>';
            }
            else{
                echo '<font color="red">Errore: '.$invito['error'].'</font>';
            }
        }

    }
    die();
}

$isDirettivo = $userActions->isUserAbleTo('DIRETTIVO');
$isStationManager = $userActions->isUserAbleTo('STATION_MANAGER');

if(!isset($_GET['list']) && $isDirettivo) {
    $template->init('admin', 'users_dashboard');
    $membriTotali     = Utenti::count();
    $membriUomini     = Utenti::count(array('conditions' => 'sesso = 2 AND attivo != -1'));
    $membriDonna      = Utenti::count(array('conditions' => 'sesso = 1 AND attivo != -1'));
    $membriAltro      = Utenti::count(array('conditions' => 'sesso = 3 AND attivo != -1'));
    $membriQuota      = Utenti::count(array('conditions' => 'quota = 0 AND attivo != -1'));
    $membriFirma      = Utenti::count(array('conditions' => 'firma = 0 AND attivo != -1'));
    $membriNonAttivi  = Utenti::count(array('conditions' => 'attivo = -1'));
    $membriAttivare1  = Utenti::count(array('conditions' => 'attivo = 0'));
    $membriAttivare2  = Utenti::count(array('conditions' => 'attivo = 1'));
    $membriAttivi     = Utenti::count(array('conditions' => 'attivo = 2'));
    $membriFirmaQuota = Utenti::count(array('conditions' => 'quota = 0 AND firma = 0 AND attivo != -1'));
    $membriAdministrator = Utenti::count(array('conditions' => 'administrator = 1'));
    $membriDirettivo = Utenti::count(array('conditions' => "livello <> '' AND livello <> 'MEMBRO' AND attivo != -1"));
    $collaboratori    = Utenti::count(array('conditions' => "tipo = 'COLLABORATORE' AND attivo != -1"));
    $socio_ordinario  = Utenti::count(array('conditions' => "tipo = 'SOCIO_ORDINARIO' AND attivo != -1"));
    $socio_onorario   = Utenti::count(array('conditions' => "tipo = 'SOCIO_ONORARIO' AND attivo != -1"));
    $noAccessoRedazione = Utenti::count(array('conditions' => 'accessoRedazione = 0 AND attivo != -1'));
    $accessoRedazione = Utenti::count(array('conditions' => 'accessoRedazione = 1 AND attivo != -1'));
    $adminRedazione = Utenti::count(array('conditions' => 'adminredazione = 1 AND attivo != -1'));
    $accessoOTP = Utenti::count(array('conditions' => 'otp_access = 1 AND attivo != -1'));
    $vars = array(
        'active'              => 'users',
        'membriTotali'        => $membriTotali,
        'membriUomini'        => $membriUomini,
        'membriDonna'         => $membriDonna,
        'membriAltro'         => $membriAltro,
        'membriQuota'         => $membriQuota,
        'membriFirma'         => $membriFirma,
        'membriNonAttivi'     => $membriNonAttivi,
        'membriAttivare1'     => $membriAttivare1,
        'membriAttivare2'     => $membriAttivare2,
        'membriAttivi'        => $membriAttivi,
        'membriFirmaQuota'    => $membriFirmaQuota,
        'membriAdministrator' => $membriAdministrator,
        'membriDirettivo'     => $membriDirettivo,
        'membriRedazione'     => $accessoRedazione,
        'membriNoRedazione'   => $noAccessoRedazione,
        'membriAdminRedazione' => $adminRedazione,
        'collaboratori'       => $collaboratori,
        'socio_ordinario'     => $socio_ordinario,
        'socio_onorario'      => $socio_onorario,
        'isDirettivo'         => $isDirettivo,
        'isStationManager'    => $isStationManager,
        'ableToScheda'        => $userActions->isUnelevatedUserAbleTo('DIRETTIVO'),
        'membriAccessoOTP'    => $accessoOTP,
    );
}
else {
    $conditions = array(
        '',
        'attivo = 2',
        'attivo = 0',
        'attivo = 1',
        'attivo = -1',
        'sesso = 2 AND attivo != -1',
        'sesso = 1 AND attivo != -1',
        'sesso = 3 AND attivo != -1',
        'quota = 0 AND attivo != -1',
        'firma = 0 AND attivo != -1',
        'firma = 0 AND quota = 0 AND attivo != -1',
        'administrator = 1',
        "livello <> '' AND livello <> 'MEMBRO' AND attivo != -1",
        "accessoRedazione = 0 AND attivo != -1",
        "accessoRedazione = 1 AND attivo != -1",
        "tipo = 'SOCIO_ORDINARIO' AND attivo != -1",
        "tipo = 'SOCIO_ONORARIO' AND attivo != -1",
        "tipo = 'COLLABORATORE' AND attivo != -1",
        'adminredazione = 1 AND attivo != -1',
        'otp_access = 1 AND attivo != -1',
    );
    $activePages = array(
        'Lista Membri',
        'Lista Membri Attivi',
        'Lista Membri da attivare (step 1)',
        'Lista Membri da attivare (step 2)',
        'Lista Membri non attivi',
        'Lista Membri Uomini',
        'Lista Membri Donne',
        'Lista Membri Altro Sesso',
        'Lista Membri con quota non pagata',
        'Lista Membri con liberatoria non firmata',
        'Lista Membri con quota non pagata e liberatoria non firmata',
        'Lista Amministratori',
        'Lista Membri del Direttivo',
        'Lista Membri senza accesso alla Redazione',
        'Lista Membri con accesso alla Redazione',
        'Lista Membri \'Socio Ordinario\'',
        'Lista Membri \'Socio Onorario\'',
        'Lista Membri \'Collaboratore\'',
        'Lista Membri con accesso Amministratore alla Redazione',
        'Lista Membri con accesso OTP'
    );
    if(!$isDirettivo) {
        $list = 1;
        $activePage = $activePages[0];
    }
    else {
        $list = isset($conditions[(int)$_GET['list']]) ? (int)$_GET['list'] : 0;
        $activePage = $activePages[$list];
    }
    $condition  = $conditions[$list];
    $nameOfLevel = $userActions->nameOfLevel();
    $nameOfType = $userActions->nameOfType();
    $vars = array('active' => 'users', 'activePage' => $activePage, 'list' => $list, 'nameOfType' => $nameOfType, 'nameOfLevel' => $nameOfLevel, 'isDirettivo' => $isDirettivo, 'ableToScheda' => $userActions->isUnelevatedUserAbleTo('DIRETTIVO'), 'isStationManager' => $isStationManager);
    if(isset($_POST['delete_user']) && $isStationManager) {
        try {
            $userDeleted = $userActions->deleteUser($_POST['delete_user']);
            $success = 'Utente <b>'.$userDeleted.'</b> eliminato!';
            $vars['success'] = $success;
            if(isset($_GET['m'])) {
                unset($_GET['m']);
            }
            if(isset($_GET['u'])) {
                unset($_GET['u']);
            }
        } catch(Exception $e) {
            $error = $e->getMessage();
            $vars['error'] = $error;
        }
    }
    if(isset($_POST['enable_firma']) && $isDirettivo) {
        try {
            $userEnabled = $userActions->enableFirma($_POST['enable_firma']);
            $success = 'Liberatoria impostata come firmata per <b>'.$userEnabled.'</b>!';
            $vars['success'] = $success;
            if(isset($_GET['m'])) {
                unset($_GET['m']);
            }
            if(isset($_GET['u'])) {
                unset($_GET['u']);
            }
        } catch(Exception $e) {
            $error = $e->getMessage();
            $vars['error'] = $error;
        }
    }
    if(isset($_POST['enable_user']) && $isDirettivo) {
        try {
            $userEnabled = $userActions->enableUser($_POST['enable_user']);
            $success = 'Utente <b>'.$userEnabled.'</b> abilitato!';
            $vars['success'] = $success;
            if(isset($_GET['m'])) {
                unset($_GET['m']);
            }
            if(isset($_GET['u'])) {
                unset($_GET['u']);
            }
        } catch(Exception $e) {
            $error = $e->getMessage();
            $vars['error'] = $error;
        }
    }
    if(isset($_POST['enable_quota']) && $isDirettivo) {
        try {
            $userEnabled = $userActions->enableQuota($_POST['enable_quota']);
            $success = 'Quota associativa impostata come pagata per <b>'.$userEnabled.'</b>!';
            $vars['success'] = $success;
            if(isset($_GET['m'])) {
                unset($_GET['m']);
            }
            if(isset($_GET['u'])) {
                unset($_GET['u']);
            }
        } catch(Exception $e) {
            $error = $e->getMessage();
            $vars['error'] = $error;
        }
    }
    if(isset($_GET['u'])) {
        $user = Utenti::first($_GET['u']);
        if(!$user) {
            $template->init('admin', 'user_profile_not_found');
        } else {
            $vars['user'] = $user;
            $vars['tabella_province'] = $dataTableActions->getProvince($regioni = [],$order = 'id_province');
            $vars['tabella_stati'] = $dataTableActions->getStati($continenti = [],$order = 'id_stati');
            $vars['programActions'] = $programActions;
            $vars['sessoValue'] = $userActions->getSessoValue($user->sesso);
            $vars['nameOfLevel'] = $userActions->nameOfLevel();
            $vars['nameOfType'] = $userActions->nameOfType();
            $template->init('admin', 'user_profile');

        }
    }
    elseif(isset($_GET['m']) && $isStationManager) {
        $user = Utenti::first($_GET['m']);
        if(!$user) {
            $template->init('admin', 'user_profile_not_found');
        } else {
            $js  = $template->globalJS();
            $js .= '<script src="'.$template->getBaseUrl().'js/jquery.form.min.js"></script>'."\n";
            $js .= '<script src="'.$template->getBaseUrl().'js/admin.profile_photo.js"></script>'."\n";
            $js .= '<script src="'.$template->getBaseUrl().'js/bootstrap-datepicker.min.js"></script>'."\n";
            $js .= '<script src="'.$template->getBaseUrl().'js/bootstrap-datepicker.it.min.js"></script>'."\n";
            $js .= '<script type="text/javascript">$(function() { $("#datepicker").datepicker({language: "it", autoclose: true}); });</script>'."\n";
            $js .= '<script type="text/javascript">$(function() { $("#datepicker2").datepicker({language: "it", autoclose: true}); });</script>'."\n";
            $template->setGlobalJS($js);

            $css  = $template->globalCSS();
            $css .= '<link href="'.$template->getBaseUrl().'css/bootstrap-datepicker.min.css" rel="stylesheet">'."\n";
            $template->setGlobalCSS($css);

            $vars['sessoValue'] = $userActions->getSessoValue();
            $vars['mesiValue'] = $userActions->getMesiValue();
            $vars['tabella_province'] = $dataTableActions->getProvince();
            $vars['tabella_stati'] = $dataTableActions->getStati();

            if(isset($_FILES["FileInput"])) {
                if($_FILES["FileInput"]["error"] == UPLOAD_ERR_OK) {
                    $absPath = 'photos/user/';
                    $UploadDirectory = dirname(__FILE__).'/../'.$absPath;

                    if (!isset($_SERVER['HTTP_X_REQUESTED_WITH'])){
                        die();
                    }

                    if ($_FILES["FileInput"]["size"] > 10485760) {
                        die('<div class="alert alert-block alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Dimensione file troppo grande!</div>');
                    }

                    switch(strtolower($_FILES['FileInput']['type'])) {
                        case 'image/png':
                        case 'image/gif':
                        case 'image/jpeg':
                            break;
                        default:
                            die('<div class="alert alert-block alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Formato non supportato!</div>');
                    }

                    $ext = explode('.', $_FILES['FileInput']['name']);
                    $ext = strtolower($ext[count($ext)-1]);
                    $fileName = md5('1337'.$user->id."POLIRADIO").".".$ext;
                    try {
                        $userActions->setPhoto($absPath.$fileName, $user);
                    } catch(Exception $e) {
                        die('<div class="alert alert-block alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>'.$e->getMessage().'!</div>');
                    }

                    if(move_uploaded_file($_FILES['FileInput']['tmp_name'], $UploadDirectory.$fileName)) {
                        die('<div class="alert alert-block alert-success"><button type="button" class="close" data-dismiss="alert">&times;</button>File caricato!</div>');
                    }
                    else{
                        die('<div class="alert alert-block alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Impossibile caricare il file!</div>');
                    }
                }
                else {
                    die('<div class="alert alert-block alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>File non caricato ('.$phpFileUploadErrors[$_FILES["FileInput"]["error"]].')!</div>');
                }
            }

            if(count($_POST) > 0) {
                $errors = array();
                try {
                    $userActions->editNome($_POST['nome'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editCognome($_POST['cognome'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editSesso($_POST['sesso'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editEmail($_POST['email'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editPrefisso($_POST['prefisso'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editTelephone($_POST['telefono'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editTelegram($_POST['telegram'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }

                try {
                    $userActions->editPseudonimo($_POST['pseudonimo'], $user);
                } catch(Exception $e) {
                                        $errors[] = $e->getMessage();
                                }

                /*
                maiux 04/10/2018 - two-step disabled, impractical
                try {
                    $userActions->editQrCode($_POST['inputQrSecret'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                */
                try {
                    $userActions->editComuneNascita($_POST['comune_nascita'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editProvinciaNascita($_POST['provincia_nascita'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editStatoNascita($_POST['stato_nascita'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editAccessoRedazione($_POST['redazione'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editAccessoOTP($_POST['otp-access'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editAdminRedazione($_POST['adminredazione'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editDataNascita($_POST['data_nascita'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                /*try {
                    $userActions->editDataIscrizione($_POST['data_iscrizione'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }*/
                try {
                    $userActions->editCodiceFiscale($_POST['codice_fiscale'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editResidenzaStato($_POST['residenza_stato'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editResidenzaComune($_POST['residenza_comune'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editResidenzaProvincia($_POST['residenza_provincia'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editResidenzaCAP($_POST['residenza_cap'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editResidenzaIndirizzo($_POST['residenza_indirizzo'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editResidenzaCivico($_POST['residenza_civico'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editDomicilioStato($_POST['domicilio_stato'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editDomicilioComune($_POST['domicilio_comune'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editDomicilioProvincia($_POST['domicilio_provincia'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editDomicilioCAP($_POST['domicilio_cap'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editDomicilioIndirizzo($_POST['domicilio_indirizzo'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editDomicilioCivico($_POST['domicilio_civico'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                //modifica sia il valore studente che il codice persona
                try {
                    $userActions->editStudentePolitecnico($_POST['studente_politecnico'],$_POST['codice_persona'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                /*try {
                    $userActions->editCodicePersona($_POST['codice_persona'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }*/
                try {
                    $userActions->editQuota($_POST['quota'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editFirma($_POST['firma'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editAttivo($_POST['attivo'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    if(strlen($_POST['password']) > 0) {
                        $userActions->editPassword($_POST['password'], $user);
                    }
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editAdministrator($_POST['administrator'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editLivello($_POST['livello'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $userActions->editType($_POST['type'], $user);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    if($_POST['activate_code'] == '{{REGEN}}') {
                        $userActions->editActivationCode($user);
                    }
                    if($_POST['activate_code'] == '' && $user->activate_code != '') {
                        $userActions->setActivationCodeNull($user);
                    }
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                if(count($errors) > 0) {
                    $vars['errors'] = $errors;
                }
            }
            $vars['user'] = $user;
            $vars['nameOfLevel'] = $userActions->nameOfLevel();
            $vars['nameOfType'] = $userActions->nameOfType();
            $template->init('admin', 'user_profile_edit');
        }
    }
    else {
        $users = Utenti::all(array('order' => 'cognome asc', 'conditions' => $condition));
        $vars['users'] = $users;
        $template->init('admin', 'users');
    }
}
$template->loadTemplate($vars);
?>
