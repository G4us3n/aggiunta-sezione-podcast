<div class="modal hide fade" id="modalBBInfo">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		<h3>BB Code Info</h3>
	</div>
	<div class="modal-body form-horizontal">
		Per formattare il testo puoi usare i seguenti codici:<br><br>
		<table class="table table-hover">
			<tr>
				<td><h4>Tipo</h4></td>
				<td><h4>Codice</h4></td>
				<td><h4>Risultato</h4></td>
			</tr>
			<tr>
				<td>Grassetto:</td>
				<td>[b]Testo[/b]</td>
				<td><strong>Testo</strong></td>
			</tr>
			<tr>
				<td>Corsivo:</td>
				<td>[i]Testo[/i]</td>
				<td><em>Testo</em></td>
			</tr>
			<tr>
				<td>Sottolineato:</td>
				<td>[u]Testo[/u]</td>
				<td><u>Testo</u></td>
			</tr>
			<tr>
				<td>Link personalizzato:</td>
				<td>[url=http://www.sito.com/link]Collegamento[/url]</td>
				<td><a href="http://www.sito.com/link">Collegamento</a></td>
			</tr>
			<tr>
				<td>Link con URL visibile:</td>
				<td>[url]http://www.sito.com/link[/url]</td>
				<td><a href="http://www.sito.com/link">www.sito.com/link</a></td>
			</tr>
		</table><br>
		Puoi anche combinarli tra loro per ottenere pi&ugrave; effetti.<br>
		Esempio: [b][u][i]Testo[/i][/u][/b] -&gt; <strong><u><em>Testo</em></u></strong>
	</div>
	<div class="modal-footer">
		<a href="#" data-dismiss="modal" class="btn btn-info">Ok</a>
	</div>
</div>
<div class="modal hide fade" id="modalAddMedia">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		<h3>Aggiungi Media</h3>
	</div>
	<div class="modal-body form-horizontal">
		<div class="control-group">
			<label class="control-label" for="mediaType"><strong>Tipo:</strong></label>
			<div class="controls">
				<select id="mediaType" class="input-small">
					<option value="youtube" onclick="$('#mediaUrl').attr('placeholder', 'https://www.youtube.com/watch?v=URLID');">Youtube</option>
					<option value="vimeo" onclick="$('#mediaUrl').attr('placeholder', 'https://vimeo.com/URLID');">Vimeo</option>
					<option value="soundcloud" onclick="$('#mediaUrl').attr('placeholder', 'https://soundcloud.com/URL');">SoundCloud</option>
					<option value="anchor" onclick="$('#mediaUrl').attr('placeholder', 'https://anchor.fm/');">Anchor</option>
				</select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label" for="mediaUrl"><strong>Url:</strong></label>
			<div class="controls">
				<input type="text" id="mediaUrl" class="input-big" placeholder="http://www.youtube.com/watch?v=URLID">
			</div>
		</div>
	</div>
	<div class="modal-footer">
		<a href="#" data-dismiss="modal" class="btn">Annulla</a>
		<a href="#" id="mediaAdder" data-dismiss="modal" class="btn btn-primary">Aggiungi</a>
	</div>
</div>

<div class="modal hide fade" id="modalFotoManager">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		<h3>Seleziona Immagine</h3>
	</div>
	<div class="modal-body">
		<ul id="myTab" class="nav nav-tabs">
			<li class="active"><a href="#allFoto" data-toggle="tab">Libreria Immagini</a></li>
			<li><a href="#uploadFoto" data-toggle="tab">Carica Immagine</a></li>
		</ul>
		<div id="myTabContent" class="tab-content">
			<div class="tab-pane fade in active" id="allFoto">
				
			</div>
			<div class="tab-pane fade" id="uploadFoto">
				<div id="output"></div>
				<form method="post" enctype="multipart/form-data" id="MyUploadForm" class="form-horizontal span6">
					<div class="control-group">
						<label class="control-label" for="FileInput"><strong>Immagine:</strong></label>
						<div class="controls">
							<input name="FileInput" id="FileInput" type="file" />
						</div>
						<div>
							Ehi, puoi trovare immagini prive di copyright al seguente link ;)<br />
							<a href="https://unsplash.com/">Unsplash</a>
						</div>
					</div>
					<div class="control-group">
						<div class="controls">
							<input type="submit" id="submit-btn" class="btn btn-primary btn-medium" value="Carica" />
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
	<div class="modal-footer">
		<div class="control-group" id="uploadProgress" style="display: none;">
	    	<div class="progress progress-striped active">
	    		<div class="bar" style="width: 0%;" id="progressbar">0%</div>
	    	</div>
		</div>
	</div>
