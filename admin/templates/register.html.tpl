<!DOCTYPE html>
<html lang="it">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>POLI.RADIO - Registrazione Staff</title>
    <meta name="description" content="">
    <meta name="author" content="Matteo Morana">
    <?php echo $css; ?>
  </head>
  <body>
    <div class="container">
      <div class="form-signin">
        <?php eval($sub); ?>
      </div>
    </div>
    <?php echo $js; ?>
    <?php if(date('d-m') == '01-04') { ?><script type="text/javascript">document.getElementsByTagName("BODY")[0].style.opacity = 0.25;</script><?php } ?>
  </body>
</html>
