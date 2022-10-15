<?php
require_once "cors.php";
require_once dirname(__FILE__) . '/../../includes/core.php';

function getAllRow($type='all'){
    //type specifica il tipo di colore del link

    if($type == 'all') {

        $conditions = array();

    }else{

        $conditions = array('conditions' => array('color = ?', $type));
    }

    $order = array('order' => 'position');

    $parameters = array_merge($conditions,$order);

    //print_r($parameters);

    if(empty($parameters)){
        $table = AvvisiSpeaker::all();
    }else{
        $table = AvvisiSpeaker::all($parameters);
    }

    return $table;
    
}


$table_obj = getAllRow();
$data = [];

foreach ($table_obj as $avviso){
	if($avviso->end_date < date("Y-m-d")){
		continue;
	}    
    $data_avviso = array('id'=>$avviso->id,'title'=>$avviso->title,'description'=>$avviso->description,'color'=>$avviso->color);
    
    array_push($data,$data_avviso);
    
}

echo json_encode($data);
?>
