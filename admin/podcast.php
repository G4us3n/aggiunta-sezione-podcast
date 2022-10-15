<?php
define('PROGRAM', 1);
define('REDAZIONEOK', 1);
include("includes/global.php");
$check = $programActions->isUserLoggedForRedaction();
$vars = array(
    'program'   => $programActions->getCurrentProgram(),
    'programActions' => $programActions,
    'active'  => $check ? 'redazione' : 'podcast',
    'count'     => $podcastActions->getPodcastCount(),
    'mesiValue' => $userActions->getMesiValue()
);

if(isset($_GET['dw'])) {
    $podcast = PodcastProgrammi::first($_GET['dw']);
    if(!$podcast) goto no_download;
    try {
        $podcastActions->verifyPermissions($podcast->programmi_id);
    } catch(Exception $e) {
        goto no_download;
    }
    if($podcast->download != 2) goto no_download;
    $file = '../podcast/'.$podcast->filedownload;
    if(!file_exists($file)) goto no_download;
    $file_name = str_replace('/','_', $podcast->filedownload);
    $file_name = str_replace('_id_'.$podcast->id, '', $file_name);
    ob_clean();
    ob_start();
    header('Content-Description: File Transfer');
    header('Content-Type: application/octet-stream');
    header('Content-Disposition: attachment; filename='.$file_name);
    header('Expires: 0');
    header('Cache-Control: must-revalidate');
    header('Pragma: public');
    header('Content-Length: '.filesize($file));
    readfile($file);
    exit;
    no_download:
    header('location: '.$template->getBaseUrl().'podcast.php');
    die();
}

