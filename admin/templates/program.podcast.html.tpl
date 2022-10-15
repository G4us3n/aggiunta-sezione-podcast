<form method="post">
	<div class="modal hide fade" id="modalDeletePodcast">
		<input type="hidden" name="delete_podcast" id="delete_podcast">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			<h3>Elimina Podcast</h3>
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
			<h3>Modifica Visibilit&agrave; Podcast</h3>
		</div>
		<div class="modal-body" id="change_visibility_text">
		</div>
		<div class="modal-footer">
			<a href="#" data-dismiss="modal" class="btn">Annulla</a>
			<button type="submit" class="btn btn-info"><i class="icon-refresh"></i>Modifica</button>
		</div>
	</div>
</form>

<ul class="breadcrumb">
	<li><a href="<?php echo $this->base_url; ?>">Home</a> <span class="divider">/</span></li>
	<?php if($page == 0) { ?>
	<li class="active">Podcast (<?php echo $count; ?>)</li>
	<?php } else { ?>
	<li><a href="<?php echo $this->base_url; ?>podcast.php">Podcast (<?php echo $count; ?>)</a> <span class="divider">/</span></li>
	<li class="active">Pagina <?php echo $page+1; ?></li>
	<?php } ?>
	<li class="pull-right"><a href="<?php $this->base_url; ?>podcast.php?new" class="btn btn-warning btn-mini"><i class="icon-book"></i> Nuovo podcast</a></li>
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
		<th>Data</th>
		<?php if(isset($listAdmin)) { ?><th>Programma</th><?php } ?>
		<th>Publisher</th>
		<th>Pubblicato</th>
		<?php /*<th>Views</th>*/ ?>
		<?php /*<th>Download</th>*/ ?>
		<th>Visibile</th>
		<th>Azioni</th>
	</thead>
	<tbody>
		<?php foreach($podcast as $singlePodcast) { ?>
		<tr<?php echo $singlePodcast->visibile == 1 ? '' : ' class="warning"'; ?>>
			<td><?php echo $singlePodcast->giorno." ".$mesiValue[$singlePodcast->mese]." ".$singlePodcast->anno; ?></td>
			<?php if(isset($listAdmin)) { ?><td><?php echo hfix($singlePodcast->global == 1 ? 'Redazione' : $singlePodcast->programmi->nome); ?></td><?php } ?>
			<td><?php echo hfix($singlePodcast->utenti->nome." ".$singlePodcast->utenti->cognome); ?></td>
			<td><?php echo date('d-m-Y H:i:s', $singlePodcast->time); ?></td>
			<?php /*<td><?php echo $singlePodcast->views; ?></td>*/ ?>
			<?php /*
			<td><?php
				switch($singlePodcast->download) {
					case 0:
						echo 'In coda';
						break;
					case 1:
						$ratio = filesize('../tmp/'.$singlePodcast->filedownload)/$singlePodcast->filesize;
						if($ratio == 1) {
							echo 'In elaborazione';
						} else {
							echo round($ratio*100, 2).'%';
						}
						break;
					default:
						echo '<a href="'.$this->base_url.'podcast.php?dw='.$singlePodcast->id.'">Download</a>';
						break;
				}
				?>
			</td>*/?>
			<td><a href="#" class="changeVisibility" data-id="<?php echo $singlePodcast->id; ?>" data-status="<?php echo $singlePodcast->visibile; ?>" data-titolo="<?php echo $singlePodcast->giorno." ".$mesiValue[$singlePodcast->mese]." ".$singlePodcast->anno; ?>"><?php echo $singlePodcast->visibile == 1 ? 'Si' : 'No'; ?></a></td>
			<td>
				<a href="<?php $this->base_url; ?>podcast.php?edit=<?php echo $singlePodcast->id; ?>" class="btn btn-mini btn-warning"><i class="icon-edit"></i></a> 
				<a href="#" data-id="<?php echo $singlePodcast->id; ?>" data-titolo="<?php echo $singlePodcast->giorno." ".$mesiValue[$singlePodcast->mese]." ".$singlePodcast->anno; ?>" class="deletePodcast btn btn-mini btn-danger"><i class="icon-trash"></i></a>
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
			<li><a href="<?php $this->base_url; ?>podcast<?php echo isset($listAdmin) ? 'Admin' : ''; ?>.php?p=<?php echo $page-1; ?>">Prev</a></li>
			<?php } ?>
			<?php for($a = 0; $a < $pages; $a++) { ?>
			<li<?php if($page == $a) echo ' class="active"'; ?>><a href="<?php $this->base_url; ?>podcast<?php echo isset($listAdmin) ? 'Admin' : ''; ?>.php?p=<?php echo $a; ?>"><?php echo $a+1; ?></a></li>
			<?php } ?>
			<?php if($page >= $pages-1) { ?>
			<li class="disabled"><a href="#">Next</a></li>
			<?php } else { ?>
			<li><a href="<?php $this->base_url; ?>podcast<?php echo isset($listAdmin) ? 'Admin' : ''; ?>.php?p=<?php echo $page+1; ?>">Next</a></li>
			<?php } ?>
		</ul>
	</div>
</center>
<?php } ?>
