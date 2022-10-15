<?php

class LinkIndexActions{
    
    public function __construct(){
        
        $this->column_name = [];
        
        $columns = Linkindex::table()->columns;
        
        foreach ($columns as $column) {
            array_push($this->column_name,$column->name);
        }
        
        //print_r($this->column_name);
        
    }
    
    //recupera tutte le righe dal database
    public function getAllRow($type='all',$visible = false){
        //type specifica se 'link', 'social', 'all'
        //visible specifica prendere solo i visibili (true) o tutti quanti (false)
        
        switch ($type) {
            case 'all':
                
                if($visible){
                    $conditions = array('conditions' => array('visible = ?', true));
                }else{
                    $conditions = array();
                }
                
                break;
            case 'link':
                
                $where = $visible ? 'social = ? AND visible = ?' : 'social = ? ';
                
                $conditions = array('conditions' => array($where, false));
                
                if($visible){
                    $conditions['conditions'][2] = true ;
                }
                break;
            case 'social':
                
                
                $where = $visible ? 'social = ? AND visible = ?' : 'social = ? ';
                
                $conditions = array('conditions' => array($where, true));
                
                if($visible){
                    $conditions['conditions'][2] = true ;
                }
                
                break;
            default:
                $conditions = array();
        }
            
        if($type != 'all'){
            $colonna_desc = 'position_'.$type.' asc';
            $order = array('order' => $colonna_desc);
        }else{
            $order = array();
        }
        
        
        
        
        $parameters = array_merge($conditions,$order);
        
        //print_r($parameters);
        
        if(empty($parameters)){
            $table = Linkindex::all();
        }else{
            $table = Linkindex::all($parameters);
        }
        
        return $table;

    }
    
    public function findById($id){
        $obj = Linkindex::first($id);
        return $obj;
    }
    
    //se $social = true, ricerca position_social
    public function findByPosition($position,$social){
        if($social){
            $obj = Linkindex::first(array('conditions' => array('position_social = ?', $position)));
        }else{
            $obj = Linkindex::first(array('conditions' => array('position_link = ?', $position)));
        }
        return $obj;
    }
    
    public function getPosition($id){
        $obj = $this->findById($id);
        $position = $obj->position_link + $obj->position_social;
        return $position;
    }
    
    public function getMaxPosition($social = false){
        $position_attribute = $social ? 'position_social' : 'position_link';
        
        $max_position = Linkindex::find('all', array('select' => 'max('.$position_attribute.') as max_position'));
        $max_position = $max_position[0]->max_position;
        //print_r($max_position);
        return $max_position;
    }
    
    public function addLink($parameters = []){
        //print_r($parameters);
        $this->slidePositions(1,'down',$parameters['social']);
        $post = Linkindex::create($parameters);
        return $post;
    }
    
    public function editLink($id,$parameters = []){
        $obj = $this->findById($id);
        
        //nel caso la posizione cambia da link generici a link social
        if($obj->social != $parameters['social']){
            $position_attribute = $parameters['social'] ? 'position_social' : 'position_link'; //E' il campo che indica la colonna da usare per la posizione nella nuova tabella
            
            
            //sulla vecchia tabella diventa posizione zero e le altre voci salgono
            //nota che la posizione è gia stata settata su zero prima che il metodo editLink venisse chiamato
            $this->slidePositions($parameters[$position_attribute],'up',!$parameters['social']);
            
            //sulla nuova tabella va in prima posizione, e le altre voci scendono
            $parameters[$position_attribute] = 1;
            $this->slidePositions(1,'down',$parameters['social']);
            
        }
        
        $column_to_change = $this->column_name;
        
        array_shift($column_to_change); //rimuove id
        
        //print_r($column_to_change);
        
        foreach($column_to_change as $column){
            $obj->$column = $parameters[$column];
        }
        $obj->save();
    }
    
    public function changeVisibility($id){
        
        $obj = $this->findById($id);
        
        $obj->visible = $obj->visible ? false : true;
        $obj->save();
    }
    
    public function deleteLink($id){
        
        $obj = $this->findById($id);
        
        $this->slidePositions($this->getPosition($id),'up',$obj->social);
        
        $obj->delete();
    }
    
    
    //funzione per spostare in su/in giu di un posto : prende l'id della riga, e se $move=true muove verso l'alto, se $move=false muove verso il basso; con $social recupera la posizione della fila corretta, e modifica la posizione nella fila corretta
    public function changePosition($id,$move){
        $obj1 = $this->findById($id);
        $social = $obj1->social;
        $position1 = $this->getPosition($id);
        
        $position_attribute = $social ? 'position_social' : 'position_link';
        
        //verifico che non sia l'ultimo elemento a voler scendere o il primo a voler andare su;
        //non ci sono i pulsanti per farlo, ma non si sa mai;
        
        $max_position = $this->getMaxPosition($social);
        
        if($position1 == 1 && $move == 'up') {
            return;
        }
        
        if($position1 == $max_position && $move == 'down'){
            return;
        }
        
        
        
        //echo($move);
        
        if($move == 'up'){
            $obj2 = $this->findByPosition($position1 - 1,$social);
            $obj2->$position_attribute += 1;
            $obj1->$position_attribute -= 1;
        }elseif($move == 'down'){
            $obj2 = $this->findByPosition($position1 + 1,$social);
            $obj2->$position_attribute -= 1;
            $obj1->$position_attribute += 1;
        }
        
        $obj1->save();
        $obj2->save();
    }
    
    
    //quando elimino, creo, cambio categoria link_social a una riga, slitto il valore posizione delle altre in modo che sia in ordine; per farlo utilozzo, questo metodo che dato un'id è un $move true se verso l'alto, false se verso il basso, slitta tutti i valori sotto o sopra all'elemento passato;
    public function slidePositions($position,$move,$social){
        
        $obj = $this->findByPosition($position,$social);

        $position_attribute = $social ? 'position_social' : 'position_link';
        
        if($move == 'up'){
            //li sposto verso l'alto
            $obj = $this->findByPosition($position + 1,$social);
            while($obj != null){
                $obj2 = $this->findByPosition($position + 1,$social);
                $obj->$position_attribute -= 1;
                $obj->save();
                $obj = $obj2;
                $position += 1;
            }
            
            
        }elseif($move == 'down'){
            //li sposto verso il basso
            while($obj != null ){
                //echo $position;
                $obj2 = $this->findByPosition($position + 1,$social);
                $obj->$position_attribute += 1;
                $obj->save();
                $obj = $obj2;
                $position += 1;
            }
            
        }
        
        
    }
    
    
}


?>
