<?php $user = $userActions->getCurrentUser();
$desinenza = $userActions->getSessoDesinenza($user);?>
<div class="span5 myGridContainer">
    <div class="myGrid">
        <div class="myGridInside" style="position: relative;">
        <?php if($user->id == -1) { ?>
        <div class="alert alert-warning">Ti confermo <b>NERD</b> ogni <b>Gioved&igrave;</b> dalle <b>20.00</b> alle <b>21.00</b></div>
        <?php } ?>
        <?php if($user->id == 63) { ?>
        <div class="alert alert-warning">ALE stai CALMAAAAAAAA! &lt;3 </div>
        <?php } ?>
        <?php if($user->id == 240) {
            $name = '🐝🐝🐝 Andrew Honey 🐝🐝🐝';
        } else {
            $name = strlen($user->pseudonimo) > 0 ? hfix($user->pseudonimo) : hfix($user->nome." ".$user->cognome);
        }?>
        <p>
            Benvenut<?php echo $desinenza ?> <b><?php echo $name; ?></b>
            <?php if($user->id == 63) { ?>
            <span class="pull-right label label-important">aledenardo</span>
            <?php } else if($user->id == 73) { ?>
            <span class="pull-right label label-important">Nobile</span>
            <?php } else if($user->id == 1) { ?>
            <span class="pull-right label label-important">Maiux</span>
            <?php } else if($user->administrator) { ?>
            <span class="pull-right label label-important">Admin</span>
            <?php } ?><br>
        </p>

        <?php if($user->id == 174) { ?>
        <img id="enrico" style="position: absolute; right: 0px; width: 25%" class="img-polaroid" onmouseover="document.getElementById('micSound').play();" src="<?php echo $this->base_url; ?>audiologin/michelino_lapide.png">
        <audio id="micSound" src="<?php echo $this->base_url; ?>audiologin/padrino.mp3" style="display: none;"></audio>
        <?php } ?>

        <?php if($user->id == 63) { ?>
        <img id="" style="position: absolute; right: 0px; width: 25%" class="img-polaroid" onmouseover="document.getElementById('aleSound').play();" src="<?php echo $this->base_url; ?>audiologin/ale_lapide.png">
        <audio id="aleSound" src="<?php echo $this->base_url; ?>audiologin/padrino.mp3" style="display: none;"></audio>
        <?php } ?>

        <?php if($user->id == 240) { ?>
        <img id="" style="position: absolute; right: 0px; width: 25%" class="img-polaroid" onmouseover="document.getElementById('honeySound').play();" src="<?php echo $this->base_url; ?>audiologin/miele.png">
        <audio id="honeySound" src="<?php echo $this->base_url; ?>audiologin/ninnananna.mp3" style="display: none;"></audio>
        <?php } ?>

        <?php if($user->id == 163) { ?>
        <img id="" style="position: absolute; right: 0px; width: 25%" class="img-polaroid" onmouseover="document.getElementById('lucianoSound').play();" src="<?php echo $this->base_url; ?>audiologin/emma.png">
        <audio id="lucianoSound" src="<?php echo $this->base_url; ?>audiologin/luciano.ogg" style="display: none;"></audio>
        <?php } ?>
        
        <?php /*
        <a href="https://save.enricazoleo.it/" target="_BLANK" onmouseover="document.getElementById('enricoSound').play()"><img id="enrico" style="position: absolute; right: 0px; width: 25%" class="img-polaroid" src="<?php echo $this->base_url; ?>audiologin/mirko.jpg"></a>
        <audio id="enricoSound" src="<?php echo $this->base_url; ?>audiologin/enricopapi.mp3" style="display: none;"></audio>
        */ ?>

        Posizione: <b>
        <span class="label label-<?php echo $user->livello == 'MEMBRO' ? 'default' : ($user->livello == 'STATION_MANAGER' ? 'success' : 'info'); ?>">
            <?php echo $userActions->nameOfLevel($user->livello); ?>
        </span></b>
        <?php
        $info_data = (array) $user->data_nascita;
        $data = new DateTime($info_data['date']);
        $data = $data->format('d-m');
        if($data == date('d-m')){
            echo '<br><br><h4 class="myGridTitle">Tanti auguri '.hfix($user->nome).'!</h4><br>';
        }else{
            echo '<br><br>';
        }
        ?>
        <b>
            Liberatoria: <font color="<?php echo $user->firma ? 'green' : 'red'; ?>"><?php echo $user->firma ? 'Firmata' : 'Non Firmata'; ?></font><br>
            Quota associativa: <font color="<?php echo $user->quota ? 'green' : 'red'; ?>"><?php echo $user->quota ? 'Pagata' : 'Non Pagata'; ?></font><br>
        </b>
        <br>
        <?php $programCount = count($user->programmi); ?>
        Fai parte di <b><?php echo $programCount; ?></b> programm<?php echo $programCount == 1 ? 'a' : 'i'; ?><br>
        Ultimo IP: <b><?php echo $user->last_login_ip; ?></b><br>
        Hai effettuato <b><?php echo $user->login; ?></b> access<?php echo $user->login == 1 ? 'o' : 'i'; ?> total<?php echo $user->login == 1 ? 'e' : 'i'; ?>
        </div>
    </div>
