<!-- Form Delete -->
<form method="post">
	<div class="modal hide fade" id="modalDeleteLink">
		<input type="hidden" name="delete_link" id="delete_link">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			<h3>Elimina Link</h3>
		</div>
		<div class="modal-body" id="delete_text">
		</div>
		<div class="modal-footer">
			<a href="#" data-dismiss="modal" class="btn">Annulla</a>
			<button type="submit" class="btn btn-danger"><i class="icon-trash"></i>Elimina</button>
		</div>
	</div>
</form>

<!-- Form Visibility -->
<form method="post">
	<div class="modal hide fade" id="modalEditVisibility">
		<input type="hidden" name="change_visibility" id="change_visibility">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			<h3>Modifica Visibilit&agrave; Link</h3>
		</div>
		<div class="modal-body" id="change_visibility_text">
		</div>
		<div class="modal-footer">
			<a href="#" data-dismiss="modal" class="btn">Annulla</a>
			<button type="submit" class="btn btn-info"><i class="icon-refresh"></i>Modifica</button>
		</div>
	</div>
</form>

<!-- Form Add Edit -->
<form method="post" id="addEditForm">
	<div class="modal hide fade" id="modalAddEditLink">
		<input type="hidden" name="add_edit_link" id="add_edit_link">
		<input type="hidden" name="edit_id" id="edit_id">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			<h3 id="addEditTitle">Aggiungi Link</h3>
		</div>
		<div class="modal-body" id="add_text">
			<div class="form-horizontal">
				
				<div class="control-group">
					<label class="control-label">Titolo:</label>
					<div class="controls">
						<input type="text" name="title" id="title">
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Sottotitolo:</label>
					<div class="controls">
						<input type="text" name="subtitle" id="subtitle">
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">URL:</label>
					<div class="controls">
						<input type="url" name="url" id="url">	
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Visibile:</label>
					<div class="controls">
						<input type="checkbox" name="visible" id="visible">
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Tipologia:</label>
					<div class="controls">
						<select name="link_type" id="link_type">
						  <option value="generico">Link Generico</option>
						  <option value="social">Link Social</option>
						</select>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Immagine:</label>
					<div class="controls">
						<input type="url" name="img" id="img">
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
	<li class="active">Linkindex</li>
	<li class="pull-right"><a href="#" class="addLink btn btn-success btn-mini"><i class="icon-book"></i> Nuovo Link</a></li>
</ul>

<!-- Tabella dei Link -->
<table class="table table-hover table-striped">
	<h4 class="well well-small" style="text-align:center">Link Generici</h4>
	<thead>
		<tr>
			<th style="display: none">Posizione</th>
			<th>Titolo</th>
			<th>Descrizione</th>
			<th>Link</th>
			<th style="display: none">Immagine</th>
			<th style="text-align: center">Visibile</th>
			<th>Azioni</th>
		</tr>
	</thead>
	<tbody>
	<?php foreach($link_data as $row): ?>
		<?php //$data_array = $link_data->attributes();
			//print_r($data_array);
		?>
		<tr data-row="<?=$row->id?>">
			<td data-name="position" style="display:none"><?=$row->position_link?></td>
			<td data-name="title"><?=$row->title?></td>
			<td data-name="subtitle" style="max-width: 300px"><?=$row->subtitle?></td>
			<td data-name="url"><a target="_blank" href="<?=$row->url?>"><?=$row->url?></a></td>
			<td data-name="img" style="display: none"><a target="_blank" href="<?=$row->img?>"><?=$row->img?></a></td>
			<td data-name="visible" style="text-align: center">
				<a href="#" class="changeVisibility" data-id="<?=$row->id?>" data-status="<?=$row->visible?>" data-titolo="<?=$row->title?>"><?=$row->visible ? 'Si' : 'No' ?></a>
			</td>
			<td>
				<!-- button up -->
				<a href="#" data-id="<?=$row->id?>" data-titolo="<?=$row->title?>" data-position_up="<?=$row->position_link?>" class="moveUpLink btn btn-primary btn-mini"><i class="icon-arrow-up"></i></a>
				<!-- button down -->
				<a href="#" data-id="<?=$row->id?>" data-titolo="<?=$row->title?>" data-position_link_down="<?=$row->position_link?>" class="moveDownLink btn btn-primary btn-mini"><i class="icon-arrow-down"></i></a>
				<!-- edit button -->
				<a href="#" data-id="<?=$row->id?>" class="editLink btn btn-warning btn-mini" 
