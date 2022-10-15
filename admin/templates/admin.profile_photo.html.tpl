<div id="output"></div>
<div class="span2"></div>
<div class="span6">
	<form method="post" enctype="multipart/form-data" id="MyUploadForm" class="form-horizontal span6">
	<center>
		<h3>Modifica Foto</h3>
		<img src="<?php echo $foto; ?>" style="max-width: 450px;" id="foto" class="img-polaroid"><br><br>
		<a class="btn btn-info" href="#" onclick="rotate_myimg(-90);"><i class="icon-repeat"></i><i class="icon-arrow-left"></i></a>
		<a class="btn btn-info" href="#" onclick="rotate_myimg(180);"><i class="icon-repeat"></i><i class="icon-arrow-down"></i></a>
		<a class="btn btn-info" href="#" onclick="rotate_myimg(90);"><i class="icon-repeat"></i><i class="icon-arrow-right"></i></a>
	</center>
	<br>
	<div class="control-group">
		<label class="control-label" for="FileInput"><strong>Foto:</strong></label>
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
		$.get('<?php echo $this->base_url; ?>rotator.php', {'rot': deg}, function(data){
			var myimg = $('#foto').attr('src');
			$('#foto').attr('src', myimg+'?'+Math.floor((Math.random()*1000)+1));
		});
	}
	function afterSuccess() {
		$('#submit-btn').show();
		$('#loading-img').hide();
		$('#uploadProgress').delay( 1000 ).fadeOut();
		var photo = $('#foto').attr('src');
		if(photo.search('base64') >= 0) {
			$.get('<?php echo $this->base_url; ?>rotator.php?urlOf', function(data){
				if(data.search('base64') == -1) {
					$('#foto').attr('src', data);
				}
			});
		}
		else {
			$('#foto').attr('src', photo+'?rand='+ Math.random());
		}
		$('#foto').show();
	}
</script>