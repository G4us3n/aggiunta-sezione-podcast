<?php if($isStationManager && !$user->administrator) { ?>
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
<?php } ?>
<ul class="breadcrumb">
    <li><a href="<?php echo $this->base_url; ?>">Home</a> <span class="divider">/</span></li>
    <?php if($isDirettivo) { ?><li><a href="<?php echo $this->base_url; ?>users.php">Statistiche Membri</a> <span class="divider">/</span></li><?php } ?>
    <li><a href="<?php echo $this->base_url.'users.php?list='.$list; ?>"><?php echo $activePage; ?></a> <span class="divider">/</span></li>
    <li class="active"><?php echo hfix($user->nome." ".$user->cognome); ?></li>
    <li class="pull-right"><?php if($ableToScheda) { ?><a href="<?php echo $this->base_url; ?>printScheda.php?id=<?php echo $user->id; ?>" target="_BLANK" class="btn btn-info btn-mini"><i class="icon-book"></i> Scheda Associato</a> <?php } if($isStationManager) { ?><a href="<?php echo $this->base_url.'users.php?list='.$list; ?>&m=<?php echo $user->id; ?>" class="btn btn-warning btn-mini">Modifica <i class="icon-edit"></i></a> <?php if(!$user->administrator) { ?><a href="#modalDeleteUser" data-toggle="modal" class="btn btn-danger btn-mini"><i class="icon-trash"></i> Elimina utente</a><?php } }?></li>
</ul>
<ul id="myTab" class="nav nav-tabs">
    <li class="active"><a href="#anagrafica" data-toggle="tab">Anagrafica</a></li>
    <?php if($isDirettivo) { ?><li><a href="#residenza" data-toggle="tab">Residenza</a></li>
    <li><a href="#domicilio" data-toggle="tab">Domicilio</a></li><?php } ?>
    <li><a href="#foto" data-toggle="tab">Foto</a></li>
    <li><a href="#info_laurea" data-toggle="tab">Info Laurea</a></li>
    <li><a href="#info_associazione" data-toggle="tab">Info Associazione</a></li>
    <?php if($isDirettivo) { ?><li><a href="#info_sistema" data-toggle="tab">Info Sistema</a></li><?php } ?>
    <li><a href="#info_programmi" data-toggle="tab">Programmi</a></li>
    <li><a href="#other_infos" data-toggle="tab">Altre info</a></li>
