<ul class="breadcrumb">
	<li><a href="<?php echo $this->base_url; ?>">Home</a> <span class="divider">/</span></li>
	<li class="active">Abilita Funzioni Avanzate</li>
</ul>
<div class="span2"></div>
<div class="span7">
<form method="POST" autocomplete="off">
	<?php if(count($_POST) > 0) { ?><div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Dati errati!</div><?php } ?>
	<div class="form-horizontal">
		<center><h3>Autenticati</h3></center><br>
		<div class="control-group">
			<label class="control-label" for="inputPassword"><strong>Password:</strong></label>
			<div class="controls">
				<input name="password" type="password" id="inputPassword" placeholder="Password">
			</div>
		</div>
		<div class="control-group">
			<label class="control-label" for="inputCode"><strong>Codice di Autenticazione:</strong></label>
			<div class="controls">
				<input name="code" type="text" id="inputCode" placeholder="Codice di Autenticazione">
			</div>
		</div>
		<div class="control-group">
			<label class="control-label" for="inputSubmit"></label>
			<div class="controls">
				<button type="submit" id="inputSubmit" class="btn btn-medium btn-primary"><i class="icon-ok"></i> Autenticati</button>
			</div>
		</div>
	</div>
</form>
</div>
<!--<audio loop autoplay>
	<source src="evoluzione.mp3" type="audio/mpeg">
</audio> -->
