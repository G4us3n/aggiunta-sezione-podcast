<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>POLI.RADIO - Amministrazione</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <?php echo $css; ?>
    </head>
    <body>
<?php
$last = $userActions->getLastNotification();
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
<div id="telegramDownload" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3>Come caricare file su Condivisa da telegram</h3>
  </div>
  <div class="modal-body">
    <ol>
        <li>Inoltra i file che vuoi caricare in condivisa a <a href="https://t.me/poliradiodownloadbot" target="_blank">@poliradiodownloadbot</a></li>
        <li>Troverai tutti i file inviati in <i>Condivisa/_telegram_downloads/{TUO USERNAME TELEGRAM}</i></li>
    </ol>
    <br>
    <h5>NB: per poter caricare i file tramite telegram, assicurati di aver impostato il tuo username di telegram dentro membri!</h5>
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">Chiudi</button>
  </div>
</div>

<div id="rigenPalinsestoIG" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
      <h3>Rigenera Storia Palinsesto Instagram</h3>
    </div>
    <div class="modal-body">
      Sei sicuro di voler rigenerare la storia del Palinsesto?
    </div>
    <div class="modal-footer">
      <button class="btn btn-danger" onclick="$.get('users.php?rigenera'); $('#rigenPalinsestoIG').modal('hide');">Si</button>
      <button class="btn" data-dismiss="modal" aria-hidden="true">No</button>
    </div>
</div>


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
    <button class="btn btn-danger" onclick="$.get('notifications.php?<?php if(isset($forceDelete)) echo 'force'; ?>delete='+$('#notificationDeleteID').val(), function(data){ if(data != '') { $('#notificationDeleteContent').html(data); } else { location.reload(); } });">Elimina</button>
    <button class="btn" data-dismiss="modal" aria-hidden="true">Chiudi</button>
  </div>
</div>

<div id="resetQuota" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3>Reset Quote Associative</h3>
  </div>
  <div class="modal-body">
    Sei sicuro di voler resettare le quote associative?
  </div>
  <div class="modal-footer">
    <button class="btn btn-danger" onclick="$.get('users.php?resetquote'); $('#resetQuota').modal('hide');">Si</button>
    <button class="btn" data-dismiss="modal" aria-hidden="true">No</button>
  </div>
</div>

<div id="resetFirma" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3>Reset Firma Liberatoria</h3>
  </div>
  <div class="modal-body">
    Sei sicuro di voler resettare le firme delle liberatorie?
  </div>
  <div class="modal-footer">
    <button class="btn btn-danger" onclick="$.get('users.php?resetfirma'); $('#resetFirma').modal('hide');">Si</button>
    <button class="btn" data-dismiss="modal" aria-hidden="true">No</button>
  </div>
</div>

