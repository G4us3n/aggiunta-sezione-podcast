$(document).ready(function() { 
	var alertErrorHTML = '<div class="alert alert-block alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>';
	var options = { 
		dataType: 'json',
		beforeSubmit:  beforeSubmit,
		success:       afterSuccess,
		uploadProgress: OnProgress,
		resetForm: true
	}; 
		
	 $('#MyUploadForm').submit(function() { 
		$(this).ajaxSubmit(options);  			
		return false; 
	}); 
		
	$('#modalFotoManagerOpen').click(function() {
		$.get('news.php?imgList&tag='+program_tag_img_list, function(data) {
			$('#allFoto').html(data);
		});
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
			$("#output").val('');  
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
$('#inputTags').tagsinput({
  maxTags: 5,
  maxChars: 25,
  trimValue: true,
  typeahead: {
    source: $tags
  },
  freeInput: true
});
$('#inputTags').on('beforeItemAdd', function(event) {
	if($tags_banned.indexOf(event.item) != -1) {
		event.cancel = true;
		$('#tagError').html('<div class="alert"><button type="button" class="close" data-dismiss="alert">&times;</button>Questo tag non pu&ograve; essere utilizzato!</div>');
	}
	if((event.item).toLowerCase() == 'poliradio' || (event.item).toLowerCase() == 'poli.radio') {
		event.cancel = true;
		$('#tagError').html('<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Cazzo metti come tag poliradio, coglione? cazzo di valore aggiunto da? un cazzo di niente.</div>');
	}
});
$('#inputTags').on('itemAdded', function(event) {
  $('#tagsLabel').html('Tags ('+$(this).tagsinput('items').length+'/5):');
});
$('#inputTags').on('itemRemoved', function(event) {
  $('#tagsLabel').html('Tags ('+$(this).tagsinput('items').length+'/5):');
});

if(typeof mediaObj === "undefined") {
	var mediaObj = {firstID: 0, count: 0, media: {}};
} else {
	printAllMedia();
	updateMediaInput();
}

if(typeof add_tags !== "undefined") {
	tagsToAdd = add_tags.split(',');
	for(var i = 0; i < tagsToAdd.length; i++) {
		$('#inputTags').tagsinput('add', tagsToAdd[i]);
	}
}

if(typeof podcasts !== "undefined") {
	printAllPodcasts();
}

$('#modalAddMediaOpen').click(function() {
	if(mediaObj.count < 8) {
		$('#modalAddMedia').modal({show: true});
	}
});

$('#mediaAdder').click(function() {
	addMedia($('#mediaType').val(), $('#mediaUrl').val());
});

$(function(){
    $.contextMenu({
        selector: '.rightClickBinder', 
        callback: function(key, options) {
        	switch(key) {
        		case 'select':
        			setCopertina($(this).data('name'));
        			break;
        		case 'view':
        			openImage($(this).data('name'));
        			break;
        		case 'delete':
    				$('#imgDelBody').html('<img style="float: left; margin: 0px 15px 15px 0px;" src="'+$(this).attr('src')+'" class="img-polaroid">Vuoi eliminare questa immagine dall\'archivio immagini del programma?<br>Questa operazione &egrave; <strong>permanente</strong> e <strong>non pu&ograve; essere annullata</strong>.');
    				$('#imgDelValue').val($(this).data('name'));
    				$('#delImgConfirmModal').modal('show');
    				break;
           	} 
        },
        items: {
            "select": {name: "Seleziona", icon: "select"},
            "view": {name: "Visualizza", icon: "view" },
            "delete": {name: "Cancella", icon: "trash"},
            "sep1": "---------",
            "quit": {name: "Chiudi"}
        }
    });
});

$(document).on('click', '.confirmDeleteImage', function(event){
	$.get('news.php?delImg='+$('#imgDelValue').val(), function(data){
		$('#allFoto').html(data);
	});
});

$(document).on('click', '.confirmAddPodcast', function(event){
	$.get('news.php?edit='+newsID+'&a='+$('#addPodcastID').val(), function(data){
		data = JSON.parse(data);
		if(data.message != 'ok') {
			$('#addPodcastBody').html('<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button><strong>Errore:</strong>'+data.message+'</div>'+$('#addPodcastBody').html());
		} else {
			podcasts = data.podcasts;
			printAllPodcasts();
		}
	});
});

$(document).on('click', '.confirmDeletePodcast', function(event){
	$.get('news.php?edit='+newsID+'&d='+$('#removePodcastId').val(), function(data){
		data = JSON.parse(data);
		if(data.message != 'ok') {
			$('#removepodcastbody').html('<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button><strong>Errore:</strong>'+data.message+'</div>');
		} else {
			podcasts = data.podcasts;
			printAllPodcasts();
		}
	});
});

$(document).on('click', '.rightClickBinder', function(event){
	setCopertina($(this).data('name'));
});

function addMedia(mediaType, mediaUrl) {
	if(mediaObj.count >= 8) {
		return;
	}
	var url = null;
	if(mediaType == 'youtube') {
		url = mediaUrl.split('v=');
		url = url[1].split('&');
		url = url[0];
	} else if(mediaType == 'vimeo') {
		url = mediaUrl.split('/');
		url = url[url.length-1];
	} else if(mediaType == 'soundcloud') {
		//url = mediaUrl.split('tracks/');
		//url = url[1].split('&amp');
		//url = url[0];
		url = null;
		$.ajax({
  			type: 'POST',
  			url: '/getSoundcloud.php',
  			data: {'url': mediaUrl},
  			success: function(data){
				url = data;
			},
  			async: false
		});
	} else if(mediaType == 'anchor') {
		url = mediaUrl.replace('/episodes/', '/embed/episodes/');
	}
	if(url === null) {
		return;
	}
	if(mediaExists(mediaType, url)) {
		return;
	}
	var id = mediaObj.firstID+1;
	var count = mediaObj.count+1;
	mediaObj.count = count;
	mediaObj.firstID = id;
	mediaObj.media[id] = {mediaType: mediaType, mediaUrl: url};
	printAllMedia();
	updateMediaInput();
}

function updateMediaInput() {
	$('#media').val(JSON.stringify(mediaObj));
}

function removeMedia(id) {
	var count = mediaObj.count-1;
	mediaObj.count = count;
	delete mediaObj.media[id];
	printAllMedia();
	updateMediaInput();
}

function mediaExists(mediaType, mediaUrl) {
	for(var all in mediaObj.media) {
		if(mediaObj.media[all] !== null){
			var obj = mediaObj.media[all];
			if(obj.mediaType == mediaType && obj.mediaUrl == mediaUrl) {
				return true;
			}
		}
	}
	return false;
}

function moveMediaUp(id) {
	var prev = null;
	for(var all in mediaObj.media) {
		if(all == id && prev !== null && mediaObj.media[all] !== null) {
			var backup = mediaObj.media[id];
			mediaObj.media[id] = mediaObj.media[prev];
			mediaObj.media[prev] = backup;
			printAllMedia();
			updateMediaInput();
			return;
		}
		prev = all;
	}
}

function moveMediaDown(id) {
	var prev = null;
	for(var all in mediaObj.media) {
		if(prev == id && prev !== null && mediaObj.media[all] !== null) {
			var backup = mediaObj.media[all];
			mediaObj.media[all] = mediaObj.media[prev];
			mediaObj.media[prev] = backup;
			printAllMedia();
			updateMediaInput();
			return;
		}
		prev = all;
	}
}

function printAllMedia() {
	var html = '<table class="table table-hover">';
	for(var all in mediaObj.media) {
		if(mediaObj.media[all] !== null) {
			html += '<tr><td>';
			var baseurl = '';
			if(mediaObj.media[all].mediaType == 'youtube') {
				html += '<img src="'+$abs_url+'img/youtubeicon.png">';
				baseurl = 'https://www.youtube.com/watch?v='+mediaObj.media[all].mediaUrl;
			} else if(mediaObj.media[all].mediaType == 'vimeo') {
				html += '<img src="'+$abs_url+'img/vimeoicon.png">';
				baseurl = 'http://vimeo.com/'+mediaObj.media[all].mediaUrl;
			} else if(mediaObj.media[all].mediaType == 'soundcloud') {
				html += '<img src="'+$abs_url+'img/soundcloudicon.png">';
				baseurl = 'https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/'+mediaObj.media[all].mediaUrl+'&amp;color=ff5500&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false';
			} else if(mediaObj.media[all].mediaType == 'anchor') {
				html += '<img src="'+$abs_url+'img/anchor.png">';
				baseurl = mediaObj.media[all].mediaUrl.replace('/embed/', '/');
			}
			html += '</td>';
			html += '<td><a href="'+baseurl+'" target="_BLANK">'+mediaObj.media[all].mediaUrl+'</a></td>';
			html += '<td><a href="#" onclick="moveMediaUp('+all+');"><i class="icon-arrow-up"></i></a></td>';
			html += '<td><a href="#" onclick="moveMediaDown('+all+');"><i class="icon-arrow-down"></i></a></td>';
			html += '<td><a href="#" onclick="removeMedia('+all+');"><i class="icon-trash"></i></a></td>';
			html += '</tr>';
		}
	}
	html += '</table>';
	$('#allMedia').html(html);
	$('#mediaLabel').html('Media ('+mediaObj.count+'/8):');
	if(mediaObj.count >= 8) {
		$('#modalAddMediaOpen').addClass('disabled');
	} else {
		$('#modalAddMediaOpen').removeClass('disabled');
	}
}

function printAllPodcasts() {
	var html = '<table class="table table-hover">';
	for(var all in podcasts) {
		if(podcasts[all] !== null) {
			var podcast = podcasts[all];
			html += '<tr><td><a href="podcast.php?edit='+podcast.id+'" target="_BLANK">'+podcast.date+'</a></td><td><a href="#" onclick="$(\'#removepodcastbody\').html(\'Rimuovere dai podcast associati il podcast del '+podcast.date+'?\'); $(\'#removePodcastId\').val('+podcast.id+'); $(\'#delPodcastModal\').modal(\'show\');" class="button btn-small btn-danger"><i class="icon-trash"></i></a> </tr>';
		}
	}
	html += '</table>';
	$('#podcastDiv').html(html);
}
