<?php
$key = 'AOPciubbaofa938OADIEchybafoIAE34auofdsygv';

if(!isset($_GET['key'])) die();

if($_GET['key'] != $key) die('Wrong token');

if(!isset($_GET['current_song'])) {
	$content = file_get_contents('zaraupdate.txt');
	echo $content;
}
else{
	$data = array('song' => $_GET['current_song'], 'last_update' => time());
	$fp = fopen('zaraupdate.txt', 'w+');
	fwrite($fp, json_encode($data));
	fclose($fp);
	echo 'Ok';
}
?>
