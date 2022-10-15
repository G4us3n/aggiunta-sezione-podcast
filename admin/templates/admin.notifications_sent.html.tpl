<ul class="breadcrumb">
    <li><a href="<?php echo $this->base_url; ?>">Home</a> <span class="divider">/</span></li>
    <li class="active">Notifiche Inviate</li>
</ul>
<?php if(isset($error)) { ?>
<div class="alert alert-danger">
    <button type="button" class="close" data-dismiss="alert">&times;</button>
    <?php echo $error; ?>
</div>
<?php } ?>
<?php if(isset($success)) { ?>
<div class="alert alert-success">
    <button type="button" class="close" data-dismiss="alert">&times;</button>
    <?php echo $success; ?>
</div>
<?php } ?>

<div id="receiversModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3 id="notificationTitle">Destinatari della notifica</h3>
  </div>
  <div class="modal-body" id="receiversBody">
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">Chiudi</button>
  </div>
</div>

<table class="table table-hover table-striped">
    <thead>
        <tr>
            <th>Titolo</th>
            <th>Data</th>
            <?php if(isset($sentall)) { ?>
            <th>Mittente</th>
            <?php } ?>
            <th>Destinatari</th>
            <th>Azioni</th>
        </tr>
    </thead>
    <tbody>
        <?php foreach($notifications as $notification) {
            $dest = json_decode($notification->receivers, true);
        ?>
        <tr>
            <td><?php echo hfix($notification->titolo); ?></td>
            <td><?php echo date('d-m-Y H:i:s', $notification->time); ?></td>
            <?php if(isset($sentall)) {
                $mittente = Utenti::find($notification->senderid);
            ?>
            <td><a href="<?php echo $this->base_url; ?>users.php?list=1&u=<?php echo $notification->senderid; ?>" target="_blank"><?php echo hfix($mittente->nome." ".$mittente->cognome); ?></a></td>
            <?php } ?>
            <td><a href="#" onclick="$('#receiversBody').html('<?php foreach($dest as $d) echo hfix($d)."<br>"; ?>'); $('#receiversModal').modal('toggle');"><?php echo count($dest); ?></a></td>
            <td><a href="#" class="btn btn-mini btn-info" title="visualizza" onclick="$('#notificationID').val('<?php echo $notification->id; ?>'); $('#setSeenButton').hide(); $('#notificationTitle').html('<?php echo str_replace("'", "\'", hfix($notification->titolo)); ?>'); $('#notificationContent').html('<?php echo str_replace(array("\r\n", "'"), array('<br>', "\'"), hfix($notification->contenuto)); ?>'); $('#notificationModal').modal('toggle')"><i class="icon-zoom-in"></i></a> 
            <a href="#" title="elimina" class="btn btn-mini btn-danger" onclick="$('#notificationDelete').modal('toggle'); $('#notificationDeleteID').val('<?php echo $notification->id; ?>'); $('#notificationDeleteContent').html('Eliminare dalla cartella dei destinatari tutte le notifiche \'<?php echo str_replace(array("\r\n", "'"), array('<br>', "\'"), hfix($notification->titolo)); ?>\'?');"><i class="icon-trash"></i></a></td>
        </tr>
        <?php } ?>
    </tbody>
</table>
