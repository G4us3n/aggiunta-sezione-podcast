<?php
function send_telegram_message($receivers, $title, $content){
    if(!is_array($receivers)) {
        $receivers = array($receivers);
    }

    $data = array();
    $message = "[POLI.RADIO - ".$title."]\n\n".$content;
    foreach($receivers as $receiver) {
        $data[] = array("username" => "@".$receiver, "message" => $message);
    }

    $url = "https://server.poliradio.it:8001/notifications/index.php";

    $headers = array(
       "Content-type: application/json",
       "Authorization: Basic cG9saXJhZGlvOkRZWnZVNTdVeVpWQjN5VUJ5dmQ2bWNiOUZaUXZuVw=="
    );

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);

    $ret = curl_exec($ch);
    curl_close($ch);
    #var_dump($ret);
}

#send_telegram_message("maiux", "test", "test");
?>
