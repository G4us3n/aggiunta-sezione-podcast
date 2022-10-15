<?php
$api_token = 'A43g3e1J6wpRVqNtOQKpAW6Nv5C3z0jxukOfJ90PmQE0';
if(!isset($_GET['token']) || $_GET['token'] != $api_token) {
    die();
}
define('NOLOGIN',1);
include('../includes/global.php');

$time = time() + 7200;

$users = Utenti::find('all', array('conditions' => "attivo = 2 and data_nascita LIKE '%".date('-m-d', $time)."'"));

$birthdays = array();

foreach($users as $user) {
    $name = $user->nome." ".$user->cognome;
    $info_data = (array) $user->data_nascita;
    $data = new DateTime($info_data['date']);
    $data = $data->format('Y');
    $age  = date('Y') - (int)$data;
    $telegram = $user->telegram;
    $birthdays[] = array('name' => $name, 'age' => $age, 'telegram' => $telegram);
}

echo json_encode($birthdays);
?>
