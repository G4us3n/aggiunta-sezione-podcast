<?php
include("includes/global.php");
if(!$userActions->canElevate() || ($userActions->isUserElevated() && !isset($_GET['disable']))) {
	header("location: index.php");
	die();
}
if($userActions->isUserElevated() && isset($_GET['disable'])) {
	$userActions->deElevateUser();
	header("location: index.php");
	die();
}
if(isset($_POST['code']) && isset($_POST['password'])) {
	if($userActions->elevateUser($_POST['code'], $_POST['password'])) {
		header("location: index.php");
		die();
	}
}
$template->init('admin', 'advanced');
$template->loadTemplate();
?>