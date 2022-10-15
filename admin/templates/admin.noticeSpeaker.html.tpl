<!-- Form Delete -->
<form method="post">
	<div class="modal hide fade" id="modalDeleteAvviso">
		<input type="hidden" name="delete_avviso" id="delete_avviso">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			<h3>Elimina Avviso</h3>
		</div>
		<div class="modal-body" id="delete_text">
		</div>
		<div class="modal-footer">
			<a href="#" data-dismiss="modal" class="btn">Annulla</a>
			<button type="submit" class="btn btn-danger"><i class="icon-trash"></i>Elimina</button>
		</div>
	</div>
</form>

<!-- Form Add Edit -->
<form method="post" id="addEditForm">
	<div class="modal hide fade" id="modalAddEditAvviso">
		<input type="hidden" name="add_edit_avviso" id="add_edit_avviso">
		<input type="hidden" name="edit_id" id="edit_id">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			<h3 id="addEditTitle">Aggiungi Avviso</h3>
		</div>
		<div class="modal-body" id="add_text">
			<div class="form-horizontal">
				
				<div class="control-group">
					<label class="control-label"><strong>Messaggio Breve:</strong></label>
					<div class="controls">
						<!--<input type="text" name="title" id="title" maxlength="250">-->
                        <textarea type="text" name="title" id="title" maxlength="250"></textarea>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label"><strong>Messaggio Lungo:</strong></label>
					<div class="controls">
						<textarea type="text" name="description" id="description" maxlength="500"></textarea>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label"><strong>Importanza:</strong></label>
					<div class="controls">
						<select name="color" id="color">
						
						<?php foreach($stili as $stile => $nome_stile): ?>
						  <option value="<?=$stile?>"><?=$nome_stile?></option>
						<?php endforeach; ?>
						</select>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label"><strong>Scadenza:</strong></label>
					<div class="controls">
						<input type="data" name="end_date" id="end_date" placeholder="AAAA-MM-DD es. 2021-12-31" value="<?php echo date('Y-m-d', strtotime('+15 Days')); ?>" data-toggle="datepicker">
					</div>
				</div>
				
				
			</div>
		</div>
		
		<div class="modal-footer modal-footer-add">
			<a href="#" data-dismiss="modal" class="btn">Annulla</a>
			<button type="button" class="btn btn-primary" id="confirmAddEdit">Aggiungi</button>
		</div>
	</div>
</form>

<!-- Form MoveUp -->
<form method="post" id="moveUpForm" display="none">
		<input type="hidden" name="move" id="move_up" value='up'>
		<input type="hidden" name="id" id="move_up_id">
		<!--<button type="submit" class="btn btn-danger"></button>-->
</form>

<!-- Form MoveDown -->
<form method="post" id="moveDownForm" display="none">
		<input type="hidden" name="move" id="move_down" value='down'>
		<input type="hidden" name="id" id="move_down_id">
		<!--<button type="submit" class="btn btn-danger"></button>-->
</form>


<!-- Navigation Bar -->
<ul class="breadcrumb">
	<li><a href="<?php echo $this->base_url; ?>">Home</a> <span class="divider">/</span></li>
	<li class="active">Notifiche Speaker</li>
	<li class="pull-right"><a href="#" class="addAvviso btn btn-success btn-mini"><i class="icon-book"></i> Nuovo Avviso</a></li>
</ul>

<!-- Tabella dei Avviso -->
<table class="table table-hover table-striped">
	<thead>
		<tr>
			<th style="display: none">Posizione</th>
			<th>Messaggio Corto</th>
			<th>Messaggio Lungo</th>
			<th>Importanza</th>
			<th>Scadenza</th>
			<th>Azioni</th>
		</tr>
	</thead>
	<tbody>
	<?php foreach($notice_data as $row): ?>
		<tr data-row="<?=$row->id?>" >
			<td data-name="position" style="display:none"><?=$row->position?></td>
			<td data-name="title" style="max-width:300px"><?=$row->title?></td>
			<td data-name="description" style="max-width: 300px"><?=$row->description?></td>
			<td data-name="color"><?=$stili[$row->color]?></td>
			<td data-name="date" style="min-width:85px"><?=$row->end_date?></td>
			<td style="width:130px">
				<!-- button up -->
				<a href="#" data-id="<?=$row->id?>" data-titolo="<?=$row->title?>" data-position_up="<?=$row->position?>" class="moveUpAvviso btn btn-primary btn-mini"><i class="icon-arrow-up"></i></a>
				<!-- button down -->
				<a href="#" data-id="<?=$row->id?>" data-titolo="<?=$row->title?>" data-position_avviso_down="<?=$row->position?>" class="moveDownAvviso btn btn-primary btn-mini"><i class="icon-arrow-down"></i></a>
				<!-- edit button -->
				<a href="#" data-id="<?=$row->id?>" class="editAvviso btn btn-warning btn-mini" 
onclick="$('#title').val('<?=$row->title?>'); $('#description').html('<?=$row->description?>'); $('#color option[value=<?=$row->color?>]').attr('selected','selected'); $('#end_date').val('<?=$row->end_date?>')"><i class="icon-edit"></i></a>
				<!-- delete button -->
				<a href="#" data-id="<?=$row->id?>" data-titolo="<?=$row->title?>" class="deleteAvviso btn btn-danger btn-mini"><i class="icon-trash"></i></a>
				
				
			</td>

		</tr>
	<?php endforeach;?>
	</tbody>
	<div class="last_avviso_value" data-last_avviso_value="<?=$last_notice?>" style="display:none">Fine: Last Data Value</div>
	<div class="default_date" data-default_date="<?php echo date('Y-m-d', strtotime('+15 Days')); ?>" style="display:none">Default Date</div>
</table>
