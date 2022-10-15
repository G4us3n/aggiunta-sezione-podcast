<?php
define('NOLOGIN', 1);
require '../includes/global.php';
if($userActions->userAuthenticated()) {
    header("location: ".$template->getBaseUrl());
    die();
}

if(isset($_POST['name'])) {

    $data = $_POST;
    $user_status = 0;
    $errors = array();

    if($_POST['telegram'][0] == '@') $_POST['telegram'] = str_replace('@', '', $_POST['telegram']);

    $userData = array(
        'nome'                => $userActions->formatDatabaseText($_POST['name']),
        'cognome'             => $userActions->formatDatabaseText($_POST['surname']),
        'pseudonimo'          => $userActions->formatDatabaseText($_POST['nickname']),
        'sesso'               => $_POST['gender'],
        'data_nascita'        => $_POST['birth_date'],
        'stato_nascita'       => $userActions->formatDatabaseText($_POST['country_birth']),
        'comune_nascita'      => $userActions->formatDatabaseText($_POST['place_birth']),
        'provincia_nascita'   => $userActions->formatDatabaseText($_POST['district_birth']),
        'codice_fiscale'      => strtoupper($_POST['cf']),
        'residenza_stato'     => $userActions->formatDatabaseText($_POST['permanent_address_country']),
        'residenza_comune'    => $userActions->formatDatabaseText($_POST['permanent_address_city']),
        'residenza_provincia' => $userActions->formatDatabaseText($_POST['permanent_address_district']),
        'residenza_cap'       => $_POST['permanent_address_cap'],
        'residenza_indirizzo' => $userActions->formatDatabaseText($_POST['permanent_address_address']),
        'residenza_civico'    => strtoupper($_POST['permanent_address_house_number']),
        'domicilio_stato'     => $userActions->formatDatabaseText($_POST['current_address_country']),
        'domicilio_comune'    => $userActions->formatDatabaseText($_POST['current_address_city']),
        'domicilio_provincia' => $userActions->formatDatabaseText($_POST['current_address_district']),
        'domicilio_cap'       => $_POST['current_address_cap'],
        'domicilio_indirizzo' => $userActions->formatDatabaseText($_POST['current_address_address']),
        'domicilio_civico'    => strtoupper($_POST['current_address_house_number']),
        'studente_politecnico'=> $_POST['politecnico_student'],
        'codice_persona'      => is_numeric($_POST['personal_code']) ? $_POST['personal_code'] : '',
        'email'               => strtolower($_POST['email']),
        'prefisso'            => $_POST['prefix'],
        'telefono'            => $_POST['phone'],
        'telegram'            => $_POST['telegram'],
        'password'            => $_POST['password']
    );
    try {
        $userActions->creaUtente($userData);

        $user_status = 1;

    } catch(Exception $e) {
        $errors[] = $e->getMessage();
    }

    echo  json_encode(
        [
            "user_status" => $user_status,

            "err" => [
                "code" => "GENERIC_ERROR",
                "msg" => $errors
            ],
            "data" => $data
        ]
    );
}
?>
