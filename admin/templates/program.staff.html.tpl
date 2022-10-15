<ul class="breadcrumb">
	<li><a href="<?php echo $this->base_url; ?>">Home</a> <span class="divider">/</span></li>
	<li><a href="<?php echo $this->base_url; ?>programs.php"><?php echo hfix($program->nome); ?></a> <span class="divider">/</span></li>
	<li class="active">Membri</li>
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
			<th>Cognome</th>
			<th>Nome</th>
			<th>Email</th>
			<th>Telefono</th>
			<th>Telegram</th>
			<th>Posizione</th>
			<th>Referente</th>
		</tr>
	</thead>
	<tbody>
		<?php
		$staff = $program->programmi_utenti;
		foreach($staff as $record) {
			$user = $record->utenti;
		?>
		<tr<?php if($record->referente) echo ' class="info"'; ?>>
			<td><a href="<?php echo $this->base_url.'users.php?list=0&u='.$user->id; ?>" target="_blank"><?php echo hfix($user->cognome); ?></a></td>
			<td><a href="<?php echo $this->base_url.'users.php?list=0&u='.$user->id; ?>" target="_blank"><?php echo hfix($user->nome); ?></a></td>
			<td><a href="mailto:<?php echo hfix($user->email); ?>"><?php echo hfix($user->email); ?></a></td>
			<td><?php echo $user->telefono; ?></td>
			<td><?php echo strlen($user->telegram) > 0 ? '<a href="https://t.me/'.hfix($user->telegram).'" target="_BLANK">@'.hfix($user->telegram).'</a>' : ''; ?></td>
			<td><?php echo $roles[$record->ruolo]; ?></td>
			<td><?php echo $record->referente ? 'Si' : 'No'; ?></td>
		</tr>
		<?php } ?>
	</tbody>
</table>

