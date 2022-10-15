<ul class="breadcrumb">
	<li><a href="<?php echo $this->base_url; ?>">Home</a> <span class="divider">/</span></li>
	<li class="active">Invia Notifica</li>
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

<form class="form-horizontal" method="POST">
	<div class="control-group">
		<label class="control-label" for="sendToType"><strong>Invia a: </strong></label>
		<div class="controls">
			<label class="radio">
      			<input type="radio" name="sendToType" id="sendToType" value="0" onclick="$('#selectDest').css('display', 'block');" checked>
      			Destinatari specifici
    		</label>
    		<label class="radio">
    			<input type="radio" name="sendToType" id="sendToType" value="1" onclick="$('#selectDest').css('display', 'none');">
    			A tutti gli utenti
   			</label>
    		<label class="radio">
    			<input type="radio" name="sendToType" id="sendToType" value="4" onclick="$('#selectDest').css('display', 'none');">
    			A tutti gli utenti con quota non versata (<?php echo $no_quota_count; ?>)
   			</label>
    		<label class="radio">
    			<input type="radio" name="sendToType" id="sendToType" value="5" onclick="$('#selectDest').css('display', 'none');">
    			A tutti gli utenti con liberatoria non firmata (<?php echo $no_firma_count; ?>)
   			</label>
    		<label class="radio">
    			<input type="radio" name="sendToType" id="sendToType" value="2" onclick="$('#selectDest').css('display', 'none');">
    			A tutti i programmi
   			</label>
    		<label class="radio">
    			<input type="radio" name="sendToType" id="sendToType" value="3" onclick="$('#selectDest').css('display', 'none');">
    			Al direttivo
   			</label>
		</div>
	</div>
	<div class="control-group" id="selectDest">
		<label class="control-label" for="inputDestinatari"><strong>Destinatari: </strong></label>
		<div class="controls">
			<input type="text" id="inputDestinatari" style="width: 450px;" name="destinatari">
		</div>
	</div>
	<div class="control-group">
		<label class="control-label" for="oggetto"><strong>Oggetto: </strong></label>
		<div class="controls">
			<input type="text" id="oggetto" style="width: 450px;" name="oggetto">
		</div>
	</div>
	<div class="control-group">
		<label class="control-label" for="messaggio"><strong>Messaggio: </strong></label>
		<div class="controls">
			<textarea id="messaggio" style="width: 450px; height: 120px;" name="messaggio"></textarea>
		</div>
	</div>
	<div class="control-group">
		<div class="controls">
			<label class="checkbox">
        		<input type="checkbox" name="sendtelegram" checked> Invia notifica anche via telegram
      		</label>
		<label class="checkbox">
        		<input type="checkbox" name="sendemail"> Invia notifica anche via email
      		</label>
			<button type="submit" class="btn btn-primary">Invia</button>
		</div>
	</div>
</form>

<?php
$allUsers = Utenti::all(array('select' => 'id, nome, cognome', 'conditions' => 'attivo = 2'));
$allPrograms = Programmi::all(array('select' => 'id, nome'));
?>
<script type="text/javascript">
	var $tags = [<?php foreach($allUsers as $user) { ?>{type: 'user', value: '0:<?php echo $user->id; ?>', text: '<?php echo str_replace("'", "\'", hfix($user->nome." ".$user->cognome)); ?>'}, <?php } 
		foreach($allPrograms as $program) { ?>{type: 'program', value: '1:<?php echo $program->id; ?>', text: '<?php echo str_replace("'", "\'", hfix($program->nome)); ?>'}, <?php } ?>];
</script>
