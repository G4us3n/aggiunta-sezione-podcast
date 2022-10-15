<?php
// NB: save with encoding Windows-1252
include("includes/global.php");
if(!$userActions->isUnelevatedUserAbleTo('DIRETTIVO')) {
    die('Non sei abilitato ad accedere a questa risorsa!');
}
$user = Utenti::first($_GET['id']);
if(!$user) {
    die('Utente non valido!');
}
if(is_array($userActions->nameOfType($user->tipo))) {
    die('Imposta il tipo di membro prima di stampare la sua scheda associato! <a href="users.php?list=0&m='.$user->id.'">Clicca qui per farlo</a>');
}
require('fpdf/fpdf.php');

//estensione che crea dei metodi utili per un migliore utilizzo di funzioni già preesistenti nel plugin che genera i pdf
class PDF extends FPDF {
    var $B;
    var $I;
    var $U;
    var $HREF;

    function Header() {
        //$this->Image('logo.png',10,6,30);
        $this->setY(5);
        $this->SetFont('Courier','i',12);
        $this->Cell(0, 10, 'POLI.RADIO - www.poliradio.it', 0, 0, 'C');
        $this->Line(10, 15, 200, 15);
        $this->Ln(20);
    }

    function Footer() {
        $this->SetY(-20);
        $y = $this->getY();
        $this->Line(10, $y, 200, $y);
        $this->SetFont('Courier','I',8);
        $this->Cell(0, 10, 'POLI.RADIO - Politecnico di Milano, Piazza Leonardo da Vinci, 32  20133  MILANO', 0, 0, 'C');
        //$this->Ln(7);
        //$this->Cell(0,10, $this->PageNo().'/{nb}',0,0,'C');
    }

    function Justify($text, $w, $h) {
        $tab_paragraphe = explode("\n", $text);
        $nb_paragraphe = count($tab_paragraphe);
        $j = 0;
        while ($j < $nb_paragraphe) {
            $paragraphe = $tab_paragraphe[$j];
            $tab_mot = explode(' ', $paragraphe);
            $nb_mot = count($tab_mot);
            $k = 0;
            $l = 0;
            while ($k < $nb_mot) {
                $len_mot = strlen($tab_mot[$k]);
                if ($len_mot < ($w-5) ) {
                    $tab_mot2[$l] = $tab_mot[$k];
                    $l++;
                } else {
                    $m = 0;
                    $chaine_lettre = '';
                    while($m < $len_mot) {
                        $lettre = substr($tab_mot[$k], $m, 1);
                        $len_chaine_lettre = $this->GetStringWidth($chaine_lettre.$lettre);
                        if ($len_chaine_lettre > ($w-7)) {
                            $tab_mot2[$l] = $chaine_lettre . '-';
                            $chaine_lettre = $lettre;
                            $l++;
                        } else {
                            $chaine_lettre .= $lettre;
                        }
                        $m++;
                    }
                    if ($chaine_lettre) {
                        $tab_mot2[$l] = $chaine_lettre;
                        $l++;
                    }
                }
                $k++;
            }
            $nb_mot = count($tab_mot2);
            $i = 0;
            $ligne = '';
            while($i < $nb_mot) {
                $mot = $tab_mot2[$i];
                $len_ligne = $this->GetStringWidth($ligne . ' ' . $mot);
                if ($len_ligne > ($w-5)) {
                    $len_ligne = $this->GetStringWidth($ligne);
                    $nb_carac = strlen($ligne);
                    $ecart = (($w-2) - $len_ligne)/$nb_carac;
                    $this->_out(sprintf('BT %.3F Tc ET', $ecart*$this->k));
                    $this->MultiCell($w, $h, $ligne);
                    $ligne = $mot;
                } else {
                    if ($ligne) {
                        $ligne .= ' '.$mot;
                    } else {
                        $ligne = $mot;
                    }
                }
                $i++;
            }
            $this->_out('BT 0 Tc ET');
            $this->MultiCell($w, $h, $ligne);
            $tab_mot = '';
            $tab_mot2 = '';
            $j++;
        }
    }

