<?php
define('NO_PROGRAM', 1);
include("includes/global.php");
$vars = array('active' => 'profile');

/*
if(isset($_GET['email'])) {
    if(isset($_POST['email']) && isset($_POST['password'])) {
        if(!$userActions->checkPassword($_POST['password'])) {
            $vars['error_message'] = '<strong>Errore:</strong> password errata!';
        }
        else {
            try {
                $userActions->editEmail($_POST['email']);
                header("location: ".$template->getBaseUrl()."login/emailchanged");
            } catch(Exception $e) {
                $vars['error_message'] = '<strong>Errore:</strong> '.$e->getMessage();
            }
        }
    }
    $template->init('admin', 'profile_email');
} elseif....
*/

if(isset($_GET['password'])) {
    if(isset($_POST['oldpassword']) && isset($_POST['newpassword1']) && isset($_POST['newpassword2'])) {
        try {
            $userActions->validatePassword($_POST['newpassword1'], $_POST['newpassword2'], 1);
            $userActions->editPassword($_POST['newpassword1']);
            header("location: ".$template->getBaseUrl()."login/pwchanged");
        } catch(Exception $e) {
            $vars['error_message'] = '<strong>Errore:</strong> '.$e->getMessage();
        }
    }
    $template->init('admin', 'profile_password');
}
elseif(isset($_GET['profilo'])){
    if(isset($_POST['telefono'])) {
        try {
            $userActions->editPrefisso($_POST['prefisso']);
            $userActions->editTelephone($_POST['telefono']);
            $userActions->editTelegram($_POST['telegram']);
            //$userActions->editDiscord($_POST['discord']);
            $userActions->editPseudonimo($_POST['pseudonimo']);
            $vars['success_message'] = 'Profilo aggiornato correttamente';
        } catch(Exception $e) {
            $vars['error_message'] = '<strong>Errore:</strong> '.$e->getMessage();
        }
    }
    $vars['tabella_stati'] = $dataTableActions->getStati($continenti = [],$order = 'id_stati');
    $template->init('admin', 'profile_info');
}
elseif(isset($_GET['foto'])) {
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
            $fileName = md5('1337'.$userActions->getCurrentUser()->id."POLIRADIO").".".$ext;
            try {
                $userActions->setPhoto($absPath.$fileName);
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
    else {
        $js  = $template->globalJS();
        $js .= '<script src="'.$template->getBaseUrl().'js/jquery.form.min.js"></script>'."\n";
        $template->setGlobalJS($js);
        $vars['foto'] = $userActions->getCurrentUser()->foto != null && $userActions->getCurrentUser()->foto != '' ? $template->getBaseUrl().'../'.$userActions->getCurrentUser()->foto : 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIwAAACMCAIAAAAhotZpAAAACXBIWXMAAAsSAAALEgHS3X78AAABWUlEQVR42u3RQQ0AIAzAwPkXiwYk7AlN7hQ06Ry+N68D2JkUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFLABZMilhyJuwqMAAAAAElFTkSuQmCC';
        $template->init('admin', 'profile_photo');
    }
}
else {
    header("location: ".$template->getBaseUrl()."index.php");
}
$template->loadTemplate($vars);
?>
