<?php
include("includes/global.php");

$isDirettivo = $userActions->isUserAbleTo('DIRETTIVO');
$isDirettoreProgrammi = $userActions->isUserAbleTo('DIRETTORE_PROGRAMMI');
$currentProgram = null;

try {
    $programActions->checkProgramSession();
    $currentProgram = $programActions->getCurrentProgram();
} catch(Exception $e) {
    // Null
}

if($currentProgram) {
    $isDirettivo = false;
    $isDirettoreProgrammi = false;
}

$conditions = array(
    '',
    'status = 0',
    'status = 1',
    'status = 2',
    'status = 3'
);
$activePages = array(
    'Lista Programmi',
    'Lista Programmi Attivi e Visibili',
    'Lista Programmi Attivi e Non Visibili',
    'Lista Programmi Non Attivi e Visibili',
    'Lista Programmi Disabilitati'
);

if(isset($_GET['list']) && $isDirettivo) {
    $list = isset($conditions[(int)$_GET['list']]) ? (int)$_GET['list'] : 0;
}
else {
    $list = 1;
    $activePages = array(1 => 'Lista Programmi');
}

$activePage = $activePages[$list];
$vars = array('active' => 'programs', 'activePage' => $activePage, 'list' => $list, 'isDirettivo' => $isDirettivo, 'isDirettoreProgrammi' => $isDirettoreProgrammi);

