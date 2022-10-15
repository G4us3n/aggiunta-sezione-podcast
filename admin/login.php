<?php
define('NOLOGIN',1);
include("includes/global.php");

if(isset($_GET['logout'])) {
	$programActions->programLogout();
	$nome = $userActions->logout();
}
elseif($userActions->userAuthenticated()) {
	if (!isset($_GET["api"])){
		header("location: ".$template->getBaseUrl()."index.php");
	}
}
$vars = array('failures' => $userActions->getFailures(), 'audio' => 0);

if(isset($_GET['error']) && (@$_SESSION['login_redirect'] == 1 || parse_url(@$_SERVER['HTTP_REFERER'], PHP_URL_HOST) == @$_SERVER['HTTP_HOST'])) {
	$_SESSION['login_redirect'] = 0;
	$vars['error_message'] = $_GET['error'];
}
elseif(isset($_POST['email']) && isset($_POST['password'])) {
	try {
		if($vars['failures'] >= 5) {
			$reCaptcha['success'] = 0;
			if(isset($_POST['g-recaptcha-response'])) {
				$reCaptcha = json_decode(file_get_contents(reCaptchaUrl()), true);
			}
			if(!$reCaptcha['success']) {
				throw new Exception('Captcha errato!');
			}
		}
        $nome = $userActions->login($_POST['email'], $_POST['password']);
		$vars['success_message'] = 'Benvenut'.$nome[0].' <strong>'.$nome[1].'</strong>, se il tuo browser non effettua il reindirizzamento <a href="index.php">clicca qui</a>.';

        $vars['audio'] = NULL;

        if($nome[3] == 63){
           // $vars['audio']='stai_calmo.mp3';
        }


		$vars['alert_message'] = 'Ciao <strong>'.$nome[1].'</strong>, ci risulta che non hai ancora versato la tua <b>quota associativa</b>.<br>Tale quota aiuta molto la nostra associazione e viene usata per poter gestire il bando e gli imprevisti.<br>Tutti i servizi che la nostra associazione offre <i>gratuitamente</i>, sono anche grazie a questa somma simbolica versata da ogni associato.<br>Puoi versare la tua quota in qualunque momento, mettendoti d\'accordo con lo Station Manager, con il Presidente o con qualunque membro del consiglio direttivo.<br>Se si tratta di un errore, e hai gi&agrave; versato la tua quota, contatta lo Station Manager.<br>Puoi continuare verso alcuni dei servizi offerti dall\'associazione <a href="index.php">cliccando qui</a>, ma ci farebbe molto piacere avere il tuo sostengo con il versamento della quota associativa.';
		$vars['quota_alert'] = $nome[2];

		/*
		if ($nome[3] == -1) {
			$vars['alert_message'] = 'Ciao <strong>Filippo</strong>, il tuo account &egrave; stato limitato. Ci risulta che non hai ancora pubblicato su mixcloud, sul sito o su facebook il podcast dell\'ultima puntata del tuo programma! Pubblicare il podcast &egrave; molto importante per la nostra associazione, e ci aiuta a mantenere dei contenuti freschi che attirano nuovi utenti. Per favore, pubblica il podcast non appena puoi. Puoi proseguire verso alcuni dei servizi offerti dalla nostra associazione <a href="index.php">cliccando qui</a>.<br>Una volta pubblicato i podcast arretrati, contatta il <b>Dittatrice</b> dei programmi per poter ripristinare lo stato del tuo account. Se si tratta di un errore, contatta invece il responsabile delle disattivazioni dei programmi.';
			$vars['warning'] = 1;
			$vars['quota_alert'] = 0;
			$vars['audio'] = 'phil.mp3';
		}
		*/

		$vars['redirect'] = 'index.php';

	} catch(Exception $e) {
		$vars['error_message'] = $e->getMessage();
		$vars['failures']++;
	}
}
elseif(isset($_GET['code'])) {
	try {
		$userActions->activateUserEmail($_GET['code']);
		$vars['success_message'] = 'Indirizzo email verificato. Attendi ora la conferma di un amministratore';
	} catch(Exception $e) {
		$vars['error_message'] = $e->getMessage();
	}
}
elseif(isset($_GET['pwchanged'])) {
	$vars['success_message'] = 'Password modificata con successo! Sei pregato di rieffettuare il login!';
}
elseif(isset($_GET['emailchanged'])) {
	$vars['success_message'] = 'Email modificata con successo! Sei pregato di rieffettuare il login!';
}

// Checking for JWT

