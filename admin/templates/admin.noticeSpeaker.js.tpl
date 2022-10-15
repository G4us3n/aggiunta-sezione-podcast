$(document).on("click", ".deleteAvviso", function() {
	var $id = $(this).data('id');
	var $titolo = $(this).data('titolo');
	$('#delete_avviso').val($id);
	$('#delete_text').html('Sei sicuro di voler eliminare la notifica #'+$id+' \'<b>'+$titolo+'</b>\' ?');
	$('#modalDeleteAvviso').modal({show: true});
});

$(document).on("click", ".addAvviso", function() {
	$('#add_edit_avviso').val('add');
	$('#addEditTitle').text('Nuovo Avviso');
    $('#confirmAddEdit').text('Aggiungi');
    //ripulisco i campi dell'avviso
	$('#modalAddEditAvviso').modal({show: true});
});

$(document).on("click", ".editAvviso", function() {
	var $id = $(this).data('id');
	
	$('#add_edit_avviso').val('edit');
	$('#edit_id').val($id);
	$('#addEditTitle').text('Modifica Avviso');
	$('#confirmAddEdit').text('Modifica');
	$('#modalAddEditAvviso').modal({show: true});
});

$('#confirmAddEdit').click(function(){
	$('#addEditForm').submit();
})

$('.close').click(function(){
	$('#title').html(''); 
	$('#description').html('');  
	$('#color option[value=success]').attr('selected','selected');
	var $default_date = $('.default_date').data('default_date');
	$('#end_date').val($default_date);
})


$(document).on("click", ".moveUpAvviso", function() {
	var $id = $(this).data('id');
	var $position = $(this).data('position_up');

	var $first_avviso = 1;
	
	if($position == $first_avviso){
		return;		
	
	}else{
		$('#move_up_id').val($id);
		$('#moveUpForm').submit();
	}
});


$(document).on("click", ".moveDownAvviso", function() {
	var $id = $(this).data('id');
	var $position = $(this).data('position_avviso_down');
	
	var $last_avviso = $('.last_avviso_value').data('last_avviso_value');

	if($position == $last_avviso){
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

	var $last_avviso_down = $('.last_avviso_value').data('last_avviso_value');
	

	var $button_avviso_down = $('[data-position_avviso_down='+$last_avviso_down+']');
	

	$button_avviso_down.addClass("disabled");
	$button_avviso_down.removeAttr('href');
	
});
