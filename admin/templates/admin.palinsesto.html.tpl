<?php
$settimana = array('Luned&igrave;', 'Marted&igrave;', 'Mercoled&igrave;', 'Gioved&igrave;', 'Venerd&igrave;', 'Sabato', 'Domenica');
?>
<?php if($isDirettoreProgrammi) { ?>
<form method="post">
	<div class="modal hide fade" id="modalDeletePalinsesto">
		<input type="hidden" name="deleteProgram" id="del1">
		<input type="hidden" name="deleteDay" id="del2">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			<h3>Palinsesto - Rimuovi Programma</h3>
		</div>
		<div class="modal-body" id="deletePalinsestoBody">		
		</div>
		<div class="modal-footer">
			<a href="#" data-dismiss="modal" class="btn">Annulla</a>
			<button type="submit" class="btn btn-danger"><i class="icon-trash"></i>Elimina</button>
		</div>
	</div>
</form>

<form method="POST" id="editForm">
<input type="hidden" id="ds" name="ds">
<div id="modalEditPalinsesto" class="modal hide fade" tabindex="-1" data-focus-on="input:first">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		<h3>Palinsesto - Modifica Programma</h3>
	</div>
	<div class="modal-body">
		<div id="modalEditMessages"></div>
		<div class="form-horizontal">
			<div class="control-group">
				<label class="control-label" for="inputEditProgramma"><strong>Programma:</strong></label>
				<div class="controls">
					<input type="hidden" name="programma" id="program">
					<select id="inputEditProgramma" disabled>
					<?php foreach($allProgrammi as $programma) { ?>
						<option value="<?php echo $programma->id; ?>"><?php echo hfix($programma->nome); ?></option>
					<?php } ?>
					</select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputEditGiorno"><strong>Giorno:</strong></label>
				<div class="controls">
					<select name="giorno" id="inputEditGiorno">
					<?php for($a = 0; $a < count($settimana); $a++) { ?>
						<option value="<?php echo $a; ?>"><?php echo $settimana[$a]; ?></option>
					<?php } ?>
					</select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputEditOra"><strong>Orario Inizio:</strong></label>
				<div class="controls">
					<select name="ora" id="inputEditOra" style="width: 50px;">
					<?php for($a = 0; $a < 24; $a++) { ?>
						<option value="<?php echo $a; ?>"><?php echo $a < 10 ? '0'.$a : $a; ?></option>
					<?php } ?>
					</select> : 
					<select name="minuto" id="inputEditMinuto" style="width: 50px;">
					<?php for($a = 0; $a < 60; $a++) { ?>
						<option value="<?php echo $a; ?>"><?php echo $a < 10 ? '0'.$a : $a; ?></option>
					<?php } ?>
					</select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputEditDurata"><strong>Durata:</strong></label>
				<div class="controls">
					<select name="durata" id="inputEditDurata">
						<option value="1">1 Ora</option>
						<option value="2">2 Ore</option>
					</select>
				</div>
			</div>
		</div>
	</div>
	<div class="modal-footer">
		<button type="button" data-dismiss="modal" class="btn">Annulla</button>
		<a type="button" class="btn btn-warning" id="confirmEdit">Modifica</a>
	</div>
</div>
</form>

<form method="POST" id="addForm">
<div id="modalAddProgram" class="modal hide fade" tabindex="-1" data-focus-on="input:first">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		<h3>Palinsesto - Aggiungi Programma</h3>
	</div>
	<div class="modal-body">
		<div id="modalMessages"></div>
		<div class="form-horizontal">
			<div class="control-group">
				<label class="control-label" for="inputAddProgramma"><strong>Programma:</strong></label>
				<div class="controls">
					<select name="programma" id="inputAddProgramma">
					<?php foreach($allProgrammi as $programma) { ?>
						<option value="<?php echo $programma->id; ?>"><?php echo hfix($programma->nome); ?></option>
					<?php } ?>
					</select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputAddGiorno"><strong>Giorno:</strong></label>
				<div class="controls">
					<select name="giorno" id="inputAddGiorno">
					<?php for($a = 0; $a < count($settimana); $a++) { ?>
						<option value="<?php echo $a; ?>"><?php echo $settimana[$a]; ?></option>
					<?php } ?>
					</select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputAddOra"><strong>Orario Inizio:</strong></label>
				<div class="controls">
					<select name="ora" id="inputAddOra" style="width: 50px;">
					<?php for($a = 0; $a < 24; $a++) { ?>
						<option value="<?php echo $a; ?>"><?php echo $a < 10 ? '0'.$a : $a; ?></option>
					<?php } ?>
					</select> : 
					<select name="minuto" id="inputAddMinuto" style="width: 50px;">
					<?php for($a = 0; $a < 60; $a++) { ?>
						<option value="<?php echo $a; ?>"><?php echo $a < 10 ? '0'.$a : $a; ?></option>
					<?php } ?>
					</select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputAddDurata"><strong>Durata:</strong></label>
				<div class="controls">
					<select name="durata" id="inputAddDurata">
						<option value="1">1 Ora</option>
						<option value="2">2 Ore</option>
					</select>
				</div>
			</div>
		</div>
	</div>
	<div class="modal-footer">
		<button type="button" data-dismiss="modal" class="btn">Annulla</button>
		<a type="button" class="btn btn-primary" id="confirmAdd">Aggiungi</a>
	</div>
</div>
</form>
<?php } ?>

<ul class="breadcrumb">
	<li><a href="<?php echo $this->base_url; ?>">Home</a> <span class="divider">/</span></li>
	<li class="active">Palinsesto</li>