if(isset($_GET['new'])) {
    $js  = $template->globalJS();
    /*
    TAGS DISABLED
    $js .= '<script src="'.$template->getBaseUrl().'js/bootstrap-tagsinput.js"></script>'."\n";
    $js .= '<script src="'.$template->getBaseUrl().'js/bootstrap-tagsinput-angular.js"></script>'."\n";
    */
    $js .= '<script src="'.$template->getBaseUrl().'js/jquery.contextMenu.js"></script>'."\n";
    $js .= '<script src="'.$template->getBaseUrl().'js/jquery.ui.position.js"></script>'."\n";
    $js .= '<script src="'.$template->getBaseUrl().'js/jquery.form.min.js"></script>'."\n";
    $js .= '<script src="'.$template->getBaseUrl().'js/bootstrap-datepicker.min.js"></script>'."\n";
    $js .= '<script src="'.$template->getBaseUrl().'js/bootstrap-datepicker.it.min.js"></script>'."\n";
    $js .= '<script type="text/javascript">$(function() { $("#datepicker").datepicker({language: "it", autoclose: true}); });</script>'."\n";
    $template->setGlobalJS($js);
    $css  = $template->globalCSS();
    /*
    TAGS DISABLED
    $css .= '<link href="'.$template->getBaseUrl().'css/bootstrap-tagsinput.css" rel="stylesheet">'."\n";
    */
    $css .= '<link href="'.$template->getBaseUrl().'css/jquery.contextMenu.css" rel="stylesheet">'."\n";
    $css .= '<link href="'.$template->getBaseUrl().'css/bootstrap-datepicker.min.css" rel="stylesheet">'."\n";
    $template->setGlobalCSS($css);
    $template->init('program', 'podcast_new');
    /* TAGS DISABLED
    $vars['allTags'] = $podcastActions->getAllTags();
    $vars['allProgramTags'] = $podcastActions->getAllProgramTags();
    */
    if(count($_POST) > 0) {
        $errors = array();
        //$_POST['giorno'] = (int)$_POST['giorno'];
        //$_POST['mese']   = (int)$_POST['mese'];
        //$_POST['anno']   = (int)$_POST['anno'];
        try {
            $podcastActions->validateLink($_POST['link']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
            unset($_POST['link']);
        }
        try {
            $podcastActions->validateLinkYoutube($_POST['link_youtube']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
            unset($_POST['link_youtube']);
        }
        try {
            $podcastActions->validateVisibile($_POST['visibile']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
            unset($_POST['visibile']);
        }
        try {
            //$podcastActions->validatePodcastDate($_POST['giorno'], $_POST['mese'], $_POST['anno']);
            $podcastActions->validatePodcastDate($_POST['data']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
            unset($_POST['data']);
            //unset($_POST['giorno']);
            //unset($_POST['mese']);
            //unset($_POST['anno']);
        }

        if(count($errors) == 0) {
            $params = array(
                'link'     => $_POST['link'],
                'link_youtube' => $_POST['link_youtube'],
                //'tags'     => explode(',', $_POST['tags']),
                'visibile' => $_POST['visibile'],
                'data'     => $_POST['data'],
                //'giorno'   => $_POST['giorno'],
                //'mese'     => $_POST['mese'],
                //'anno'     => $_POST['anno']
            );
            try {
                $id = $podcastActions->creaPodcast($params);
                header('location: '.$template->getBaseUrl().'podcast.php?edit='.$id.'&s');
            } catch(Exception $e) {
                $vars['errors'] = $e->getMessage();
            }
        } else {
            $vars['errors'] = $errors;
        }
    } else {

    }
}
elseif(isset($_GET['edit'])) {
    $podcast = PodcastProgrammi::first($_GET['edit']);
    if(!$podcast) {
        header('location: '.$template->getBaseUrl().'podcast.php');
        die();
    }
    try {
        $podcastActions->verifyPermissions($podcast->programmi_id);
    } catch(Exception $e) {
        header('location: '.$template->getBaseUrl().'podcast.php');
        die();
    }
    $js  = $template->globalJS();
    /* TAGS DISABLED
    $js .= '<script src="'.$template->getBaseUrl().'js/bootstrap-tagsinput.js"></script>'."\n";
    $js .= '<script src="'.$template->getBaseUrl().'js/bootstrap-tagsinput-angular.js"></script>'."\n";
    */
    $js .= '<script src="'.$template->getBaseUrl().'js/jquery.contextMenu.js"></script>'."\n";
    $js .= '<script src="'.$template->getBaseUrl().'js/jquery.ui.position.js"></script>'."\n";
    $js .= '<script src="'.$template->getBaseUrl().'js/jquery.form.min.js"></script>'."\n";
    $js .= '<script src="'.$template->getBaseUrl().'js/bootstrap-datepicker.min.js"></script>'."\n";
    $js .= '<script src="'.$template->getBaseUrl().'js/bootstrap-datepicker.it.min.js"></script>'."\n";
    $js .= '<script type="text/javascript">$(function() { $("#datepicker").datepicker({language: "it", autoclose: true}); });</script>'."\n";
    /* TAGS DISABLED
    $js .= '<script src="'.$template->getBaseUrl().'js/program.podcast_new.js"></script>'."\n";
    */
    $template->setGlobalJS($js);
    $css  = $template->globalCSS();
    /* TAGS DISABLED
    $css .= '<link href="'.$template->getBaseUrl().'css/bootstrap-tagsinput.css" rel="stylesheet">'."\n";
    */
    $css .= '<link href="'.$template->getBaseUrl().'css/jquery.contextMenu.css" rel="stylesheet">'."\n";
    $css .= '<link href="'.$template->getBaseUrl().'css/bootstrap-datepicker.min.css" rel="stylesheet">'."\n";
    $template->setGlobalCSS($css);
    $template->init('program', 'podcast_edit');
    if(count($_POST) > 0) {
        $errors = array();
        $podcastActions->setPodcast($podcast);
        try {
            $podcastActions->editLink($_POST['link']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
        }
        try {
            $podcastActions->editLinkYoutube($_POST['link_youtube']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
        }
        /* TAGS DISABLED
        try {
            $podcastActions->editTags(explode(',',$_POST['tags']));
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
        }
        */
        try {
            $podcastActions->editVisibile($_POST['visibile']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
        }
        try {
            //$podcastActions->editData($_POST['giorno'], $_POST['mese'], $_POST['anno']);
            $podcastActions->editData($_POST['data']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
        }
        if(count($errors) > 0) {
            $vars['errors'] = $errors;
        }
    }
    /* TAGS DISABLED
    $vars['allTags'] = $podcastActions->getAllTags();
    $vars['allProgramTags'] = $podcastActions->getAllProgramTags();
    $tags = $podcastActions->getTags($podcast);
    $vars['tags'] = implode(',',$tags);
    */
    $vars['podcast'] = $podcast;
}
else {
    if(isset($_POST['delete_podcast'])) {
        try {
            $success = 'Podcast \'<b>'.$podcastActions->deletePodcast($_POST['delete_podcast']).'</b>\' eliminato!';
        } catch(Exception $e) {
            $error = $e->getMessage();
        }
    }
    elseif(isset($_POST['change_visibility'])) {
        try {
            $success = $podcastActions->changeVisibility($_POST['change_visibility']);
        } catch(Exception $e) {
            $error = $e->getMessage();
        }
    }
    $podcastCount = $podcastActions->getPodcastCount();
    $pages        = $podcastActions->getPageNumber($podcastCount);
    $page         = 0;
    if(isset($_GET['p']) && ($_GET['p'] >= 0 || $_GET['p'] < $pages)) {
        $page = $_GET['p'];
    }

    $page = $page > $pages-1 ? ($pages > 0 ? $pages-1 : 0) : $page;

    $vars['podcast']  = $podcastActions->getPodcastOfPage($page);
    $vars['count'] = $podcastCount;
    $vars['pages'] = $pages;
    $vars['page']  = $page;

    if(isset($success)) {
        $vars['success'] = $success;
    }
    if(isset($error)) {
        $vars['error'] = $error;
    }
    $template->init('program', 'podcast');
}
$template->loadTemplate($vars);
?>
