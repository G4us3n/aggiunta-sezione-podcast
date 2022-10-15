<?php
require_once dirname(__FILE__).'/oauth.php';
$enabledIp = array('10.48.102.99', '10.48.102.62');
session_start();
if(defined('CHECKSESSIONONLY')) {
	$session = 1;
}
if(in_array($_SERVER['REMOTE_ADDR'], $enabledIp)) {
	// DO NOTHING
}
elseif(isset($_SESSION['ip'])) {
	if($_SESSION['ip'] != $_SERVER['REMOTE_ADDR'] || $_SESSION['expire'] < time()) {
		removeSession($doLoginUrl);
	}
}
else {
	removeSession($doLoginUrl);
}

function removeSession($doLoginUrl) {
	if(preg_match('/^10\.48\.102\./i', $_SERVER['REMOTE_ADDR'])) {
		if(preg_match('/^\/msg/i', dirname($_SERVER['PHP_SELF']))) {
			if(defined('CHECKSESSIONONLY')) {
				global $session;
				$session = 0;
				return;
			}
			$doLoginUrl = 'http://poliradio.polimi.it/msg/login.php';
		}
		else {
			$session = 1;
			return;
		}
	}
	session_unset();
	session_destroy();
	$_SESSION = array();
	redirectToLogin($doLoginUrl);
}

function redirectToLogin($loginUrl) {
	header('refresh: 1;url='.$loginUrl);
	die('Sessione scaduta! Attendi...');
}
?>