<?php
include("includes/global.php");

$isDirettivo = $userActions->isUserAbleTo('DIRETTIVO');

if(!$isDirettivo){
    header('Location: https://membri.poliradio.it/index.php');
    die();
}else{
    
    $vars = array('active' => 'servizi','isDirettivo' => $isDirettivo); 
    $subtemplate = 'linkindex';
                  
    if(isset($_POST['add_edit_link'])){
        //print_r($_POST);
        
        $attributes = $_POST;
        $id = $_POST['edit_id'];
        unset($attributes['add_edit_link']);
        unset($attributes['edit_id']);
        
        //converto il link type in social vero o falso 
        $attributes['social'] = $attributes['link_type'] == 'social' ? true : false;
        unset($attributes['link_type']);
        
        //controllo il contenuto e correggo
        $attributes['visible'] = isset($attributes['visible']) ? true : false ;
        $attributes['social'] = $attributes['social'] ? true : false ;
        
        
        if($attributes['title'] == '' || $attributes['url'] == ''){
            $attributes['visible'] = 0;
        }
        
        $attributes['title'] = ($attributes['title'] != '' )? $attributes['title']: 'Metti un Titolo';
        $attributes['url'] = ($attributes['url'] != '')? $attributes['url']: 'https://poliradio.it';
        
        
        if($attributes['social'] && !isset($attributes['img'])){
            $attributes['img'] = 'https://dev.poliradio.it/img/logo.svg';
            $attributes['visible'] = 0;
        }
        //$attributes = array('url'=>'pino','title'=>'pinuccio','subtitle'=>'','visible'=>'1','social'=>'0','img'=>'');
        
        if($_POST['add_edit_link'] == 'add'){
            
            $attributes['position_link'] = $attributes['social'] ? 0 : 1;
            $attributes['position_social'] = $attributes['social'] ? 1 : 0;
            
            //print_r($attributes);
            $result = $linkIndexActions->addLink($attributes);
        }elseif($_POST['add_edit_link'] == 'edit'){
            
            $position = $linkIndexActions->getPosition($id);
            
            //qui mi occupo di preservare la posizione; se ho fatto un cambio di tabella il nuovo valore corretto di position verrà settato da editLink;
            $attributes['position_link'] = $attributes['social'] ? 0 : $position;
            $attributes['position_social'] = $attributes['social'] ? $position : 0;
            
            
            //print_r('edit');
            //print_r($attributes);
            $result = $linkIndexActions->editLink($id,$attributes);
        }
    }
    elseif(isset($_POST['change_visibility'])){
        //print_r($_POST);
        $result = $linkIndexActions->changeVisibility($_POST['change_visibility']);
        
    }
    elseif(isset($_POST['delete_link'])){
        
        //print_r($_POST);
        $result = $linkIndexActions->deleteLink($_POST['delete_link']);
        
    }
    elseif(isset($_POST['move'])){
        
        $result = $linkIndexActions->changePosition($_POST['id'],$_POST['move']);
        
    }
    //dopo le azioni mostro la pagina
    //leggo il db
    $link_data = $linkIndexActions->getAllRow($type = 'link', $visible = false);
    $social_data = $linkIndexActions->getAllRow($type = 'social', $visible = false);
    $last_link = $linkIndexActions->getMaxPosition();
    $last_social = $linkIndexActions->getMaxPosition(true);

    $vars['link_data'] = $link_data;
    $vars['social_data'] = $social_data;
    $vars['last_link'] = $last_link;
    $vars['last_social'] = $last_social;
        
    
    
    $template->init('admin', $subtemplate);
    $template->loadTemplate($vars);

}
?>