onclick="$('#title').val('<?=$row->title?>'); $('#subtitle').val('<?=$row->subtitle?>'); $('#url').val('<?=$row->url?>'); $('#img').val('<?=$row->img?>'); $('#link_type option[value=generico]').attr('selected','selected'); $('#visible').prop('checked',<?=$row->visible?>);"><i class="icon-edit"></i></a>
				<!-- delete button -->
				<a href="#" data-id="<?=$row->id?>" data-titolo="<?=$row->title?>" class="deleteLink btn btn-danger btn-mini"><i class="icon-trash"></i></a>
				
				
			</td>

		</tr>
	<?php endforeach;?>
	</tbody>
	<div class="last_link_value" data-last_link_value="<?=$last_link?>" style="display:none">Fine: Last Data Value</div>
</table>
<!-- Tabella dei Social -->
<table class="table table-hover table-striped">
	<h4 class="well well-small" style="text-align:center">Link Social</h4>
	<thead>
		<tr>
			<th style="display: none">Posizione</th>
			<th>Titolo</th>
			<th>Immagine <a href="https://fontawesome.com/icons?d=gallery&amp;p=2" target="_blank"><i class="fas fa-info-circle"></i></a></th>
			<th>Link</th>
			
			<th style="text-align: center">Visibile</th>
			<th>Azioni</th>
		</tr>
	</thead>
	<tbody>
	<?php foreach($social_data as $row): ?>
		<?php //$data_array = $social_data->attributes();
			//print_r($data_array);
		?>
		<tr data-row="<?=$row->id?>">
			<td data-name="position" style="display:none"><?=$row->position_social?></td>
			<td data-name="title"><?=$row->title?></td>
			<td data-name="img" style="max-height: 50px; text-align: center"><i class="<?=$row->img?> fa-1x"></i></a></td>
			
			<td data-name="url"><a target="_blank" href="<?=$row->url?>"><?=$row->url?></a></td>
			
			<td data-name="visible" style="text-align: center">
				<a href="#" class="changeVisibility" data-id="<?=$row->id?>" data-status="<?=$row->visible?>" data-titolo="<?=$row->title?>"><?=$row->visible ? 'Si' : 'No' ?></a>
			</td>
			<td>
				<!-- button up -->
				<a href="#" data-id="<?=$row->id?>" data-titolo="<?=$row->title?>" data-position_up="<?=$row->position_social?>" class="moveUpLink btn btn-primary btn-mini"><i class="icon-arrow-up"></i></a>
				<!-- button down -->
				<a href="#" data-id="<?=$row->id?>" data-titolo="<?=$row->title?>" data-position_social_down="<?=$row->position_social?>" class="moveDownLink btn btn-primary btn-mini"><i class="icon-arrow-down"></i></a>
				<!-- edit button -->
				<a href="#" data-id="<?=$row->id?>" class="editLink btn btn-warning btn-mini" 
onclick="$('#title').val('<?=$row->title?>'); $('#subtitle').val('<?=$row->subtitle?>'); $('#url').val('<?=$row->url?>'); $('#img').val('<?=$row->img?>'); $('#link_type option[value=social]').attr('selected','selected'); $('#visible').prop('checked',<?=$row->visible?>);"><i class="icon-edit"></i></a>
				<!-- delete button -->
				<a href="#" data-id="<?=$row->id?>" data-titolo="<?=$row->title?>" class="deleteLink btn btn-danger btn-mini"><i class="icon-trash"></i></a>
			</td>

		</tr>
	<?php endforeach;?>
	</tbody>
	<div class="last_social_value" data-last_social_value="<?=$last_social?>" style="display:none">Fine: Last Data Value</div>
</table>