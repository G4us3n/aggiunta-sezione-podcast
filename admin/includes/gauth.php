<?php
require_once dirname(__FILE__) . '/GoogleAuthenticator.php';

$secrets = array(
	'youtube (youtube@poliradio.it)' => 'MQ6EBS7YNA54P3W3NRFLGTBY5E5L7VD5',
	'youtube (accounts@poliradio.it)' => 'IKLUMKYOQSEXO5G6FW7HNITODWSORDGY',
	'twitter (@poliradio)' => 'XXTMPCN2RQ2MULQZ',
	'twitter (@poliradioxtra)' => 'DPLQFLMAMOMPIUHV',
	'instagram (@poliradio)' => 'D5M4AVDX22NZSHEWMA6CU2ROXLLQETNZ'
);

$ga = new GoogleAuthenticator();

foreach($secrets as $k=>$v) {
	echo $k.': '.$ga->getCode($v)."\n";
}
?>
