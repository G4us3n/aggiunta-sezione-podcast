<?php
/*
if (!file_exists('madeline.php')) {
    copy('https://phar.madelineproto.xyz/madeline.php', 'madeline.php');
}
 */
ob_start();
//include 'madeline.php';
ob_end_clean();

function send_telegram_message($receivers, $title, $content){
	return;
	if(!is_array($receivers)) {
		$receivers = array($receivers);
	}
	$MadelineProto = new \danog\MadelineProto\API('session.madeline');
	$MadelineProto->settings['logger']['logger'] = 0;

	$MadelineProto->async(true);

	$message = "[POLI.RADIO - ".$title."]\n\n".$content;

	$MadelineProto->loop(function () use ($MadelineProto, $receivers, $message) {
		yield $MadelineProto->start();

		foreach($receivers as $rec) {
			yield $MadelineProto->messages->sendMessage(['peer' => '@'.$rec, 'message' => $message]);
		}
	});
}

//send_telegram_message(array('maiux'), 'prova', 'contenuto');

?>
