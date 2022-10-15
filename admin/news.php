<?php
define('PROGRAM', 1);
define('REDAZIONEOK', 1);
include("includes/global.php");
$check = $programActions->isUserLoggedForRedaction();
$vars = array(
    'program' => $programActions->getCurrentProgram(),
    'programActions' => $programActions,
    'active'  => $check ? 'redazione' : 'news',
    'count'   => $newsActions->getNewsCount()
);

$pathNewsPhotos = 'photos/news/';

if(isset($_GET['imgList'])) {
    imgList:
    //$programTag = $check ? 'redazione' : $programActions->getCurrentProgram()->tag;
    if(!isset($_GET['tag'])) die();

    $programTag = $_GET['tag'];
    if($programTag != 'redazione') {
        $prog_tag = Programmi::find('fist', array('conditions' => array('tag = ?', $programTag)));
        if(!$prog_tag) die();
    }

    $absPath   = $pathNewsPhotos.$programTag.'/';
    $uploadDir = dirname(__FILE__).'/../'.$absPath;
    if(!file_exists($uploadDir)) mkdir($uploadDir);
    chdir($uploadDir);
    $empty = 1;
    foreach(glob("*") as $file) {
        if(is_file($file) && is_file('thumbs/'.$file) && $file != '' && $file != '..' && !preg_match('/_/i', $file)) {
            echo '<a href="#">';
            echo '<img data-name="'.$file.'" src="'.$template->getBaseUrl().'../'.$absPath.'thumbs/'.$file.'" class="img-polaroid rightClickBinder" style="margin: 3px; width: 21%; height: 21%">';
            echo '</a>';
            $empty = 0;
        }
    }
    if($empty) {
        echo '<i>Nessuna immagine disponibile nell\'archivio.';
    }
    die();
}

if(isset($_GET['delImg'])) {
    try {
        $newsActions->deleteImg($_GET['delImg']);
        echo '<div class="alert alert-success"><button type="button" class="close" data-dismiss="alert">&times;</button>Copertina cancellata dall\'archivio!</div>';
    } catch(Exception $e) {
        echo '<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>'.$e->getMessage().'</div>';
    }
    goto imgList;
}
if(isset($_FILES["FileInput"])) {
    if($_FILES["FileInput"]["error"] == UPLOAD_ERR_OK) {
        $programTag = $check ? 'redazione' : $programActions->getCurrentProgram()->tag;
        if(isset($_GET['edit'])) {
            $news = NewsProgrammi::first((int)$_GET['edit']);
            if($news && $news->programmi_id != null) {
                $programTag = $news->programmi->tag;
            }
        }
        $absPath   = $pathNewsPhotos.$programTag.'/';
        $uploadDir = dirname(__FILE__).'/../'.$absPath;
        if(!is_dir($uploadDir)) {
            mkdir($uploadDir);
        }
        if(!is_dir($uploadDir.'thumbs')) {
            mkdir($uploadDir.'thumbs');
        }
        $thumbDir  = $uploadDir.'thumbs/';
        if (!isset($_SERVER['HTTP_X_REQUESTED_WITH'])){
            die();
        }

        if ($_FILES["FileInput"]["size"] > 10485760) {
            die('<div class="alert alert-block alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Dimensione file troppo grande!</div>');
        }

        switch(strtolower($_FILES['FileInput']['type'])) {
                case 'image/png': 
            case 'image/gif': 
            case 'image/jpeg': 
                break;
            default:
                die('<div class="alert alert-block alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Formato non supportato!</div>');
        }

        $ext = explode('.', $_FILES['FileInput']['name']);
        $ext = strtolower($ext[count($ext)-1]);
        $fileName = md5('1337'.time().'antani'.rand(1000,9999)."POLIRADIO").".".$ext;       
        if(move_uploaded_file($_FILES['FileInput']['tmp_name'], $uploadDir.$fileName)) {
            $md5 = md5_file($uploadDir.$fileName);
            $realName = $md5.'.'.$ext;
            $size = getimagesize($uploadDir.$fileName);
            $width = $size[0];
            $height = $size[1];
            if($width < $height) {
                unlink($uploadDir.$fileName);
                die(json_encode(array('html' => '<div class="alert alert-block alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Le immagini verticali non sono accettate!</div>')));
            }
            elseif($width < 1280 || $height < 720) {
                unlink($uploadDir.$fileName);
                die(json_encode(array('html' => '<div class="alert alert-block alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>L\'immagine deve avere almeno una risoluzione di 1366x768!</div>')));
            }
            $saveOriginal = $width > 1920 ? 0 : 1;
            if(!file_exists($uploadDir.$realName)) {
                $dimensions = array(1920, 1600, 1366, 1280, 1024);
                $initialResolution = '';
                foreach($dimensions as $dimension) {
                    $created = 0;
                    if($width > $dimension) {
                        createThumb($uploadDir.$fileName, $uploadDir.$md5."_".$dimension.".".$ext, $dimension, false);
                        $created = 1;
                    } elseif($width == $dimension) {
                        copy($uploadDir.$fileName, $uploadDir.$md5."_".$dimension.".".$ext);
                        $created = 1;
                    }
                    if($created && $initialResolution == '') {
                        $initialResolution = $md5."_".$dimension.".".$ext;
                    }
                }
                if($saveOriginal) {
                    rename($uploadDir.$fileName, $uploadDir.$realName);
                }
                else {
                    rename($uploadDir.$initialResolution, $uploadDir.$realName);
                    unlink($uploadDir.$fileName);
                }
                createThumb($uploadDir.$realName, $thumbDir.$realName);
            }
            $return = array('name' => $realName, 'html' => '<div class="alert alert-block alert-success"><button type="button" class="close" data-dismiss="alert">&times;</button>File caricato!</div>');
            die(json_encode($return));
        }
        else{
            $return = array('html' => '<div class="alert alert-block alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Impossibile caricare il file!</div>');
            die(json_encode($return));
        }       
    }
    else {
        $return = array('html' => '<div class="alert alert-block alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>File non caricato ('.$phpFileUploadErrors[$_FILES["FileInput"]["error"]].')!</div>');
        die(json_encode($return));
    }
}

