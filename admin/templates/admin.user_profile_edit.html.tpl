<form method="post">
    <div class="modal hide fade" id="modalDeleteUser">
        <input type="hidden" name="delete_user" value="<?php echo $user->id; ?>">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h3>Elimina Utente</h3>
        </div>
        <div class="modal-body">
        Sei sicuro di voler eliminare l'utente #<?php echo $user->id; ?> <b><?php echo hfix($user->nome.' '.$user->cognome); ?></b> (<?php echo hfix($user->email); ?>) ?
        </div>
        <div class="modal-footer">
            <a href="#" data-dismiss="modal" class="btn">Annulla</a>
            <button type="submit" class="btn btn-danger"><i class="icon-trash"></i>Elimina</button>
        </div>
    </div>
</form>
<ul class="breadcrumb">
    <li><a href="<?php echo $this->base_url; ?>">Home</a> <span class="divider">/</span></li>
    <li><a href="<?php echo $this->base_url; ?>users.php">Statistiche Membri</a> <span class="divider">/</span></li>
    <li><a href="<?php echo $this->base_url.'users.php?list='.$list; ?>"><?php echo $activePage; ?></a> <span class="divider">/</span></li>
    <li><a href="<?php echo $this->base_url.'users.php?list='.$list.'&u='.$user->id; ?>"><?php echo hfix($user->nome." ".$user->cognome); ?></a> <span class="divider">/</span></li>
    <li class="active">Modifica utente</li>
    <?php if($ableToScheda) { ?><li class="pull-right"><a href="<?php echo $this->base_url; ?>printScheda.php?id=<?php echo $user->id; ?>" target="_BLANK" class="btn btn-info btn-mini"><i class="icon-book"></i> Scheda Associato</a></li><?php } ?>
</ul>
<ul id="myTab" class="nav nav-tabs">
    <li class="active"><a href="#anagrafica" data-toggle="tab" onclick="$('#profileSubmitter').show();">Anagrafica</a></li>
    <li><a href="#residenza" data-toggle="tab" onclick="$('#profileSubmitter').show();">Residenza</a></li>
    <li><a href="#domicilio" data-toggle="tab" onclick="$('#profileSubmitter').show();">Domicilio</a></li>
    <li><a href="#foto_utente" data-toggle="tab" onclick="$('#profileSubmitter').hide();">Foto</a></li>
    <li><a href="#info_laurea" data-toggle="tab" onclick="$('#profileSubmitter').show();">Info Laurea</a></li>
    <li><a href="#info_associazione" data-toggle="tab" onclick="$('#profileSubmitter').show();">Info Associazione</a></li>
    <li><a href="#info_sistema" data-toggle="tab" onclick="$('#profileSubmitter').show();">Info Sistema</a></li>
