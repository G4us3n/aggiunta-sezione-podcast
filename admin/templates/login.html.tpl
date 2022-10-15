<!DOCTYPE html>
<html lang="it">
  <head>
    <meta charset="utf-8">
    <title>POLI.RADIO - Amministrazione</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    <?php echo $css; ?>
  </head>
  <body>
    <div class="container">
       <form method="post" action="<?php echo $this->base_url.'login'.(isset($_GET["api"])?"?".$_SERVER["QUERY_STRING"]:""); ?>" class="form-signin">
        <?php if(isset($error_message)) { ?>
        <div class="alert alert-error">
          <button type="button" class="close" data-dismiss="alert">&times;</button>
          <strong>Errore:</strong> <?php echo hfix($error_message); ?>
        </div>
        <?php } ?>
        <?php if(isset($success_message)) { ?>
	<?php if($quota_alert) { ?>
        <div class="alert alert-success">
          <button type="button" class="close" data-dismiss="alert">&times;</button>
          <?php echo strip_tags($success_message, '<strong><a>'); ?>
        </div>
	<?php } else { ?>
	<div class="alert <?php echo isset($warning) ? 'alert-warning' : 'alert-error';?>">
	  <?php echo $alert_message; ?>
	</div>
        <?php } } ?>
        <?php if(isset($redirect)) { ?>
        <!--<div class="alert alert-info"><center><b>Buone feste!</b></center></div>
        <img src="audiologin/jhonny.jpg" border="0" class="img-polaroid">-->
        <?php if($quota_alert) {?>
        <script type="text/javascript">
          window.setTimeout(function(){
            window.location.href = "<?php echo $redirect; ?>";
            }, 3000);
        </script>
        <?php
        } } ?>
        <h2 class="form-signin-heading">Login</h2>
        <input type="text" name="email" class="input-block-level" placeholder="Email"<?php
          if(isset($_SESSION['pref_email'])) {
            echo ' value="'.hfix($_SESSION['pref_email']).'"';
            unset($_SESSION['pref_email']);
          }
          elseif(isset($_POST['email'])) {
            echo ' value="'.hfix($_POST['email']).'"';
          }
          if(isset($redirect)) {
            echo ' disabled';
          }
          ?>>
        <input type="password" name="password" class="input-block-level" placeholder="Password"<?php if(isset($redirect)) echo ' disabled'; ?>>
        <?php if($failures >= 5) { ?><div class="g-recaptcha" data-sitekey="6LeEtf4SAAAAAMHrWah1-bCB3ZEya64vQolLPhXR"></div><br><?php } ?>
        <button class="btn btn-large btn-primary" type="submit"<?php if(isset($redirect)) echo ' disabled'; ?>>Login</button>
	<?php /* if(!isset($redirect)) { ?><a class="pull-right" href="https://poliradio.slack.com/" target="_BLANK"><img src="<?php echo $this->base_url; ?>img/slack.png" class="img-polaroid" width="34px"></a><?php } */ ?>
	</form>
    </div>
    <?php /*<audio loop autoplay>
      <source src="<?php echo $this->base_url; ?><?php echo isset($success_message) ? 'vittoria' : (isset($_GET['logout']) ? 'ending' : 'battaglia'); ?>.mp3" type="audio/mpeg">
    </audio>*/?> 

    <?php if($audio != NULL) { ?>
	<audio autoplay><source src="<?php echo $this->base_url; ?>audiologin/<?php echo $audio; ?>" type="audio/mpeg"></audio>
    <?php } ?>
    <?php if(isset($quota_alert) && $quota_alert == 0) { ?>
	<audio autoplay loop><source src="<?php echo $this->base_url; ?>audiologin/<?php echo isset($warning) ? $audio : 'pagah.mp3'; ?>" type="audio/mpeg"></audio>
    <?php } ?>
    <?php echo $js; ?>
    <?php if(date('d-m') == '01-04') { ?><script type="text/javascript">document.getElementsByTagName("BODY")[0].style.opacity = 0.25;</script><?php } ?>
  </body>
</html>
<!--
Portale membri sviluppato da Andrea Maioli
Sito web poliradio sviluppato da Pietro Avolio
-->