if(isset($_GET['v']) && isset($_GET['p']) && isset($_GET['u']) && $isDirettoreProgrammi) {
    $programActions->changeProgramMemberVisibility($_GET['u'], $_GET['p']);
    die();
}
elseif(isset($_GET['new']) && $isDirettoreProgrammi) {
    if(!isset($_GET['list'])) {
        $vars['list'] = -1;
    }
    if(count($_POST) > 0) {
        $errors = array();
        try {
            $programActions->validateNome($_POST['nome']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
            unset($_POST['nome']);
        }
        try {
            $programActions->validateDescrizione($_POST['descrizione']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
            unset($_POST['descrizione']);
        }
        try {
            $programActions->validateDescrizioneLunga($_POST['descrizionelunga']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
            unset($_POST['descrizionelunga']);
        }
        try {
            $programActions->validateEmail($_POST['email']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
            unset($_POST['email']);
        }
        try {
            $programActions->validateSpotifyDirect($_POST['spotifyDirect']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
            unset($_POST['spotifyDirect']);
        }
        try {
            $programActions->validateSpotifyLink($_POST['spotifyHTTP']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
            unset($_POST['spotifyHTTP']);
        }
        try {
            $programActions->validateStato($_POST['status']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
            unset($_POST['status']);
        }
        if(count($errors) == 0) {
            $params = array(
                'nome'             => $_POST['nome'],
                'tag'              => $_POST['tag'],
                'descrizione'      => $_POST['descrizione'],
                'descrizionelunga' => $_POST['descrizionelunga'],
                'email'            => $_POST['email'],
                'facebook'         => $_POST['facebook'],
                'instagram'        => $_POST['instagram'],
                'twitter'          => $_POST['twitter'],
                'youtube'          => $_POST['youtube'],
                'mixcloud'         => $_POST['mixcloud'],
                'spotifylink'      => $_POST['spotifyHTTP'],
                'spotifydirect'    => $_POST['spotifyDirect'],
                'status'           => $_POST['status']
            );
            try {
                $id = $programActions->creaProgramma($params);
                header("location: programs.php?list=".$list."&p=".$id);
            } catch(Exception $e) {
                $errors[] = $e->getMessage();
            }
        }
        if(count($errors) > 0) {
            $vars['errors'] = $errors;
        }
    }
    $template->init('admin', 'program_new');
}
elseif(!isset($_GET['list']) && $currentProgram == null) {
    if($isDirettivo) {
        $template->init('admin', 'programs_dashboard');
        $programmiTotali           = Programmi::count();
        $programmiAttiviVisibili   = Programmi::count(array('conditions' => 'status = 0'));
        $programmiAttiviInvisibili = Programmi::count(array('conditions' => 'status = 1'));
        $programmiInattiviVisibili = Programmi::count(array('conditions' => 'status = 2'));
        $programmiDisabilitati     = Programmi::count(array('conditions' => 'status = 3'));
        $vars = array(
            'active'                    => 'programs',
            'programmiTotali'           => $programmiTotali,
            'programmiAttiviVisibili'   => $programmiAttiviVisibili,
            'programmiInattiviVisibili' => $programmiInattiviVisibili,
            'programmiAttiviInvisibili' => $programmiAttiviInvisibili,
            'programmiDisabilitati'     => $programmiDisabilitati,
            'isDirettivo'               => $isDirettivo,
            'isDirettoreProgrammi'      => $isDirettoreProgrammi
        );
        if(isset($success)) {
            $vars['success'] = $success;
        }
    }
    else {
        goto user_normale;
    }
}
else {
    if(isset($_POST['delete_program']) && $isDirettoreProgrammi) {
        try {
            $programDeleted = $programActions->deleteProgram($_POST['delete_program']);
            $success = 'Programma <b>'.$programDeleted.'</b> eliminato!';
            $vars['success'] = $success;
            if(isset($_GET['p'])) {
                unset($_GET['p']);
            }
            if(isset($_GET['u'])) {
                unset($_GET['u']);
            }
        } catch(Exception $e) {
            $error = $e->getMessage();
            $vars['error'] = $error;
        }
    }
    if(isset($_GET['p']) || ($currentProgram && !isset($_GET['s']) && !isset($_GET['m']))) {
        if($currentProgram) {
            $program = $currentProgram;
            $vars['active'] = 'profile';
        }
        else {
            $program = Programmi::first($_GET['p']);
        }
        if(!$program) {
            $template->init('admin', 'program_profile_not_found');
        } else {
            $vars['referente'] = $programActions->getReferente($program);
            $vars['statusProgramma'] = $programActions->getStatusProgramma();
            $vars['program'] = $program;
            $vars['isProgramMember'] = $programActions->isProgramMember($userActions->getCurrentUser(), $program);
            if($currentProgram) {
                $vars['programActions'] = $programActions;
                $template->init('program', 'profile');
            }
            else {
                $template->init('admin', 'program');
            }
        }
    }
    elseif(isset($_GET['s'])) {
        if($currentProgram) {
            $program = $currentProgram;
            $vars['active'] = 'profile';
        }
        else {
            $program = Programmi::first($_GET['s']);
        }
        if(!$program) {
            $template->init('admin', 'program_profile_not_found');
        } else {
            if(isset($_POST['userid']) && $isDirettoreProgrammi) {
                $user = Utenti::first($_POST['userid']);
                try {
                    $programActions->setNewProgramMember($user, $program, $_POST['ruolo'], (int)$_POST['referente']);
                    $vars['success'] = hfix($user->nome." ".$user->cognome)." aggiunto allo staff del programma!";
                } catch(Exception $e) {
                    $vars['error'] = $e->getMessage();
                }
            }
            elseif(isset($_POST['memberid']) && $isDirettoreProgrammi) {
                $user = Utenti::first($_POST['memberid']);
                try {
                    $programActions->removeProgramMember($user, $program);
                    $vars['success'] = hfix($user->nome." ".$user->cognome)." rimosso dallo staff del programma!";
                } catch(Exception $e) {
                    $vars['error'] = $e->getMessage();
                }
            }
            elseif(isset($_POST['useridedit']) && $isDirettoreProgrammi) {
                $user = Utenti::first($_POST['useridedit']);
                try {
                    $programActions->editProgramMember($user, $program, $_POST['ruolo'], $_POST['referente']);
                    $vars['success'] = "Ruolo di ".hfix($user->nome." ".$user->cognome)." modificato!";
                } catch(Exception $e) {
                    $vars['error'] = $e->getMessage();
                }
            }
            $staffCondition = "'".implode($programActions->getProgramStaffID($program), "', '")."'";
            $notStaff = Utenti::find('all', array('order' => 'cognome asc', 'conditions' => 'id NOT IN('.$staffCondition.')'));
            $vars['program'] = $program;
            $vars['roles'] = $programActions->getRole();
            $vars['notStaff'] = $notStaff;
            if($currentProgram) {
                $vars['programActions'] = $programActions;
                $template->init('program', 'staff');
            }
            else {
                $template->init('admin', 'program_staff');
            }
        }
    }
    elseif(isset($_GET['m'])) {
        if($currentProgram) {
            $program = $currentProgram;
            $vars['active'] = 'profile';
        }
        else {
            $program = Programmi::first($_GET['m']);
        }
        if(!$program) {
            $template->init('admin', 'program_profile_not_found');
        } else {
            if(!$programActions->isProgramMember($userActions->getCurrentUser(), $program) && !$isDirettoreProgrammi) {
                goto user_normale;
            }
            $js  = $template->globalJS();
            $js .= '<script src="'.$template->getBaseUrl().'js/jquery.form.min.js"></script>'."\n";
            $js .= '<script src="'.$template->getBaseUrl().'js/admin.profile_photo.js"></script>'."\n";
            $template->setGlobalJS($js);

            if(isset($_FILES["FileInput"])) {
                if($_FILES["FileInput"]["error"] == UPLOAD_ERR_OK) {
                    $absPath = 'photos/format/';
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
                    $fileName = md5('1337'.$program->id."POLIRADIO").".".$ext;
                    try {
                        $programActions->setLogo($absPath.$fileName, $program);
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
            
            if(isset($_FILES["BackgroundImageInput"])) {
                if($_FILES["BackgroundImageInput"]["error"] == UPLOAD_ERR_OK) {
                    $absPath = 'photos/backgrounds/';
                    $UploadDirectory = dirname(__FILE__).'/../'.$absPath;
                    /*if (!isset($_SERVER['HTTP_X_REQUESTED_WITH'])){
                        echo "Ciao";
                        die();
                    }*/
                    if ($_FILES["BackgroundImageInput"]["size"] > 10485760) {
                        //die('Dimensione file troppo grande!');
			die('<li><div class="alert alert-block alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Dimensione file troppo grande!</div></li>');
                    }

                    switch(strtolower($_FILES['BackgroundImageInput']['type'])) {
                        case 'image/png': 
                        case 'image/jpeg': 
                            break;
                        default:
			//	die('Formato non supportato!');
                            die('<li><div class="alert alert-block alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Formato non supportato!</div></li>');
                    }

                    $ext = explode('.', $_FILES['BackgroundImageInput']['name']);
                    $ext = strtolower($ext[count($ext)-1]);
                    $fileName = md5('1998'.$program->id."POLIRADIO").".".$ext;
                    try {
                        $programActions->setBackgroundImage($absPath.$fileName, $program);
                    } catch(Exception $e) {
                        //die($e->getMessage());
			die('<li><div class="alert alert-block alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>'.$e->getMessage().'!</div></li>');
                    }

                    if(move_uploaded_file($_FILES['BackgroundImageInput']['tmp_name'], $UploadDirectory.$fileName)) {              
                        //die('File caricato!');
			die('<li><div class="alert alert-block alert-success"><button type="button" class="close" data-dismiss="alert">&times;</button>File caricato!</div></li>');
                    }
                    else{
			//die('Impossibile caricare il file!');
                        die('<li><div class="alert alert-block alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Impossibile caricare il file!</div></li>');
                    }
                }
                else {
		    //print_r($_FILES["BackgroundImageInput"]["error"]);
                    //die('File non caricato');
		    die('<li><div class="alert alert-block alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>File non caricato </div></li>');
                }
            }

            if(count($_POST) > 0) {
                $errors = array();
                if($isDirettoreProgrammi) {
                    try {
                        $programActions->editNome($_POST['nome'], $program);
                    } catch(Exception $e) {
                        $errors[] = $e->getMessage();
                    }
 //print_r($errors);
                    try {
                        $programActions->editTag($_POST['tag'], $program);
                    } catch(Exception $e) {
                        $errors[] = $e->getMessage();
                    }
//print_r($errors);
//print_r($_POST);
                    try {
                        $colors = array(
                            'text'             => str_replace('#', '', $_POST['text']),
                            'background_color' => str_replace('#', '', $_POST['background_color']),
                            'border'           => str_replace('#', '', $_POST['border']),
                            'hover'            => str_replace('#', '', $_POST['hover'])
                        );
                        foreach($colors as $type => $color) {
                            if(!preg_match('/^[0-9a-f]{3,6}$/i', $color)) {
                                if(strlen($color) > 0) {
                                    throw new Exception("Colore '".$type."' non valido!");
                                }
                            }
                        }
                       //  $colors['background_image'] = $_POST['background_image'];
                        $programActions->setColors($colors, $program);
                    } catch(Exception $e) {
                        $errors[] = $e->getMessage();
                    }
// print_r($errors);
                }
                
		try {
                    $led_colors = array(
                        'studio' => str_replace('#', '', $_POST['led_studio']),
                        'on_air' => str_replace('#', '', $_POST['led_on_air']),
                        'tavoli' => str_replace('#', '', $_POST['led_tavoli']),
                    );
                    foreach($led_colors as $type => $color) {
                        if(!preg_match('/^[0-9a-f]{3,6}$/i', $color)) {
                            if(strlen($color) > 0) {
                                throw new Exception("Colore led '".$type."' non valido!");
                            }
                        }
                    }
                    $programActions->setLedColor($led_colors, $program);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $programActions->editDescrizione($_POST['descrizione'], $program);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $programActions->editDescrizioneLunga($_POST['descrizionelunga'], $program);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $programActions->editEmail($_POST['email'], $program);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $programActions->editFacebook($_POST['facebook'], $program);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $programActions->editInstagram($_POST['instagram'], $program);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $programActions->editTwitter($_POST['twitter'], $program);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $programActions->editYoutube($_POST['youtube'], $program);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $programActions->editMixcloud($_POST['mixcloud'], $program);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $programActions->editSpotifyDirect($_POST['spotifyDirect'], $program);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                try {
                    $programActions->editSpotifyLink($_POST['spotifyHTTP'], $program);
                } catch(Exception $e) {
                    $errors[] = $e->getMessage();
                }
                if($isDirettoreProgrammi) {
                    try {
                        $programActions->editStato($_POST['status'], $program);
                    } catch(Exception $e) {
                        $errors[] = $e->getMessage();
                    }
                }
                if(count($errors) > 0) {
                    $vars['errors'] = $errors;
                }   
            }
            $vars['program'] = $program;
            if($currentProgram) {
                $vars['programActions'] = $programActions;
                $js  = $template->globalJS();
                $js .= '<script src="'.$template->getBaseUrl().'js/jquery-ui.js"></script>'."\n";
                $js .= '<script src="'.$template->getBaseUrl().'colorPicker/jquery.colorpicker.js"></script>'."\n";
                $js .= '<script type="text/javascript">$(\'.colorpicker\').colorpicker();</script>';
                $template->setGlobalJS($js);
                $css = $template->globalCSS();
                $css .= '<link href="'.$template->getBaseUrl().'css/jquery-ui.css" rel="stylesheet">'."\n";
                $css .= '<link href="'.$template->getBaseUrl().'colorPicker/jquery.colorpicker.css" rel="stylesheet">'."\n";
                $template->setGlobalCSS($css);
                $template->init('program', 'edit');
                $vars['active'] = 'profile';
            }
            else {
                $js  = $template->globalJS();
                $js .= '<script src="'.$template->getBaseUrl().'js/jquery-ui.js"></script>'."\n";
                $js .= '<script src="'.$template->getBaseUrl().'colorPicker/jquery.colorpicker.js"></script>'."\n";
                $js .= '<script type="text/javascript">
                    $(document).ready(function() {
                        $(\'.colorpicker\').colorpicker();
                    });
                </script>';
                $template->setGlobalJS($js);
                $css = $template->globalCSS();
                $css .= '<link href="'.$template->getBaseUrl().'css/jquery-ui.css" rel="stylesheet">'."\n";
                $css .= '<link href="'.$template->getBaseUrl().'colorPicker/jquery.colorpicker.css" rel="stylesheet">'."\n";
                $template->setGlobalCSS($css);
                $template->init('admin', 'program_edit');
            }
        }
    }
    else {
        user_normale:
        $condition  = $conditions[$list];
        $vars['statusProgramma'] = $programActions->getStatusProgramma();
        $programs = Programmi::all(array('order' => 'nome asc', 'conditions' => $condition));
        $vars['programs'] = $programs;
        $vars['programActions'] = $programActions;
        $template->init('admin', 'programs');
    }
}

$template->loadTemplate($vars);
?>
