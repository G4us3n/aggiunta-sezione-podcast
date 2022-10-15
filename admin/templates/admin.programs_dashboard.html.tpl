<ul class="breadcrumb">
	<li><a href="<?php echo $this->base_url; ?>">Home</a> <span class="divider">/</span></li>
	<li class="active">Statistiche Programmi</li>
	<?php if($isDirettoreProgrammi) { ?><li class="pull-right"><a href="<?php $this->base_url; ?>programs.php?new" class="btn btn-warning btn-mini"><i class="icon-music"></i> Nuovo Programma</a></li><?php } ?>
</ul>
<center>
<?php if(isset($success)) { ?>
<div class="alert alert-success">
	<button type="button" class="close" data-dismiss="alert">&times;</button>
	<?php echo $success; ?>
</div>
<?php } ?>
<table class="table table-hover table-striped" style="width: 350px;">
	<tr>
		<td><strong><a href="<?php $this->base_url; ?>programs.php?list=0">Programmi Totali:</a></strong></td>
		<td><?php echo $programmiTotali; ?></td>
	</tr>
	<tr>
		<td><strong><a href="<?php $this->base_url; ?>programs.php?list=1">Programmi Attivi e Visibili:</a></strong></td>
		<td><?php echo $programmiAttiviVisibili; ?></td>
	</tr>
	<tr>
		<td><strong><a href="<?php $this->base_url; ?>programs.php?list=2">Lista Programmi Attivi e Non Visibili:</a></strong></td>
		<td><?php echo $programmiAttiviInvisibili; ?></td>
	</tr>
	<tr>
		<td><strong><a href="<?php $this->base_url; ?>programs.php?list=3">Lista Programmi Non Attivi e Visibili:</a></strong></td>
		<td><?php echo $programmiInattiviVisibili; ?></td>
	</tr>
	<tr>
		<td><strong><a href="<?php $this->base_url; ?>programs.php?list=4">Lista Programmi Disabilitati:</a></strong></td>
		<td><?php echo $programmiDisabilitati; ?></td>
	</tr>
</table>
</center>