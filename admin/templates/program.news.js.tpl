$(document).on("click", ".deleteNews", function() {
	var $id = $(this).data('id');
	var $titolo = $(this).data('titolo');
	$('#delete_news').val($id);
	$('#delete_text').html('Sei sicuro di voler eliminare la news #'+$id+' \'<b>'+$titolo+'</b>\' ?');
	$('#modalDeleteNews').modal({show: true});
});

$(document).on("click", ".changeVisibility", function() {
	var $statusName = ["visibile", "non visibile"];
	var $id = $(this).data('id');
	var $status = $(this).data('status');
	var $titolo = $(this).data('titolo');
	$('#change_visibility').val($id);
	$('#change_visibility_text').html('Impostare la news #'+$id+' \'<b>'+$titolo+'</b>\' come '+$statusName[$status]+'?');
	$('#modalEditVisibility').modal({show: true});
});

$(document).on("click", ".changeCopyright", function() {
	var $statusName = ["Si", "No"];
	var $id = $(this).data('id');
	var $status = $(this).data('status');
	var $titolo = $(this).data('titolo');
	$('#change_copyright').val($id);
	$('#change_copyright_text').html('Impostare il copyright della news #'+$id+' \'<b>'+$titolo+'</b>\' come '+$statusName[$status]+'?');
	$('#modalEditCopyright').modal({show: true});
});
