<?php
include("includes/global.php");
$vars = array(
	'noDefaultStyle' => 1
);
if(isset($_SESSION['loginErrorMessage'])) {
	$vars['error_message'] = $_SESSION['loginErrorMessage'];
	$_SESSION['loginErrorMessage'] = null;
	unset($_SESSION['loginErrorMessage']);
}
try {
	$programActions->checkProgramSession();
	$currentProgram = $programActions->getCurrentProgram();
	if($currentProgram == null) goto thisException;
	$vars['program']             = $currentProgram;
	$vars['settimana']           = $settimana;
	$vars['programActions']      = $programActions;
	$vars['tagsPiuVisti']        = ProgrammiTag::find_by_sql("SELECT tags.tag as tag, tags.views as views FROM programmi_tags INNER JOIN tags ON programmi_tags.tag = tags.tag WHERE programmi_tags.programmi_id = '".$programActions->getCurrentProgram()->id."' ORDER BY views DESC LIMIT 5");
	$vars['tagsPiuUsati']        = ProgrammiTag::find_by_sql("SELECT tag, used FROM programmi_tags WHERE programmi_id = '".$programActions->getCurrentProgram()->id."' ORDER BY used DESC LIMIT 5");
	$vars['newsPiuViste']        = NewsProgrammi::find('all', array('order' => 'views DESC', 'limit' => 5, 'conditions' => array('programmi_id = ?', $programActions->getCurrentProgram()->id)));
	$vars['newsUltime']          = NewsProgrammi::find('all', array('order' => 'id DESC', 'limit' => 5, 'conditions' => array('programmi_id = ?', $programActions->getCurrentProgram()->id)));
	$vars['podcastPiuVisti']     = PodcastProgrammi::find('all', array('order' => 'views DESC', 'limit' => 5, 'conditions' => array('programmi_id = ?', $programActions->getCurrentProgram()->id)));
	$vars['podcastUltimi']       = PodcastProgrammi::find('all', array('order' => 'id DESC', 'limit' => 5, 'conditions' => array('programmi_id = ?', $programActions->getCurrentProgram()->id)));
	$vars['unseenNotifications'] = $programActions->getUnseenNotifications();
	$vars['unseenNotificationsCount'] = count ($vars['unseenNotifications']);
	$vars['seenNotifications']   = $programActions->getSeenNotifications();
	$vars['seenNotificationsCount'] = count ($vars['seenNotifications']);

	if(isset($_GET['pl'])) {
		try {
			$programActions->setOnAir((int)$_GET['onair'], $currentProgram, (int)$_GET['pl']);
		} catch(Exception $e) {
			$vars['onair_error'] = $e->getMessage();
		}
	}
	if(isset($_GET['v'])) {
		try {
			$tmp = Palinsesto::all(array('conditions' => array('programmi_id = ?', $currentProgram->id)));
			foreach($tmp as $p) {
				$vacanza = (int)$_GET['v'] == 1 ? 1 : 0;
				$p->vacanza = $vacanza;
				$p->save();
			}
		} catch(Exception $e) {
			//
		}
	}

	$vars['palinsesto'] = Palinsesto::find('all', array('conditions' => array('programmi_id = ?', $currentProgram->id)));
	$days = array('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');
	$startDate = date('d-m-Y', time()-60*24*60*60); // 2 month ago
	$onAirCond = array();
	for($i = strtotime('Monday', strtotime($startDate)); $i <= time(); $i = strtotime('+1 week', $i)) {
		foreach($vars['palinsesto'] as $p) {
			$timing = strtotime($days[$p->giorno], $i);
			$onAirCond[] = "(day = '".date('d', $timing)."' AND month = '".date('m', $timing)."' AND year = '".date('Y', $timing)."' AND hour >= '".$p->ora_inizio."' AND hour < '".ceil($p->ora_fine+($p->minuto_fine/60))."')";
		}
	}
	$condition = implode(' OR ', $onAirCond);

	if(strlen($condition) == 0) $condition = 'FALSE';

	$query_text = "SELECT day, month, year, SUM(listeners) as listeners, COUNT(listeners) as count FROM general_listens WHERE ".$condition." GROUP BY day, month, year ORDER BY year DESC, month DESC, day DESC";
	$query = GeneralListens::find_by_sql($query_text);
	//echo GeneralListens::connection()->last_query;
	$js  = $template->globalJS();
	if(count($query) > 0) {
	$js .= '<script src="'.$template->getBaseUrl().'js/jquery.canvasjs.min.js"></script>'."\n";
	$js .= '<script type="text/javascript">
	$(function () {
		var options = {
			title: {
				text: "Statistica Ascoltatori Ultimi 2 Mesi"
			},
			axisX:{
				interval: 1,
	        	intervalType: "day",
		        labelFormatter: function (e) {
					return "";
				}
		   	},
	      	animationEnabled: true,
			data: [
			{
				type: "spline", //change it to line, area, column, pie, etc
				dataPoints: [
					';
	foreach($query as $row) {
		$listeners = ceil($row->listeners/$row->count);
		$js .= '{ x: new Date('.$row->year.', '.($row->month-1).', '.$row->day.'), y: '.$listeners.' }, ';
	}
	$js .= '
				]
			}
			]
		};

		$("#listenersGraph").CanvasJSChart(options);
	});
</script>';
	}
	$template->setGlobalJS($js);
	$template->init('program', 'index');
} catch(Exception $e) {
	thisException:
	$vars['unseenNotifications'] = $userActions->getUnseenNotifications();
	$vars['unseenNotificationsCount'] = count ($vars['unseenNotifications']);
	$vars['seenNotifications']   = $userActions->getSeenNotifications();
	$vars['seenNotificationsCount'] = count ($vars['seenNotifications']);
	$vars['compleanni'] = Utenti::find('all', array('conditions' => "attivo = 2 and data_nascita LIKE '%".date('-m-d')."'"));

	
	if(date('d-m') == '30-01' and $userActions->getCurrentUser()->id != 63){
		$ale_bypass = new stdClass();
		$ale_bypass->nome = 'Alessandra';
		$ale_bypass->cognome = 'Di Nardo';
		$ale_bypass->data_nascita = '1997-01-30';
		$vars['compleanni'][] = $ale_bypass;
	}

	$template->init('admin', 'index');
}	
$template->loadTemplate($vars);
?>
