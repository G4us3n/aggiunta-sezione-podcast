<?php
function slack_invite($email, $nome, $cognome) {
	$token = 'xoxp-439863130930-440034648661-439194834320-1ed25c0308b187eb0efcae47b237e7ec';
	$url = 'https://slack.com/api/users.admin.invite?token='.$token.'&email='.urlencode($email).'&first_name='.urlencode($nome).'&last_name='.urlencode($cognome);
	$curl = curl_init();
	curl_setopt($curl, CURLOPT_URL, $url);
	curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
	$ret = curl_exec($curl);
	curl_close($curl);
	return $ret;
}
?>
