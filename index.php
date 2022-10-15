<?php
require_once dirname(__FILE__) . '/includes/core.php';

class HomepageContent{
    public $upTitle;
    public $title;
    public $subTitle;
    public $button;
    public $buttonClass;
    public $buttonUrl;
    public $bg;

    public function __construct($upTitle = NULL, $title = NULL, $subTitle = NULL,
                                    $buttonClass = NULL, $button = NULL, $buttonUrl = NULL, $bg = NULL) {
        $this->upTitle = $upTitle;
        $this->title = $title;
        $this->subTitle = $subTitle;
        $this->buttonClass = $buttonClass;
        $this->button = $button;
        $this->buttonUrl = $buttonUrl;
        $this->bg = $bg;
    }
}

$homepageContents = array();

$latestNews = NewsProgrammi::first(array('order' => 'time DESC'));
$latestNews = NewsProgrammi::find('all', array(
    'conditions' => 'visibile = 1 AND (global = 1 OR programmi_id IN(SELECT id FROM programmi WHERE status = 0 OR status = 2))',
    'order' => 'time DESC', //$latestNews->time < time()-604800 ? 'RAND()' : 'time DESC'
    'limit' => 5));


for($i = 0; $i < 5; $i++){
    $n = $latestNews[$i];
    $programTag = Database::getProgramTag($n->programmi_id);
    $programName = Database::getProgramName($n->programmi_id);

    $hpc = new HomepageContent();
    $hpc->bg = PRODUCTION_PATH . "/photos/news/" . $programTag . "/" . $n->foto;
    $hpc->title = hfix($n->titolo);
    $hpc->upTitle = $programName != "Redazione" ? $programName : NULL;
    $hpc->underTitle = $n->sottotitolo;
    $hpc->button = "leggi";
    $hpc->buttonClass = "read-article";
    $hpc->buttonUrl = PATH . "/news/" . $n->id . "/" . format_text_url(hfix($n->titolo));

    $homepageContents[] = $hpc;
}

if(date("w") == 0){
    $hpc = new HomepageContent();
    $hpc->bg = PRODUCTION_PATH . "/photos/covers/domenica.jpg";
    $hpc->title = "Weekly Podcast";
    $hpc->upTitle = "Domenica da coma?";
    $hpc->underTitle = "Ascolta la puntata che ti sei perso o riascolta il tuo programma preferito";
    $hpc->button = "Vai alle puntate";
    $hpc->buttonClass = "to-podcast";
    $hpc->buttonUrl = PATH . "/podcast/week";

    array_unshift($homepageContents, $hpc);
    unset($homepageContents[5]);
}

$currentShow = Database::getOnAirProgram();
$nextShow = Database::getNextOnAirProgram();

if($currentShow != NULL){
    $hpc = new HomepageContent();
    $hpc->bg = isShowCoverPresent($currentShow->tag) & false ?
//    $hpc->bg = isShowCoverPresent($currentShow->tag) ?
                    PRODUCTION_PATH . "/photos/covers/" . $currentShow->tag . ".jpg" :
                    PRODUCTION_PATH . "/photos/covers/default".rand(1,6).".png";
    $hpc->title = hfix($currentShow->nome);
    $hpc->upTitle = "<i class=\"fas fa-music\" style=\"font-size: 0.8em\"></i> Stai ascoltando...";
    $hpc->underTitle = hfix($currentShow->descrizione);
    $hpc->button = "Guarda la diretta";
    $hpc->buttonClass = "to-webcam";
    $hpc->buttonUrl = PATH . "/live";

    array_unshift($homepageContents, $hpc);
    unset($homepageContents[5]);
}else if( $nextShow[0] != NULL && isShowComingSoon($nextShow)){
    $hpc = new HomepageContent();
    $hpc->bg = isShowCoverPresent($nextShow[1]->tag) ?
        PRODUCTION_PATH . "/photos/covers/" . $nextShow[1]->tag . ".jpg" :
        PRODUCTION_PATH . "/photos/covers/default.jpg";
    $hpc->title = hfix($nextShow[1]->nome);
    $hpc->upTitle = "In onda alle " . $nextShow[0]->ora_inizio . ":" . addLeadingZero($nextShow[0]->minuto_inizio);
    $hpc->underTitle = hfix($nextShow[1]->descrizione);
    $hpc->button = "Pagina del programma";
    $hpc->buttonClass = NULL;
    $hpc->buttonUrl = PATH . "/show/" . $nextShow[1]->id . "/" . $nextShow[1]->tag;

    array_unshift($homepageContents, $hpc);
    unset($homepageContents[5]);
}

$pageVars = array(
    'contents' => $homepageContents
);
$TemplatesManager->loadTemplate("home",
                                new PageBundle("", "home"),
                                $pageVars);
?>
