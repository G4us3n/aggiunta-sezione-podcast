<?php
require_once dirname(__FILE__) . '/../../includes/function.php';
require_once dirname(__FILE__) . '/useractions.class.php';
require_once dirname(__FILE__) . '/programactions.class.php';
require_once dirname(__FILE__) . '/newsactions.class.php';
require_once dirname(__FILE__) . '/podcastactions.class.php';
require_once dirname(__FILE__) . '/tagactions.class.php';
require_once dirname(__FILE__) . '/linkindex.class.php';
require_once dirname(__FILE__) . '/noticeSpeakeractions.class.php';
require_once dirname(__FILE__) . '/datatableactions.class.php';

//global $template, $userActions;

//$template = new Template('http://localhost/r/admin/', true);
$template = new Template('https://membri.poliradio.it/', true);

$js  = '<script src="'.$template->getBaseUrl().'js/jquery.js"></script>'."\n";
$js .= '<script src="'.$template->getBaseUrl().'js/bootstrap.js"></script>'."\n";
$template->setGlobalJS($js);

$css = '<link href="'.$template->getBaseUrl().'css/bootstrap.css" rel="stylesheet">'."\n";
$css .= '<link href="'.$template->getBaseUrl().'css/fontawesome-free-5.15.3/css/all.min.css" rel="stylesheet">'."\n";
$template->setGlobalCSS($css);

$dataTableActions = new DataTableActions();
$userActions      = new UserActions($dataTableActions);
$programActions   = new ProgramActions($userActions);
$newsActions      = new NewsActions($userActions, $programActions);
$podcastActions   = new PodcastActions($userActions, $programActions);
$linkIndexActions = new LinkIndexActions();
$noticeSpeakerActions = new NoticeSpeakerActions();
if(!defined('NOLOGIN')) {
    try {
        $userActions->checkUserSession();
    } catch(Exception $e) {
        $_SESSION['login_redirect'] = 1;
        header("location: ".$template->getBaseUrl()."login/error/".$e->getMessage());
        die();
    }
}
if(defined('LEVEL')) {
    if(!$userActions->isUserAbleTo(LEVEL)) {
        header("location: ".$template->getBaseUrl()."index.php");
        die();
    }
}
if(defined('PROGRAM')) {
    try {
        $programActions->checkProgramSession();
        $newsActions->initializeTagActions();
        $podcastActions->initializeTagActions();
    } catch(Exception $e) {
        header("location: index.php");
    }
}

if(defined('NO_PROGRAM')) {
    try {
        $programActions->checkProgramSession();
        header("location: ".$template->getBaseUrl()."index.php");
    } catch(Exception $e) {
        // all right
    }
}

function reCaptchaUrl() {
    return "https://www.google.com/recaptcha/api/siteverify?secret=6LeEtf4SAAAAAEZSFrJe-KKBr_Udubj611rWbMLT&remoteip=".$_SERVER['REMOTE_ADDR']."&response=".$_POST['g-recaptcha-response'];
}

$phpFileUploadErrors = array(
    0 => 'There is no error, the file uploaded with success',
    1 => 'The uploaded file exceeds the upload_max_filesize directive in php.ini',
    2 => 'The uploaded file exceeds the MAX_FILE_SIZE directive that was specified in the HTML form',
    3 => 'The uploaded file was only partially uploaded',
    4 => 'No file was uploaded',
    6 => 'Missing a temporary folder',
    7 => 'Failed to write file to disk.',
    8 => 'A PHP extension stopped the file upload.',
);

$enabled_suid = array(1,147,174,240,);

?>