</div>

<div class="span2"></div>

<div class="span7 myGridContainer">
    <div class="myGrid">
        <div class="myGridInside">
        <h4 class="myGridTitle"><i class="icon-music"></i> Programmi di cui fai parte</h4>
        <?php if($programCount == 0) { ?>
        <i>Purtroppo non fai ancora parte di alcun programma!</i>
        <?php
            }
            else {
        ?>
        <table class="table table-hover">
            <tr>
                <td><strong>Nome</strong></td>
                <td><strong>Membri</strong></td>
                <td><strong>Ruolo</strong></td>
            </tr>
            <?php
            foreach($user->programmi as $program) {
                $staff = $program->programmi_utenti;
                ?>
                <tr>
                    <td>
                        <a class="btn btn-mini btn-success" href="<?php echo $this->base_url; ?>programs.php?list=0&p=<?php echo $program->id; ?>"><i class="icon-music"></i></a> <a href="http://www.poliradio.it/programmi/<?php echo $program->id; ?>/<?php echo hfix($program->tag); ?>" target="_BLANK"><?php echo hfix($program->nome).($program->id == 44 ? ' (SALUTE)' : ''); ?></a>
                    </td>
                    <td>
                        <span class="label label-warning"><?php echo count($staff); ?></span>
                    </td>
                    <td>
                        <?php
                            foreach($staff as $record) {
                                if($record->utenti_id == $user->id) {
                                    ?>
                        <span class="label label-success"><?php echo $record->ruolo; ?></span>
                                    <?php
                                    if($record->referente) {
                                    ?>
                        <span class="label label-info">Referente</span>
                                    <?php
                                    }
                                    break;
                                }
                            }
                        ?>
                    </td>
                </tr>
        <?php } ?>
        </table>
        <?php } ?>
        </div>
    </div>
</div>

<div class="newLine"></div>

