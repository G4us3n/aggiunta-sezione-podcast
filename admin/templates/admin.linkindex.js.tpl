$(document).on("click", ".deleteLink", function() {
	var $id = $(this).data('id');
	var $titolo = $(this).data('titolo');
	$('#delete_link').val($id);
	$('#delete_text').html('Sei sicuro di voler eliminare il link #'+$id+' \'<b>'+$titolo+'</b>\' ?');
	$('#modalDeleteLink').modal({show: true});
});

$(document).on("click", ".changeVisibility", function() {
	var $statusName = ["visibile", "non visibile"];
	var $id = $(this).data('id');
	var $status = $(this).data('status');
	var $titolo = $(this).data('titolo');
	$('#change_visibility').val($id);
	$('#change_visibility_text').html('Impostare il link #'+$id+' \'<b>'+$titolo+'</b>\' come '+$statusName[$status]+'?');
	$('#modalEditVisibility').modal({show: true});
});

$(document).on("click", ".addLink", function() {
	$('#add_edit_link').val('add');
	$('#confirmAddEdit').val('Aggiungi');
	$('#modalAddEditLink').modal({show: true});
});

$(document).on("click", ".editLink", function() {
	var $id = $(this).data('id');
	
	$('#add_edit_link').val('edit');
	$('#edit_id').val($id);
	$('#addEditTitle').text('Modifica Link')
	$('#confirmAddEdit').text('Modifica');
	$('#modalAddEditLink').modal({show: true});
});

$('#confirmAddEdit').click(function(){
	$('#addEditForm').submit();
})

$('.close').click(function(){
	$('#title').val(''); 
	$('#subtitle').val(''); 
	$('#url').val(''); 
	$('#img').val(''); 
	$('#link_type option[value=generico]').attr('selected','selected');
	$('#visible').prop('checked',false);
})


$(document).on("click", ".moveUpLink", function() {
	var $id = $(this).data('id');
	var $position = $(this).data('position_up');

	var $first_link = 1;
	
	if($position == $first_link){
		return;		
	
	}else{
		$('#move_up_id').val($id);
		$('#moveUpForm').submit();
	}
});


$(document).on("click", ".moveDownLink", function() {
	var $id = $(this).data('id');
	var $position_link = $(this).data('position_link_down');
	var $position_social = $(this).data('position_social_down');
	

	//ottine i numeri dell'ultima riga generale e dell'ultima riga social
	var $last_link_down = $('.last_link_value').data('last_link_value');
	var $last_social_down = $('.last_social_value').data('last_social_value');

	//Scelgo quale ultimo guardare, e quale posizione considerare
	if($position_link == undefined){
		$last_link = $last_social_down;
		$position = $position_social
	}
	if($position_social == undefined){
		$last_link = $last_link_down;
		$position = $position_link;
	}

	if($position == $last_link){
		return;		
	
	}else{

		$('#move_down_id').val($id); //Passo l'id dell'elemento da muovere nel form;
		$('#moveDownForm').submit();

	}

	
});

/* Disabilita il pulsante Up della prima riga e quello Down dell'ultima */
$(document).ready(function(){
	
	var $button_up = $('[data-position_up=1]');
	$button_up.addClass("disabled");
	$button_up.removeAttr('href');

	var $last_link_down = $('.last_link_value').data('last_link_value');
	var $last_social_down = $('.last_social_value').data('last_social_value');

	var $button_link_down = $('[data-position_link_down='+$last_link_down+']');
	var $button_social_down = $('[data-position_social_down='+$last_social_down+']');

	$button_link_down.addClass("disabled");
	$button_link_down.removeAttr('href');
	
	$button_social_down.addClass("disabled");
	$button_social_down.removeAttr('href');
	
});
