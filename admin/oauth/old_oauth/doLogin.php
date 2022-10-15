<?php
require_once 'oauth.php';
if(isset($_GET['token'])) {
	define('NOLOGIN', 1);
}
include("../includes/global.php");


if(!isset($_GET['token'])) {
	// TOKEN1: id:hash(time1 + hash(userData)):time1
	$user  = $userActions->getCurrentUser();
	$hash  = hash($hashingFunction, $user->id.$user->hash.$user->salt);
	$time  = time()+20;
	$hash  = hash($hashingFunction, $time.$hash);
	$token = encryptAuth($user->id.":".$hash.":".$time);
	header("location: ".$receiveLoginUrl."?token=".$token.(isset($_GET['page']) ? '&page='.$_GET['page'] : ''));
}
else {
	// TOKEN2: id:hash(hash(time1 + hash(userData)) + time2):time1:time2
	$token = decryptAuth($_GET['token']);
	$exp = explode(':', $token);
	if(count($exp) != 4) {
		goto error;
	}
	$userID       = $exp[0];
	$receivedHash = $exp[1];
	$time1        = $exp[2];
	$time2        = $exp[3];

	if($time1 < time() || $time2 < time()) {
		goto error;
	}

	$user         = Utenti::first($userID);
	$hash         = hash($hashingFunction, $user->id.$user->hash.$user->salt);
	$originalHash = hash($hashingFunction, hash($hashingFunction, $time1.$hash).$time2);
	if($originalHash != $receivedHash) {
		error:
		$returnHash  = hash($hashingFunction, randomBytes());
		$returnToken = encryptAuth($returnHash);
	} else {
		$random = randomBytes();
		$returnHash = hash($hashingFunction, $token.$random).":".$random;
		$returnToken = encryptAuth($returnHash);
	}
	echo $returnToken;
}
?>