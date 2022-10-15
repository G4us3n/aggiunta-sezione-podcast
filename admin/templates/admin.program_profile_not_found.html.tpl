<ul class="breadcrumb">
	<li><a href="<?php echo $this->base_url; ?>">Home</a> <span class="divider">/</span></li>
	<?php if($isDirettivo) { ?><li><a href="<?php echo $this->base_url; ?>programs.php">Statistiche Programmi</a> <span class="divider">/</span></li><?php } ?>
	<?php if($list >= 0) { ?>
	<li><a href="<?php echo $this->base_url.'programs.php?list='.$list; ?>"><?php echo $activePage; ?></a> <span class="divider">/</span></li>
	<?php } ?>
	<li class="active">Programma non trovato</li>
</ul>
<center><h3>Programma non trovato!</h3></center>