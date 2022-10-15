<?php
define('NO_PROGRAM', 1);
include("includes/global.php");

$isDirettoreProgrammi = $userActions->isUserAbleTo('DIRETTORE_PROGRAMMI');

if($isDirettoreProgrammi && isset($_GET['onair'])) {
	try {
		$programma = Programmi::first($_GET['p']);
		$programActions->setOnAir((int)$_GET['onair'], $programma, (int)$_GET['pl'], true);
	} catch(Exception $e) {
		$vars['onair_error'] = $e->getMessage();
	}
}

if($isDirettoreProgrammi && isset($_GET['v'])) {
	try {
		$palinsesto = Palinsesto::all(array('conditions' => array('programmi_id = ?',$_GET['p'])));
		foreach($palinsesto as $p) {
			$vacanza = (int)$_GET['v'] == 1 ? 1 : 0;
			$p->vacanza = $vacanza;
			$p->save();
		}
	} catch(Exception $e) {
		$vars['onair_error'] = $e->getMessage();
	}
}

if(isset($_GET['d']) && isset($_GET['ds']) && isset($_GET['p']) && !isset($_GET['h']) && !isset($_GET['m']) && !isset($_GET['l']) && $isDirettoreProgrammi) {
	if($_GET['d'] != $_GET['ds']) {
		$find = programmaGiaPresente($_GET['p'], $_GET['d']);
		die($find);
	}
	die('0');
}

if(isset($_GET['d']) && isset($_GET['h']) && isset($_GET['m']) && isset($_GET['l']) && $isDirettoreProgrammi) {
	$t_i = convertToTime((int)$_GET['d'], (int)$_GET['h'], (int)$_GET['m']);
	$t_f = convertToTime((int)$_GET['d'], (int)$_GET['h']+(int)$_GET['l'], (int)$_GET['m']);
	if(!isset($_GET['p'])) $_GET['p'] = -1;
	$find = orarioOccupato($t_i, $t_f, $_GET['p']);
	if($find) {
		if(!isset($_GET['p']) || !isset($_GET['ds']) || (isset($_GET['p']) && ($find->programmi_id != (int)$_GET['p'] || $find->giorno != $_GET['ds']))) {
			die(hfix($find->programmi->nome));
		}
	}
	die('0');
}

if(isset($_GET['d']) && isset($_GET['p']) && $isDirettoreProgrammi) {
	$find = programmaGiaPresente($_GET['p'], $_GET['d']);
	die($find);
}

