<ul class="breadcrumb">
	<li><a href="<?php echo $this->base_url; ?>">Home</a> <span class="divider">/</span></li>
	<li class="active">Notifiche</li>
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
<table class="table table-hover table-striped">
	<thead>
		<tr>
			<th>Titolo</th>
			<th>Data</th>
			<th>Azioni</th>
		</tr>
	</thead>
	<tbody>
		<?php foreach($notifications as $notification) { ?>
		<tr class="<?php echo $notification->seen ? 'warning' : 'info'; ?>">
			<td><?php echo hfix($notification->titolo); ?></td>
			<td><?php echo date('d-m-Y H:i:s', $notification->time); ?></td>
			<td><a href="#" class="btn btn-mini btn-info" title="visualizza" onclick="$('#notificationID').val('<?php echo $notification->id; ?>'); <?php if($notification->seen) echo "$('#setSeenButton').hide();" ?> $('#notificationTitle').html('<?php echo str_replace("'", "\'", hfix($notification->titolo)); ?>'); $('#notificationContent').html('<?php echo str_replace(array("\r\n", "'"), array('<br>', "\'"), hfix($notification->contenuto)); ?>'); $('#notificationModal').modal('toggle')"><i class="icon-zoom-in"></i></a> 
			<a href="#" title="elimina" class="btn btn-mini btn-danger" onclick="$('#notificationDelete').modal('toggle'); $('#notificationDeleteID').val('<?php echo $notification->id; ?>'); $('#notificationDeleteContent').html('Eliminare la notifica \'<?php echo str_replace("'", "\'", hfix($notification->titolo)); ?>\'?');"><i class="icon-trash"></i></a></td>
		</tr>
		<?php } ?>
	</tbody>
</table>