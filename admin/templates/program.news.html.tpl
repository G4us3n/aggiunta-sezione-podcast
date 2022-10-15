<form method="post">
	<div class="modal hide fade" id="modalDeleteNews">
		<input type="hidden" name="delete_news" id="delete_news">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			<h3>Elimina News</h3>
		</div>
		<div class="modal-body" id="delete_text">
		</div>
		<div class="modal-footer">
			<a href="#" data-dismiss="modal" class="btn">Annulla</a>
			<button type="submit" class="btn btn-danger"><i class="icon-trash"></i>Elimina</button>
		</div>
	</div>
</form>

<form method="post">
	<div class="modal hide fade" id="modalEditVisibility">
		<input type="hidden" name="change_visibility" id="change_visibility">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			<h3>Modifica Visibilit&agrave; News</h3>
		</div>
		<div class="modal-body" id="change_visibility_text">
		</div>
		<div class="modal-footer">
			<a href="#" data-dismiss="modal" class="btn">Annulla</a>
			<button type="submit" class="btn btn-info"><i class="icon-trash"></i>Modifica</button>
		</div>
	</div>
</form>

<form method="post">
	<div class="modal hide fade" id="modalEditCopyright">
		<input type="hidden" name="change_copyright" id="change_copyright">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			<h3>Modifica Copyright News</h3>
		</div>
		<div class="modal-body" id="change_copyright_text">
		</div>
		<div class="modal-footer">
			<a href="#" data-dismiss="modal" class="btn">Annulla</a>
			<button type="submit" class="btn btn-info"><i class="icon-trash"></i>Modifica</button>
		</div>
	</div>
</form>

<ul class="breadcrumb">
	<li><a href="<?php echo $this->base_url; ?>">Home</a> <span class="divider">/</span></li>
	<?php if($page == 0) { ?>
	<li class="active">News (<?php echo $count; ?>)</li>
	<?php } else { ?>
	<li><a href="<?php echo $this->base_url; ?>news.php">News (<?php echo $count; ?>)</a> <span class="divider">/</span></li>
	<li class="active">Pagina <?php echo $page+1; ?></li>
	<?php } ?>
	<li class="pull-right"><a href="<?php $this->base_url; ?>news.php?new" class="btn btn-warning btn-mini"><i class="icon-book"></i> Nuova news</a></li>
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
		<th>Titolo</th>
		<?php if(isset($listAdmin)) { ?><th>Programma</th><?php } ?>
		<th>Publisher</th>
		<th>Views</th>
		<th>Data</th>
		<th>Ora</th>
		<th>Visibile</th>
        <th>Copyright</th>
		<th>Azioni</th>
	</thead>
	<tbody>
		<?php foreach($news as $singleNews) { ?>
		<tr<?php echo $singleNews->visibile == 1 ? '' : ' class="warning"'; ?>>
			<?php if($singleNews->visibile == 1) { ?>
			<td><a href="<?php echo str_replace('membri.', 'www.', $this->base_url); ?>news/<?php echo $singleNews->id.'/'.format_text_url($singleNews->titolo); ?>" target="_BLANK"><?php echo hfix($singleNews->titolo); ?></a></td>
			<?php } else { ?>
			<td><a href="<?php echo str_replace('membri.', 'www.', $this->base_url); ?>article.php?article=<?php echo $singleNews->id; ?>" target="_BLANK"><?php echo hfix($singleNews->titolo); ?></a></td>
			<?php } ?>
			<?php if(isset($listAdmin)) { ?><td><?php echo hfix($singleNews->global == 1 ? 'Redazione' : $singleNews->programmi->nome); ?></td><?php } ?>
			<td><?php echo hfix($singleNews->utenti->nome." ".$singleNews->utenti->cognome); ?></td>
			<td><?php echo $singleNews->views; ?></td>
			<td><?php echo date('d-m-Y', $singleNews->time); ?></td>
			<td><?php echo date('H:i:s', $singleNews->time); ?></td>
			<td>
				<?php if($programActions->isUserLoggedForRedaction(1) || $singleNews->utenti_id == $currentUser->id) { ?>
				<a href="#" class="changeVisibility" data-id="<?php echo $singleNews->id; ?>" data-status="<?php echo $singleNews->visibile; ?>" data-titolo="<?php echo hfix($singleNews->titolo); ?>">
				<?php echo $singleNews->visibile == 1 ? 'Si' : 'No'; ?>
				</a>
				<?php } else echo $singleNews->visibile == 1 ? 'Si' : 'No'; ?>
			</td>
            <td>
				<?php if($programActions->isUserLoggedForRedaction(1) || $singleNews->utenti_id == $currentUser->id) { ?>
				<a href="#" class="changeCopyright" data-id="<?php echo $singleNews->id; ?>" data-status="<?php echo $singleNews->copyright; ?>" data-titolo="<?php echo hfix($singleNews->titolo); ?>">
				<?php echo $singleNews->copyright == 1 ? 'Si' : 'No'; ?>
				</a>
				<?php } else echo $singleNews->copyright == 1 ? 'Si' : 'No'; ?>
			</td>

			<td>
				<?php if($programActions->isUserLoggedForRedaction(1) || $singleNews->utenti_id == $currentUser->id) { ?>
				<a href="<?php $this->base_url; ?>news.php?edit=<?php echo $singleNews->id; ?>" class="btn btn-mini btn-warning"><i class="icon-edit"></i></a> 
				<a href="#" data-id="<?php echo $singleNews->id; ?>" data-titolo="<?php echo hfix($singleNews->titolo); ?>" class="deleteNews btn btn-mini btn-danger"><i class="icon-trash"></i></a>
				<?php } ?>
			</td>
		</tr>
		<?php } ?>
	</tbody>
</table>
<?php if($pages > 1) { ?>
<center>
	<div class="pagination">
		<ul>
			<?php if($page == 0) { ?>
			<li class="disabled"><a href="#">Prev</a></li>
			<?php } else { ?>
			<li><a href="<?php $this->base_url; ?>news<?php echo isset($listAdmin) ? 'Admin' : ''; ?>.php?p=<?php echo $page-1; ?>">Prev</a></li>
			<?php } ?>
			<?php for($a = 0; $a < $pages; $a++) { ?>
			<li<?php if($page == $a) echo ' class="active"'; ?>><a href="<?php $this->base_url; ?>news<?php echo isset($listAdmin) ? 'Admin' : ''; ?>.php?p=<?php echo $a; ?>"><?php echo $a+1; ?></a></li>
			<?php } ?>
			<?php if($page >= $pages-1) { ?>
			<li class="disabled"><a href="#">Next</a></li>
			<?php } else { ?>
			<li><a href="<?php $this->base_url; ?>news<?php echo isset($listAdmin) ? 'Admin' : ''; ?>.php?p=<?php echo $page+1; ?>">Next</a></li>
			<?php } ?>
		</ul>
	</div>
</center>
<?php } ?>
