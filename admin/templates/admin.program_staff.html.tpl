<ul class="breadcrumb">
	<li><a href="<?php echo $this->base_url; ?>">Home</a> <span class="divider">/</span></li>
	<?php if($isDirettivo) { ?><li><a href="<?php echo $this->base_url; ?>programs.php">Statistiche Programmi</a> <span class="divider">/</span></li><?php } ?>
	<li><a href="<?php echo $this->base_url; ?>programs.php?list=<?php echo $list; ?>"><?php echo $activePage; ?></a> <span class="divider">/</span></li>
	<li><a href="<?php echo $this->base_url; ?>programs.php?list=<?php echo $list; ?>&p=<?php echo $program->id; ?>"><?php echo hfix($program->nome); ?></a> <span class="divider">/</span></li>
	<li class="active">Membri</li>
	<?php if($isDirettoreProgrammi) { ?>
	<li class="pull-right"><a href="#modalAddMember" data-toggle="modal" class="btn btn-warning btn-mini"><i class="icon-music"></i> Aggiungi membro</a></li>
	<?php } ?>
</ul>

<?php if($isDirettoreProgrammi) { ?>
<form method="post">
	<div class="modal hide fade" id="modalAddMember">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			<h3>Aggiungi Membro</h3>
		</div>
		<div class="modal-body form-horizontal">
			<div class="control-group">
				<label class="control-label" for="inputMembro"><strong>Membro:</strong></label>
				<div class="controls">
					<select name="userid" id="inputMembro">
						<?php foreach($notStaff as $singleUser) { ?>
						<option value="<?php echo $singleUser->id; ?>"><?php echo hfix($singleUser->cognome." ".$singleUser->nome); ?></option>
						<?php } ?>
					</select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputRuolo"><strong>Ruolo:</strong></label>
				<div class="controls">
					<select name="ruolo" id="inputRuolo">
						<?php foreach($roles as $roleValue => $roleName) { ?>
						<option value="<?php echo $roleValue; ?>"><?php echo $roleName; ?></option>
						<?php } ?>
					</select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputReferente"><strong>Referente:</strong></label>
				<div class="controls">
					<label class="radio">
						<input type="radio" name="referente" id="inputReferente" value="0" checked>
						No
					</label>
					<label class="radio">
						<input type="radio" name="referente" id="inputReferente" value="1">
						Si
					</label>
				</div>
			</div>
		</div>
		<div class="modal-footer">
			<a href="#" data-dismiss="modal" class="btn">Annulla</a>
			<button type="submit" class="btn btn-success"><i class="icon-user"></i>Aggiungi</button>
		</div>
	</div>
</form>

<form method="post">
	<input type="hidden" name="memberid" id="memberid">
	<div class="modal hide fade" id="modalRemoveMember">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			<h3>Rimuovi Membro</h3>
		</div>
		<div class="modal-body" id="member_remove_text">			
		</div>
		<div class="modal-footer">
			<a href="#" data-dismiss="modal" class="btn">Annulla</a>
			<button type="submit" class="btn btn-danger"><i class="icon-trash"></i>Rimuovi</button>
		</div>
	</div>
</form>

<form method="post">
	<div class="modal hide fade" id="modalEditMember">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			<h3>Modifica Membro</h3>
		</div>
		<div class="modal-body form-horizontal">
			<div class="control-group">
				<label class="control-label" for="selectUser"><strong>Membro:</strong></label>
				<div class="controls">
					<input type="hidden" name="useridedit" id="useridedit">
					<select id="selectUser" disabled>
					</select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputRuoloEdit"><strong>Ruolo:</strong></label>
				<div class="controls">
					<select name="ruolo" id="inputRuoloEdit">
						<?php foreach($roles as $roleValue => $roleName) { ?>
						<option value="<?php echo $roleValue; ?>"><?php echo $roleName; ?></option>
						<?php } ?>
					</select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputReferenteEdit0"><strong>Referente:</strong></label>
				<div class="controls">
					<label class="radio">
						<input type="radio" name="referente" id="inputReferenteEdit0" value="0">
						No
					</label>
					<label class="radio">
						<input type="radio" name="referente" id="inputReferenteEdit1" value="1">
						Si
					</label>
				</div>
			</div>
		</div>
		<div class="modal-footer">
			<a href="#" data-dismiss="modal" class="btn">Annulla</a>
			<button type="submit" class="btn btn-warning"><i class="icon-edit"></i> Modifica</button>
		</div>
	</div>
</form>
<?php } ?>

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
			<!--<th>Email</th>-->
			<th>Telefono</th>
			<th>Telegram</th>
			<th>Posizione</th>
			<th>Referente</th>
			<?php if($isDirettoreProgrammi) { ?><th>Visibile</th><th>Azioni</th><?php } ?>
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
			<!--<td><a href="mailto:<?php echo hfix($user->email); ?>"><?php echo hfix($user->email); ?></a></td>-->
			<td><?php echo $user->telefono; ?></td>
			<td><?php echo strlen($user->telegram) > 0 ? '<a href="https://t.me/'.hfix($user->telegram).'" target="_BLANK">@'.hfix($user->telegram).'</a>' : ''; ?></td>
			<td><?php echo $roles[$record->ruolo]; ?></td>
			<td><?php echo $record->referente ? 'Si' : 'No'; ?></td>
			<?php if($isDirettoreProgrammi) { ?>
			<td>
				<center><input id="vis<?php echo $user->id; ?>" onclick="$('#vis<?php echo $user->id; ?>').attr('disabled', true); $.get('programs.php?u=<?php echo $user->id; ?>&p=<?php echo $program->id; ?>&v', function(data) { $('#vis<?php echo $user->id; ?>').removeAttr('disabled'); });" type="checkbox" <?php if($record->visibile == 1) echo ' checked'; ?>>&nbsp;&nbsp;&nbsp;&nbsp;</center>
			</td>
			<td>
				<a href="#" data-id="<?php echo hfix($user->id); ?>" data-nome="<?php echo hfix($user->nome); ?>" data-cognome="<?php echo hfix($user->cognome); ?>" data-ruolo="<?php echo $record->ruolo; ?>" data-referente="<?php echo $record->referente; ?>" class="btn btn-mini btn-warning editProgramMember"><i class="icon-edit"></i></a> 
				<a href="#" data-id="<?php echo hfix($user->id); ?>" data-nome="<?php echo hfix($user->nome); ?>" data-cognome="<?php echo hfix($user->cognome); ?>" class="btn btn-mini btn-danger removeUserFromProgram"><i class="icon-trash"></i></a>
			</td>
			<?php } ?>
		</tr>
		<?php } ?>
	</tbody>
</table>
