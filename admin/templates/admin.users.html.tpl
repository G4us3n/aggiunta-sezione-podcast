<?php if($isStationManager) { ?>
<form method="post">
  <div class="modal hide fade" id="modalDeleteUser">
    <input type="hidden" name="delete_user" id="delete_user">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
      <h3>Elimina Utente</h3>
    </div>
    <div class="modal-body" id="delete_text">
    </div>
    <div class="modal-footer">
      <a href="#" data-dismiss="modal" class="btn">Annulla</a>
      <button type="submit" class="btn btn-danger"><i class="icon-trash"></i>Elimina</button>
    </div>
  </div>
</form>

<form method="post">
  <div class="modal hide fade" id="modalEnableUser">
    <input type="hidden" name="enable_user" id="enable_user">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
      <h3>Abilita Utente</h3>
    </div>
    <div class="modal-body" id="enable_user_text">
    </div>
    <div class="modal-footer">
      <a href="#" data-dismiss="modal" class="btn">No</a>
      <button type="submit" class="btn btn-info">Si</button>
    </div>
  </div>
</form>
<?php } ?>
<?php
global $enabled_suid;
if(in_array($currentUser->id, $enabled_suid)) {
?>
<div class="modal hide fade" id="modalSUID">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h3>Loging come altro utente</h3>
  </div>
  <div class="modal-body" id="enable_user_text">
  <center>
    <select id="suid_id">
    <?php
    $utenti = Utenti::all(array('order' => 'cognome ASC, nome ASC'));
    foreach($utenti as $utente) {
      echo '<option value="'.$utente->id.'">'.hfix($utente->cognome.', '.$utente->nome).'</option>';
    }
    ?>
    </select>
  </center>
  </div>
        <div class="modal-footer">
    <a href="#" data-dismiss="modal" class="btn">Annulla</a>
                <button type="submit" class="btn btn-warning" onclick="location.href='<?php echo $this->base_url;?>users.php?suid='+$('#suid_id').val();">Login</button>
        </div>
</div>
<?php } ?>

<?php if($isDirettivo) { ?>
<form method="post">
  <div class="modal hide fade" id="modalEnableQuota">
    <input type="hidden" name="enable_quota" id="enable_quota">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
      <h3>Impostazione Quota Associativa</h3>
    </div>
    <div class="modal-body" id="enable_quota_text">
    </div>
    <div class="modal-footer">
      <a href="#" data-dismiss="modal" class="btn">No</a>
      <button type="submit" class="btn btn-info">Si</button>
    </div>
  </div>
</form>

<form method="post">
  <div class="modal hide fade" id="modalEnableFirma">
    <input type="hidden" name="enable_firma" id="enable_firma">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
      <h3>Impostazione Liberatoria</h3>
    </div>
    <div class="modal-body" id="enable_firma_text">
    </div>
    <div class="modal-footer">
      <a href="#" data-dismiss="modal" class="btn">No</a>
      <button type="submit" class="btn btn-info">Si</button>
    </div>
  </div>
</form>
<?php } ?>
<ul class="breadcrumb">
  <li><a href="<?php echo $this->base_url; ?>">Home</a> <span class="divider">/</span></li>
  <?php if($isDirettivo) { ?><li><a href="<?php echo $this->base_url; ?>users.php">Statistiche Membri</a> <span class="divider">/</span></li><?php } ?>
  <li class="active"><?php echo $activePage; ?></li>
  <?php if(in_array($currentUser->id, $enabled_suid)) { ?>
    <li class="pull-right"><button class="btn btn-warning btn-mini" data-toggle="modal" href="#modalSUID"><i class="icon icon-user"></i></button></li>
  <?php } ?>
