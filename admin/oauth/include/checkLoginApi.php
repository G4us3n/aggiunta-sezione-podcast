<?php

define('NOLOGIN',1);

require dirname(__FILE__) . '/../../includes/global.php';

function checkLoginApi($role = null){
try {
    global $userActions;
    $userActions->checkUserSession();

    if (!isset($role) || $userActions->isUserAbleTo($role)){
        $user = $userActions->getCurrentUser();
	return Array(
            "id" => $user->id,
            "nome" => $user->nome,
            "cognome" => $user->cognome,
            "email" => $user->email,
            "codice_fiscale" => $user->codice_fiscale
        );
    }
    else {
         header($_SERVER["SERVER_PROTOCOL"]." 403 Forbidden", true, 403);
    	 die();
    }
}
catch (Exception $e){
    header('WWW-Authenticate: Bearer realm="https://membri.poliradio.it/oauth/doLogin.php?noredirect"');
    header($_SERVER["SERVER_PROTOCOL"]." 401 Unauthorized", true, 401);
    die();
}
}

// https://roytuts.com/how-to-generate-and-validate-jwt-using-php-without-using-third-party-api/
function checkJWT($jwt, $secret){
	if (!isset($jwt)){
		return FALSE;
	}

	// split the jwt
	$tokenParts = explode('.', $jwt);
	$header = json_decode(base64_decode($tokenParts[0]));
	$payload = json_decode(base64_decode($tokenParts[1]));
	$signature_provided = $tokenParts[2];

	// check the expiration time - note this will cause an error if there is no 'exp' claim in the jwt
	$expiration = $payload->exp;
	$is_token_expired = ($expiration - time()) < 0;

	// build a signature based on the header and payload using the secret
	$signature = hash_hmac('SHA512', $tokenParts[0] . "." . $tokenParts[1], $secret, true);
	$base64_url_signature = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($signature));
	
	// verify it matches the signature provided in the jwt
	$is_signature_valid = ($base64_url_signature === $signature_provided);
	
	if ($is_token_expired || !$is_signature_valid) {
		return FALSE;
	} else {
		return $payload;
	}
}
?>

