<?php
if(!isset($_POST['id'])) {
	die();
}

$mysqli = new mysqli('127.0.0.1', 'session_helper', '', 'website');

if($mysqli->connect_error) {
	die();
}

$mysqli->query("DELETE FROM sessions WHERE expire <= ".time());

$result = $mysqli->query("SELECT expire FROM sessions WHERE id = '".$mysqli->escape_string($_POST['id'])."'");

if($result->num_rows > 0) {
	die('OK');
}

$mysqli->close();

?>
