<ul class="breadcrumb">
	<li><a href="<?php echo $this->base_url; ?>">Home</a> <span class="divider">/</span></li>
	<li><a href="<?php echo $this->base_url; ?>programs.php">Statistiche Programmi</a> <span class="divider">/</span></li>
	<?php if($list >= 0) { ?>
	<li><a href="<?php echo $this->base_url.'programs.php?list='.$list; ?>"><?php echo $activePage; ?></a> <span class="divider">/</span></li>
	<?php } ?>
	<li class="active">Nuovo Programma</li>
</ul>
<div class="span2">
</div>
<div class="span7">
<?php if(isset($errors)) { ?>
<div class="alert alert-danger">
	<button type="button" class="close" data-dismiss="alert">&times;</button>
	<?php foreach($errors as $error) {
		echo $error.'<br>';
	}
	?>
</div>
<?php } ?>
	<form method="post">
		<div class="form-horizontal">
			<div class="control-group">
				<label class="control-label" for="inputNome"><strong>Nome programma:</strong></label>
				<div class="controls">
					<input class="input-big" name="nome" type="text" id="inputNome" placeholder="Nome programma" value="<?php if(isset($_POST['nome'])) echo hfix($_POST['nome']); ?>">
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputTag"><strong>Tag programma:</strong></label>
				<div class="controls">
					<input class="input-big" name="tag" type="text" id="inputTag" placeholder="Tag programma" value="<?php if(isset($_POST['tag'])) echo hfix($_POST['tag']); ?>">
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputDescrizione"><strong>Descrizione:</strong></label>
				<div class="controls">
					<textarea class="input-big" name="descrizione" id="inputDescrizione" placeholder="Descrizione"><?php if(isset($_POST['descrizione'])) echo hfix($_POST['descrizione']); ?></textarea>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputDescrizioneLunga"><strong>Descrizione Lunga:</strong></label>
				<div class="controls">
					<textarea class="input-big" name="descrizionelunga" id="inputDescrizioneLunga" placeholder="Descrizione Lunga"><?php if(isset($_POST['descrizionelunga'])) echo hfix($_POST['descrizionelunga']); ?></textarea>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputEmail"><strong>Email:</strong></label>
				<div class="controls">
					<input class="input-big" name="email" type="text" id="inputEmail" placeholder="Email" value="<?php if(isset($_POST['email'])) echo hfix($_POST['email']); ?>">
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputFacebook"><strong>Link pagina facebook:</strong></label>
				<div class="controls">
					<input class="input-big" name="facebook" type="text" id="inputFacebook" placeholder="https://www.facebook.com/PaginaProgramma" value="<?php if(isset($_POST['facebook'])) echo hfix($_POST['facebook']); ?>">
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputInstagram"><strong>Link pagina instagram:</strong></label>
				<div class="controls">
					<input class="input-big" name="instagram" type="text" id="inputInstagram" placeholder="https://www.instagram.com/PaginaProgramma" value="<?php if(isset($_POST['instagram'])) echo hfix($_POST['instagram']); ?>">
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputTwitter"><strong>Link profilo twitter:</strong></label>
				<div class="controls">
					<input class="input-big" name="twitter" type="text" id="inputTwitter" placeholder="https://twitter.com/ProfiloProgramma" value="<?php if(isset($_POST['twitter'])) echo hfix($_POST['twitter']); ?>">
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputYoutube"><strong>Link account youtube:</strong></label>
				<div class="controls">
					<input class="input-big" name="youtube" type="text" id="inputYoutube" placeholder="https://www.youtube.com/user/AccountProgramma" value="<?php if(isset($_POST['youtube'])) echo hfix($_POST['youtube']); ?>">
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputMixcloud"><strong>Link account mixcloud:</strong></label>
				<div class="controls">
					<input class="input-big" name="mixcloud" type="text" id="inputMixcloud" placeholder="http://www.mixcloud.com/NomeProgramma" value="<?php if(isset($_POST['mixcloud'])) echo hfix($_POST['mixcloud']); ?>">
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputSpotifyDirect"><strong>Link diretto playlist spotify:</strong></label>
				<div class="controls">
					<input class="input-big" name="spotifyDirect" type="text" id="inputSpotifyDirect" placeholder="spotify:user:poliradio:playlist:..." value="<?php if(isset($_POST['spotifyDirect'])) echo hfix($_POST['spotifyDirect']); ?>">
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputSpotifyHTTP"><strong>Link HTTP playlist spotify:</strong></label>
				<div class="controls">
					<input class="input-big" name="spotifyHTTP" type="text" id="inputSpotifyHTTP" placeholder="https://open.spotify.com/user/poliradio/playlist/..." value="<?php if(isset($_POST['spotifyHTTP'])) echo hfix($_POST['spotifyHTTP']); ?>">
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputStatus"><strong>Stato:</strong></label>
				<div class="controls">
					<select name="status" id="inputStatus" class="select-big">
						<option value=""></option>
						<option value="0"<?php if(isset($_POST['status'])) { if($_POST['status'] == 0) echo ' selected'; } ?>>Attivo e Visibile</option>
						<option value="1"<?php if(isset($_POST['status'])) { if($_POST['status'] == 1) echo ' selected'; } ?>>Attivo e non Visibile</option>
						<option value="2"<?php if(isset($_POST['status'])) { if($_POST['status'] == 2) echo ' selected'; } ?>>Non Attivo e Visibile</option>
						<option value="3"<?php if(isset($_POST['status'])) { if($_POST['status'] == 3) echo ' selected'; } ?>>Disabilitato</option>
					</select>
				</div>
			</div>
			<div class="control-group">
				<div class="controls">
					<button type="submit" class="btn btn-primary btn-medium">Crea Programma</button>
				</div>
			</div>
		</div>
	</form>
</div>