if(isset($_GET['new'])) {
    $js  = $template->globalJS();
    $js .= '<script src="'.$template->getBaseUrl().'js/bootstrap-tagsinput.js"></script>'."\n";
    $js .= '<script src="'.$template->getBaseUrl().'js/bootstrap-tagsinput-angular.js"></script>'."\n";
    $js .= '<script src="'.$template->getBaseUrl().'js/jquery.contextMenu.js"></script>'."\n";
    $js .= '<script src="'.$template->getBaseUrl().'js/jquery.ui.position.js"></script>'."\n";
    $js .= '<script src="'.$template->getBaseUrl().'js/jquery.form.min.js"></script>'."\n";
    $template->setGlobalJS($js);
    $css  = $template->globalCSS();
    $css .= '<link href="'.$template->getBaseUrl().'css/bootstrap-tagsinput.css" rel="stylesheet">'."\n";
    $css .= '<link href="'.$template->getBaseUrl().'css/jquery.contextMenu.css" rel="stylesheet">'."\n";
    $template->setGlobalCSS($css);
    $template->init('program', 'news_new');
    $vars['allTags'] = $newsActions->getAllTags();
    $vars['allProgramTags'] = $newsActions->getAllProgramTags();
    $programTag = $check ? 'redazione' : $programActions->getCurrentProgram()->tag;
    $vars['path'] = '../'.$pathNewsPhotos.$programTag;
    if(count($_POST) > 0) {
        $errors = array();
        try {
            $newsActions->validateTitolo($_POST['titolo']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
            unset($_POST['titolo']);
        }
        try {
            $newsActions->validateSottotitolo($_POST['sottotitolo']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
            unset($_POST['sottotitolo']);
        }
        try {
            $newsActions->validateFoto($_POST['foto']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
            unset($_POST['foto']);
        }
        try {
            $newsActions->validateTesto($_POST['testo']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
            unset($_POST['testo']);
        }
        try {
            $newsActions->validateVisibile($_POST['visibile']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
            unset($_POST['visibile']);
        }
        try {
            $newsActions->validateCopyright($_POST['copyright']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
            unset($_POST['copyright']);
        }
        try {
            $newsActions->validateMetaType($_POST['metatype']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
            unset($_POST['metatype']);
        }
        try {
            $newsActions->validateCoverAlignment($_POST['cover_alignment']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
            unset($_POST['cover_alignment']);
        }
        try {
            $newsActions->validateHomeAlignment($_POST['home_alignment']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
            unset($_POST['home_alignment']);
        }

        if(count($errors) == 0) {
            $params = array(
                'titolo'      => $_POST['titolo'],
                'sottotitolo' => $_POST['sottotitolo'],
                'foto'        => $_POST['foto'],
                'testo'       => $_POST['testo'],
                'media'       => $_POST['media'],
                'tags'        => explode(',', $_POST['tags']),
                'metatype'    => $_POST['metatype'],
                'visibile'    => $_POST['visibile'],
                'copyright'   => $_POST['copyright'],
                'cover_alignment' => $_POST['cover_alignment'],
                'home_alignment' => $_POST['home_alignment']
            );
            try {
                $id = $newsActions->creaNews($params);
                header('location: '.$template->getBaseUrl().'news.php?edit='.$id.'&s');
            } catch(Exception $e) {
                $vars['errors'] = array($e->getMessage());
            }
        } else {
            $vars['errors'] = $errors;
        }
    } else {

    }
}
elseif(isset($_GET['edit'])) {
    $news = NewsProgrammi::first($_GET['edit']);
    if(!$news) {
        header('location: '.$template->getBaseUrl().'news.php');
        die();
    }
    try {
        $newsActions->verifyPermissions($news->programmi_id);
        if($news->programmi_id == null) {
            if(!$programActions->isUserLoggedForRedaction(1) && $news->utenti_id != $userActions->getCurrentUser()->id){
                throw new Exception('Non hai i permessi per modificare questa news');
            }
        }
    } catch(Exception $e) {
        header('location: '.$template->getBaseUrl().'news.php');
        die();
    }
    if(isset($_GET['a']) || isset($_GET['d'])) {
        $newsActions->setNews($news);
        $return = array('message' => 'ok');
        if(isset($_GET['a'])) {
            try {
                $newsActions->associatePodcast($_GET['a']);
            } catch(Exception $e) {
                $return['message'] = $e->getMessage();
            }
        }
        if(isset($_GET['d'])) {
            try {
                $newsActions->removeAssociatedPodcast($_GET['d']);
            } catch(Exception $e) {
                $return['message'] = $e->getMessage();
            }
        }
        $podcasts = $news->podcast_programmi;
        $pod = array();
        foreach($podcasts as $p) {
            $pod[] = array('id' => $p->id, 'date' => $p->giorno."-".$p->mese."-".$p->anno);
        }
        $return['podcasts'] = $pod;
        die(json_encode($return));
    }
    $podcasts = $news->podcast_programmi;
    $pod = array();
    foreach($podcasts as $p) {
        $pod[] = array('id' => $p->id, 'date' => $p->giorno."-".$p->mese."-".$p->anno);
    }
    $js  = $template->globalJS();
    $js .= '<script src="'.$template->getBaseUrl().'js/bootstrap-tagsinput.js"></script>'."\n";
    $js .= '<script src="'.$template->getBaseUrl().'js/bootstrap-tagsinput-angular.js"></script>'."\n";
    $js .= '<script src="'.$template->getBaseUrl().'js/jquery.contextMenu.js"></script>'."\n";
    $js .= '<script src="'.$template->getBaseUrl().'js/jquery.ui.position.js"></script>'."\n";
    $js .= '<script src="'.$template->getBaseUrl().'js/jquery.form.min.js"></script>'."\n";
    $js .= '<script src="'.$template->getBaseUrl().'js/program.news_new.js"></script>'."\n";
    $template->setGlobalJS($js);
    $css  = $template->globalCSS();
    $css .= '<link href="'.$template->getBaseUrl().'css/bootstrap-tagsinput.css" rel="stylesheet">'."\n";
    $css .= '<link href="'.$template->getBaseUrl().'css/jquery.contextMenu.css" rel="stylesheet">'."\n";
    $template->setGlobalCSS($css);
    $template->init('program', 'news_edit');
    $programTag = $news->programmi_id == null ? 'redazione' : $news->programmi->tag;
    $vars['path'] = '../'.$pathNewsPhotos.$programTag;
    if(count($_POST) > 0) {
        $errors = array();
        $newsActions->setNews($news);
        try {
            $newsActions->editTitolo($_POST['titolo']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
        }
        try {
            if(isset($_POST['autore']))
                $newsActions->editAutore((int)$_POST['autore']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
        }
        try {
            $newsActions->editCoverAlignment($_POST['cover_alignment']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
        }
        try {
            $newsActions->editHomeAlignment($_POST['home_alignment']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
        }
        try {
            if($userActions->isUserAbleTo('DIRETTORE_PROGRAMMI') || $userActions->isUserAbleTo('DIRETTORE_REDAZIONE')) {
                $newsActions->editDate($_POST['date']);
            }
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
        }
        try {
            $newsActions->editSottotitolo($_POST['sottotitolo']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
        }
        try {
            $newsActions->editFoto($_POST['foto']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
        }
        try {
            $newsActions->editTesto($_POST['testo']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
        }
        try {
            $newsActions->editMedia($_POST['media']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
        }
        try {
            $newsActions->editTags(explode(',',$_POST['tags']));
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
        }
        try {
            $newsActions->editMetaType($_POST['metatype']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
        }
        try {
            $newsActions->editVisibile($_POST['visibile']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
        }
        try {
            $newsActions->editCopyright($_POST['copyright']);
        } catch(Exception $e) {
            $errors[] = $e->getMessage();
        }
        if(count($errors) > 0) {
            $vars['errors'] = $errors;
        }
    }
    $vars['allTags'] = $newsActions->getAllTags();
    $vars['allProgramTags'] = $newsActions->getAllProgramTags();
    $tags = $newsActions->getTags($news);
    $vars['tags'] = implode(',',$tags);
    $vars['news'] = $news;
    $vars['pod'] = $pod;
}
else {
    if(isset($_POST['delete_news'])) {
        try {
            $success = 'News \'<b>'.$newsActions->deleteNews($_POST['delete_news']).'</b>\' eliminata!';
        } catch(Exception $e) {
            $error = $e->getMessage();
        }
    }
    elseif(isset($_POST['change_visibility'])) {
        try {
            $success = $newsActions->changeVisibility($_POST['change_visibility']);
        } catch(Exception $e) {
            $error = $e->getMessage();
        }
    }
    elseif(isset($_POST['change_copyright'])) {
        try {
            $success = $newsActions->changeCopyright($_POST['change_copyright']);
        } catch(Exception $e) {
            $error = $e->getMessage();
        }
    }
    $newsCount = $newsActions->getNewsCount();
    $pages     = $newsActions->getPageNumber($newsCount);
    $page      = 0;
    if(isset($_GET['p']) && ($_GET['p'] >= 0 || $_GET['p'] < $pages)) {
        $page = $_GET['p'];
    }

    $page = $page > $pages-1 ? ($pages > 0 ? $pages-1 : 0) : $page;

    $vars['news']  = $newsActions->getNewsOfPage($page);
    $vars['count'] = $newsCount;
    $vars['pages'] = $pages;
    $vars['page']  = $page;
    $vars['programActions'] = $programActions;

    if(isset($success)) {
        $vars['success'] = $success;
    }
    if(isset($error)) {
        $vars['error'] = $error;
    }
    $template->init('program', 'news');
}
$vars['tinymce'] = 1;
$template->loadTemplate($vars);
?>
