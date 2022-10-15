
<?php
//error_reporting(E_ALL);
//ini_set('display_errors', 'On');

//define('NOLOGIN',1);
die();
include("../includes/global.php");
try {
    $userActions->checkUserSession();
    $userActions->login_as_user(197);
    header('Location: https://membri.poliradio.it');
}
catch (Exception $e){
    print_r($e);
    header('WWW-Authenticate: Bearer realm="https://' . $_SERVER['HTTP_HOST'] . dirname($_SERVER['PHP_SELF']) . '/doLogin.php?noredirect"');
    header($_SERVER["SERVER_PROTOCOL"]." 401 Unauthorized", true, 401);
}
?>