</div>

<ul class="breadcrumb">
	<li><a href="<?php echo $this->base_url; ?>">Home</a> <span class="divider">/</span></li>
	<li><a href="<?php echo $this->base_url; ?>news.php">News (<?php echo $count; ?>)</a> <span class="divider">/</span></li>
	<li class="active">Nuova News</li>
</ul>
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
				<label class="control-label" for="inputTitolo"><strong>Titolo:</strong></label>
				<div class="controls">
					<input class="input-big" name="titolo" type="text" id="inputTitolo" placeholder="Titolo" value="<?php if(isset($_POST['titolo'])) echo hfix($_POST['titolo']); ?>">
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputSottotitolo"><strong>Sottotitolo:</strong></label>
				<div class="controls">
					<input class="input-big" name="sottotitolo" type="text" id="inputSottotitolo" placeholder="Sottotitolo" value="<?php if(isset($_POST['sottotitolo'])) echo hfix($_POST['sottotitolo']); ?>">
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputFoto"><strong>Immagine Copertina:</strong></label>
				<div class="controls">
					<a href="<?php echo !isset($_POST['foto']) ? '#' : $path.'/'.hfix($_POST['foto']); ?>" id="selectedPhotoHref"<?php if(isset($_POST['foto'])) echo ' target="_BLANK"'; ?>><img src="<?php echo !isset($_POST['foto']) ? 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIwAAACMCAIAAAAhotZpAAAACXBIWXMAAAsSAAALEgHS3X78AAABWUlEQVR42u3RQQ0AIAzAwPkXiwYk7AlN7hQ06Ry+N68D2JkUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFLABZMilhyJuwqMAAAAAElFTkSuQmCC' : $path.'/'.hfix($_POST['foto']); ?>" id="selectedPhoto" class="img-polaroid" style="width: 140px; height: 140px;"></a>
					<a id="modalFotoManagerOpen" href="#modalFotoManager" data-toggle="modal" class="btn btn-medium btn-primary" style="position: relative; left: 50px;">Seleziona</a>
					<input name="foto" id="inputFoto" value="<?php if(isset($_POST['foto'])) echo hfix($_POST['foto']); ?>" type="hidden" />
				</div>
			</div>
			<div class="control-group">
                <label class="control-label" for="inputAlignment"><strong>Allineamento verticale in news:</strong></label>
                <div class="controls">
                        <select name="cover_alignment" id="inputAlignment">
                                <option value="top"<?php echo isset($_POST['cover_alignment']) ? ($_POST['cover_alignment'] == 'top' ? ' SELECTED' : '') : ''; ?>>In Alto</option>
                                <option value="center"<?php echo isset($_POST['cover_alignment']) ? ($_POST['cover_alignment'] == 'center' ? ' SELECTED' : '') : ''; ?>>Centrale</option>
                                <option value="bottom"<?php echo isset($_POST['cover_alignment']) ? ($_POST['cover_alignment'] == 'bottom' ? ' SELECTED' : '') : ''; ?>>In Basso</option>
                        </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputHomeAlignment"><strong>Allineamento verticale in home:</strong></label>
                <div class="controls">
                        <select name="home_alignment" id="inputHomeAlignment">
                                <option value="top"<?php echo isset($_POST['home_alignment']) ? ($_POST['home_alignment'] == 'top' ? ' SELECTED' : '') : ''; ?>>In Alto</option>
                                <option value="center"<?php echo isset($_POST['home_alignment']) ? ($_POST['home_alignment'] == 'center' ? ' SELECTED' : '') : ''; ?>>Centrale</option>
                                <option value="bottom"<?php echo isset($_POST['home_alignment']) ? ($_POST['home_alignment'] == 'bottom' ? ' SELECTED' : '') : ''; ?>>In Basso</option>
                        </select>
                </div>
            </div>
			<div class="control-group">
				<label class="control-label" for="inputContenuto"><strong>Contenuto:</strong><br><a class="btn btn-mini btn-info" href="#modalBBInfo" data-toggle="modal"><i class="icon-info-sign"></i></a></label>
				<div class="controls">
					<textarea class="input-big" name="testo" id="inputContenuto" placeholder="Contenuto" style="height: 250px;"><?php if(isset($_POST['testo'])) echo hfix($_POST['testo']); ?></textarea>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputMedia"><strong id="mediaLabel">Media (0/8):</strong>
					<a href="#" id="modalAddMediaOpen" class="btn btn-link"><i class="icon-plus"></i></a></label>
				<div class="controls">
					<input type="hidden" id="media" name="media">
					<div id="allMedia"></div>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputTags"><strong id="tagsLabel">Tags (0/5):</strong></label>
				<div class="controls">
					<div id="tagError"></div>
					<input data-role="tagsinput" type="text" name="tags" id="inputTags">
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="metaDescription"><strong>Meta Tag 'Description':</strong></label>
				<div class="controls">
					<select name="metatype" id="metaDescription" class="select-big">
						<option value="0"<?php if(isset($_POST['metatype'])) { if($_POST['metatype'] == 0) echo ' selected'; } ?>>Sottotitolo</option>
						<option value="1"<?php if(isset($_POST['metatype'])) { if($_POST['metatype'] == 1) echo ' selected'; } ?>>Testo</option>
					</select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputVisibile"><strong>Visibile:</strong></label>
				<div class="controls">
					<select name="visibile" id="inputVisibile" class="select-big">
						<option value="1"<?php if(isset($_POST['visibile'])) { if($_POST['visibile'] == 1) echo ' selected'; } ?>>Visibile</option>
						<option value="0"<?php if(isset($_POST['visibile'])) { if($_POST['visibile'] == 0) echo ' selected'; } ?>>Non Visibile</option>
					</select>
				</div>
			</div>
            <div class="control-group">
				<label class="control-label" for="inputCopyright"><strong>Copyright:</strong></label>
				<div class="controls">
					<select name="copyright" id="inputCopyright" class="select-big">
						<option value="1"<?php if(isset($_POST['copyright'])) { if($_POST['copyright'] == 1) echo ' selected'; } ?>>Si</option>
						<option value="0"<?php if(isset($_POST['copyright'])) { if($_POST['copyright'] == 0) echo ' selected'; } ?>>No</option>
					</select>
				</div>
			</div>
			<div class="control-group">
				<div class="controls">
					<button type="submit" class="btn btn-primary btn-medium">Crea News</button>
				</div>
			</div>
		</div>
	</form>
