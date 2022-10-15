<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require_once dirname(__FILE__) . '/../../includes/libPHPMailer/Exception.php';
require_once dirname(__FILE__) . '/../../includes/libPHPMailer/PHPMailer.php';
require_once dirname(__FILE__) . '/../../includes/libPHPMailer/SMTP.php';

class PoliRadioMailer {

    private function getLoginArray($id) {
        $login_array = array(
            array(
                'nome'     => 'POLI.RADIO',
                'email'    => 'no-reply@poliradio.it',
                'password' => 'DoAGae*WQTK1'
            )
        );
        return $login_array[$id];
    }

    public function sendEmail($id, $email_data_array) {
        $login_array = $this->getLoginArray($id);
        $this->pSendEmail($login_array, $email_data_array);
    }

    private function pSendEmail($login_array, $email_data_array) {
        $mail = new PHPMailer();
        $mail->IsSMTP();
        $mail->Host        = "smtp.office365.com";
        $mail->SMTPSecure  = 'tls';
        $mail->SMTPAuth    = true;
        $mail->Port        = 587;
        $mail->Username    = $login_array['email'];
        $mail->Password    = $login_array['password'];

        $mail->SMTPDebug   = 0;
        $mail->Debugoutput = 'html';

        $mail->CharSet     = PHPMailer::CHARSET_UTF8;
        $mail->setFrom($login_array['email'], $login_array['nome']);
        $mail->isHTML($email_data_array['html']);
        $mail->Subject = $email_data_array['subject'];
        $mail->Body    = $email_data_array['body'];

        if($email_data_array['html']) {
            $mail->AltBody = $email_data_array['nohtml_body'];
        }
        if(is_array($email_data_array['to'])) {
            foreach($email_data_array['to'] as $to) {
                $mail->addAddress($to);
            }
        }
        else {
            $mail->addAddress($email_data_array['to']);
        }
        if(!$mail->send()) {
            throw new Exception($mail->ErrorInfo);
        }
    }
}

/*
if(isset($_GET['debug'])) {
    error_reporting(E_ALL);
    $email_data_array = array(
        'to'          => "andrea@maiux.net",
        'subject'     => 'Registrazione account STAFF',
        'html'        => true,
        'body'        => 'il tuo account è stato attivato.<br>'.
                     'Per proseguire con l\'accesso all\'area riservata <a href="http://www.poliradio.it/admin/login.php">clicca qui</a>',
        'nohtml_body' => 'il tuo account è stato attivato.'. "\n" .
                     'Per proseguire con l\'accesso all\'area riservata dirigiti al seguente indirizzo: http://www.poliradio.it/admin/login.php'
    );
    $email = new PoliRadioMailer();
    $email->sendEmail(0, $email_data_array);

}
*/
?>
