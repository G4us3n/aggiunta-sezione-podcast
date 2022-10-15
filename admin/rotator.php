<?php
include("includes/global.php");


if(isset($_GET['urlOf'])) {
    if($userActions->isUserAbleTo('STATION_MANAGER') && $_GET['urlOf'] != '') {
        $user = Utenti::first($_GET['urlOf']);
        die($template->getBaseUrl().'../'.$user->foto);
    }
    die($template->getBaseUrl().'../'.$userActions->getCurrentUser()->foto);
}
elseif(isset($_GET['purlOf'])) {
    $program = Programmi::first($_GET['purlOf']);
    if($program) {
        die($template->getBaseUrl().'../'.$program->logo);
    }
}

$rot = 90;

if(isset($_GET['rot'])) {
	if($_GET['rot'] == '-90' || $_GET['rot'] == '90' || $_GET['rot'] == '180') {
		$rot = $_GET['rot'];
	}
}


if(isset($_GET['p'])) {
    $program = Programmi::first($_GET['p']);
    if($program) {
        if($programActions->isProgramMember($userActions->getCurrentUser(), $program)) {
            myrotate(dirname(__FILE__).'/../'.$program->logo, $rot);
        }
    }
    die();
}

if($userActions->isUserAbleTo('STATION_MANAGER') && isset($_GET['u'])) {
	$user = Utenti::first($_GET['u']);
	if($user) {
		myrotate(dirname(__FILE__).'/../'.$user->foto, $rot);
	}
}
else {
	myrotate(dirname(__FILE__).'/../'.$userActions->getCurrentUser()->foto, $rot);
}

?>