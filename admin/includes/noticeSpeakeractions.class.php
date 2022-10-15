<?php
class NoticeSpeakerActions{
    
    public function __construct(){
        
		$this->isDirettivo =  true;
        
		$this->column_name = [];
        
        $columns = AvvisiSpeaker::table()->columns;
        
        foreach ($columns as $column) {
            array_push($this->column_name,$column->name);
        }
        
        //print_r($this->column_name);
        
    }
    
    //recupera tutte le righe dal database
    public function getAllRow($type='all'){
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
    
    public function findById($id){
        $obj = AvvisiSpeaker::first($id);
        return $obj;
    }
    
    //se $social = true, ricerca position_social
    public function findByPosition($position){
		$obj = AvvisiSpeaker::first(array('conditions' => array('position = ?', $position)));
		
        return $obj;
    }
    
    public function getPosition($id){
        $obj = $this->findById($id);
        $position = $obj->position;
        return $position;
    }
    
    public function getMaxPosition(){
 
        $max_position = AvvisiSpeaker::find('all', array('select' => 'max(position) as max_position'));
        $max_position = $max_position[0]->max_position;
        //print_r($max_position);
        return $max_position;
    }
    
    public function addNotice($parameters = []){
		
		if(!$this->isDirettivo){
			return;
		}
		
        //print_r($parameters);
        $this->slidePositions(1,'down');
        $post = AvvisiSpeaker::create($parameters);
        return $post;
    }
    
    public function editNotice($id,$parameters = []){
        if(!$this->isDirettivo){
			return;
		}
		
		$obj = $this->findById($id);
		
		$parameters['position'] = $obj->position;
		
		
        $column_to_change = $this->column_name;
        
        array_shift($column_to_change); //rimuove id
        
        //print_r($column_to_change);
        
        foreach($column_to_change as $column){
            $obj->$column = $parameters[$column];
        }
        $obj->save();
    }
    
    public function deleteNotice($id){
        if(!$this->isDirettivo){
			return;
		}
		
        $obj = $this->findById($id);
        
        $this->slidePositions($this->getPosition($id),'up');
        
        $obj->delete();
    }
    
    
    //change position inverte due righe del database adiacenti per posizione, scelta una riga la inverte con quella superiore o con quella inferiore
    public function changePosition($id,$move){
        if(!$this->isDirettivo){
			return;
		}
		$obj1 = $this->findById($id);
        $position1 = $this->getPosition($id);
        
        //verifico che non sia l'ultimo elemento a voler scendere o il primo a voler andare su;
        //non ci sono i pulsanti per farlo, ma non si sa mai;
        
        $max_position = $this->getMaxPosition();
        
        if($position1 == 1 && $move == 'up') {
            return;
        }
        
        if($position1 == $max_position && $move == 'down'){
            return;
        }
        
        
        //echo($move);
        
        if($move == 'up'){
            $obj2 = $this->findByPosition($position1 - 1);
            $obj2->position += 1;
            $obj1->position -= 1;
        }elseif($move == 'down'){
            $obj2 = $this->findByPosition($position1 + 1);
            $obj2->position -= 1;
            $obj1->position += 1;
        }
        
        $obj1->save();
        $obj2->save();
    }
    
    
    //quando elimino o creo slitto il valore posizione delle altre in modo che sia in ordine; 
	//per farlo utilizzo questo metodo che dato un'id e move slitta tutti i valori sotto o sopra all'elemento del dato id;
    public function slidePositions($position,$move){
        if(!$this->isDirettivo){
			return;
		}
		
        $obj = $this->findByPosition($position);
        
        if($move == 'up'){
            //li sposto verso l'alto
            $obj = $this->findByPosition($position + 1);
            while($obj != null){
                $obj2 = $this->findByPosition($position + 1);
                $obj->position -= 1;
                $obj->save();
                $obj = $obj2;
                $position += 1;
            }
            
            
        }elseif($move == 'down'){
            //li sposto verso il basso
            while($obj != null ){
                //echo $position;
                $obj2 = $this->findByPosition($position + 1);
                $obj->position += 1;
                $obj->save();
                $obj = $obj2;
                $position += 1;
            }
            
        }
        
        
    }
    
    
}


?>
