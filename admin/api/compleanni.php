<?php
$api_token = '57kgUb6dTbHNhOdjU3rnN8FmPdaNLnSauisu3R0g';
if(!isset($_GET['token']) || $_GET['token'] != $api_token) {
    die();
}
define('NOLOGIN',1);
include('../includes/global.php');
$users = Utenti::find('all', array('conditions' => "attivo = 2 and id != 1 and data_nascita LIKE '%".date('-m-d')."'"));
$birthdays = array();

if(count($users) == 0) {
    if(rand(0, 300) == 50) {
        $birthdays[] = array('name' => "Alessandra Di Nardo", 'age' => rand(23,33), 'telegram' => 'bakaale');
    }
}

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
