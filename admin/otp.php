<?php
include("includes/global.php");
require_once 'includes/GoogleAuthenticator.php';

/*
try {
    $userActions->onlyPosition('DIRETTIVO');
} catch(Exception $e) {
    header("location: index.php");
    die();
}
*/

if(!$userActions->canAccessOTP()) {
    header("location: index.php");
    die();
}

$secrets = array(
    'youtube (youtube@poliradio.it)' => 'MQ6EBS7YNA54P3W3NRFLGTBY5E5L7VD5',
    'youtube (accounts@poliradio.it)' => 'IKLUMKYOQSEXO5G6FW7HNITODWSORDGY',
    'twitter (@poliradio)' => 'XXTMPCN2RQ2MULQZ',
    'twitter (@poliradioxtra)' => 'DPLQFLMAMOMPIUHV',
    'instagram (@poliradio)' => 'HP3UD37QO2ZRWDSLI6YSYVI22OSZUOVE',
    'twitch (@poliradioit)' => 'P5SKNZM2ZS4CZBHKPSECP6UJREMPVPCFVFZ2FIZVRSPDYOUKMNBQ'
);

$ga = new GoogleAuthenticator();

$vars['codes'] = array();

foreach($secrets as $account=>$secret) {
    $vars['codes'][$account] = $ga->getCode($secret)."\n";
}

$seconds = date('s');
$vars['remaining_seconds'] = $seconds > 30 ? 60 - $seconds : 30 - $seconds;
$vars['active'] = 'OTP';

$template->init('admin', 'otp');
$template->loadTemplate($vars);

?>