    function WriteHTML($html) {
        $html = str_replace("\n", ' ', $html);
        $a = preg_split('/<(.*)>/U', $html, -1, PREG_SPLIT_DELIM_CAPTURE);
        foreach($a as $i=>$e) {
            if($i%2==0) {
                if($this->HREF) {
                    $this->PutLink($this->HREF, $e);
                }
                else {
                    $this->Write(5, $e);
                }
            }
            else {
                if($e[0]=='/') {
                    $this->CloseTag(strtoupper(substr($e, 1)));
                }
                else {
                    $a2 = explode(' ', $e);
                    $tag = strtoupper(array_shift($a2));
                    $attr = array();
                    foreach($a2 as $v) {
                        if(preg_match('/([^=]*)=["\']?([^"\']*)/', $v, $a3)) {
                            $attr[strtoupper($a3[1])] = $a3[2];
                        }
                    }
                    $this->OpenTag($tag, $attr);
                }
            }
        }
    }

    function OpenTag($tag, $attr) {
        if($tag=='B' || $tag=='I' || $tag=='U') {
            $this->SetStyle($tag, true);
        }
        if($tag=='A') {
            $this->HREF = $attr['HREF'];
        }
        if($tag=='BR') {
            $this->Ln(5);
        }
    }

    function CloseTag($tag) {
        if($tag=='B' || $tag=='I' || $tag=='U') {
            $this->SetStyle($tag, false);
        }
        if($tag=='A') {
            $this->HREF = '';
        }
    }

    function SetStyle($tag, $enable) {
        $this->$tag += ($enable ? 1 : -1);
        $style = '';
        foreach(array('B', 'I', 'U') as $s) {
            if($this->$s>0) {
                $style .= $s;
            }
        }
        $this->SetFont('', $style);
    }

    function PutLink($URL, $txt) {
        $this->SetTextColor(0, 0, 255);
        $this->SetStyle('U', true);
        $this->Write(5, $txt, $URL);
        $this->SetStyle('U', false);
        $this->SetTextColor(0);
    }
}
//Fine dell'estensione

//Testi della liberatoria
$desinenza = $userActions->getSessoDesinenza($user);
$articolo = $userActions->getSessoArticolo($user);
$pronome = $userActions->getSessoPronome($user,'IT'); // lui,lei ; his,her
$pronome2 = $userActions->getSessoPronome2($user,'IT'); // lo,la ;

$testo_scheda = $articolo . ' sottoscritt'.$desinenza.' esprime la volontà di voler collaborare a titolo volontario e non remunerato all’associazione POLI.RADIO e acconsente alle decisioni demandate dall\'Organo Direttivo e dall’assemblea. Si impegna altresì al rispetto dello statuto e del regolamento associativo e all\'adempimento delle mansioni affidategli.';

$testo_privacy = $articolo." sottoscritt".$desinenza." dichiara di aver preso visione dell'informativa sulla privacy e di accettarne i termini e le condizioni. L'informativa è disponibile al seguente sito ";

$link_privacy = "https://www.poliradio.it/privacy/InformativaPrivacy.pdf";

$testo_proprieta_intellettuale = "affinché POLI.RADIO possa radiodiffondere, utilizzare, elaborare, modificare, adattare, fissare, riprodurre, sincronizzare, ivi compresa la comunicazione al pubblico e ogni altra attività prevista ai sensi del Titolo I Capo III sezione I e della Legge 633/1941 (legge sul diritto d’autore) quanto da ".$pronome." comunicato, dichiarato o comunque qualsiasi suo contributo o materiale artistico realizzato nel corso delle riprese audiovisive, attraverso i canali di comunicazione indicati riconoscendo altresì in capo a POLI.RADIO la facoltà di modificare e/o rieditare il suddetto materiale attraverso i suddetti canali. Eventuali modifiche apportate sul suddetto materiale da POLI.RADIO non dovranno essere preventivamente approvate";

$testo_liberatoria_immagini = "per l’uso, la riproduzione e la pubblicazione con ogni mezzo tecnico delle riprese audio-video della propria persona trattate da POLI.RADIO.

NE VIETA altresì l'uso in tutti i casi che ne pregiudichino l’onore, la reputazione e il decoro della propria persona, ai sensi dell’art. 97 legge n° 633/41 e art. 10 del Codice civile. Ai sensi dell’art.98 legge n° 633/41 e in conformità alla sentenza n. 4094 del 28/6/1980 della Corte di Cassazione, le immagini in originale (files digitali sorgenti e/o negativi su pellicola) si intendono di proprietà di POLI.RADIO.

