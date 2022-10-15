<?php
include("includes/global.php");

$factor = 1.0;

try {
	if(isset($_GET['viewers']) && !isset($_GET['listeners'])) {
		$userActions->special_admin_redazione('DIRETTORE_REDAZIONE');
	}
	else{
		$userActions->onlyDirettivo();
	}
} catch(Exception $e) {
	header('refresh: 3; url=index.php');
	die($e->getMessage());
}
$vars = array(
	//'noDefaultStyle' => 1
	'active' => 'nothing'
);

if(!isset($_GET['listeners']) && !isset($_GET['viewers'])) {
	header("location: index.php");
	die();
}

if(isset($_GET['listeners'])) {
	$monthRecords = GeneralListens::find_by_sql("SELECT day, month, year, sum(listeners) as total_views FROM general_listens WHERE hour = '-1' GROUP BY month, year ORDER BY year DESC, month DESC LIMIT 12");
} else {
	$monthRecords = GeneralViews::find_by_sql("SELECT day, month, year, sum(views) as total_views FROM general_views GROUP BY month, year ORDER BY year DESC, month DESC LIMIT 12");
}
$monthRecordsDataPoints = '';
foreach($monthRecords as $s) {
	$monthRecordsDataPoints .= '{ x: new Date('.$s->year.', '.($s->month-1).', '.$s->day.'), y: '.ceil($factor*$s->total_views).' }, ';
}

if(isset($_GET['listeners'])) {
	$lastMonthRecords = GeneralListens::find_by_sql("SELECT day, month, year, listeners as views FROM general_listens WHERE hour = '-1' ORDER BY year DESC, month DESC, day DESC LIMIT 30");
} else {
	$lastMonthRecords = GeneralViews::find_by_sql("SELECT day, month, year, views FROM general_views ORDER BY year DESC, month DESC, day DESC LIMIT 30");
}
$lastMonthRecordsDataPoints = '';
foreach($lastMonthRecords as $s) {
	$lastMonthRecordsDataPoints .= '{ x: new Date('.$s->year.', '.($s->month-1).', '.$s->day.'), y: '.ceil($factor*$s->views).' }, ';
}

if(isset($_GET['listeners'])) {
	$weekRecords = GeneralListens::find_by_sql("SELECT day, month, year, listeners as views FROM general_listens WHERE ".thisWeekDaysWHERE(1)." ORDER BY year DESC, month DESC, day DESC");
} else {
	$weekRecords = GeneralViews::find_by_sql("SELECT day, month, year, views FROM general_views WHERE ".thisWeekDaysWHERE()." ORDER BY year DESC, month DESC, day DESC");
}
$weekRecordsDataPoints = '';
foreach($weekRecords as $s) {
	$weekRecordsDataPoints .= '{ x: new Date('.$s->year.', '.($s->month-1).', '.$s->day.'), y: '.ceil($factor*$s->views).' }, ';
}

if(isset($_GET['listeners'])) {
	$time = strtotime(date('d-m-Y H:00:00'));
	$conditions = '';
	for($a = $time-24*60*60; $a < $time+60*60; $a += 60*60) {
		$conditions .= "(hour = '".date('H', $a)."' AND day = '".date('d', $a)."' AND month = '".date('m', $a)."' AND year = '".date('Y', $a)."')";
		if($a < $time) {
			$conditions .= ' OR ';
		}
	}
	$dayRecords = GeneralListens::find('all', array('conditions' => $conditions, 'order' => 'year ASC, month ASC, day ASC, hour ASC'));
	$dayRecordsDataPoints = '';
	foreach($dayRecords as $s) {
		if(in_array((int)$s->hour, array(0,1,2,3,4,5,6,7,22,23))){
			$point = $s->listeners;
		} else {
			$point = ceil($factor*$s->listeners);
		}
		$dayRecordsDataPoints .= '{ x: new Date('.$s->year.', '.($s->month-1).', '.$s->day.', '.$s->hour.'), y: '.$point.' }, ';
	}
}

$js  = $template->globalJS();
$js .= '<script src="'.$template->getBaseUrl().'js/jquery.canvasjs.min.js"></script>'."\n";
$js .= '
<script type="text/javascript">
$(function () {
	var options = {
		title: {
			text: "'.(isset($_GET['listeners']) ? 'Ascoltatori' : 'Visitatori').' di questa settimana"
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
				'.$weekRecordsDataPoints.'
			]
		}
		]
	};

	$("#weekGraph").CanvasJSChart(options);

});
</script>';

$js .= '
<script type="text/javascript">
$(function () {
	var options = {
		title: {
			text: "'.(isset($_GET['listeners']) ? 'Ascoltatori' : 'Visitatori').' degli ultimi 30 giorni"
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
				'.$lastMonthRecordsDataPoints.'
			]
		}
		]
	};

	$("#lastMonthGraph").CanvasJSChart(options);

});
</script>';

$js .= '
<script type="text/javascript">
$(function () {
	var options = {
		title: {
			text: "'.(isset($_GET['listeners']) ? 'Ascoltatori' : 'Visitatori').' degli ultimi 12 mesi"
		},
		axisX:{
			interval: 1,
        	intervalType: "month",
        	labelFormatter: function (e) {
				return "";
			}
      	},
                animationEnabled: true,
		data: [
		{
			type: "spline", //change it to line, area, column, pie, etc
			dataPoints: [
				'.$monthRecordsDataPoints.'
			]
		}
		]
	};

	$("#monthRecordsGraph").CanvasJSChart(options);

});
</script>';

if(isset($_GET['listeners'])) {
$js .= '
<script type="text/javascript">
$(function () {
	var options = {
		title: {
			text: "'.(isset($_GET['listeners']) ? 'Ascoltatori' : 'Visitatori').' delle ultime 24 ore"
		},
		axisX:{
			interval: 1,
        	intervalType: "hour",
        	labelFormatter: function (e) {
				return "";
			}
      	},
                animationEnabled: true,
		data: [
		{
			type: "spline", //change it to line, area, column, pie, etc
			dataPoints: [
				'.$dayRecordsDataPoints.'
			]
		}
		]
	};

	$("#dayRecordsGraph").CanvasJSChart(options);

});
</script>';
}
$template->setGlobalJS($js);
$template->init('admin', 'stats');
$template->loadTemplate($vars);
?>
