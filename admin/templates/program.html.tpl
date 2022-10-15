<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Poli.Radio - Amministrazione</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <?php echo $css; ?>
    </head>
    <body>
<?php
$last = $programActions->getLastNotification();
if($last) {
?>
<div id="newNotificationModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3 id="myModalLabel">[Notifica]: <?php echo hfix($last->titolo); ?></h3>
  </div>
  <div class="modal-body">
    <?php echo str_replace("\r\n", "<br>", hfix($last->contenuto)); ?>
  </div>
  <div class="modal-footer">
    <button class="btn btn-primary" onclick="$.get('notifications.php?seen=<?php echo $last->id; ?>', function(data){ location.reload(); });">Segna come letta</button>
    <button class="btn" data-dismiss="modal" aria-hidden="true">Chiudi</button>
  </div>
</div>
<?php
}
?>
<div id="notificationModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3 id="notificationTitle"></h3>
  </div>
  <div class="modal-body" id="notificationContent">
  </div>
  <div class="modal-footer">
    <input type="hidden" id="notificationID">
    <button id="setSeenButton" class="btn btn-primary" onclick="$.get('notifications.php?seen='+$('#notificationID').val(), function(data){ location.reload(); });">Segna come letta</button>
    <button class="btn" data-dismiss="modal" aria-hidden="true">Chiudi</button>
  </div>
</div>

<div id="notificationDelete" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3>Elimina notifica</h3>
  </div>
  <div class="modal-body" id="notificationDeleteContent">
  </div>
  <div class="modal-footer">
    <input type="hidden" id="notificationDeleteID">
    <button class="btn btn-danger" onclick="$.get('notifications.php?delete='+$('#notificationDeleteID').val(), function(data){ if(data != '') { $('#notificationDeleteContent').html(data); } else { location.reload(); } });">Elimina</button>
    <button class="btn" data-dismiss="modal" aria-hidden="true">Chiudi</button>
  </div>
