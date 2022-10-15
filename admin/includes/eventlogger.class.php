<?php
class EventLogger {

	public static function log($function, $descrizione = '', $user = '', $program = '') {
		global $userActions;
		$currentUser = $userActions->getCurrentUser();
		if(EventLogger::isUserVarOk($currentUser)) {
			$currentID = $currentUser->id;
		} else {
			$currentID = -1;
		}
		if(is_numeric($user)) {
			$userID = $user;
		}
		elseif(EventLogger::isUserVarOk($user)) {
			$userID = $user->id;
		}
		else {
			$userID = $currentID;
		}
		if(is_numeric($program)) {
			$programID = $program;
		}
		elseif(EventLogger::isProgramVarOk($program)) {
			$programID = $program->id;
		} else {
			$programID = -1;
		}

		$string = '['.$function.'] - ['.date('d-m-Y H:i:s').'] - ['.$_SERVER['REMOTE_ADDR'].'] - ['.$descrizione.'] - [userID: '.($currentID == -1 ? null : $currentID).';programID: '.($programID == -1 ? null : $programID).']';
		$path = dirname(__FILE__).'/../logs/';
		$fp = fopen($path.date('Y_m_d').'.txt', 'a+');
		fwrite($fp, $string."\n");
		fclose($fp);
	}

	private static function isUserVarOk($user) {
		return is_object($user) && get_class($user) == 'Utenti' && isset($user->id);
	}

	private static function isProgramVarOk($program) {
		return is_object($program) && get_class($program) == 'Programmi' && isset($program->id);
	}

}
?>