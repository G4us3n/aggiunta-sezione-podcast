<?php
define('NOLOGIN', 1);
require 'includes/global.php';
if($userActions->userAuthenticated()) {
    header("location: ".$template->getBaseUrl());
    die();
}


//$variables = array('mesiValue' => $userActions->getMesiValue());

$template->setCustomHeadCode("<script src='https://www.google.com/recaptcha/api.js'></script>");

//Recuperare elenchi dal DB (Stati,Province,Prefisso) per passarli al template del frontend
$tabella_province = $dataTableActions->getProvince();
$tabella_stati = $dataTableActions->getStati();

$variables = array('tabella_province' => $tabella_province,'tabella_stati' => $tabella_stati);

/*if(isset($_GET['success']) && $_GET['success'] == 1){

  $template->init('register', 'confirm');

}else */
if(!$template->isInitialized()) {
    $js  = '<script src="'.$template->getBaseUrl().'js/jquery.js"></script>'."\n";
    $js .= '<script src="'.$template->getBaseUrl().'js/vue.js"></script>'."\n";
    $js .= '<script src="'.$template->getBaseUrl().'js/bootstrap5/bootstrap.bundle.js"></script>'."\n";
    $template->setGlobalJS($js);

    $css = '<link href="'.$template->getBaseUrl().'css/bootstrap5/bootstrap.css" rel="stylesheet">'."\n";
    $template->setGlobalCSS($css);

    $template->init('register', 'form');
}
$template->loadTemplate($variables);

?>
