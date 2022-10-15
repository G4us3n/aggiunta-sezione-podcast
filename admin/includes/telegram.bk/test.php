<?php
if (!file_exists('madeline.php')) {
    copy('https://phar.madelineproto.xyz/madeline.php', 'madeline.php');
}
ob_start();
include 'madeline.php';
ob_end_clean();

function send_telegram_message($receivers, $message){
    $MadelineProto = new \danog\MadelineProto\API('session.madeline');
    $MadelineProto->settings['logger']['logger'] = 0;

    $MadelineProto->async(true);

    $MadelineProto->loop(function () use ($MadelineProto, $receivers, $message) {
        yield $MadelineProto->start();

        foreach($receivers as $rec) {
            yield $MadelineProto->messages->sendMessage(['peer' => '@'.$rec, 'message' => $message]);
        }
    });
}

send_telegram_message(array('maiux'), "Caro Matteo Boveri, ci risulta che Lei si sia appropriato indebitamente di euro 63.58 dalla cassa della radio. La invitiamo caldamente a restituire tale somma in tempi giuridicamente celeri.\nCordialmente, il Consiglio Direttivo Supremo.\n\nSe riceve questo messaggio per errore, le assicuriamo che non lo è.");

?>