</ul>
<?php if(isset($error)) { ?>
<div class="alert alert-danger">
  <button type="button" class="close" data-dismiss="alert">&times;</button>
  <?php echo $error; ?>
</div>
<?php } ?>
<?php if(isset($success)) { ?>
<div class="alert alert-success">
  <button type="button" class="close" data-dismiss="alert">&times;</button>
  <?php echo $success; ?>
</div>
<?php } ?>
<table class="table table-hover table-striped">
  <thead>
    <tr>
      <th>Cognome</th>
      <th>Nome</th>
      <?php /*<th>Email</th>*/ ?>
      <th>Telefono</th>
      <th>Telegram</th>
      <th>Posizione</th>
      <?php if($isDirettivo) { ?><th>Et&agrave;</th>
      <th>Attivo</th>
      <th>Quota</th>
      <th>Liberatoria</th>
      <?php } ?>
    </tr>
  </thead>
  <tbody>
    <?php
    $today = date('d-m-Y');
    foreach($users as $user) {
      $class = '';
      if($user->administrator) {
        $class = 'info';
      } elseif($user->livello != 'MEMBRO' && $user->livello != '') {
        $class = 'success';
      }
      if($user->attivo < 2) {
        $class = 'warning';
      } elseif(!$user->firma || !$user->quota) {
        $class = 'error';
      }
    ?>
    <tr<?php
      if($class != '') echo ' class="'.$class.'"';
      if($isStationManager) echo " data-bind='popover' data-id='".$user->id."'";
      else echo ' onclick="document.location.href=\''.$this->base_url.'users.php?list='.$list.'&u='.$user->id.'\';"';
      ?>>
      <td><?php echo hfix($user->cognome); ?></td>
      <td><?php echo hfix($user->nome); ?></td>
      <!--<td><?php echo $user->email; ?></td>-->
      <td><?php echo hfix($user->telefono); ?></td>
      <td><?php echo strlen($user->telegram) > 0 ? '<a href="https://t.me/'.hfix($user->telegram).'" target="_BLANK">@'.hfix($user->telegram).'</a>' : ''; ?></td>
      <td><?php echo $nameOfLevel[$user->livello]; ?></td>
      <?php if($isDirettivo) { ?>

            <td><?
                $info_data = (array) $user->data_nascita;
                $data = new DateTime($info_data['date']);
                echo date_diff(new DateTime("now"), new DateTime($info_data['date']))->y; ?>
            </td>
      <td>
        <?php
        switch ($user->attivo) {
          case -1:
            echo 'Disattivato';
            break;
          case 0:
            echo 'No';
            break;
          case 1:
            echo '<a href="#" class="enableUser" data-id="'.hfix($user->id).'" data-nome="'.hfix($user->nome).'" data-cognome="'.hfix($user->cognome).'">No</a>';
            break;
          default:
            echo 'Si';
            break;
        }
        ?>
      </td>
      <td><?php echo $user->quota ? 'Si' : '<a href="#" class="enableQuota" data-id="'.hfix($user->id).'" data-nome="'.hfix($user->nome).'" data-cognome="'.hfix($user->cognome).'">No</a>'; ?></td>
      <td><?php echo $user->firma ? 'Si' : '<a href="#" class="enableFirma" data-id="'.hfix($user->id).'" data-nome="'.hfix($user->nome).'" data-cognome="'.hfix($user->cognome).'">No</a>'; ?></td>
      <?php } ?>
      <?php if($isStationManager) { ?>
      <div style="display: none;" id="popoverContent<?php echo $user->id; ?>">
        <a href="<?php echo $this->base_url; ?>users.php?list=<?php echo (int)$list; ?>&u=<?php echo $user->id; ?>" class="btn btn-success btn-mini"><i class="icon-user"></i></a>
        <a href="<?php echo $this->base_url; ?>users.php?list=<?php echo (int)$list; ?>&m=<?php echo $user->id; ?>" class="btn btn-warning btn-mini"><i class="icon-edit"></i></a>
        <a href="<?php echo $this->base_url; ?>printScheda.php?id=<?php echo $user->id; ?>" target="_BLANK" class="btn btn-info btn-mini"><i class="icon-book"></i></a>
        <?php if(!$user->administrator) { ?>
        <a href="#" data-id="<?php echo $user->id; ?>" data-nome="<?php echo hfix($user->nome); ?>" data-cognome="<?php echo hfix($user->cognome); ?>" data-email="<?php echo hfix($user->email); ?>" class="deleteUser btn btn-danger btn-mini"><i class="icon-trash"></i></a>
        <?php } ?>
      </div>
      <?php } ?>
    </tr>
    <?php } ?>
  </tbody>
</table>
