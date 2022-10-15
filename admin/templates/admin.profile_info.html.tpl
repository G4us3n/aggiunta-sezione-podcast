<div class="span2"></div>
<div class="span6">
    <form method="post" class="form-horizontal span6">
        <center>
            <h3>Modifica Profilo</h3>
        </center>
        <div class="control-group">
            <label class="control-label" for="prefisso"><strong>Prefisso:</strong></label>
            <div class="controls">
                <div class="input-prepend">
                    <select name="prefisso" id="prefisso" style="width: 170px;" placeholder="prefisso" >
                    <?php foreach($tabella_stati as $row): ?>
                      <?php if($userActions->getCurrentUser()->prefisso == substr($row->prefisso_telefonico_stati,1)): ?>
                      <option value="<?= substr($row->prefisso_telefonico_stati,1)?>" selected ><?=$row->prefisso_telefonico_stati?> (<?=$row->nome_stati?>)</option>
                      <?php else: ?>
                      <option value="<?=substr($row->prefisso_telefonico_stati,1)?>"><?=$row->prefisso_telefonico_stati?> (<?=$row->nome_stati?>)</option>
                      <?php endif; ?>
                    <?php endforeach; ?>
                    </select>
                </div>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="telefono"><strong>Numero di Telefono:</strong></label>
            <div class="controls">
                <div class="input-prepend">
                    <input type="text" name="telefono" id="telefono" style="width: 170px;" placeholder="telefono" value="<?php echo hfix($userActions->getCurrentUser()->telefono); ?>">
                </div>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="telegram"><strong>Username di Telegram:</strong></label>
            <div class="controls">
                <div class="input-prepend">
                    <span class="add-on">@</span>
                    <input type="text" name="telegram" id="telegram" style="width: 170px;" placeholder="username" value="<?php echo hfix($userActions->getCurrentUser()->telegram); ?>">
                </div>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="pseudonimo"><strong>Pseudonimo:</strong></label>
            <div class="controls">
                <input type="text" name="pseudonimo" id="pseudonimo" placeholder="pseudonimo" value="<?php echo hfix($userActions->getCurrentUser()->pseudonimo); ?>">
            </div>
        </div>
        <div class="control-group">
            <div class="controls">
                <button type="submit" class="btn btn-primary">Modifica</button>
            </div>
        </div>
    </form>
</div>
