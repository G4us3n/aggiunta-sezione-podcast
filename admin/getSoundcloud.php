<?php
/*$get = file_get_contents('https://api.soundcloud.com/resolve.json?url='.urlencode($_REQUEST['url']).'&client_id=52683b82a46aa9d2403f0087de30932a');
$data = json_decode($get, true);
if(isset($data['id'])) {
	echo $data['id'];
}
else {
	echo 'ciao';
}*/
$matches = array();
preg_match('/(tracks\/)([0-9]*)(&color=)/', $_REQUEST['url'], $matches);
echo $matches[2];
?>