</ul>
<div class="span3">
</div>
<div id="myTabContent" class="tab-content">
    <div class="tab-pane fade in active" id="anagrafica">
        <div class="form-horizontal">
            <div class="control-group">
                <label class="control-label"><strong>Nome:</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($user->nome); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Cognome:</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($user->cognome); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Pseudonimo:</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($user->pseudonimo); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Sesso:</strong></label>
                <div class="controls controls-text">
                    <?php echo $sessoValue; ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Email:</strong></label>
                <div class="controls controls-text">
                    <a href="mailto:<?php echo hfix($user->email); ?>"><?php echo hfix($user->email); ?></a>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Telefono:</strong></label>
                <div class="controls controls-text">
                    <?php echo '+' . hfix($user->prefisso) . ' ' . hfix($user->telefono); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Telegram:</strong></label>
                <div class="controls controls-text">
                    <?php echo strlen($user->telegram) > 0 ? '<a href="https://t.me/'.hfix($user->telegram).'" target="_BLANK">@'.hfix($user->telegram).'</a>' : ''; ?>
                </div>
            </div>
            <?php if($isDirettivo) { ?>
            <div class="control-group">
                <label class="control-label"><strong>Comune di Nascita:</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($user->comune_nascita); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Provincia di Nascita:</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($user->provincia_nascita) ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Stato di Nascita:</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($user->stato_nascita) ?>
                </div>
            </div>
            <?php } ?>
            <div class="control-group">
                <label class="control-label"><strong>Data di Nascita:</strong></label>
                <div class="controls controls-text">
                    <?php   $info_data = (array) $user->data_nascita;
                            $data = new DateTime($info_data['date']);
                            echo hfix($data->format('d-m-Y'));
                    ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Et&agrave;</strong></label>
                                <div class="controls controls-text">
                    <?php echo date_diff(new DateTime("now"), new DateTime($info_data['date']))->y; ?>
                </div>
            </div>
            <?php if($isDirettivo) { ?>
            <div class="control-group">
                <label class="control-label"><strong>Codice Fiscale:</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($user->codice_fiscale); ?>
                </div>
            </div>
            <?php } ?>
        </div>
    </div>
    <?php if($isDirettivo) { ?>
    <div class="tab-pane fade" id="residenza">
        <div class="form-horizontal">
            <div class="control-group">
                <label class="control-label"><strong>Comune di residenza:</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($user->residenza_comune); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Provincia di residenza:</strong></label>
                <div class="controls controls-text">
                  <?php echo hfix($user->residenza_provincia) ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Stato di residenza:</strong></label>
                <div class="controls controls-text">
                  <?php echo hfix($user->residenza_stato) ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>CAP di residenza:</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($user->residenza_cap); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Indirizzo di residenza:</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($user->residenza_indirizzo); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Civico di residenza:</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($user->residenza_civico); ?>
                </div>
            </div>
        </div>
    </div>
    <div class="tab-pane fade" id="domicilio">
        <div class="form-horizontal">
            <div class="control-group">
                <label class="control-label"><strong>Comune di domicilio:</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($user->domicilio_comune); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Provincia di domicilio:</strong></label>
                <div class="controls controls-text">
                  <?php echo hfix($user->domicilio_provincia) ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Stato di domicilio:</strong></label>
                <div class="controls controls-text">
                  <?php echo hfix($user->domicilio_stato) ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>CAP di domicilio:</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($user->domicilio_cap); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Indirizzo di domicilio:</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($user->domicilio_indirizzo); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Civico di domicilio:</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($user->domicilio_civico); ?>
                </div>
            </div>
        </div>
    </div>
    <?php } ?>
    <div class="tab-pane fade" id="foto">
        <img src="<?php echo $this->base_url.'../'.$user->foto; ?>" style="max-width: 450px;" id="foto" class="img-polaroid"><br><br>
    </div>
    <div class="tab-pane fade" id="info_laurea">
        <div class="form-horizontal">
            <?php if($isDirettivo) {?>
            <div class="control-group">
                <label class="control-label"><strong>Politecnico:</strong></label>
                <div class="controls controls-text">
                    <?php if($user->studente_politecnico == 1):?>
                    Sì
                    <?php else: ?>
                    No
                    <?php endif; ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Codice Persona:</strong></label>
                <div class="controls controls-text">
                    <?php if($user->studente_politecnico == 1){echo hfix($user->codice_persona);}; ?>
                </div>
            </div>
            <?php } ?>
        </div>
    </div>
    <div class="tab-pane fade" id="info_associazione">
        <div class="form-horizontal">
            <?php if($isDirettivo) { ?>
            <div class="control-group">
                <label class="control-label"><strong>Quota associativa pagata:</strong></label>
                <div class="controls controls-text">
                    <?php echo $user->quota ? 'Si' : 'No'; ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Liberatoria firmata:</strong></label>
                <div class="controls controls-text">
                    <?php echo $user->firma ? 'Si' : 'No'; ?>
                </div>
            </div>
            <?php } ?>
            <div class="control-group">
                <label class="control-label"><strong>Posizione:</strong></label>
                <div class="controls controls-text">
                    <?php echo $nameOfLevel[$user->livello]; ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Tipo:</strong></label>
                <div class="controls controls-text">
                    <?php if(isset($nameOfType[$user->tipo])) echo $nameOfType[$user->tipo]; ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Data Iscrizione:</strong></label>
                <div class="controls controls-text">
                    <?php   $info_data = (array) $user->data_iscrizione;
                            $data = new DateTime($info_data['date']);
                            echo hfix($data->format('d-m-Y'));
                    ?>
                </div>
            </div>
        </div>
    </div>
    <?php if($isDirettivo) { ?>
    <div class="tab-pane fade" id="info_sistema">
        <div class="form-horizontal">
            <div class="control-group">
                <label class="control-label"><strong>ID:</strong></label>
                <div class="controls controls-text">
                    <?php echo $user->id; ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Amministratore:</strong></label>
                <div class="controls controls-text">
                    <?php echo $user->administrator ? '<font color="red">Si</font>' : 'No'; ?>
                </div>
            </div>

            <?php /* maiux 04/10/2018 two-step disabled, impractical
            if($isStationManager) { ?>
            <?php if($userActions->getCurrentUser()->administrator && $userActions->userHasQR($user->id)) { ?>
            <div class="control-group">
                <label class="control-label"><strong>Auth QR Code:</strong></label>
                <div class="controls controls-text">
                    <button type="button" id="qrbutton" onclick="$('#qr').toggle(); $('#qrcode').toggle(); $('#qrbutton').toggle();" class="btn btn-small btn-warning">Visualizza</button>
                    <img id="qr" style="display: none;" onclick="$('#qr').toggle(); $('#qrcode').toggle(); $('#qrbutton').toggle();" src="<?php echo $userActions->getUserQR($user->id); ?>">
                    <br><input class="input-big" type="text" id="qrcode" style="display: none;" value="<?php echo $user->userchecksum; ?>">
                </div>
            </div>
            <?php } */?>

            <div class="control-group">
                <label class="control-label"><strong>Data ultimo login:</strong></label>
                <div class="controls controls-text">
                    <?php echo date('d-m-Y H:i:s', $user->last_login_time); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>IP ultimo login:</strong></label>
                <div class="controls controls-text">
                <?php echo $user->last_login_ip; ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Numero login:</strong></label>
                <div class="controls controls-text">
                <?php echo $user->login; ?>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label"><strong>Account attivo:</strong></label>
                <div class="controls controls-text">
                    <?php
                    switch($user->attivo){
                        case -1:
                            echo 'Disattivato';
                            break;
                        case 0:
                            echo 'No (Email da confermare)';
                            break;
                        case 1:
                            echo 'No (Account da confermare da un amministratore)';
                            break;
                        default:
                            echo 'Si';
                    }
                    ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Codice attivazione email:</strong></label>
                <div class="controls controls-text">
                    <?php echo strlen($user->activate_code) > 0 ? hfix($user->activate_code) : 'Gi&agrave; utilizato'; ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Accesso Redazione:</strong></label>
                <div class="controls controls-text">
                    <?php echo $user->accessoredazione == 1 ? 'Abilitato' : 'Disabilitato'; ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Accesso Admin Redazione:</strong></label>
                <div class="controls controls-text">
                    <?php echo $user->adminredazione == 1 ? 'Abilitato' : 'Disabilitato'; ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Accesso OTP:</strong></label>
                <div class="controls controls-text">
                    <?php echo $user->otp_access == 1 ? 'Abilitato' : 'Disabilitato'; ?>
                </div>
            </div>
        </div>
    </div>
    <?php } ?>
    <div class="tab-pane fade" id="info_programmi">
        <div class="form-horizontal">
            <?php
            $programmi = $user->programmi_utenti;
            foreach ($programmi as $record) {
                $ruolo     = $programActions->getRole($record->ruolo);
                $programma = hfix($record->programmi->nome);
            ?>
            <div class="control-group">
                <label class="control-label"><a href="<?php echo $this->base_url; ?>programs.php?list=0&p=<?php echo $record->programmi_id; ?>" target="_blank"><?php echo $programma; ?></a></label>
                <div class="controls controls-text">
                     <?php echo $ruolo; ?> <?php if($record->referente) echo '[Referente]'; ?>
                </div>
            </div>
            <?php } ?>
        </div>
    </div>

    <div class="tab-pane fade" id="other_infos">
        <div class="form-horizontal">
            <?php
            $infos = $user->other_infos == '' ? array() : json_decode($user->other_infos, true);
            if(count($infos) == 0) echo '<i>Nessun altra informazione disponibile.</i><br><br>';

            foreach($infos as $info_name=>$info_value) {
            ?>
            <div class="control-group">
                <label class="control-label"><?php echo hfix($info_name); ?></label>
                <div class="controls controls-text">
                    <?php echo hfix($info_value); ?>
                </div>
            </div>
            <?php } ?>
        </div>
    </div>
</div>
