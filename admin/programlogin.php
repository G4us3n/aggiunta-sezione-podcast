<?php
include("includes/global.php");
if(isset($_GET['id'])) {
	try {
		$programActions->programLogin($_GET['id']);
	} catch(Exception $e) {
		$_SESSION['loginErrorMessage'] = $e->getMessage();
	}
}
elseif(isset($_GET['logout'])) {
	$programActions->programLogout();
}
header("location: index.php");
?>