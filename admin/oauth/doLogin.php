<?php
include('../includes/global.php');

$mysqli = new mysqli('127.0.0.1', 'session_helper', '', 'website');

if($mysqli->connect_error) {
	header("location: index.php");
	die();
}

$mysqli->query("DELETE FROM sessions WHERE expire <= ".time());

$result = $mysqli->query("SELECT expire FROM sessions WHERE id = '".$mysqli->escape_string($_COOKIE['PHPSESSID'])."'");

if($result->num_rows == 0) {
	$mysqli->query("INSERT INTO sessions(id, expire) VALUES('".$mysqli->escape_string($_COOKIE['PHPSESSID'])."', '".(time()+1440)."');");
}

$mysqli->close();

if(isset($_GET['page']) && $_GET['page'] == 'old') {
	header("location: http://old.poliradio.it/allow.php?id=".sha1($_COOKIE['PHPSESSID'].date('d-m-Y H')));
	die();
}

$location = '/services/';
$pages = array('logs','msg','cart', 'condivisa', 'status');
if(isset($_GET['page']) && in_array($_GET['page'], $pages)) {
        $location .= $_GET['page']."/";
}
$location .= 'index.php';

if (isset($_GET['noredirect'])){	
	echo('Logged in. This window should close automatically soon.<script>window.close()</script>');
}
if (isset($_GET["getsession"])){
	echo("<script>window.opener.postMessage(JSON.stringify({session: '" . $_COOKIE['PHPSESSID'] . "'}), '*');window.close();</script>");
}
else {
	header("location: ".$location);
}
?>
