<?php
$api_token = '98dhsjfkhedHAGHAGhfrheu38dUHAsg32KHJSH2e';
if(!isset($_GET['token']) || $_GET['token'] != $api_token) {
	die();
}
define('NOLOGIN',1);
include('../includes/global.php');
$users = Utenti::find('all', array('conditions' => "attivo = 2"));
$membri = array();

foreach($users as $user) {
	$name = $user->nome." ".$user->cognome;
	$telegram = $user->telegram;
	$membri[] = array('name' => $name, 'telegram' => $telegram);
}

$user = array_rand($membri);

echo json_encode($membri);
?>
