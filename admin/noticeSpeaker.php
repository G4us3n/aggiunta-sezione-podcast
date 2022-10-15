<?php
include("includes/global.php");

$isDirettivo = $userActions->isUserAbleTo('DIRETTIVO');

//$noticeSpeakerActions->

if(!$isDirettivo){
    header('Location: https://membri.poliradio.it/index.php');
    die();
}else{
    $vars = array('active' => 'servizi','isDirettivo' => $isDirettivo); 
    $subtemplate = 'noticeSpeaker';
	
	if(isset($_POST['add_edit_avviso'])){
        //print_r($_POST);
        
        $attributes = $_POST;
        $id = $_POST['edit_id'];
        unset($attributes['add_edit_avviso']);
        unset($attributes['edit_id']);
        

        $attributes['title'] = ($attributes['title'] != '' )? $attributes['title']: 'Inserisci un messaggio';
        
        if(isset($attributes['end_date']) && strtotime($attributes['end_date']) != false && $attributes['end_date']>= date("Y-m-d")){
            //la data è correttamente scelta
            $attributes['end_date'] = date("Y-m-d", strtotime($attributes['end_date']));
		}else{
			//imposta la data di default, 15 giorni da oggi
			$attributes['end_date'] = date("Y-m-d", strtotime('+15 Days'));
		}
		
        
        //$attributes = array(title'=>'Halloween','subtitle'=>'','color'=>'alert-warning','end_date'='2022-10-31');
        
        if($_POST['add_edit_avviso'] == 'add'){
			
			$attributes['position'] = 1;

            //print_r($attributes);
            $result = $noticeSpeakerActions->addNotice($attributes);
        }
		elseif($_POST['add_edit_avviso'] == 'edit'){
			
            //print_r('edit');
            //print_r($attributes);
            $result = $noticeSpeakerActions->editNotice($id,$attributes);
        }
        header("Location: https://membri.poliradio.it/noticeSpeaker.php");

    }
    elseif(isset($_POST['delete_avviso'])){
        
        //print_r($_POST);
        $result = $noticeSpeakerActions->deleteNotice($_POST['delete_avviso']);
        header("Location: https://membri.poliradio.it/noticeSpeaker.php");
    }
    elseif(isset($_POST['move'])){
        
        $result = $noticeSpeakerActions->changePosition($_POST['id'],$_POST['move']);
        header("Location: https://membri.poliradio.it/noticeSpeaker.php");
    }
    //dopo le azioni mostro la pagina
    //leggo il db
    $notice_data = $noticeSpeakerActions->getAllRow();
	
	//nel caso alcuni eventi siano diventati obsoleti li elimina
	
	foreach($notice_data as $row){
		if ($row->end_date < date("Y-m-d")){
			//print_r($row);
			$result = $noticeSpeakerActions->deleteNotice($row->id);
		}
	}
	
    $last_notice = $noticeSpeakerActions->getMaxPosition();
	
    $vars['notice_data'] = $notice_data;
    $vars['last_notice'] = $last_notice;
    
	$stili = array('alert-success'=>'Verde','alert-warning'=>'Giallo','alert-danger'=>'Rosso');
		
	$vars['stili'] = $stili;
	
	
	$js = $template->globalJS();
	//$js .= '<script src="'.$template->getBaseUrl().'datePicker/datepicker.it-IT.js"></script>';
	$template->setGlobalJs($js);
	
	$css = $template->globalCSS();
	//$css .= '<link rel="stylesheet" href="'.$template->getBaseUrl().'datePicker/datepicker.css">';
	$template->setGlobalCSS($css);
	
    $template->init('admin', $subtemplate);
    $template->loadTemplate($vars);

}
?>
