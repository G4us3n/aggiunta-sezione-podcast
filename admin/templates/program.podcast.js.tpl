$(document).on("click", ".deletePodcast", function() {
	var $id = $(this).data('id');
	var $titolo = $(this).data('titolo');
	$('#delete_podcast').val($id);
	$('#delete_text').html('Sei sicuro di voler eliminare il podcast #'+$id+' \'<b>'+$titolo+'</b>\' ?');
	$('#modalDeletePodcast').modal({show: true});
});

$(document).on("click", ".changeVisibility", function() {
	var $statusName = ["visibile", "non visibile"];
	var $id = $(this).data('id');
	var $status = $(this).data('status');
	var $titolo = $(this).data('titolo');
	$('#change_visibility').val($id);
	$('#change_visibility_text').html('Impostare il podcast #'+$id+' \'<b>'+$titolo+'</b>\' come '+$statusName[$status]+'?');
	$('#modalEditVisibility').modal({show: true});
});