<?php if($userActions->canElevate() || $userActions->special_admin_redazione('DIRETTORE_REDAZIONE')) { ?>
<div class="span6 myGridContainer">
    <?php
        $month = GeneralViews::find_by_sql("SELECT sum(views) as total_views FROM general_views WHERE month = '".date('m')."' AND year = '".date('Y')."'");
        $week  = GeneralViews::find_by_sql("SELECT sum(views) as total_views FROM general_views WHERE ".thisWeekDaysWHERE());
        $day   = GeneralViews::find('first', array('conditions' => array('day = ? AND month = ? and year = ?', date('d'), date('m'), date('Y'))));
    ?>
    <div class="myGrid">
        <div class="myGridInside">
        <h4 class="myGridTitle"><i class="icon-user"></i> Statistiche visitatori <span class="pull-right"><a class="btn btn-mini btn-info" href="<?php echo $this->base_url; ?>stats.php?viewers"><i class="icon-file"></i></a></span></h4>
        <table class="table table-hover table-bordered">
            <tr>
                <td><strong>Questo mese:</strong></td>
                <td><?php echo ceil($month[0]->total_views); ?></td>
            </tr>
            <tr>
                <td><strong>Questa settimana:</strong></td>
                <td><?php echo ceil($week[0]->total_views); ?></td>
            </tr>
            <tr>
                <td><strong>Oggi:</strong></td>
                <td><?php echo !$day ? 0 : ceil($day->views); ?></td>
            </tr>
        </table>
        </div>
    </div>
</div>
<?php } ?>

<div class="span6 myGridContainer">
    <div class="myGrid">
        <div class="myGridInside">
        <h4 class="myGridTitle"><i class="icon-bell"></i> Notifiche <span class="label label-info pull-right"><?php echo $unseenNotificationsCount; ?></span></h4>
        <?php
            if($unseenNotificationsCount+$seenNotificationsCount == 0) echo 'Al momento non ci sono notifiche!';
            else {
            ?>
            <table class="table table-hover table-bordered">
                <tr>
                    <th>Titolo</th>
                    <th>Data</th>
                    <th></th>
                </tr>
                <?php
                $i = 0;
                foreach($unseenNotifications as $notification) {
                    $i++;
                    ?>
                <tr class="info">
                    <td><?php echo hfix($notification->titolo); ?></td>
                    <td><?php echo date('d-m-Y H:i:s', $notification->time); ?></td>
                    <td><a href="#" class="btn btn-mini btn-info" title="visualizza" onclick="$('#notificationID').val('<?php echo $notification->id; ?>'); $('#notificationTitle').html('<?php echo str_replace("'", "\'", hfix($notification->titolo)); ?>'); $('#notificationContent').html('<?php echo str_replace(array("\r\n", "'"), array('<br>', "\'"), hfix($notification->contenuto)); ?>'); $('#notificationModal').modal('toggle')"><i class="icon-zoom-in"></i></a> <a href="#" title="elimina" class="btn btn-mini btn-danger" onclick="$('#notificationDelete').modal('toggle'); $('#notificationDeleteID').val('<?php echo $notification->id; ?>'); $('#notificationDeleteContent').html('Eliminare la notifica \'<?php echo str_replace("'", "\'", hfix($notification->titolo)); ?>\'?');"><i class="icon-trash"></i></a></td>
                </tr>
                <?php
                    if($i > 10) goto endnotifications;
                }
                foreach($seenNotifications as $notification) {
                    $i++;?>
                <tr class="warning">
                    <td><?php echo hfix($notification->titolo); ?></td>
                    <td><?php echo date('d-m-Y H:i:s', $notification->time); ?></td>
                    <td><a href="#" class="btn btn-mini btn-info" title="visualizza" onclick="$('#notificationID').val('<?php echo $notification->id; ?>'); $('#setSeenButton').hide(); $('#notificationTitle').html('<?php echo str_replace("'", "\'", hfix($notification->titolo)); ?>'); $('#notificationContent').html('<?php echo str_replace(array("\r\n", "'"), array('<br>', "\'"), hfix($notification->contenuto)); ?>'); $('#notificationModal').modal('toggle')"><i class="icon-zoom-in"></i></a> <a href="#" title="elimina" class="btn btn-mini btn-danger" onclick="$('#notificationDelete').modal('toggle'); $('#notificationDeleteID').val('<?php echo $notification->id; ?>'); $('#notificationDeleteContent').html('Eliminare la notifica \'<?php echo str_replace("'", "\'", hfix($notification->titolo)); ?>\'?');"><i class="icon-trash"></i></a></td>
                </tr>
                <?php
                    if($i > 10) goto endnotifications;
                }
                endnotifications:
                ?>
            </table>
            <?php } ?>
        </div>
    </div>
