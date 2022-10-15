$( document ).ready(function() {
  $('#rigeneraCodiceAttivazione').click(function(){
    $('#inputCodiceAttivazione').val('{{REGEN}}');
  });
  $('#rigeneraQrSecret').click(function(){
    $('#inputQrSecret').val('{{REGEN}}');
  });

  $('#copiaDaResidenza').click(function() {
    $('#inputDomicilioComune').val($('#inputResidenzaComune').val());
    $('#inputDomicilioProvincia').val($('#inputResidenzaProvincia').val());
    $('#inputDomicilioCap').val($('#inputResidenzaCap').val());
    $('#inputDomicilioIndirizzo').val($('#inputResidenzaIndirizzo').val());
    $('#inputDomicilioCivico').val($('#inputResidenzaCivico').val());
    $('#inputDomicilioDug').val($('#inputResidenzaDug').val());
    $('#inputDomicilioStato').val($('#inputResidenzaStato').val());
  });
  $('.deleteProgram').click(function(){
    var $id = $(this).data('id');
    var $nome = $(this).data('nome');
    $('#delete_program').val($id);
    $('#delete_text').html('Sei sicuro di voler eliminare il programma #'+$id+' <b>'+$nome+'</b>?');
    $('#modalDeleteProgram').modal({show: true});
  });
  $(document).on("click", ".deleteUser", function() {
    var $id = $(this).data('id');
    var $nome = $(this).data('nome');
    var $cognome = $(this).data('cognome');
    var $email = $(this).data('email');
    $('#delete_user').val($id);
    $('#delete_text').html('Sei sicuro di voler eliminare l\'utente #'+$id+' <b>'+$nome+' '+$cognome+'</b> ('+$email+') ?');
    $('#modalDeleteUser').modal({show: true});
  });
  $('.removeUserFromProgram').click(function(){
    var $id = $(this).data('id');
    var $nome = $(this).data('nome');
    var $cognome = $(this).data('cognome');
    $('#memberid').val($id);
    $('#member_remove_text').html('Sei sicuro di voler rimuovere dal programma l\'utente #'+$id+' <b>'+$nome+' '+$cognome+'</b>?');
    $('#modalRemoveMember').modal({show: true});
  });
  $('.enableQuota').click(function() {
    var $id = $(this).data('id');
    var $nome = $(this).data('nome');
    var $cognome = $(this).data('cognome');
    $('#enable_quota').val($id);
    $('#enable_quota_text').html('Ha l\'utente <b>'+$nome+' '+$cognome+'</b> pagato la quota associativa?');
    $('#modalEnableQuota').modal({show: true});
  });
  $('.enableFirma').click(function() {
    var $id = $(this).data('id');
    var $nome = $(this).data('nome');
    var $cognome = $(this).data('cognome');
    $('#enable_firma').val($id);
    $('#enable_firma_text').html('Ha l\'utente <b>'+$nome+' '+$cognome+'</b> firmato la liberatoria?');
    $('#modalEnableFirma').modal({show: true});
  });
  $('.enableUser').click(function() {
    var $id = $(this).data('id');
    var $nome = $(this).data('nome');
    var $cognome = $(this).data('cognome');
    $('#enable_user').val($id);
    $('#enable_user_text').html('Abilitare l\'utente <b>'+$nome+' '+$cognome+'</b>?');
    $('#modalEnableUser').modal({show: true});
  });
  $("[data-bind='popover']").popover({
      html: true,
       content: function(){
        $id = $(this).data('id');
        return $('#popoverContent'+$id).html();
       }
  });
  $('.editProgramMember').click(function(){
    var $id = $(this).data('id');
    var $nome = $(this).data('nome');
    var $cognome = $(this).data('cognome');
    var $ruolo = $(this).data('ruolo');
    var $referente = $(this).data('referente');
    $('#useridedit').val($id);
    $('#inputRuoloEdit').val($ruolo);
    $('#selectUser').empty().append('<option>'+$nome+' '+$cognome+'</option>');
    $('#inputReferenteEdit'+$referente).prop('checked', true);
    $('#modalEditMember').modal({show: true});
  });
});
