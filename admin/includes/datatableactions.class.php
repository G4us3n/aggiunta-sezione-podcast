<?php
//Questo file contiene una classe con metodi per ottenere i dati da tabelle del db, come province, stati, prefissi ect...

class DataTableActions{


  //restituisce l'elenco delle regioni
  public function getRegioni(){


    $order = array('order' => 'regione_province asc');

    $parameters = array_merge($order);

    print_r($parameters);

    $table = Province::all($parameters);

    return $table;


  }

  //recupera i dati di tutte le province o di quelle di una regione
  public function getProvince($regioni = [],$order = 'nome_province'){

    //$conditions = array('conditions' => array('visible = ? OR visible = ? ....', true,false,....));
    //$parameters = array_merge($conditions,$order);
    //$table = Linkindex::all($parameters);

    //print_r($regioni);

    if(empty($regioni)){

      $conditions = array();

    }else{

      $where = '';
      $conditions = array($where);
      foreach ($regioni as $regione){

        $where .= 'regione_province = ? OR ';
        array_push($conditions,$regione);
      }

      $where = rtrim($where,' OR ');

      $conditions[0] = $where;

      $conditions = array('conditions' => $conditions);
    }

    $order .= ' asc';
    $order = array('order' => $order);

    $parameters = array_merge($conditions,$order);

    //print_r($parameters);

    $table = Province::all($parameters);

    return $table;

  }

  //verifica se la provincia esiste (usa l'id) e restituisce la provincia
  public function isProvincia($provincia){
    $obj = Province::first(array('conditions' => array('nome_province = ?', $provincia)));
    if($obj->nome_province == $provincia){
      return $obj;
    }else{
      return false;
    }
  }


  //recupera i dati di stati e prefissi
  public function getStati($continenti = [],$order = 'nome_stati'){

    $conditions = array('conditions' => array("nome_inglese_stati <> '' AND nome_inglese_stati is not NULL"));

    $order .= ' asc';
    $order = array('order' => $order);

    $parameters = array_merge($conditions,$order);

    $table = Stati::all($parameters);

    return $table;

  }


  //verifica lo stato esiste
  public function isStato($stato){
    $obj = Stati::first(array('conditions' => array('nome_stati = ?', $stato)));
    if($obj->nome_stati == $stato){
      return $obj;
    }else{
      return false;
    }
  }

  //verifica se il prefisso esiste
  public function isPrefisso($prefisso){
    $obj = Stati::first(array('conditions' => array('prefisso_telefonico_stati = ?', '+'.$prefisso)));
    if($obj->prefisso_telefonico_stati == $prefisso){
      return $obj;
    }else{
      return false;
    }
  }

  /*
  public function findProvince($province = []){

    //prepara le where condition
    $where = '';
    $conditions = array($where);

    foreach($province as $provincia){

      $where .= 'sigla_province = ? OR ';
      array_push($conditions,$provincia);
    }

      $where = rtrim($where,' OR ');

      $conditions[0] = $where;
      $conditions = array('conditions' => $conditions);


    $obj = Linkindex::first(array('conditions' => array('sigla_province = ?', $provincia)));

    return $obj;

  }
  */
}

?>