</div>

<div class="span6 myGridContainer">
        <div class="myGrid">
                <div class="myGridInside">
                <h4 class="myGridTitle"><i class="icon-heart"></i> Compleanni <span class="label label-info pull-right"><?php echo count($compleanni); ?></span></h4>
                <?php if(count($compleanni) > 0) { ?>
                    <table class="table table-hover table-bordered">
                        <tr>
                            <th>Membro</th>
                            <th>Et&agrave;</th>
                        </tr>
                        <?php
                        foreach($compleanni as $compleanno) {
                                
                                $nome = $compleanno->nome." ".$compleanno->cognome;

                                if($nome == 'Alessandra Di Nardo'){
                                    $data = $compleanno->data_nascita;
                                    $data = substr($data,0,4);
                                 }else{
                                    $info_data = (array) $compleanno->data_nascita;
                                    $data = new DateTime($info_data['date']);
                                    $data = $data->format('Y');
                                }
                                $eta = date('Y') - (int)$data;
                            echo '<tr><td>'.hfix($nome).'</td><td>'.$eta.'</td></tr>'."\n";
                        }
                        ?>
                    </table>
                <?php } else echo "Non ci sono compleanni oggi."; ?>
        </div>
    </div>
</div>

<?php if($userActions->canElevate()) { ?>
<div class="newLine"></div>

<div class="span6 myGridContainer">
    <?php
        $month = GeneralListens::find_by_sql("SELECT sum(listeners) as total_listens FROM general_listens WHERE hour = '-1' AND month = '".date('m')."' AND year = '".date('Y')."'");
        $week  = GeneralListens::find_by_sql("SELECT sum(listeners) as total_listens FROM general_listens WHERE ".thisWeekDaysWHERE(1));
        $day   = GeneralListens::find('first', array('conditions' => array('hour = \'-1\' AND day = ? AND month = ? and year = ?', date('d'), date('m'), date('Y'))));
        $hour  = GeneralListens::find('first', array('conditions' => array('hour = ? AND day = ? AND month = ? and year = ?', date('H'), date('d'), date('m'), date('Y'))));
    ?>
    <div class="myGrid">
        <div class="myGridInside">
        <h4 class="myGridTitle"><i class="icon-headphones"></i> Statistiche ascoltatori <span class="pull-right"><a class="btn btn-mini btn-info" href="<?php echo $this->base_url; ?>stats.php?listeners"><i class="icon-file"></i></a></span></h4>
        <table class="table table-hover table-bordered">
            <tr>
                <td><strong>Questo mese:</strong></td>
                <td><?php echo ceil($month[0]->total_listens); ?></td>
            </tr>
            <tr>
                <td><strong>Questa settimana:</strong></td>
                <td><?php echo ceil($week[0]->total_listens); ?></td>
            </tr>
            <tr>
                <td><strong>Oggi:</strong></td>
                <td><?php echo !$day ? 0 : ceil($day->listeners); ?></td>
            </tr>
            <tr>
                <td><strong>Ultima Ora:</strong></td>
                <td><?php echo !$hour ? 0 : ceil($hour->listeners); ?></td>
            </tr>
        </table>
        </div>
    </div>
</div>
<?php } ?>

<div class="span6 myGridContainer">
    <div class="myGrid">
        <div class="myGridInside">
            <h4 class="myGridTitle"><i class="icon-star"></i> Decreto presidenziale - Peto libero</span></h4>
            Il decreto presidenziale 87 stabilisce che a partire da oggi 22 Settembre 2022 è formalmente consentito nei locali dell'associazione denominata POLI.RADIO il peto libero.
        </div>
    </div>
</div>

