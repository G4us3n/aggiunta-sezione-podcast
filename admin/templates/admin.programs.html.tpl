<?php if($isDirettoreProgrammi) { ?>
<form method="post">
	<div class="modal hide fade" id="modalDeleteProgram">
		<input type="hidden" name="delete_program" id="delete_program">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			<h3>Elimina Programma</h3>
		</div>
		<div class="modal-body" id="delete_text">
		</div>
		<div class="modal-footer">
			<a href="#" data-dismiss="modal" class="btn">Annulla</a>
			<button type="submit" class="btn btn-danger"><i class="icon-trash"></i>Elimina</button>
		</div>
	</div>
</form>
<?php } ?>

<ul class="breadcrumb">
	<li><a href="<?php echo $this->base_url; ?>">Home</a> <span class="divider">/</span></li>
	<?php if($isDirettivo) { ?>
	<li><a href="<?php echo $this->base_url; ?>programs.php">Statistiche Programmi</a> <span class="divider">/</span></li>
	<?php } ?>
	<li class="active"><?php echo $activePage; ?></li>
	<?php if($isDirettoreProgrammi) { ?>
	<li class="pull-right"><a href="<?php $this->base_url; ?>programs.php?list=<?php echo $list; ?>&new" class="btn btn-warning btn-mini"><i class="icon-music"></i> Nuovo Programma</a></li>
	<?php } ?>
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
			<th>Nome</th>
			<th>Tag</th>
			<th>Referente</th>
			<?php if($isDirettivo) { ?><th>Status</th><?php } ?>
			<th>Azioni</th>
		</tr>
	</thead>
	<tbody>
		<?php foreach($programs as $program) { ?>
		<tr class="<?php
			switch($program->status) {
				case 0:
					echo 'success';
					break;
				case 1:
					echo 'warning';
					break;
				case 2:
					echo 'info';
					break;
				default:
					echo 'error';
			}
		?>">
			<td><?php echo hfix($program->nome); ?></td>
			<td><?php echo hfix($program->tag); ?></td>
			<td><?php
			$referente = $programActions->getReferente($program);
			if(is_object($referente)) {
				echo '<a href="'.$this->base_url.'users.php?list=0&u='.$referente->id.'" target="_blank">'.hfix($referente->nome." ".$referente->cognome).'</a>';
			}
			?></td>
			<?php if($isDirettivo) { ?><td><?php echo $statusProgramma[$program->status]; ?></td><?php } ?>
			<td>
				<a href="<?php echo $this->base_url; ?>programs.php?list=<?php echo (int)$list; ?>&p=<?php echo $program->id; ?>" class="btn btn-success btn-mini"><i class="icon-music"></i></a> 
				<a href="<?php echo $this->base_url; ?>programs.php?list=<?php echo (int)$list; ?>&s=<?php echo $program->id; ?>" class="btn btn-success btn-mini"><i class="icon-user"></i></a> 
				<?php if($isDirettoreProgrammi) { ?>
				<a href="<?php echo $this->base_url; ?>programs.php?list=<?php echo (int)$list; ?>&m=<?php echo $program->id; ?>" class="btn btn-warning btn-mini"><i class="icon-edit"></i></a> 
				<a href="#" data-id="<?php echo $program->id; ?>" data-nome="<?php echo hfix($program->nome); ?>" class="deleteProgram btn btn-danger btn-mini"><i class="icon-trash"></i></a> 
				<a href="<?php echo $this->base_url; ?>programlogin.php?id=<?php echo $program->id; ?>" class="btn btn-info btn-mini"><i class="icon-resize-small"></i></a>
				<?php } ?>
			</td>
		</tr>
		<?php } ?>
	</tbody>
</table>