<ul class="breadcrumb">
	<li><a href="<?php echo $this->base_url; ?>">Home</a> <span class="divider">/</span></li>
	<li><a href="<?php echo $this->base_url; ?>programs.php"><?php echo hfix($program->nome); ?></a> <span class="divider">/</span></li>
	<li class="pull-right"><a href="<?php echo $this->base_url.'programs.php?s'; ?>" class="btn btn-success btn-mini"><i class="icon-user"></i> Membri</a></li>
	<li class="active">Modifica Programma</li>
</ul>

<?php /* ?>
<ul id="myTab" class="nav nav-tabs">
	<li class="active"><a href="#info" data-toggle="tab">Info</a></li>
	<li><a href="#logo_tab" data-toggle="tab">Logo</a></li>
</ul>
<?php */ ?>

<div id="myTabContent" class="tab-content">
	<div class="tab-pane fade in active" id="info">
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
			<?php if(count($_POST) > 0 && !isset($errors)) { ?>
			<div class="alert alert-success">
				<button type="button" class="close" data-dismiss="alert">&times;</button>
				Programma modificato con successo!
			</div>
			<?php } ?>
			<form method="post">
				<div class="form-horizontal">
					<div class="control-group">
						<label class="control-label" for="inputDescrizione"><strong>Descrizione:</strong></label>
						<div class="controls">
							<textarea class="input-big" name="descrizione" id="inputDescrizione" placeholder="Descrizione"><?php echo hfix($program->descrizione); ?></textarea>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="inputDescrizioneLunga"><strong>Descrizione Lunga:</strong></label>
						<div class="controls">
							<textarea class="input-big" name="descrizionelunga" id="inputDescrizioneLunga" placeholder="Descrizione Lunga"><?php echo hfix($program->descrizionelunga); ?></textarea>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="inputEmail"><strong>Email:</strong></label>
						<div class="controls">
							<input class="input-big" name="email" type="text" id="inputEmail" placeholder="Email" value="<?php echo hfix($program->email); ?>">
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="inputFacebook"><strong>Link pagina facebook:</strong></label>
						<div class="controls">
							<input class="input-big" name="facebook" type="text" id="inputFacebook" placeholder="https://www.facebook.com/PaginaProgramma" value="<?php echo hfix($program->facebook); ?>">
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="inputInstagram"><strong>Link pagina instagram:</strong></label>
						<div class="controls">
							<input class="input-big" name="instagram" type="text" id="inputInstagram" placeholder="https://www.instagram.com/PaginaProgramma" value="<?php echo hfix($program->instagram); ?>">
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="inputTwitter"><strong>Link profilo twitter:</strong></label>
						<div class="controls">
							<input class="input-big" name="twitter" type="text" id="inputTwitter" placeholder="https://twitter.com/ProfiloProgramma" value="<?php echo hfix($program->twitter); ?>">
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="inputYoutube"><strong>Link account youtube:</strong></label>
						<div class="controls">
							<input class="input-big" name="youtube" type="text" id="inputYoutube" placeholder="https://www.youtube.com/user/AccountProgramma" value="<?php echo hfix($program->youtube); ?>">
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="inputMixcloud"><strong>Link account mixcloud:</strong></label>
						<div class="controls">
							<input class="input-big" name="mixcloud" type="text" id="inputMixcloud" placeholder="http://www.mixcloud.com/NomeProgramma" value="<?php echo hfix($program->mixcloud); ?>">
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="inputSpotifyDirect"><strong>Link diretto playlist spotify:</strong></label>
						<div class="controls">
							<input class="input-big" name="spotifyDirect" type="text" id="inputSpotifyDirect" placeholder="spotify:user:poliradio:playlist:..." value="<?php echo hfix($program->spotifydirect); ?>">
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="inputSpotifyHTTP"><strong>Link HTTP playlist spotify:</strong></label>
						<div class="controls">
							<input class="input-big" name="spotifyHTTP" type="text" id="inputSpotifyHTTP" placeholder="https://open.spotify.com/user/poliradio/playlist/..." value="<?php echo hfix($program->spotifylink); ?>">
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="led_color"><strong>Colore LED Studio:</strong></label>
						<div class="controls">
							<input class="input-big colorpicker" name="led_color" type="text" id="led_color" placeholder="" value="<?php echo hfix($program->led_color); ?>">
						</div>
					</div>
					<div class="control-group">
						<div class="controls">
							<button type="submit" class="btn btn-primary btn-medium"><i class="icon-ok"></i> Salva</button>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
	<?php /*
	<div class="tab-pane fade in" id="logo_tab">
		<div class="span2"></div>
		<div class="span6">
			<form method="post" enctype="multipart/form-data" id="MyUploadForm" class="form-horizontal span6">
				<div id="output"></div>
				<center>
					<h3>Modifica Logo</h3>
				<img src="<?php echo $program->logo != '' ? $this->base_url.'../'.$program->logo : 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIwAAACMCAIAAAAhotZpAAAACXBIWXMAAAsSAAALEgHS3X78AAABWUlEQVR42u3RQQ0AIAzAwPkXiwYk7AlN7hQ06Ry+N68D2JkUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFLABZMilhyJuwqMAAAAAElFTkSuQmCC'; ?>" style="max-width: 450px;" id="logo" class="img-polaroid"><br><br>
					<a class="btn btn-info" href="#" onclick="rotate_myimg(-90);"><i class="icon-repeat"></i><i class="icon-arrow-left"></i></a>
					<a class="btn btn-info" href="#" onclick="rotate_myimg(180);"><i class="icon-repeat"></i><i class="icon-arrow-down"></i></a>
					<a class="btn btn-info" href="#" onclick="rotate_myimg(90);"><i class="icon-repeat"></i><i class="icon-arrow-right"></i></a>
				</center>
				<br>
				<div class="control-group">
					<label class="control-label" for="FileInput"><strong>Logo:</strong></label>
					<div class="controls">
						<input name="FileInput" id="FileInput" type="file" />
					</div>
				</div>
				<div class="control-group">
					<div class="controls">
						<input type="submit" id="submit-btn" class="btn btn-info btn-small" value="Upload" />
					</div>
				</div>
				<div class="control-group" id="uploadProgress" style="display: none;">
			    	<div class="progress progress-striped active">
			    		<div class="bar" style="width: 0%;" id="progressbar">0%</div>
			    	</div>
				</div>
			</form>
		</div>
		<script type="text/javascript">
			function rotate_myimg(deg){
				$.get('<?php echo $this->base_url; ?>rotator.php', {'rot': deg, 'p':'<?php echo $program->id; ?>'}, function(data){
					var myimg = $('#logo').attr('src');
					$('#logo').attr('src', myimg+'?'+Math.floor((Math.random()*1000)+1));
				});
			}
			function afterSuccess() {
				$('#submit-btn').show();
				$('#loading-img').hide();
				$('#uploadProgress').delay( 1000 ).fadeOut();
				var photo = $('#logo').attr('src');
				if(photo.search('base64') >= 0) {
					$.get('<?php echo $this->base_url; ?>rotator.php?purlOf=<?php echo $program->id; ?>', function(data){
						if(data.search('base64') == -1) {
							$('#logo').attr('src', data);
						}
					});
				}
				else {
					$('#logo').attr('src', photo+'?rand='+ Math.random());
				}
				$('#logo').show();
			}
		</script>
	</div>
	<?php */ ?>
</div>