if(isset($_POST['deleteProgram']) && isset($_POST['deleteDay']) && $isDirettoreProgrammi) {
	$palinsesto = Palinsesto::first(array('conditions' => array('programmi_id = ? AND giorno = ?', (int)$_POST['deleteProgram'], (int)$_POST['deleteDay'])));
	if($palinsesto) {
		// Maiux NERD mod -> disabled
		/*if($palinsesto->programmi_id == 2 && $palinsesto->giorno == 3 && $palinsesto->ora_inizio == 20) {
			$errors[] = 'Impossibile rimuovere NERD dal Gioved&igrave;. Questo tentativo verr&agrave; notificato e saranno presi <b>SERI</b> provvedimenti.';
		}
    else{*/
			$_POST['giorno'] = $palinsesto->giorno;
			$data                  = $palinsesto->to_json();
			$data                  = json_decode($data, true);
			$data['userID']        = $userActions->getCurrentUser()->id;
			$data['userNome']      = $userActions->getCurrentUser()->nome;
			$data['userCognome']   = $userActions->getCurrentUser()->cognome;
			$data['nomeProgramma'] = $palinsesto->programmi->nome;
			EventLogger::log('deleteFromPalinsesto()', json_encode($data), $userActions->getCurrentUser());
			$palinsesto->delete();
			$success = 'Programma rimosso dal palinsesto!';
		#}
	}
	else {
		$errors[] = 'Impossibile rimuovere questo elemento!';
	}
}
elseif(count($_POST) > 0 && !isset($_POST['ds']) && $isDirettoreProgrammi) {
	// new
	$errors = array();
	$programma = Programmi::first((int)$_POST['programma']);
	if(!$programma) {
		$errors[] = 'Programma non valido!';
	}
	if((int)$_POST['ora'] < 0 || (int)$_POST['ora'] > 23 || (int)$_POST['minuto'] < 0 || (int)$_POST['minuto'] > 59) {
		$errors[] = 'Orario non valido!';
	}
	if((int)$_POST['giorno'] < 0 || (int)$_POST['giorno'] > 6) {
		$errors[] = 'Giorno non valido!';
	}
	if((int)$_POST['durata'] < 1 || (int)$_POST['durata'] > 2) {
		$errors[] = 'Durata non valida!';
	}
	$t_i = convertToTime((int)$_POST['giorno'], (int)$_POST['ora'], (int)$_POST['minuto']);
	$t_f = $t_i + (int)$_POST['durata'] * 60 * 60;
	$orarioOccupato = orarioOccupato($t_i, $t_f, $programma->id);
	if($orarioOccupato) {
		$errors[] = 'Orario occupato dal programma '.hfix($orarioOccupato->programmi->nome).'.';
	}
	if(programmaGiaPresente($_POST['programma'], $_POST['giorno']) > 0) {
		$errors[] = 'Programma gi&agrave; presente durante la giornata.';
	}
	if(count($errors) == 0) {
		$palinsesto = new Palinsesto();
		$palinsesto->programmi_id  = (int)$_POST['programma'];
		$palinsesto->giorno        = (int)$_POST['giorno'];
		$palinsesto->ora_inizio    = (int)$_POST['ora'];
		$palinsesto->minuto_inizio = (int)$_POST['minuto'];
		$palinsesto->ora_fine      = (int)$_POST['ora'] + (int)$_POST['durata'];
		$palinsesto->minuto_fine   = (int)$_POST['minuto'];
		$palinsesto->durata        = (int)$_POST['durata'];
		$palinsesto->t_i           = $t_i;
		$palinsesto->t_f           = $t_f;
		$palinsesto->save();
		if($palinsesto->is_invalid()) {
			$errors[] = 'Errore del database!';
		} else {
			$data                  = $palinsesto->to_json();
			$data                  = json_decode($data, true);
			$data['userID']        = $userActions->getCurrentUser()->id;
			$data['userNome']      = $userActions->getCurrentUser()->nome;
			$data['userCognome']   = $userActions->getCurrentUser()->cognome;
			$data['nomeProgramma'] = $palinsesto->programmi->nome;
			EventLogger::log('insertIntoPalinsesto()', json_encode($data), $userActions->getCurrentUser());
			$success = 'Programma aggiunto al palinsesto!';
		}
	}
}
elseif(count($_POST) > 0 && isset($_POST['ds']) && $isDirettoreProgrammi) {
	// edit
	$errors = array();
    $programma = Programmi::first((int)$_POST['programma']);
	if(!$programma) {
		$errors[] = 'Programma non valido!';
	}
	if((int)$_POST['ora'] < 0 || (int)$_POST['ora'] > 23 || (int)$_POST['minuto'] < 0 || (int)$_POST['minuto'] > 59) {
		$errors[] = 'Orario non valido!';
	}
	if((int)$_POST['giorno'] < 0 || (int)$_POST['giorno'] > 6) {
		$errors[] = 'Giorno non valido!';
	}
	if((int)$_POST['durata'] < 1 || (int)$_POST['durata'] > 2) {
		$errors[] = 'Durata non valida!';
	}
	$t_i = convertToTime((int)$_POST['giorno'], (int)$_POST['ora'], (int)$_POST['minuto']);
	$t_f = $t_i + (int)$_POST['durata'] * 60 * 60;
	$orarioOccupato = orarioOccupato($t_i, $t_f, $programma->id);
	if($orarioOccupato && ($orarioOccupato->programmi_id != $programma->id || $orarioOccupato->giorno != (int)$_POST['ds'])) {
		$errors[] = 'Orario occupato dal programma '.hfix($orarioOccupato->programmi->nome).'.';
	}
	if(programmaGiaPresente($_POST['programma'], $_POST['giorno']) > 0 && $_POST['giorno'] != $_POST['ds']) {
		$errors[] = 'Programma gi&agrave; presente durante la giornata.';
	}
    $palinsesto = Palinsesto::find(array('conditions' => array('programmi_id = ? AND giorno = ?', (int)$_POST['programma'], (int)$_POST['ds'])));
	if(!$palinsesto) {
		$errors[] = 'Elemento non trovato!';
	}
	/*if($palinsesto->programmi_id == 2 && $palinsesto->giorno == 3 && $palinsesto->ora_inizio == 20) {
		$errors[] = 'Impossibile rimuovere NERD dal Gioved&igrave;. Questo tentativo verr&agrave; notificato e saranno presi <b>SERI</b> provvedimenti.';
    }*/
	if(count($errors) == 0) {
		// Activerecord bug: not updating primary keys; fixing down
		if($_POST['giorno'] != $_POST['ds']) {
			Palinsesto::connection()->query("UPDATE palinsesto SET giorno = '".(int)$_POST['giorno']."' WHERE giorno = '".(int)$_POST['ds']."' AND programmi_id = '".$palinsesto->programmi_id."'");
			$palinsesto = Palinsesto::find(array('conditions' => array('programmi_id = ? AND giorno = ?', (int)$_POST['programma'], (int)$_POST['giorno'])));
        };
        $palinsesto->giorno        = (int)$_POST['giorno'];
		$palinsesto->ora_inizio    = (int)$_POST['ora'];
		$palinsesto->minuto_inizio = (int)$_POST['minuto'];
		$palinsesto->ora_fine      = (int)$_POST['ora'] + (int)$_POST['durata'];
		$palinsesto->minuto_fine   = (int)$_POST['minuto'];
		$palinsesto->durata        = (int)$_POST['durata'];
		$palinsesto->t_i           = $t_i;
		$palinsesto->t_f           = $t_f;
        $palinsesto->save();
        //print_r($palinsesto);
		if($palinsesto->is_invalid()) {
			$errors[] = 'Errore del database!';
		} else {
			$data                  = $palinsesto->to_json();
			$data                  = json_decode($data, true);
			$data['userID']        = $userActions->getCurrentUser()->id;
			$data['userNome']      = $userActions->getCurrentUser()->nome;
			$data['userCognome']   = $userActions->getCurrentUser()->cognome;
			$data['nomeProgramma'] = $palinsesto->programmi->nome;
			EventLogger::log('editFromPalinsesto()', json_encode($data), $userActions->getCurrentUser());
			$success = 'Modifica del palinsesto effettuata! '.$t_i.' '.$palinsesto->t_i;
		}
	}
}

$allProgrammi = Programmi::all(array('select' => 'id, nome', 'order' => 'nome'));
$vars = array('active' => 'palinsesto', 'isDirettoreProgrammi' => $isDirettoreProgrammi, 'allProgrammi' => $allProgrammi);
if(isset($errors) && count($errors) > 0) {
	$vars['errors'] = $errors;
}
if(isset($success)) {
	$vars['success'] = $success;
}
$template->init('admin', 'palinsesto');
$template->loadTemplate($vars);

?>
