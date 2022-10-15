<?php
$allow = array(
	'login.css',
	'admin.css',
	'register.css',
	'program.css'
);
$file = '../templates/'.$_GET['c'].'.tpl';

if(in_array($_GET['c'], $allow) && is_file($file)) {
	header("Content-type: text/css");
	echo file_get_contents($file);
}
else {
	header("HTTP/1.0 404 Not Found");
	echo "<h1>Error 404 Not Found</h1>";
    echo "The page that you have requested could not be found.";
}
?>