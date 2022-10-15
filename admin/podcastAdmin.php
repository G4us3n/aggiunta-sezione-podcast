<?php
define('PROGRAM', 1);
define('REDAZIONEOK', 1);
include("includes/global.php");
try {
	$userActions->onlyPosition('DIRETTORE_REDAZIONE');
} catch(Exception $e) {
	header("location: index.php");
	die();
}
$vars = array(
	'program' => $programActions->getCurrentProgram(),
	'programActions' => $programActions,
	'active'  => 'redazione'
);


$podcastCount = $podcastActions->getPodcastCount('', 1);
$pages     = $podcastActions->getPageNumber($podcastCount, 15);
$page      = 0;
if(isset($_GET['p']) && ($_GET['p'] >= 0 || $_GET['p'] < $pages)) {
	$page = $_GET['p'];
}

$page = $page > $pages-1 ? ($pages > 0 ? $pages-1 : 0) : $page;

$vars['podcast']  = $podcastActions->getPodcastOfPage($page, '', 15, 1);
$vars['count'] = $podcastCount;
$vars['mesiValue'] = $userActions->getMesiValue();
$vars['pages'] = $pages;
$vars['page']  = $page;
$vars['listAdmin'] = 1;

$template->init('program', 'podcast');
$template->loadTemplate($vars);
?>