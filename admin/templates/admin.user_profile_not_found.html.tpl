<ul class="breadcrumb">
	<li><a href="<?php echo $this->base_url; ?>">Home</a> <span class="divider">/</span></li>
	<?php if($isDirettivo) { ?><li><a href="<?php echo $this->base_url; ?>users.php">Statistiche Membri</a> <span class="divider">/</span></li><?php } ?>
	<li><a href="<?php echo $this->base_url.'users.php?list='.$list; ?>"><?php echo $activePage; ?></a> <span class="divider">/</span></li>
	<li class="active">Utente non trovato</li>
</ul>
<center><h3>Utente non trovato!</h3></center>