</ul>
<div class="span3">
</div>
<form method="post">
<div id="myTabContent" class="tab-content">
    <?php if(isset($errors)) { ?>
    <div class="alert alert-danger">
        <button type="button" class="close" data-dismiss="alert">&times;</button>
        <?php foreach($errors as $error) {
            echo $error.'<br>';
        }
        ?>
    </div>
    <?php } ?>
    <?php if(count($_POST) > 0 && !isset($errors)) { ?>
    <div class="alert alert-success">
        <button type="button" class="close" data-dismiss="alert">&times;</button>
        Utente modificato con successo!
    </div>
    <?php } ?>
    <div class="tab-pane fade in active" id="anagrafica">
        <div class="form-horizontal">
            <div class="control-group">
                <label class="control-label" for="inputNome"><strong>Nome:</strong></label>
                <div class="controls">
                    <input name="nome" type="text" id="inputNome" placeholder="Nome" value="<?php echo hfix($user->nome); ?>">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputCognome"><strong>Cognome:</strong></label>
                <div class="controls">
                    <input name="cognome" type="text" id="inputCognome" placeholder="Cognome" value="<?php echo hfix($user->cognome); ?>">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputPseudonimo"><strong>Pseudonimo:</strong></label>
                <div class="controls">
                    <input name="pseudonimo" type="text" id="inputPseudonimo" placeholder="pseudonimo" value="<?php echo hfix($user->pseudonimo); ?>">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputSesso"><strong>Sesso:</strong></label>
                <div class="controls controls-text">
                    <select name="sesso" id="inputSesso">
                        <option value="1"<?php echo $user->sesso == 1 ? ' selected' : ''; ?>>Femmina</option>
                        <option value="2"<?php echo $user->sesso == 2 ? ' selected' : ''; ?>>Maschio</option>
                        <option value="3"<?php echo $user->sesso == 3 ? ' selected' : ''; ?>>Altro</option>
                    </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputEmail"><strong>Email:</strong></label>
                <div class="controls">
                    <input name="email" type="text" id="inputEmail" placeholder="Email" value="<?php echo hfix($user->email); ?>">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputPrefisso"><strong>Prefisso:</strong></label>
                <div class="controls controls-text">
                    <select name="prefisso" id="inputPrefisso">
                    <?php foreach($tabella_stati as $row): ?>
                      <?php if($user->prefisso == substr($row->prefisso_telefonico_stati,1)): ?>
                      <option value="<?= substr($row->prefisso_telefonico_stati,1)?>" selected ><?=$row->prefisso_telefonico_stati?> (<?=$row->nome_stati?>)</option>
                      <?php else: ?>
                      <option value="<?=substr($row->prefisso_telefonico_stati,1)?>"><?=$row->prefisso_telefonico_stati?> (<?=$row->nome_stati?>)</option>
                      <?php endif; ?>
                    <?php endforeach; ?>
                  </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputTelefono"><strong>Telefono:</strong></label>
                <div class="controls">
                    <div class="input-prepend">
                        <input name="telefono" type="text" id="inputTelefono" style="width: 170px;" placeholder="Telefono" value="<?php echo hfix($user->telefono); ?>">
                    </div>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputTelegram"><strong>Telegram:</strong></label>
                <div class="controls">
                    <div class="input-prepend">
                        <span class="add-on" style="height: 20px; line-height: 20px;">@</span>
                        <input name="telegram" type="text" id="inputTelegram" style="width: 170px;" placeholder="Telegram" value="<?php echo hfix($user->telegram); ?>">
                    </div>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputComuneNascita"><strong>Comune di Nascita:</strong></label>
                <div class="controls controls-text">
                    <input name="comune_nascita" type="text" id="inputComuneNascita" placeholder="Comune di nascita" value="<?php echo hfix($user->comune_nascita); ?>">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputProvinciaNascita"><strong>Provincia di Nascita:</strong></label>
                <div class="controls controls-text">

                  <select name="provincia_nascita" id="inputProvinciaNascita">
                    <?php foreach($tabella_province as $row): ?>
                      <?php if($user->provincia_nascita == $row->nome_province): ?>
                      <option value="<?=$row->nome_province?>" selected ><?=$row->nome_province?> (<?=$row->sigla_province?>)</option>
                      <?php else: ?>
                      <option value="<?=$row->nome_province?>"><?=$row->nome_province?> (<?=$row->sigla_province?>)</option>
                      <?php endif; ?>
                    <?php endforeach; ?>
                  </select>

                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputStatoNascita"><strong>Stato di Nascita:</strong></label>
                <div class="controls controls-text">
                  <select name="stato_nascita" id="inputStatoNascita">
                    <?php foreach($tabella_stati as $row): ?>
                      <?php if($user->stato_nascita == $row->nome_stati): ?>
                      <option value="<?=$row->nome_stati?>" selected ><?=$row->nome_stati?> (<?=$row->nome_inglese_stati?>)</option>
                      <?php else: ?>
                      <option value="<?=$row->nome_stati?>"><?=$row->nome_stati?> (<?=$row->nome_inglese_stati?>)</option>
                      <?php endif; ?>
                    <?php endforeach; ?>
                  </select>
                </div>
            </div>
            <?php $info_data = (array) $user->data_nascita;
                  $data = new DateTime($info_data['date']);
            ?>
            <div class="control-group">
                <label class="control-label" for="inputData"><strong>Data di Nascita:</strong></label>
                <div class="controls">
                  <input id="datepicker" value="<?php echo $data->format('d-m-Y'); ?>" name="data_nascita" type="text">
              </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="inputCodiceFiscale"><strong>Codice Fiscale:</strong></label>
                <div class="controls">
                    <input name="codice_fiscale" type="text" id="inputCodiceFiscale" placeholder="Codice Fiscale" value="<?php echo hfix($user->codice_fiscale); ?>">
                </div>
            </div>
        </div>
    </div>
    <div class="tab-pane fade" id="residenza">
        <div class="form-horizontal">
            <div class="control-group">
                <label class="control-label" for="inputResidenzaStato"><strong>Stato di residenza:</strong></label>
                <div class="controls controls-text">
                  <select name="residenza_stato" id="inputResidenzaStato">
                    <?php foreach($tabella_stati as $row): ?>
                      <?php if($user->residenza_stato == $row->nome_stati): ?>
                      <option value="<?=$row->nome_stati?>" selected ><?=$row->nome_stati?> (<?=$row->nome_inglese_stati?>)</option>
                      <?php else: ?>
                      <option value="<?=$row->nome_stati?>"><?=$row->nome_stati?> (<?=$row->nome_inglese_stati?>)</option>
                      <?php endif; ?>
                    <?php endforeach; ?>
                  </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputResidenzaComune"><strong>Comune di residenza:</strong></label>
                <div class="controls controls-text">
                    <input name="residenza_comune" type="text" id="inputResidenzaComune" value="<?php echo hfix($user->residenza_comune); ?>">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputResidenzaProvincia"><strong>Provincia di residenza:</strong></label>
                <div class="controls controls-text">
                  <select name="residenza_provincia" id="inputResidenzaProvincia">
                    <?php foreach($tabella_province as $row): ?>
                      <?php if($user->residenza_provincia == $row->nome_province): ?>
                      <option value="<?=$row->nome_province?>" selected ><?=$row->nome_province?> (<?=$row->sigla_province?>)</option>
                      <?php else: ?>
                      <option value="<?=$row->nome_province?>"><?=$row->nome_province?> (<?=$row->sigla_province?>)</option>
                      <?php endif; ?>
                    <?php endforeach; ?>
                  </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputResidenzaCap"><strong>CAP di residenza:</strong></label>
                <div class="controls controls-text">
                    <input name="residenza_cap" type="text" id="inputResidenzaCap" value="<?php echo hfix($user->residenza_cap); ?>">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputResidenzaIndirizzo"><strong>Indirizzo di residenza:</strong></label>
                <div class="controls controls-text">
                    <input name="residenza_indirizzo" type="text" id="inputResidenzaIndirizzo" value="<?php echo hfix($user->residenza_indirizzo); ?>">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputResidenzaCivico"><strong>Civico di residenza:</strong></label>
                <div class="controls controls-text">
                    <input name="residenza_civico" type="text" id="inputResidenzaCivico" value="<?php echo hfix($user->residenza_civico); ?>">
                </div>
            </div>
        </div>
    </div>
    <div class="tab-pane fade" id="domicilio">
        <div style="float: right; padding-right: 70px;">
            <button type="button" class="btn btn-warning btn-medium" id="copiaDaResidenza"><i class="icon-edit"></i> Copia da Residenza</button>
        </div>
        <div class="form-horizontal">
            <div class="control-group">
                <label class="control-label" for="inputDomicilioStato"><strong>Stato di domicilio:</strong></label>
                <div class="controls controls-text">
                  <select name="domicilio_stato" id="inputDomicilioStato">
                    <?php foreach($tabella_stati as $row): ?>
                      <?php if($user->domicilio_stato == $row->nome_stati): ?>
                      <option value="<?=$row->nome_stati?>" selected ><?=$row->nome_stati?> (<?=$row->nome_inglese_stati?>)</option>
                      <?php else: ?>
                      <option value="<?=$row->nome_stati?>"><?=$row->nome_stati?> (<?=$row->nome_inglese_stati?>)</option>
                      <?php endif; ?>
                    <?php endforeach; ?>
                  </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputDomicilioComune"><strong>Comune di domicilio:</strong></label>
                <div class="controls controls-text">
                    <input name="domicilio_comune" type="text" id="inputDomicilioComune" value="<?php echo hfix($user->domicilio_comune); ?>">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputDomicilioProvincia"><strong>Provincia di domicilio:</strong></label>
                <div class="controls controls-text">
                  <select name="domicilio_provincia" id="inputDomicilioProvincia">
                    <?php foreach($tabella_province as $row): ?>
                      <?php if($user->domicilio_provincia == $row->nome_province): ?>
                      <option value="<?=$row->nome_province?>" selected ><?=$row->nome_province?> (<?=$row->sigla_province?>)</option>
                      <?php else: ?>
                      <option value="<?=$row->nome_province?>"><?=$row->nome_province?> (<?=$row->sigla_province?>)</option>
                      <?php endif; ?>
                    <?php endforeach; ?>
                  </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputDomicilioCap"><strong>CAP di domicilio:</strong></label>
                <div class="controls controls-text">
                    <input name="domicilio_cap" type="text" id="inputDomicilioCap" value="<?php echo hfix($user->domicilio_cap); ?>">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputDomicilioIndirizzo"><strong>Indirizzo di domicilio:</strong></label>
                <div class="controls controls-text">
                    <input name="domicilio_indirizzo" type="text" id="inputDomicilioIndirizzo" value="<?php echo hfix($user->domicilio_indirizzo); ?>">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputDomicilioCivico"><strong>Civico di domicilio:</strong></label>
                <div class="controls controls-text">
                    <input name="domicilio_civico" type="text" id="inputDomicilioCivico" value="<?php echo hfix($user->domicilio_civico); ?>">
                </div>
            </div>
        </div>
    </div>
    <div class="tab-pane fade" id="info_laurea">
        <div class="form-horizontal">
            <div class="control-group">
                <label class="control-label" for="inputStudentePolitecnico"><strong>Studente Politecnico:</strong></label>
                <div class="controls controls-text">
                    <select name="studente_politecnico" id="inputStudentePolitecnico">
                        <option value="2"<?php echo $user->studente_politecnico == 2 ? ' selected' : ''; ?>>No</option>
                        <option value="1"<?php echo $user->studente_politecnico == 1 ? ' selected' : ''; ?>>Si</option>
                    </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputCodicePersona"><strong>Codice Persona:</strong></label>
                <div class="controls controls-text">
                    <input name="codice_persona" type="text" id="inputCodicePersona" value="<?php echo hfix($user->codice_persona); ?>">
                </div>
            </div>

        </div>
    </div>
    <div class="tab-pane fade" id="info_associazione">
        <div class="form-horizontal">
            <div class="control-group">
                <label class="control-label" for="selectQuota"><strong>Quota associativa pagata:</strong></label>
                <div class="controls controls-text">
                    <select name="quota" id="selectQuota">
                        <option value="0"<?php echo $user->quota == 0 ? ' selected' : ''; ?>>No</option>
                        <option value="1"<?php echo $user->quota == 1 ? ' selected' : ''; ?>>Si</option>
                    </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="selectFirma"><strong>Liberatoria firmata:</strong></label>
                <div class="controls controls-text">
                    <select name="firma" id="selectFirma">
                        <option value="0"<?php echo $user->firma == 0 ? ' selected' : ''; ?>>No</option>
                        <option value="1"<?php echo $user->firma == 1 ? ' selected' : ''; ?>>Si</option>
                    </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="selectLivello"><strong>Posizione:</strong></label>
                <div class="controls controls-text">
                    <select name="livello" id="selectLivello">
                        <?php foreach($nameOfLevel as $value => $name) { ?>
                        <option value="<?php echo $value; ?>"<?php if($user->livello == $value) echo ' selected'; ?>><?php echo $name; ?></option>
                        <?php } ?>
                    </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="selectType"><strong>Tipo:</strong></label>
                <div class="controls controls-text">
                    <select name="type" id="selectType">
                        <option value=""></option>
                        <?php foreach($nameOfType as $value => $name) { ?>
                        <option value="<?php echo $value; ?>"<?php if($user->tipo == $value) echo ' selected'; ?>><?php echo $name; ?></option>
                        <?php } ?>
                    </select>
                </div>
            </div>
            <?php $info_data = (array) $user->data_iscrizione;
                  $data = new DateTime($info_data['date']);
            ?>
            <div class="control-group">
                <label class="control-label" for="inputData"><strong>Data di Iscrizione:</strong></label>
                <div class="controls">
                  <input id="datepicker2" value="<?php echo $data->format('d-m-Y'); ?>" name="data_iscrizione" type="text" disabled>
              </div>
            </div>
        </div>
    </div>
    <div class="tab-pane fade" id="info_sistema">
        <div class="form-horizontal">
            <div class="control-group">
                <label class="control-label" for="inputID"><strong>ID:</strong></label>
                <div class="controls">
                    <input id="inputID" type="text" value="<?php echo $user->id; ?>" disabled>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="selectAdmin"><strong>Amministratore:</strong></label>
                <div class="controls controls-text">
                    <select name="administrator" id="selectAdmin">
                        <option value="0"<?php echo $user->administrator == 0 ? ' selected' : ''; ?>>No</option>
                        <option value="1"<?php echo $user->administrator == 1 ? ' selected' : ''; ?>>Si</option>
                    </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputPassword"><strong>Nuova password:</strong></label>
                <div class="controls controls-text">
                    <input name="password" type="text" id="inputPassword">
                </div>
            </div>
            <?php /* maiux 04/10/2018, two-step disabled, impractical if($userActions->getCurrentUser()->administrator) { ?>
            <div class="control-group">
                <label class="control-label" for="inputQrSecret"><strong>Qr Code Secret:</strong></label>
                <div class="controls controls-text">
                    <input type="hidden" name="inputQrSecret" id="inputQrSecret"> <button type="button" class="btn btn-mini btn-info" id="rigeneraQrSecret"><i class="icon-edit"></i> Rigenera</button>
                </div>
            </div>
            <?php } */?>
            <div class="control-group">
                <label class="control-label" for="selectAccountAttivo"><strong>Account attivo:</strong></label>
                <div class="controls controls-text">
                    <select name="attivo" id="selectAccountAttivo">
                        <option value="0"<?php echo $user->attivo == 0 ? ' selected' : ''; ?>>No - Email da confermare (Status: 0)</option>
                        <option value="1"<?php echo $user->attivo == 1 ? ' selected' : ''; ?>>No - Account da confermare (Status: 1)</option>
                        <option value="2"<?php echo $user->attivo == 2 ? ' selected' : ''; ?>>Si</option>
                        <option value="-1"<?php echo $user->attivo == -1 ? ' selected' : ''; ?>>Disattivato</option>
                    </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputCodiceAttivazione"><strong>Codice attivazione email:</strong></label>
                <div class="controls controls-text">
                    <input name="activate_code" type="text" id="inputCodiceAttivazione" value="<?php echo hfix($user->activate_code); ?>"> <button type="button" class="btn btn-mini btn-info" id="rigeneraCodiceAttivazione"><i class="icon-edit"></i>Rigenera</button>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputRedazione"><strong>Accesso Redazione:</strong></label>
                <div class="controls">
                    <label class="radio">
                        <input name="redazione" type="radio" id="inputRedazione" value="0"<?php echo $user->accessoredazione == 0 ? ' checked' : ''; ?>> Disabilitato
                    </label>
                    <label class="radio">
                        <input name="redazione" type="radio" id="inputRedazione" value="1"<?php echo $user->accessoredazione == 1 ? ' checked' : ''; ?>> Abilitato
                    </label>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputOTP"><strong>Accesso OTP:</strong></label>
                <div class="controls">
                    <label class="radio">
                        <input name="otp-access" type="radio" id="inputOTP" value="0"<?php echo $user->otp_access == 0 ? ' checked' : ''; ?>> Disabilitato
                    </label>
                    <label class="radio">
                        <input name="otp-access" type="radio" id="inputOTP" value="1"<?php echo $user->otp_access == 1 ? ' checked' : ''; ?>> Abilitato
                    </label>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputAdminRedazione"><strong>Accesso Admin Redazione:</strong></label>
                <div class="controls">
                    <label class="radio">
                        <input name="adminredazione" type="radio" id="inputAdminRedazione" value="0"<?php echo $user->adminredazione == 0 ? ' checked' : ''; ?>> Disabilitato
                    </label>
                    <label class="radio">
                        <input name="adminredazione" type="radio" id="inputAdminRedazione" value="1"<?php echo $user->adminredazione == 1 ? ' checked' : ''; ?>> Abilitato
                    </label>
                </div>
            </div>
            <?php /* slack */ ?>
            <div class="control-group">
                <label class="control-label" for="slack_invite"><strong>Slack:</strong></label>
                <div class="controls controls-text">
                    <button type="button" class="btn btn-mini btn-success" id="slack_invite" onclick="$(this).hide(); $.get('users.php?slack_invite=<?php echo $user->id; ?>', function(data) { $('#slack_invite_result').html(data); });"><i class="icon-gift"></i> Invita</button>
                    <span id="slack_invite_result"></span>
                </div>
            </div>
            <?php /* */ ?>
        </div>
    </div><br>
    <div style="float: right; padding-right: 270px;" id="profileSubmitter">
        <a href="#modalDeleteUser" data-toggle="modal" class="btn btn-danger btn-medium"><i class="icon-trash"></i> Elimina utente</a>
        <button type="submit" class="btn btn-medium btn-primary"><i class="icon-ok"></i> Salva</button>
    </div>
</form>
    <div class="tab-pane fade" id="foto_utente">
        <form method="post" enctype="multipart/form-data" id="MyUploadForm" class="form-horizontal span6">
            <div id="output"></div>
            <center>
                <h3>Modifica Foto</h3>
            <img src="<?php echo $user->foto != '' ? $this->base_url.'../'.$user->foto : 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIwAAACMCAIAAAAhotZpAAAACXBIWXMAAAsSAAALEgHS3X78AAABWUlEQVR42u3RQQ0AIAzAwPkXiwYk7AlN7hQ06Ry+N68D2JkUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFLABZMilhyJuwqMAAAAAElFTkSuQmCC'; ?>" style="max-width: 450px;" id="foto" class="img-polaroid"><br><br>
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
        <script type="text/javascript">
            function rotate_myimg(deg){
                $.get('<?php echo $this->base_url; ?>rotator.php', {'rot': deg, 'u':'<?php echo $user->id; ?>'}, function(data){
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
                    $.get('<?php echo $this->base_url; ?>rotator.php?urlOf=<?php echo $user->id; ?>', function(data){
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
    </div>
</div>