<?php
$unseenNotificationsCount = $userActions->countUnseenNotifications();
?>
        <div class="container" style="position: relative; top: 20px;">
            <div class="navbar">
                <div class="navbar-inner">
                    <?php /* <a class="brand" href="#"><img src="<?php echo $this->base_url; ?>img/logo.svg"></a> */ ?>
                    <a class="brand" href="<?php echo $this->base_url; ?>"><img src="<?php echo $this->base_url; ?>img/logo.svg"></a>
                    <ul class="nav">
                        <?php if(!isset($active)) $active = 'home'; ?>
                        <!-- <li<?php echo ($active == 'home') ? ' class="active"' : ''; ?>><a href="<?php echo $this->base_url; ?>">Home</a></li> -->
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
                                <li class="divider"></li>
                                <li><a href="<?php echo $this->base_url; ?>notifications.php?sentall">Tutte le notifiche inviate</a></li>
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
                        <?php global $programActions; if($programActions->isUserLoggedForRedaction()) { ?>
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
                        <?php } ?>
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
                                <li><a href="https://poliradio.sharepoint.com/:f:/s/direttivo/ElFFKJNJI8lAtsUI3XIZWEYBax-IgW5QAjwmSDZNcKrEsA?e=93rLqm" target="_BLANK">Documenti Ufficiali</a></li>
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



                <?php /*
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown"><font color="red"><b>Elezioni</b></font><b class="caret"></b></a>
                    <ul class="dropdown-menu">
                        <li><a href="https://poliradio-my.sharepoint.com/:x:/g/personal/elezioni_poliradio_it/Eas38EPxOitFvwhge_NMHHABGLVJ5Cj_O-X2hR9vodoFKQ?e=eCbLs1" target="_BLANK">Lista candidati</a></li>
                        <li><a href="https://poliradio-my.sharepoint.com/:x:/g/personal/elezioni_poliradio_it/EXPWfoR30LdBlVIa8bcFisUBFTKDSVhPSv_adpoh2dJfYw?e=RQg33I" target="_BLANK">Lista deleghe</a></li>
                        <li class="divider"></li>
                        <li><a href="#"><b>Termine candidature:</b> 15/10/2018 alle 23.59</a></li>
                        <li><a href="#"><b>Termine deleghe:</b> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 16/10/2018 alle 16.59</a></li>
                    </ul>
                </li>
                */ ?>

            </ul>
                    <ul class="nav pull-right">
                        <li class="dropdown<?php echo ($active == 'profile') ? ' active' : ''; ?>">
                            <?php /*<a href="#" class="dropdown-toggle" data-toggle="dropdown"><?php if($userActions->isUserElevated()) echo '<font color="red">'; ?><i class="icon-user"></i> <?php $currentUser = $userActions->getCurrentUser(); echo hfix($currentUser->nome." ".$currentUser->cognome); if($userActions->isUserElevated()) echo ' <i class="icon-star"></i></font>'; ?> <b class="caret"></b></a>*/ ?>
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="icon-user"></i> <?php $currentUser = $userActions->getCurrentUser(); echo hfix($currentUser->nome); ?><b class="caret"></b></a>
                            <?php /*<a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="icon-user"></i> <b class="caret"></b></a>*/ ?>
                            <ul class="dropdown-menu">
                                <?php $currentUser = $userActions->getCurrentUser(); ?>
                                <li><a href="#"><b><?php echo hfix($currentUser->nome); ?> <?php echo hfix($currentUser->cognome); ?></b></a></li>
                                <li class="divider"></li>
                                <li><a href="<?php echo $this->base_url; ?>profilo/foto">Modifica Foto</a></li>
                                <?php /*<li><a href="<?php echo $this->base_url; ?>profilo/email">Modifica Email</a></li>*/ ?>
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
                                <?php /* maiux 04/10/2018; two-step impractical
                                <?php if(!$userActions->isUserElevated() && $userActions->canElevate()) { ?><li><a href="<?php echo $this->base_url; ?>advanced.php"><i class="icon-lock"></i> Abilita Funzioni Avanzate</a></li><?php } ?>
                                <?php if($userActions->isUserElevated()) { ?><li><a href="<?php echo $this->base_url; ?>advanced.php?disable"><i class="icon-lock"></i> Disabilita Funzioni Avanzate</a></li><?php } ?>
                                <?php */ ?>
                                <?php /* if($userActions->isUserAbleTo('DIRETTIVO')) { */ ?>
                                <?php if($userActions->canAccessOTP()) { ?>
                                <li><a href="<?php echo $this->base_url;?>otp.php"><i class="icon-time"></i> OTP</a></li>
                                <li class="divider"></li>
                                <?php } ?>
                                <li><a href="<?php echo $this->base_url; ?>logout">Logout</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="container">
            <div class="row">
                <?php if(isset($error_message) || isset($success_message)) { ?>
                <div class="span12">
                    <br>
                    <div class="alert <?php echo isset($error_message) ? 'alert-error' : 'alert-success'; ?>">
                        <button type="button" class="close" data-dismiss="alert">&times;</button>
                        <?php echo isset($error_message) ? $error_message : $success_message; ?>
                    </div>
                </div>
                <?php } ?>
                <?php if(!isset($noDefaultStyle)) { ?>
                <div class="span12 widget">
                    <div class="widget-container">
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
        <?php if($last) {?>
        <script type="text/javascript">
            $('#newNotificationModal').modal('toggle');
        </script>
        <?php } ?>
        <?php if(date('d-m') == '01-04') { ?><script type="text/javascript">document.getElementsByTagName("BODY")[0].style.opacity = 0.25;</script><?php } ?>
    </body>
</html>
<!--
Portale membri sviluppato da Andrea Maioli
Sito web poliradio sviuluppato da Pietro Avolio
-->
