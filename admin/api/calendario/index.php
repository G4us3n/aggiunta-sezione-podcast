<?php

if ($_GET['action'] == 'test'){
	if (send_notification('prova 3')){
		echo('{}');
	}
	else {
		echo('{error: "Unable to send notification"}');
	}
	die();
}

require_once('../../oauth/include/checkLoginApi.php');
header("Access-Control-Allow-Origin: http://localhost:8080");
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    die();
}
// Only POST are accepted
if ($_SERVER['REQUEST_METHOD'] != 'POST' && $_SERVER['REQUEST_METHOD'] != 'OPTIONS') {
    header($_SERVER["SERVER_PROTOCOL"] . " 405 Method Not Allowed", true, 405);
    die();
}

$user = checkJWT(
    $_POST['_JWT'],
    "gbMoOEMExXl51kvn7SfmIRT7Wjwuw3IAAzwrfZ3jNIo4FWSbzP6GlmUzs97ub4ukR5LaJ4GLWQYoiGtnbqU9SmqLicR8g2uMdoJzifRrAPJ3v8RISWpa4edK7CAH9r23"
);

if ($user == false) {
    header($_SERVER["SERVER_PROTOCOL"] . " 401 Unauthorized", true, 401);
    die();
}


$MYSQL_HOST = 'localhost';
$MYSQL_USER = 'api-calendario';
$MYSQL_PASSWORD = 'G34ua8AtqqY2vN58';
$MYSQL_DB = 'website';
$CALENDARIO_RESOURCES = ['room-studio1', 'room-studio2'];
//define('TELEGRAM_BOT_TOKEN', '919615789:AAEoqcE5DkWI-p3rmK-2ES-o5V_1-zVxUuA');

#error_reporting(E_ALL);
#ini_set('display_errors', 'On');

// Connecting to DB
$connection = new PDO("mysql:host=$MYSQL_HOST;dbname=$MYSQL_DB", $MYSQL_USER, $MYSQL_PASSWORD);
$connection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

#error_reporting(E_ALL);

/*function send_notification($data){

$ch = curl_init();

$CURL_URL = 'https://api.telegram.org/bot919615789:AAEoqcE5DkWI-p3rmK-2ES-o5V_1-zVxUuA/sendMessage';
curl_setopt($ch, CURLOPT_URL,$CURL_URL);
//die($CURL_URL);
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_POSTFIELDS,
            http_build_query(array( 'chat_id' => '280420325', 'text' => $data)));

// In real life you should use something like:
// curl_setopt($ch, CURLOPT_POSTFIELDS, 
//          http_build_query(array('postvar1' => 'value1')));

// Receive server response ...
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

$server_output = curl_exec($ch);

curl_close ($ch);

// Further processing ...
return json_decode($server_output))->ok;
//die();
//if (json_parse($server_output)['ok'] == 'true'){
//	return true;
//}
//else {
//return false;
//}
}*/


function send_notification($data){
    $ch = curl_init();

    $CURL_URL = 'https://api.telegram.org/bot919615789:AAEoqcE5DkWI-p3rmK-2ES-o5V_1-zVxUuA/sendMessage';
    curl_setopt($ch, CURLOPT_URL,$CURL_URL);
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query(array( 'chat_id' => '76508505', 'text' => $data)));

    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

    $server_output = curl_exec($ch);

    curl_close ($ch);

    return json_decode($server_output)->ok;
}

