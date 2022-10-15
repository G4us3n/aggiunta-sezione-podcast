<?php
$hashingFunction = 'sha256';
$psk = 'Zq7?j14N7-6oNMw^TG(L!dU2bdn2-":K';
$doLoginUrl = 'http://membri.poliradio.it/oauth/doLogin.php';
$receiveLoginUrl = 'http://poliradio.polimi.it:8100/api/receiveLogin.php';

function randomBytes() {
	$ivSize = mcrypt_get_iv_size(MCRYPT_RIJNDAEL_256, MCRYPT_MODE_CBC);
	$iv = mcrypt_create_iv($ivSize, MCRYPT_DEV_URANDOM);
	return bin2hex($iv);
}

function encryptAuth($secret) {
	global $psk;
	$ivSize = mcrypt_get_iv_size(MCRYPT_RIJNDAEL_256, MCRYPT_MODE_CBC);
	$iv = mcrypt_create_iv($ivSize, MCRYPT_DEV_URANDOM);
	$encrypted = mcrypt_encrypt(MCRYPT_RIJNDAEL_256, $psk, $secret, MCRYPT_MODE_CBC, $iv);
	return base64_encode(base64_encode($iv).":".base64_encode($encrypted));
}

function decryptAuth($encrypted) {
	global $psk;
	$exp = explode(':', base64_decode($encrypted));
	$decrypted = mcrypt_decrypt(MCRYPT_RIJNDAEL_256, $psk, base64_decode($exp[1]), MCRYPT_MODE_CBC, base64_decode($exp[0]));
	return rtrim($decrypted, "\0");
}
?>