".$articolo." sottoscritt".$desinenza." è al corrente, e non ha alcuna obiezione al riguardo, che il programma al quale parteciperà e/o tutto ciò che potrebbe essere realizzato con tutto o parte delle riprese della propria partecipazione, sarà veicolo di promozione e diffusione anche su altre piattaforme di streaming. In tal senso ".$articolo." sottoscritt".$desinenza." concede a POLI.RADIO e ai suoi aventi causa - ai sensi degli artt. 12, 84, 96, 110 e 119 comma 5 della Legge 633/1941 (legge sul diritto d’autore) – il diritto di sfruttare, e di concedere a terze parti autorizzate da POLI.RADIO di sfruttare - nonché di utilizzare, elaborare, modificare, adattare, fissare, riprodurre, diffondere, ivi compresa la comunicazione al pubblico e ogni altra attività prevista ai sensi del Titolo I Capo III sezione I e Titolo II Capo III della Legge 633/1941 - a titolo completamente gratuito e senza limiti di tempo, le immagini, e in ogni caso tutti i contenuti digitali, fotografici e audiovisivi raccolti che ".$pronome2." ritraggono (direttamente o indirettamente), nonché il proprio nome attraverso siti web ufficiali e piattaforme digitali e social media attuali e futuri di POLI.RADIO e di terze parti autorizzate da POLI.RADIO, per finalità promozionali quali, ad esempio, l’inserimento all’interno di spot, product placement e/o altre forme di pubblicità, manifestazioni, concorsi a premi, giochi, programmi e spettacoli vari. Resta inteso che i propri abiti e/o accessori saranno privi di qualsiasi logo e/o marchio atto a identificare direttamente o indirettamente società e/o aziende.
";

$testo_responsabilita_danni = $articolo." sottoscritt".$desinenza." solleva POLI.RADIO da ogni responsabilità in relazione a:
a)  qualsiasi incidente dovesse occorrergli in dipendenza della partecipazione di cui sopra, salvo che ciò dipenda da responsabilità diretta di POLI.RADIO.
b)  eventuali danni a locali e/o attrezzature capitati durante lo svolgimento dell’evento di cui sopra. Si impegna quindi a risarcire eventuali spese per danni causati dalla propria incuria
c)  eventuali danni causati all’Ateneo o pretese risarcitorie che dovessero avanzare Autorità o soggetti terzi in merito a quanto oggetto della propria partecipazione di cui sopra per la violazione di diritti morali, personali, intellettuali o comunque di norme di legge.
";


//INIZIO CREAZIONE PDF
$pdf = new PDF();
$pdf->SetTitle("Liberatoria di ".$user->nome." ".$user->cognome.".pdf");
$pdf->AliasNbPages();
$pdf->AddPage();
$pdf->SetFont('Courier', 'B', 11);
$pdf->Cell(130, 0, 'SCHEDA ASSOCIATO NUMERO: '.$user->id, 0, 1, 'L');
$pdf->Cell(0, 0, $userActions->nameOfType($user->tipo), 0, 1, 'R');
$pdf->Ln(10);

//DATI ANAGRAFICI
$pdf->SetFont('Courier', '', 10);
$pdf->Cell(0, 0, 'Nome: '.$user->nome);
$pdf->Ln(5);
$pdf->Cell(0, 0, 'Cognome: '.$user->cognome);
$pdf->Ln(5);
$info_data = (array) $user->data_nascita;
$data = new DateTime($info_data['date']);
$pdf->Cell(0, 0, 'Nat'.$desinenza.' a '.$user->comune_nascita.' ('.$user->provincia_nascita.') ' . $user->stato_nascita . ' il '.$data->format('d-m-Y'));
$pdf->Ln(5);
$pdf->Cell(0, 0, 'Codice Fiscale: '.$user->codice_fiscale);
$pdf->Ln(10);
$pdf->Cell(0, 0, 'Residente a '.$user->residenza_comune.' in ' . $user->residenza_indirizzo.' '.$user->residenza_civico);
$pdf->Ln(5);
$pdf->SetX(35.5);
$pdf->Cell(0, 0, 'CAP: '.$user->residenza_cap.' Provincia: '.$user->residenza_provincia . ' Stato: '.$user->residenza_stato);
$pdf->Ln(10);
$pdf->Cell(0, 0, 'Domiciliat'.$desinenza.' a '.$user->domicilio_comune.' in ' .$user->domicilio_indirizzo.' '.$user->domicilio_civico);
$pdf->Ln(5);
$pdf->SetX(35.5);
$pdf->Cell(0, 0, 'CAP: '.$user->domicilio_cap.' Provincia: '.$user->domicilio_provincia . ' Stato: '.$user->domicilio_stato);
$pdf->Ln(10);
$pdf->Cell(0, 0, 'Recapito Telefonico: +'.$user->prefisso.' '.$user->telefono);
$pdf->Ln(5);
$pdf->Cell(0, 0, 'Email: '.$user->email);
$pdf->Ln(10);