switch ($_GET['action']) {
    case 'add':
        try {
            $title = parse_string($_POST['title']);
            $start = parse_number($_POST['start']);
            $end = parse_number($_POST['end']);
            $resource = parse_string($_POST['resource']);

            if ($start >= $end) {
                throw new Exception('DateMismatch');
            }
        } catch (Exception $e) {
header($_SERVER["SERVER_PROTOCOL"] . " 400 Bad Request", true, 400);
            die();
        }

        $query = $connection->prepare("INSERT INTO `api-calendario-prenotazioni` (`resource`, `user`, `title`, `start`, `end`, `approved`, `deleted`, `style`, `allDay`) VALUES (:resource, :user, :title, :start, :end, 0, 0, '{}', 0)");
        $query->bindParam(':resource', $resource);
        $query->bindParam(':user', $user->sub);
        $query->bindParam(':title', $title);
        $query->bindParam(':start', $start);
        $query->bindParam(':end', $end);
        $query->execute();

	
 	       if (send_notification('Nuova Prenotazione ' . $title . '@'. $resource)){
        	        echo('{}');
        	}
        	else {
        	        echo('{error: "Unable to send notification"}');
        	}
	
        break;
 /*   case 'cancel':
        try {
            $id = parse_number($_POST['id']);
        } catch (Exception $e) {
            header($_SERVER["SERVER_PROTOCOL"] . " 400 Bad Request", true, 400);
            die();
        }
        $query = $connection->prepare("UPDATE `api-calendario-prenotazioni` SET `deleted` = '1' WHERE `id` = :id AND `user` = :user AND `approved` = '0'");
        $query->bindParam(':user', $user->sub);
        $query->bindParam(':id', $id);

        $query->execute();
        if ($query->rowCount() == 0) {
            header($_SERVER["SERVER_PROTOCOL"] . " 403 Forbidden", true, 403);
            die();
        }
        echo ('{}');

        break;*/
    case 'accept':
        // Checking Login
        if ($user->role != 'DIRETTORE_PROGRAMMI') {
            header($_SERVER["SERVER_PROTOCOL"] . " 403 Forbidden", true, 403);
            die();
        }

        try {
            $id = parse_number($_POST['id']);
        } catch (Exception $e) {
//print_r($e);         
   header($_SERVER["SERVER_PROTOCOL"]." 400 Bad Request", true, 400);
            die();
        }

        $query = $connection->prepare("UPDATE `api-calendario-prenotazioni` SET `approved` = '1' WHERE `id` = :id AND `deleted` = '0'");
        $query->bindParam(':id', $id);
        $query->execute();
        echo ('{}');

        break;
    case 'reject':
        if ($user->role != 'DIRETTORE_PROGRAMMI') {
            header($_SERVER["SERVER_PROTOCOL"] . " 403 Forbidden", true, 403);
            die();
        }

        try {
            $id = parse_number($_POST['id']);
        } catch (Exception $e) {
            header($_SERVER["SERVER_PROTOCOL"] . " 400 Bad Request", true, 400);
            die();
        }

        $query = $connection->prepare("UPDATE `api-calendario-prenotazioni` SET `deleted` = '1' WHERE `id` = :id");
        $query->bindParam(':id', $id);
        $query->execute();
        echo ('{}');

        break;
    case 'get':
        try {
            $id = parse_number($_POST['id']);
        } catch (Exception $e) {
            header($_SERVER["SERVER_PROTOCOL"] . " 400 Bad Request", true, 400);
            die();
        }

        $query = $connection->prepare("SELECT * FROM `api-calendario-prenotazioni` WHERE `id` = :id");
        $query->bindParam(':id', $id);
        $query->execute();
        $query->setFetchMode(PDO::FETCH_ASSOC);
        print_r(json_encode($query->fetchAll()));


        break;
    case 'list':
        //$resource = parse_string($_POST['resource']);

        //$query = $connection->prepare("SELECT * FROM `api-calendario-prenotazioni` WHERE `resource` = :resource");
        //$query->bindParam(':resource', $resource);
        $query = $connection->prepare("SELECT * FROM `api-calendario-prenotazioni`");
        $query->execute();
        $query->setFetchMode(PDO::FETCH_ASSOC);
        print_r(json_encode($query->fetchAll()));

        break;
        // // $query = $connection->prepare("SELECT * FROM api-calendario-prenotazioni WHERE `id` = :id");
        // $query->bindParam(':id', $id);
        // $query->execute();
        // print_r($query->setFetchMode(PDO::FETCH_ASSOC));

        // $query->close();
        // // $title = $_POST['title'];
        // // $start_date = $_POST['start_date'];
        // // $end_date = $_POST['end_date'];
        // // $notes = $_POST['notes'];
        // // $rRule = $_POST['rRule'];
        // // $style = $_POST['style'];

        // // if (!(
        // //     isset($title) && strlen($title) > 0 &&
        // //     isset($rRule) && strlen($rRule) > 0 &&
        // //     isset($style) && strlen($style) > 0 &&
        // //     isset($start_date) && strtotime($start_date) != false &&
        // //     isset($end_date) && strtotime($end_date) != false &&
        // //     strtotime($start_date) < strtotime($end_date)
        // // )){
        // //     header($_SERVER["SERVER_PROTOCOL"]." 400 Bad Request", true, 400);
        // //     die();
        // // }

        // // $query = $conn->prepare("INSERT INTO api-calendario-prenotazioni (`resource`, `user`, `title`, `notes`, `start_date`, `end_date`, `approved`, `deleted`, `rRule`, `style`) VALUES (?, ?, ?, ?, ?, ?, 0, 0, ?, ?)");
        // // $query->bind_param("sissiiiiss", $resource, $user['id'], $title, $notes, $start_date, $end_date, $rRule, $style);
        // // $query->execute();
        // // $query->close();
        break;
    default:
        header($_SERVER["SERVER_PROTOCOL"] . " 400 Bad Request", true, 400);
        die();
}

function parse_time($data)
{
    if (isset($data) && strtotime($data) != false) {
        return strtotime($data);
    } else {
        throw new Exception('InvalidData');
    }
}

function parse_string($data)
{
    if (isset($data) && strlen($data) > 0) {
        return $data;
    } else {
        throw new Exception('InvalidData');
    }
}
function parse_optional_string($data)
{
print_r($data);
    if (!isset($data)) {
        return "";
    } else {
        return parse_string($data);
    }
}
function parse_number($data)
{
    if (isset($data) && is_numeric($data)) {
        return $data;
    } else {
        throw new Exception('InvalidData');
    }
}

function parse_json($data)
{
    if (isset($data) && json_decode($data) != null) {
        return json_decode($data);
    } else {
        throw new Exception('InvalidData');
    }
}
function parse_bool($data)
{
    return isset($data);
}

