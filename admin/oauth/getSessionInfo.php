<?php
	require_once dirname(__FILE__) . '/include/checkLoginApi.php';
        error_reporting(0);
        ini_set('display_errors', 'Off');
	die(
		json_encode(
			checkLoginApi($_GET['check_role'])
		)
	);
?>
