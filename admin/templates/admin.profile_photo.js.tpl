$(document).ready(function() { 
	var alertErrorHTML = '<div class="alert alert-block alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>';
	var options = { 
		target:   '#output',
		beforeSubmit:  beforeSubmit,
		success:       afterSuccess,
		uploadProgress: OnProgress,
		resetForm: true
	}; 
		
	 $('#MyUploadForm').submit(function() { 
		$(this).ajaxSubmit(options);  			
		return false; 
	}); 
		
	function beforeSubmit(){
    	if (window.File && window.FileReader && window.FileList && window.Blob) {
			if( !$('#FileInput').val()) {
				$("#output").html(alertErrorHTML+'Errore!</div>');
				return false;
			}
			
			var fsize = $('#FileInput')[0].files[0].size;
			var ftype = $('#FileInput')[0].files[0].type;
	
			switch(ftype) {
	            case 'image/png': 
				case 'image/gif': 
				case 'image/jpeg': 
				case 'image/pjpeg':
				case 'text/plain':
				case 'text/html':
				case 'application/x-zip-compressed':
				case 'application/pdf':
				case 'application/msword':
				case 'application/vnd.ms-excel':
				case 'audio/mpeg':
				case 'video/mp4':
	                break;
	            default:
	                $("#output").html(alertErrorHTML+" <b>"+ftype+"</b> Formato non supportato!</div>");
					return false;
	        }
		
			if(fsize>10485760) {
				$("#output").html(alertErrorHTML+" <b>"+bytesToSize(fsize) +"</b> File troppo grande!</div>");
				return false;
			}
		
			$('#submit-btn').hide();
			$('#loading-img').show();
			$('#foto').hide();
			$("#output").html("");  
		}
		else {
			$("#output").html(alertErrorHTML+" Funzionalit&agrave; non supportata!</div>");
			return false;
		}
	}
	
	function OnProgress(event, position, total, percentComplete) {
    	$('#uploadProgress').show();
    	$('#progressbar').width(percentComplete + '%');
    	$('#progressbar').html(percentComplete + '%');
	}
	
	function bytesToSize(bytes) {
		var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
		if (bytes == 0) {
			return '0 Bytes';
		}
		var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
		return Math.round(bytes / Math.pow(1024, i), 2) + ' ' + sizes[i];
	}
}); 