//TIPOLOGIA DI ISCRIZIONE
if($user->tipo == 'SOCIO_ORDINARIO') {
    $pdf->SetFont('Courier', 'B', 10);
    $pdf->Cell(0, 0, 'In qualità di socio ordinario, dichiara di essere iscritto al Politecnico di Milano');
    $pdf->SetFont('Courier', '', 10);
    $pdf->Ln(5);
    $pdf->Cell(0, 0, 'Codice Persona: '.$user->codice_persona);
    //$pdf->Ln(5);
    //$pdf->Cell(0, 0, 'Corso di Laurea: '.$user->corso_laurea);
    $pdf->Ln(10);
}

//ISCRIZIONE ASSOCIAZIONE
$pdf->Justify($testo_scheda, 190, 5);
$pdf->Ln(10);

//PRIVACY
$pdf->Justify($testo_privacy, 190, 5);
$pdf->Ln(5);
$pdf->SetFont('Courier', 'I', 10);
$pdf->Cell(0, 0, $link_privacy);
$pdf->Ln(10);


//PROPRIETA INTELLETUALE
$pdf->SetFont('Courier', 'B', 11);
$pdf->Cell(130, 0, '1.  PROPRIETA’ INTELLETTUALE', 0, 1, 'L');
$pdf->Ln(7);
$pdf->SetFont('Courier', '', 10);
$pdf->Cell(0, 0, $articolo . ' sottoscritt'.$desinenza);
$pdf->Ln(10);
$pdf->SetX(35.5);
$pdf->Cell(0, 0, '[ ] PRESTA IL CONSENSO');
$pdf->SetX(110);
$pdf->Cell(0, 0, '[ ] NEGA IL CONSENSO');
$pdf->Ln(8);
$pdf->Justify($testo_proprieta_intellettuale, 190, 5);
$pdf->Ln(10);

//LIBERATORIA IMMAGINI
$pdf->SetFont('Courier', 'B', 11);
$pdf->Cell(130, 0, '2. LIBERATORIA IMMAGINI E RIPRESE AUDIO-VIDEO', 0, 1, 'L');
$pdf->Ln(7);
$pdf->SetFont('Courier', '', 10);
$pdf->Cell(0, 0, $articolo . ' sottoscritt'.$desinenza);
$pdf->Ln(10);
$pdf->SetX(35.5);
$pdf->Cell(0, 0, '[ ] PRESTA IL CONSENSO');
$pdf->SetX(110);
$pdf->Cell(0, 0, '[ ] NEGA IL CONSENSO');
$pdf->Ln(8);
$pdf->Justify($testo_liberatoria_immagini, 190, 5);
$pdf->Ln(10);

//RESPONSABILITA' DANNI
$pdf->SetFont('Courier', 'B', 11);
$pdf->Cell(130, 0, '3. RESPONSABILITA’ DANNI', 0, 1, 'L');
$pdf->Ln(8);
$pdf->SetFont('Courier', '', 10);
$pdf->Justify($testo_responsabilita_danni, 190, 5);
$pdf->Ln(10);

//FIRMA
$pdf->setY(-40);
$pdf->setX(25);
$pdf->Cell(0, 0, 'Milano, lì', 0, 1, 'L');
$pdf->setX(-60);
$pdf->Cell(0, 0, 'Firma', 0, 1);
$pdf->Ln(10);
$pdf->setX(25);
$pdf->Cell(0, 0, date('d/m/Y'));
$x = $pdf->getX();
$y = $pdf->getY();
$pdf->Line($x-5, $y, $x-80, $y);
$pdf->Output();

//VERSIONE INGLESE da mostrare se l'utente non è nato in italia

if($user->provincia_nascita == "ESTERO"){

}


?>
