$('#confirmAdd').click(function() {
	programID    = $('#inputAddProgramma').val();
	day          = $('#inputAddGiorno').val();
	hour         = $('#inputAddOra').val();
	minute       = $('#inputAddMinuto').val();
	durata       = $('#inputAddDurata').val();
	$.get('palinsesto.php?d='+day+'&p='+programID, function(data) {
		if(data > '23') {
			$('#modalMessages').html('<div class="alert alert-danger"><button type="button" class="close" data-dismiss="alert">&times;</button>Programma gi&agrave; presente durante la giornata.</div>');
		} else {
			$.get('palinsesto.php?d='+day+'&h='+hour+'&m='+minute+'&l='+durata, function(data) {
				if(data != '0') {
					$('#modalMessages').html('<div class="alert alert-danger"><button type="button" class="close" data-dismiss="alert">&times;</button>Orario occupato dal programma <i>'+data+'</i></div>');
				} else {
					$('#addForm').submit();
				}
			});
		}
	});
});

$('#confirmEdit').click(function() {
	programID    = $('#inputEditProgramma').val();
	day          = $('#inputEditGiorno').val();
	hour         = $('#inputEditOra').val();
	minute       = $('#inputEditMinuto').val();
	durata       = $('#inputEditDurata').val();
	ds           = $('#ds').val();
	$.get('palinsesto.php?p='+programID+'&ds='+ds+'&d='+day+'&h='+hour+'&m='+minute+'&l='+durata, function(data) {
		if(data != '0') {
			$('#modalEditMessages').html('<div class="alert alert-danger"><button type="button" class="close" data-dismiss="alert">&times;</button>Orario occupato dal programma <i>'+data+'</i></div>');
		} else {
			$.get('palinsesto.php?d='+day+'&ds='+ds+'&p='+programID, function(data) {
				if(data > '23') {
					$('#modalEditMessages').html('<div class="alert alert-danger"><button type="button" class="close" data-dismiss="alert">&times;</button>Programma gi&agrave; presente durante la giornata.</div>');
				} else {
					$('#editForm').submit();
				}
			});
		}
	});
});
