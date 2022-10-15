/*
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
});
$('#inputTags').on('itemAdded', function(event) {
  $('#tagsLabel').html('Tags ('+$(this).tagsinput('items').length+'/5):');
});
$('#inputTags').on('itemRemoved', function(event) {
  $('#tagsLabel').html('Tags ('+$(this).tagsinput('items').length+'/5):');
});

if(typeof add_tags !== "undefined") {
	tagsToAdd = add_tags.split(',');
	for(var i = 0; i < tagsToAdd.length; i++) {
		$('#inputTags').tagsinput('add', tagsToAdd[i]);
	}
}
*/