</div>
<?php
$unseenNotificationsCount = $programActions->countUnseenNotifications();
?>
        <div class="container" style="position: relative; top: 20px;">
            <div class="navbar">
                <?php if(!$programActions->isUserLoggedForRedaction()) { ?>
                <div class="navbar-inner">
                    <a class="brand" href="#"><img src="<?php echo $this->base_url; ?>img/logo.svg"></a>
                    <ul class="nav">
                        <?php if(!isset($active)) $active = 'home'; ?>
                        <li<?php echo ($active == 'home') ? ' class="active"' : ''; ?>><a href="<?php echo $this->base_url; ?>">Home</a></li>
                        <li<?php echo ($active == 'news') ? ' class="active"' : ''; ?>><a href="<?php echo $this->base_url; ?>news.php">News</a></li>
                        <li<?php echo ($active == 'podcast') ? ' class="active"' : ''; ?>><a href="<?php echo $this->base_url; ?>podcast.php">Podcast</a></li>
                        <li<?php echo ($active == 'notifications') ? ' class="active"' : ''; ?>><a href="<?php echo $this->base_url; ?>notifications.php">Notifiche<?php echo $unseenNotificationsCount > 0 ? ' <span class="label label-info">'.$unseenNotificationsCount.'</span>' : ''; ?></a></li>
                    </ul>
                    <ul class="nav pull-right">
                        <li class="dropdown<?php echo ($active == 'profile') ? ' active' : ''; ?>">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="icon-user"></i> <?php echo hfix($program->nome).($program->id == 44 ? ' (SALUTE)' : ''); ?><b class="caret"></b></a>
                            <ul class="dropdown-menu">
                                <li><a href="<?php echo $this->base_url; ?>programs.php">Profilo Programma</a></li>
                                <li><a href="<?php echo $this->base_url; ?>programs.php?s">Staff Programma</a></li>
                                <li class="divider"></li>
                                <li><a href="<?php echo $this->base_url; ?>programs.php?m">Modifica Profilo</a></li>
                                <li class="divider"></li>
                                <li><a href="<?php echo $this->base_url; ?>programlogin.php?logout"><?php $currentUser = $userActions->getCurrentUser(); echo hfix($currentUser->nome." ".$currentUser->cognome); ?></a></li>
                                <li><a href="<?php echo $this->base_url; ?>logout">Logout</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
                <?php } else { ?>
                <div class="navbar-inner">
                    <a class="brand" href="<?php echo $this->base_url; ?>"><img src="<?php echo $this->base_url; ?>img/logo.svg"></a>
                    <ul class="nav">
                        <?php /*
                        <li<?php echo ($active == 'users') ? ' class="active"' : ''; ?>><a href="<?php echo $this->base_url; ?>users.php">Membri</a></li>
                        <li<?php echo ($active == 'programs') ? ' class="active"' : ''; ?>><a href="<?php echo $this->base_url; ?>programs.php">Programmi</a></li>
                        */ ?>
                        <?php if($userActions->isUserElevated()) {
                        $membriAttivi     = Utenti::count(array('conditions' => 'attivo = 2'));
                            $membriAttivare1  = Utenti::count(array('conditions' => 'attivo = 0'));
                        $membriAttivare2  = Utenti::count(array('conditions' => 'attivo = 1'));
                        $membriNonAttivi  = Utenti::count(array('conditions' => 'attivo = -1'));
                            $membriTotali     = Utenti::count();
                        ?>
                        <li class="dropdown<?php echo ($active == 'users') ? ' active' : ''; ?>">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Membri<?php echo $membriAttivare2 > 0 ? ' <span class="label label-info">'.$membriAttivare2.'</span>' : ''; ?><b class="caret"></b></a>
                            <ul class="dropdown-menu">
                                <li><a href="<?php echo $this->base_url; ?>users.php?list=1">Membri Attivi [<?php echo $membriAttivi; ?>]</a></li>
                                <li><a href="<?php echo $this->base_url; ?>users.php?list=2">Membri da attivate (step 1) [<?php echo $membriAttivare1; ?>]</a></li>
                                <li><a href="<?php echo $this->base_url; ?>users.php?list=3">Membri da attivare (step 2) [<?php echo $membriAttivare2; ?>]</a></li>
                                <li><a href="<?php echo $this->base_url; ?>users.php?list=4">Membri Non Attivi [<?php echo $membriNonAttivi; ?>]</a></li>
                                <li><a href="<?php echo $this->base_url; ?>users.php?list=0">Membri Totali [<?php echo $membriTotali; ?>]</a></li>
                                <li class="divider"></li>
                                <li><a href="<?php echo $this->base_url; ?>users.php">Tutte le Statistiche Membri</a></li>
                            </ul>
                        </li>
                        <?php } else { ?>
                        <li<?php echo ($active == 'users') ? ' class="active"' : ''; ?>><a href="<?php echo $this->base_url; ?>users.php">Membri</a></li>
                        <?php } ?>
                        <?php try {
                            $userActions->onlyDirettivo();
                        ?>
                        <li class="dropdown<?php echo ($active == 'notifications') ? ' active' : ''; ?>">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Notifiche<?php echo $unseenNotificationsCount > 0 ? ' <span class="label label-info">'.$unseenNotificationsCount.'</span>' : ''; ?><b class="caret"></b></a>
                            <ul class="dropdown-menu">
                                <li><a href="<?php echo $this->base_url; ?>notifications.php">Notifiche Ricevute</a></li>
                                <li class="divider"></li>
                                <li><a href="<?php echo $this->base_url; ?>notifications.php?send">Invia Notifica</a></li>
                                <li><a href="<?php echo $this->base_url; ?>notifications.php?sent">Notifiche inviate</a></li>
                                
                            </ul>
                        </li>
                        <?php } catch(Exception $e) { ?>
                        <li<?php echo ($active == 'notifications') ? ' class="active"' : ''; ?>><a href="<?php echo $this->base_url; ?>notifications.php">Notifiche<?php echo $unseenNotificationsCount > 0 ? ' <span class="label label-info">'.$unseenNotificationsCount.'</span>' : ''; ?></a></li>
                        <?php } ?>
                        <?php if($userActions->isUserElevated()) { 
                            $programmiTotali = Programmi::count();
                        ?>
                        <li class="dropdown<?php echo ($active == 'programs') ? ' active' : ''; ?>">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Programmi<b class="caret"></b></a>
                            <ul class="dropdown-menu">
                                <li><a href="<?php echo $this->base_url; ?>programs.php?list=0">Programmi Totali [<?php echo $programmiTotali; ?>]</a></li>
                                <li class="divider"></li>
                                <li><a href="<?php echo $this->base_url; ?>programs.php">Tutte le Statistiche Programmi</a></li>
                            </ul>
                        </li>
                        <?php } else { ?>
                        <li<?php echo ($active == 'programs') ? ' class="active"' : ''; ?>><a href="<?php echo $this->base_url; ?>programs.php">Programmi</a></li>
                        <?php } ?>
                        <li class="dropdown<?php echo ($active == 'redazione') ? ' active' : ''; ?>">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Redazione <b class="caret"></b></a>
                            <ul class="dropdown-menu">
                                <li><a href="<?php echo $this->base_url; ?>news.php">News Redazione</a></li>
                                <li><a href="<?php echo $this->base_url; ?>podcast.php">Podcast Redazione</a></li>
                                <?php if($userActions->isUserElevated() || $userActions->special_admin_redazione('DIRETTORE_REDAZIONE')) { ?>
                                <li class="divider"></li>
                                <li><a href="<?php echo $this->base_url; ?>newsAdmin.php">Lista Globale News</a></li>
                                <li><a href="<?php echo $this->base_url; ?>podcastAdmin.php">Lista Globale Podcast</a></li>
                                <?php } ?>
                            </ul>
                        </li>
                        <li<?php echo ($active == 'palinsesto') ? ' class="active"' : ''; ?>><a href="<?php echo $this->base_url; ?>palinsesto.php">Palinsesto</a></li>


                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Servizi<b class="caret"></b></a>
                            <ul class="dropdown-menu">
                                <!--<li><a href="<?php echo $this->base_url;?>oauth/doLogin.php" target="_BLANK">Home</a></li>
                                <li class="divider"></li>-->
                                <li><a href="<?php echo $this->base_url;?>oauth/doLogin.php?page=msg" target="_BLANK">Messaggi</a></li>
                                <li><a href="<?php echo $this->base_url;?>oauth/doLogin.php?page=logs" target="_BLANK">Registrazioni Diretta</a></li>
                                <li><a href="<?php echo $this->base_url;?>oauth/doLogin.php?page=condivisa" target="_BLANK">Condivisa</a></li>
                                <li><a href="<?php echo $this->base_url;?>oauth/doLogin.php?page=cart" target="_BLANK">Catalogo Musicale</a></li>
                                <li class="divider"></li>
                                <li><a href="<?php echo $this->base_url;?>calendario" target="_BLANK">Calendario</a></li>
                                <li><a href="https://forms.office.com/r/U8gM8LzE3n" target="_BLANK">Form Richiesta Accrediti</a></li>
                                <li><a href="#telegramDownload" data-toggle="modal">Upload Condivisa da Telegram</a></li>
                                <li><a href="<?php echo $this->base_url;?>oauth/doLogin.php?page=status" target="_BLANK">Status Servizi</a></li>
                                <!-- <li><a href="<?php echo $this->base_url;?>oauth/doLogin.php?page=old" target="_BLANK">Vecchio Sito</a></li> -->
                                <!-- <li><a href="https://poliradio-my.sharepoint.com/:f:/g/personal/smartphone_poliradio_it/EgG66Q1BEtNNtbM3tTjciYYBVa7R-f62PsevL11__hGMsw?e=7tIKca" target="_BLANK">File Smartphone</a></li>-->
                                <li class="divider"></li>
                                <li><a href="https://poliradio-my.sharepoint.com/:f:/g/personal/stationmanager_poliradio_it/Evz51jRct8NEgcHk-_lQpQkBecZBZXI2B1S2NNtASDIigQ?e=nvQoJW" target="_BLANK">Documenti Ufficiali</a></li>
                                <!--
                                <li><a href="https://poliradio-my.sharepoint.com/:f:/g/personal/stationmanager_poliradio_it/EmfuxrWGRDxHu5efvl3H_9UBW8m70GpS7g9g3l5zXXaC6Q?e=XjV8p3" target="_BLANK">Verbali Riunioni Direttivo</a></li>
                                <li><a href="https://poliradio-my.sharepoint.com/:f:/g/personal/stationmanager_poliradio_it/Ep080PeVCeZBly2fDLBQX58BfcggYOCk4c6i_Cg_7KJcLQ?e=26V0k1" target="_BLANK">Verbali Riunioni Staff</a></li>
                                <li><a href="https://poliradio-my.sharepoint.com/:f:/g/personal/stationmanager_poliradio_it/Ekw_HnMt3zlFolcstOnIiDwBrInBTMdn0CuLCDkAXigGnQ?e=hOubvS" target="_BLANK">Documenti POLI.RADIO</a></li>
                                -->
                                <li class="divider"></li>
                                <li><a href="<?php echo $this->base_url;?>oauth/doLogin.php?page=old" target="_BLANK">Vecchio Sito</a></li>
                                <li><a href="https://poliradio-my.sharepoint.com/:f:/g/personal/smartphone_poliradio_it/EgG66Q1BEtNNtbM3tTjciYYBVa7R-f62PsevL11__hGMsw?e=7tIKca" target="_BLANK">File Smartphone</a></li>
                            </ul>
                        </li>

                        <?php if($userActions->isUserAbleTo('DIRETTIVO')){ ?>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Admin<b class="caret"></b></a>
                            <ul class="dropdown-menu">
                                <li><a href="linkindex.php">Link Index</a></li>
                                <li><a href="noticeSpeaker.php">Avvisi Diretta</a></li>
                                <li><a href="#rigenPalinsestoIG" data-toggle="modal">Rigenera PalinsestoIG</a></li>
                                <li class="divider"></li>
                                <?php if($userActions->getCurrentUser()->administrator && $userActions->isUserElevated()) { ?>
                                <li><a href="<?php echo $this->base_url;?>livefeed" target="_BLANK">Webcam</a></li>
                                <?php } ?>
                                <li class="divider"></li>
                                <?php if($userActions->getCurrentUser()->administrator && $userActions->isUserElevated()) { ?>
                                <li><a href="#resetQuota" data-toggle="modal">Azzera Quote Associative</a></li>
                                <li><a href="#resetFirma" data-toggle="modal">Azzera Firma Liberatoria</a></li>
                                <?php } ?>
                                <!-- <li><a href="https://poliradio-my.sharepoint.com/:x:/g/personal/redazione_poliradio_it/Eatwo34fZLhEmb_i0XxlKjoB7U3-MCTlCHlz5Lp-ckPQVw?e=cXMddH" target="_BLANK">Lista Accrediti</a></li> -->
                                <!-- <li><a href="https://poliradio-my.sharepoint.com/:f:/g/personal/smartphone_poliradio_it/Ej_LCi1fcD9HjXlvMjiiDzcB8h2F_tChljlyuAMtj_Q8GQ?e=BudZJd" target="_BLANK">File Smartphone</a></li>-->
                            </ul>
                        </li>
                        <?php } ?>
                    </ul>
                    <ul class="nav pull-right">
                        <li class="dropdown<?php echo ($active == 'profile') ? ' active' : ''; ?>">
                            <?php /*<a href="#" class="dropdown-toggle" data-toggle="dropdown"><?php if($userActions->isUserElevated()) echo '<font color="red">'; ?><i class="icon-user"></i> <?php $currentUser = $userActions->getCurrentUser(); echo hfix($currentUser->nome." ".$currentUser->cognome); if($userActions->isUserElevated()) echo ' <i class="icon-star"></i></font>'; ?><b class="caret"></b></a>*/?>
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="icon-user"></i> <?php $currentUser = $userActions->getCurrentUser(); echo hfix($currentUser->nome); ?><b class="caret"></b></a>
                            <ul class="dropdown-menu">
                                <li><a href="<?php echo $this->base_url; ?>profilo/foto">Modifica Foto</a></li>
                                <li><a href="<?php echo $this->base_url; ?>profilo/profilo">Modifica Profilo</a></li>
                                <li><a href="<?php echo $this->base_url; ?>profilo/password">Modifica Password</a></li>

                                <li class="divider"></li>
                                <?php
                                $programmi = $currentUser->programmi;
                                if(count($programmi) > 0) {
                                ?>
                                <li class="dropdown-submenu">
                                    <a tabindex="-1" href="#">Programma</a>
                                    <ul class="dropdown-menu">
                                        <?php foreach($programmi as $programma) { ?>
                                        <li><a href="<?php echo $this->base_url; ?>programlogin.php?id=<?php echo $programma->id; ?>"><?php echo hfix($programma->nome); ?></a></li>
                                        <?php } ?>
                                    </ul>
                                </li>
                                <li class="divider"></li>
                                <?php } ?>
                                <?php /*if(!$userActions->isUserElevated() && $userActions->canElevate()) { ?><li><a href="<?php echo $this->base_url; ?>advanced.php"><i class="icon-lock"></i> Abilita Funzioni Avanzate</a></li><?php } ?>
                                <?php if($userActions->isUserElevated()) { ?><li><a href="<?php echo $this->base_url; ?>advanced.php?disable"><i class="icon-lock"></i> Disabilita Funzioni Avanzate</a></li><?php } */?>
                                <li><a href="<?php echo $this->base_url; ?>logout">Logout</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
                <?php } ?>
            </div>
        </div>
        <div class="container">
            <div class="row">
                <?php if(!isset($noDefaultStyle)) { ?>
                <div class="span12 widget">
                    <div class="widget-container">
                    <?php if(isset($error_message) || isset($success_message)) { ?>
                    <div class="alert <?php echo isset($error_message) ? 'alert-error' : 'alert-success'; ?>">
                        <button type="button" class="close" data-dismiss="alert">&times;</button>
                        <?php echo isset($error_message) ? $error_message : $success_message; ?>
                    </div>
                    <?php } ?>
                    <?php eval($sub); ?>
                    </div>
                </div>
                <br>&nbsp;
                <?php } else {
                    eval($sub);
                } ?>
            </div>
        </div>
        <?php echo $js; ?>
        <?php if(isset($tinymce)) { ?>
        <script type="text/javascript" src="<?php echo $this->base_url; ?>/tinymce/tinymce.min.js"></script>
        <script type="text/javascript">
        tinymce.init({
            selector: "textarea",
            plugins: [
                "bbcode autolink lists link charmap preview searchreplace visualblocks contextmenu paste"
            ],
            menubar: '',
            paste_as_text: true,
            language: 'it',
            toolbar_items_size : 'small',
            forced_root_block: false,
            force_p_newlines: false,
            remove_linebreaks: false,
            force_br_newlines: true, // check
            remove_trailing_nbsp: false,   
            verify_html: false,
            width: 700,
            toolbar: "undo redo | cut copy paste searchreplace | bold italic underline strikethrough | subscript superscript | removeformat | link "
        });
        </script>
        <?php } ?>
        <?php if($last) {?>
        <script type="text/javascript">
            $('#newNotificationModal').modal('toggle');
        </script>
        <?php } ?>
        <?php if(date('d-m') == '01-04') { ?><script type="text/javascript">document.getElementsByTagName("BODY")[0].style.opacity = 0.25;</script><?php } ?>
    </body>
</html>