if(isset($_GET["api"])){
	if ($_GET["api"] == "generate_JWT"){
		try {
			$userActions->checkUserSession();
			$userData = $userActions->getCurrentUser();
			$ALLOWED_AUD = array(
				"services-accessi" => array(
					"url" => "http://localhost:3100#jwt=",
					"secret" => "mBJR6POQs2ri4sohhvpwojhTsijmpVPK4zH9afEJ8VvEjENhaR5Ho2ederc9O1JaJaY9h6W1zBk5DD3F4a3Ne7jxFhMczYh3ParQtb9o5RiB0vtSoejX6Y0hlS1L5pDDZoM31ushOfoojyESXymgikAS4pJvL9RKLYBwMLbRApIVH0zhaRGCADtGGbx3jpbTjy9RxBZusF1y8YElTlD8VFbfyOr8u2s30T3c0zVjFo2EwLpLBuTwtCITzCNbtXiU"
				),
				"services-_couchdb" => array(
					"url" => "http://localhost:3000#jwt=",
					"secret" => "KewU3hShNaipFgVdC6WmKhrF1XorwOMU64FrQt9upMTGvktC9Jed0fy36SbfI4WJOBi9Wc7gsDY2pJiS5TROJDbJPCRxzbgqyV3aBVf1skrRIXTCzXzuh6Pb3KaIiQMzirU5qYXuqtPAie7NHoGCWiDWZN2AShpUf7o47kQ3AT4ssspInqruKsfcYeEjhqLdXNgnFyHeuQBzSjHkaxGFeUv95Mlh5gdBQHU6pfs8AmKyPy1pVDM5oOjjcB8afid4"
				),
                                "api-calendario" => array(
                                        "url" => "http://membri.poliradio.it/calendario/#jwt=",
                                        "secret" => "gbMoOEMExXl51kvn7SfmIRT7Wjwuw3IAAzwrfZ3jNIo4FWSbzP6GlmUzs97ub4ukR5LaJ4GLWQYoiGtnbqU9SmqLicR8g2uMdoJzifRrAPJ3v8RISWpa4edK7CAH9r23"
                                ),
                                "api-vnc" => array(
                                        "url" => "http://localhost:3000/app/#jwt=",
                                        "secret" => "iSioX4vi9XhLekGXrGZ4S6tYtiNEpginF2OjopKILG6nsv46uVBCbtyqwJgVZiz1oDuHOFzljlTirLFiJOLldmyi4wPTedmplXMx43mFZ3ptgl9JcWjvgIcv8D90bZhT"
                                )
			);

			if (!isset($_GET["aud"]) || !array_key_exists($_GET["aud"], $ALLOWED_AUD)){
				throw new Exception("Invalid JWT Audience");
			}

			//$JWT_SECRET = "mBJR6POQs2ri4sohhvpwojhTsijmpVPK4zH9afEJ8VvEjENhaR5Ho2ederc9O1JaJaY9h6W1zBk5DD3F4a3Ne7jxFhMczYh3ParQtb9o5RiB0vtSoejX6Y0hlS1L5pDDZoM31ushOfoojyESXymgikAS4pJvL9RKLYBwMLbRApIVH0zhaRGCADtGGbx3jpbTjy9RxBZusF1y8YElTlD8VFbfyOr8u2s30T3c0zVjFo2EwLpLBuTwtCITzCNbtXiU";
			$header = json_encode(['typ' => 'JWT', 'alg' => 'HS512']);
			$payload = json_encode([
				'iss' => 'https://membri.poliradio.it/login.php',
				'aud' => $_GET["aud"],
				'sub' => "".$userData->id,
				'name' => $userData->nome . " " . $userData->cognome,
				'iat' => time(),
				'picture' => $userData->foto,
				'nbf' => time(),
				'exp' => time() + 1800,
				'role' => $userData->livello,
				'permissions' => array($userData->livello),
				'admin' => $userData->administrator
			]);
			$base64UrlHeader = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($header));
			$base64UrlPayload = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($payload));
			$signature = hash_hmac('sha512', $base64UrlHeader . "." . $base64UrlPayload, $ALLOWED_AUD[$_GET["aud"]]["secret"], true);
			$base64UrlSignature = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($signature));
			$jwt = $base64UrlHeader . "." . $base64UrlPayload . "." . $base64UrlSignature;

			header("Location: " . $ALLOWED_AUD[$_GET["aud"]]["url"] . $jwt);
	        	die();
		} catch(Exception $e) {
		//	header("location: login.php?generate_JWT");
	                $vars['error_message'] = $e->getMessage();
	        }
	}
	else if ($_GET["api"] == "js_check_login"){
		try {
			$userActions->checkUserSession();
			//echo('Autenticato.<script>window.close()</script>');
			// We need to authenticate both here and in the local server
			header("Location: https://membri.poliradio.it/oauth/doLogin.php?noredirect");
			//echo("Hello Word");			
			die();
		}
		catch(Exception $e){
			$vars['error_message'] = $e->getMessage();
		}
	}
}

$template->setCustomHeadCode("<script src='https://www.google.com/recaptcha/api.js'></script>");
$template->init('login');
$template->loadTemplate($vars);
?>
