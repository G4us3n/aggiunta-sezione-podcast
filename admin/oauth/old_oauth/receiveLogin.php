<?php
require_once 'oauth.php';
session_start();

if(isset($_SESSION['ip'])) {
	if($_SESSION['ip'] == $_SERVER['REMOTE_ADDR'] && $_SESSION['expire'] >= time()) {
		goto redirect;
	}
}

if(!isset($_GET['token'])) {
	error:
	header('refresh: 1;url='.$doLoginUrl);
	die('Sessione scaduta! Attendi...');
}

// TOKEN1: id:hash(time1 + hash(userData)):time1
// TOKEN2: id:hash(hash(time1 + hash(userData)) + time2):time1:time2
// TOKEN3: hash(token2 + random):random
$token1 = decryptAuth($_GET['token']);
$exp    = explode(':', $token1);

if(count($exp) != 3 || $exp[2] < time()) {
	goto error;
}

$time    = time()+20;
$exp[1]  = hash($hashingFunction, $exp[1].$time);
$token2  = implode(':', $exp).":".$time;
$secret  = encryptAuth($token2);
$request = file_get_contents($doLoginUrl.'?token='.$secret);
$token3  = decryptAuth($request);
$exp     = explode(':', $token3);
if(count($exp) != 2) {
	goto error;
}
$random = $exp[1];
if(hash($hashingFunction, $token2.$random) != $exp[0]) {
	goto error;
}
$_SESSION['token']  = $token2;
$_SESSION['ip']     = $_SERVER['REMOTE_ADDR'];
$_SESSION['expire'] = time()+3600;
redirect:
$baseUrl = 'http://poliradio.polimi.it:8100/';
$pages = array('logs','msg','cart');
if(isset($_GET['page']) && in_array($_GET['page'], $pages)) {
	$baseUrl .= $_GET['page']."/";
}
$baseUrl .= 'index.php';
header("location: ".$baseUrl);
?>