</div>
<?php $path = $program == null ? 'redazione' : $program->tag; ?>
<script type="text/javascript">
	var $tags = <?php echo $allTags; ?>;
	var $tags_banned = <?php echo $allProgramTags; ?>;
<?php if(isset($_POST['tags'])) { ?>
	var add_tags = "<?php echo hfix($_POST['tags']); ?>";
<?php } ?>
	var $abs_url = '<?php echo $this->base_url;?>';
<?php if(isset($_POST['media']) && !empty($_POST['media'])) { ?>
	mediaObj = <?php echo $_POST['media']; ?>;
<?php } ?>
	function afterSuccess(returnObj) {
		$('#output').html(returnObj.html);
		if(returnObj.hasOwnProperty('name')) {
			setCopertina(returnObj.name);
		}
		$('#submit-btn').show();
		$('#uploadProgress').delay(1000).fadeOut();
	}

	function setCopertina(img) {
		$('#selectedPhotoHref').attr('href', $abs_url+'../photos/news/<?php echo $path;?>/'+img);
		$('#selectedPhotoHref').attr('target', '_BLANK');
		$('#selectedPhoto').attr('src', $abs_url+'../photos/news/<?php echo $path;?>/thumbs/'+img);
		$('#inputFoto').val(img);
		$('#modalFotoManagerOpen').html('Cambia');
		$('#modalFotoManager').modal('hide');
	}

	function openImage(img) {
		var imgViewer = window.open($abs_url+'../photos/news/<?php echo $path;?>/'+img);
		imgViewer.focus();
	}
</script>

<div id="delImgConfirmModal" class="modal hide fade" tabindex="-1" data-focus-on="input:first">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		<h3>Cancella immagine</h3>
	</div>
	<input type="hidden" id="imgDelValue">
	<div class="modal-body" id="imgDelBody">
	</div>
	<div class="modal-footer">
		<button type="button" data-dismiss="modal" class="btn">No</button>
		<button type="button" class="btn btn-danger confirmDeleteImage" data-dismiss="modal">Si</button>
	</div>
</div>
<script type="text/javascript">program_tag_img_list = '<?php echo $path; ?>';</script>