</ul>
<?php if(isset($errors)) { ?>
<div class="alert alert-danger">
	<button type="button" class="close" data-dismiss="alert">&times;</button>
	<?php foreach($errors as $error) {
		echo $error.'<br>';
	}
	?>
</div>
<?php } elseif(isset($success)) { ?>
<div class="alert alert-success">
	<button type="button" class="close" data-dismiss="alert">&times;</button>
	<?php echo $success; ?>
</div>
<?php } ?>
<?php $active = isset($_POST['giorno']) ? (int)$_POST['giorno'] : (date('N')-1); ?>
<ul id="myTab" class="nav nav-pills">
	<?php for($a = 0; $a < count($settimana); $a++) { ?>
		<li<?php if($a == $active) echo ' class="active"'; ?>><a href="#giorno-<?php echo $a; ?>" data-toggle="tab"><?php echo $settimana[$a]; ?></a></li>
	<?php } ?>
</ul>
<div id="myTabContent" class="tab-content">
	<?php for($a = 0; $a < count($settimana); $a++) { ?>
	<div class="tab-pane fade in<?php if($a == $active) echo ' active'; ?>" id="giorno-<?php echo $a; ?>">
		<table class="table table-hover table-bordered">
			<tr>
				<th style="width: 100px;"><center>Ora Inizio</center></th>
				<th style="width: 100px;"><center>Ora Fine</center></th>
				<th><center>Programma</center></th>
				<?php if($isDirettoreProgrammi) { ?><th><center>OnAir</center></th><th><center>Azioni</center></th><?php } ?>
			</tr>
			<?php
			$giornata = Palinsesto::all(array('order' => 't_i asc', 'conditions' => array('giorno = ?', $a))); 
			foreach($giornata as $sr) { 
				if($isDirettoreProgrammi) {
					$days = array('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');
					$reverseDays = array_flip($days);
					$day = $days[$sr->giorno];
					$currentDatabaseTime = convertToTime($reverseDays[date('l')], date('H'), date('i'))+date('s');
					if(strtolower(date("l")) == strtolower($day) && $currentDatabaseTime < $sr->t_f) {
						$time = time();
					} else {
						$time = strtotime('next '.$day);
					}
					$onAirDay = date('d-m-Y', $time);
					$status = $onAirDay == $sr->notonair;
					$vacanza = $sr->vacanza;
				}
				?>
			<tr<?php if($isDirettoreProgrammi) echo ' class="'.($vacanza == 1 ? 'warning' : ($status ? 'error' : 'success')).'"'; ?>>
				<td><center><?php echo hfix(formatOrario($sr->ora_inizio, $sr->minuto_inizio)); ?></center></td>
				<td><center><?php echo hfix(formatOrario($sr->ora_fine, $sr->minuto_fine)); ?></center></td>
				<td><center><a href="programs.php?list=0&p=<?php echo $sr->programmi->id; ?>" target="_BLANK"><?php echo hfix($sr->programmi->nome); ?></a></center></td>
				<?php if($isDirettoreProgrammi) { ?>
				<td><center><?php if($vacanza) echo 'Vacanza'; else { echo $onAirDay; ?> <a class="btn btn-mini <?php echo $status ? 'btn-danger' : 'btn-success'; ?>" href="<?php echo $this->base_url; ?>palinsesto.php?pl=<?php echo $sr->giorno; ?>&p=<?php echo $sr->programmi_id; ?>&onair=<?php echo $status ? '1' : '0'; ?>"><?php echo $status ? '<i class="icon-volume-off"></i> No' : '<i class="icon-volume-up"></i> Si'; ?></a><?php } ?>
				</center></td>
				<td><center>
				<a class="btn btn-mini <?php echo $vacanza ? 'btn-warning' : 'btn-success'; ?>" href="<?php echo $this->base_url; ?>palinsesto.php?p=<?php echo $sr->programmi_id; ?>&v=<?php echo (1-$vacanza); ?>"><?php echo $vacanza ? 'Imposta non in vacanza' : 'Imposta in vacanza'; ?></a>
				<a href="#modalEditPalinsesto" class="btn btn-warning btn-mini" data-toggle="modal" onclick="$('#inputEditDurata').val('<?php echo (int)$sr->durata; ?>'); $('#inputEditGiorno').val('<?php echo (int)$sr->giorno; ?>'); $('#inputEditOra').val('<?php echo (int)$sr->ora_inizio; ?>'); $('#inputEditMinuto').val('<?php echo (int)$sr->minuto_inizio; ?>'); $('#inputEditProgramma').val('<?php echo $sr->programmi->id; ?>'); $('#program').val('<?php echo $sr->programmi->id; ?>'); $('#ds').val('<?php echo (int)$sr->giorno; ?>');"><i class="icon-edit"></i></a>
				<a href="#modalDeletePalinsesto" class="btn btn-danger btn-mini" data-toggle="modal" onclick="$('#deletePalinsestoBody').html('Sei sicuro di voler rimuovere il programma <b><?php echo hfix($sr->programmi->nome); ?></b> dal<?php if($a == 6) echo 'la'; ?> <b><?php echo $settimana[$a]; ?></b> ?'); $('#del1').val('<?php echo $sr->programmi_id; ?>'); $('#del2').val('<?php echo $sr->giorno; ?>');"><i class="icon-trash"></i></a>
				</center></td>
				<?php } ?>
			</tr>
			<?php } ?>
		</table>
		<?php if($isDirettoreProgrammi) { ?>	
		<a href="#modalAddProgram" class="btn btn-primary btn-small pull-right" data-toggle="modal" onclick="$('#inputAddGiorno').val('<?php echo $a; ?>');">Aggiungi <i class="icon-plus"></i></a>
		<?php } ?>
	</div>
	<?php } ?>
</div>

<!---
Fare login su qualsiasi programma se sei direttore programmi o >
-->
