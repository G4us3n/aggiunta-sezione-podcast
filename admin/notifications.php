<?php
include("includes/global.php");

$vars = array('active' => 'notifications');
try {
    $programActions->checkProgramSession();
    $currentProgram = $programActions->getCurrentProgram();
    if($currentProgram == null) goto thisException;
    if(isset($_GET['seen'])) {
        $programActions->setNotificationSeen($_GET['seen']);
        die();
    }
    if(isset($_GET['delete'])) {
        try {
            $programActions->deleteNotification($_GET['delete']);
        } catch(Exception $e) {
            echo '<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>'.$e->getMessage().'</div>';
        }
        die();
    }
    $vars['unseenNotifications'] = $programActions->getUnseenNotifications();
    $vars['unseenNotificationsCount'] = count ($vars['unseenNotifications']);
    $vars['seenNotifications']   = $programActions->getSeenNotifications();
    $vars['seenNotificationsCount'] = count ($vars['seenNotifications']);
    $vars['programActions'] = $programActions;
    $vars['program'] = $programActions->getCurrentProgram();
    $vars['notifications'] = $programActions->getAllNotificatons();
    $template->init('program', 'notifications');
} catch(Exception $e) {
    thisException:
    if(isset($_GET['seen'])) {
        $userActions->setNotificationSeen($_GET['seen']);
        die();
    }
    if(isset($_GET['forcedelete'])) {
        try {
            $userActions->forceDeleteNotification($_GET['forcedelete']);
        } catch(Exception $e) {
            echo '<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>'.$e->getMessage().'</div>';
        }
        die();
    }
    if(isset($_GET['delete'])) {
        try {
            $userActions->deleteNotification($_GET['delete']);
        } catch(Exception $e) {
            echo '<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>'.$e->getMessage().'</div>';
        }
        die();
    }
    if(isset($_GET['sent'])) {
        try {
            $userActions->onlyDirettivo();
            $vars['notifications'] = $userActions->getSentNotifications();
            $vars['forceDelete'] = 1;
        } catch(Exception $e) {
            header("location: index.php");
            die();
        }
        $template->init('admin', 'notifications_sent');
    }
    elseif(isset($_GET['sentall'])) {
        try {
            $userActions->onlyDirettivo();
            $vars['notifications'] = $userActions->getSentNotifications(true);
            $vars['forceDelete'] = 1;
            $vars['sentall'] = 1;
        } catch(Exception $e) {
            header("location: index.php");
            die();
        }
        $template->init('admin', 'notifications_sent');
    }
    elseif(isset($_GET['send'])) {
        try {
            $userActions->onlyDirettivo();
        } catch(Exception $e) {
            header("location: index.php");
            die();
        }
        $js  = $template->globalJS();
        $js .= '<script src="'.$template->getBaseUrl().'js/bootstrap-tagsinput.js"></script>'."\n";
        $js .= '<script src="'.$template->getBaseUrl().'js/bootstrap-tagsinput-angular.js"></script>'."\n";
        $js .= '<script src="'.$template->getBaseUrl().'js/jquery.contextMenu.js"></script>'."\n";
        $js .= '<script src="'.$template->getBaseUrl().'js/jquery.ui.position.js"></script>'."\n";
        $js .= '<script src="'.$template->getBaseUrl().'js/jquery.form.min.js"></script>'."\n";
        $template->setGlobalJS($js);
        $css  = $template->globalCSS();
        $css .= '<link href="'.$template->getBaseUrl().'css/bootstrap-tagsinput.css" rel="stylesheet">'."\n";
        $css .= '<link href="'.$template->getBaseUrl().'css/jquery.contextMenu.css" rel="stylesheet">'."\n";
        $template->setGlobalCSS($css);
        $template->init('admin', 'notification_send');
        $vars['no_quota_count'] = Utenti::count(array('conditions' => array('attivo = 2 and quota = 0')));
        $vars['no_firma_count'] = Utenti::count(array('conditions' => array('attivo = 2 and firma = 0')));
        if(isset($_POST['sendToType'])) {
            switch ($_POST['sendToType']) {
                case 0: // destinatari specifici
                    $destinatari = explode(',', $_POST['destinatari']);
                    for($a = 0; $a < count($destinatari); $a++) {
                        $tmp = explode(':', $destinatari[$a]);
                        $destinatari[$a] = array('id' => $tmp[1], 'type' => $tmp[0]);
                    }
                    break;
                case 1: // tutti gli utenti
                    $allUsers = Utenti::all(array('conditions' => array('attivo = 2')));
                    $destinatari = array();
                    foreach($allUsers as $utente) {
                        $destinatari[] = array('id' => $utente->id, 'type' => 0);
                    }
                    break;
                case 2: // tutti i programmi
                    $allPrograms = Programmi::all(array('conditions' => array('status = 0')));
                    $destinatari = array();
                    foreach($allPrograms as $programma) {
                        $destinatari[] = array('id' => $programma->id, 'type' => 1);
                    }
                    break;
                case 3: // direttivo
                    $dir = Utenti::find('all', array('conditions' => "livello <> '' AND livello <> 'MEMBRO'"));
                    $destinatari = array();
                    foreach($dir as $utente) {
                        $destinatari[] = array('id' => $utente->id, 'type' => 0);
                    }
                    break;
                case 4: // quota unpaid
                    $allUsers = Utenti::all(array('conditions' => array('attivo = 2 and quota = 0')));
                                        $destinatari = array();
                                        foreach($allUsers as $utente) {
                                                $destinatari[] = array('id' => $utente->id, 'type' => 0);
                                        }
                                        break;
                case 5: // liberatoria non firmata
                                        $allUsers = Utenti::all(array('conditions' => array('attivo = 2 and firma = 0')));
                                        $destinatari = array();
                                        foreach($allUsers as $utente) {
                                                $destinatari[] = array('id' => $utente->id, 'type' => 0);
                                        }
                                        break;
                default:
                    $vars['error'] = 'Errore!';
                    break;
            }
            if(!isset($vars['error'])) {
                $vars['success'] = $userActions->sendNotifications($_POST['oggetto'], $_POST['messaggio'], $destinatari, isset($_POST['sendemail']));
                if(isset($_POST['sendtelegram'])) {
                    $template->loadTemplate($vars); // fix for async
                    $userActions->sendTelegramNotifications($_POST['oggetto'], $_POST['messaggio'], $destinatari);
                    die(); // fix for async
                }
            }
        }
    }
    else {
        $vars['unseenNotifications'] = $userActions->getUnseenNotifications();
        $vars['unseenNotificationsCount'] = count ($vars['unseenNotifications']);
        $vars['seenNotifications']   = $userActions->getSeenNotifications();
        $vars['seenNotificationsCount'] = count ($vars['seenNotifications']);
        $vars['notifications'] = $userActions->getAllNotificatons();
        $template->init('admin', 'notifications');
    }
}
$template->loadTemplate($vars);
?>
