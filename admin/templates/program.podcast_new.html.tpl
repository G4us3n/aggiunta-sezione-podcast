<ul class="breadcrumb">
    <li><a href="<?php echo $this->base_url; ?>">Home</a> <span class="divider">/</span></li>
    <li><a href="<?php echo $this->base_url; ?>podcast.php">Podcast (<?php echo $count; ?>)</a> <span class="divider">/</span></li>
    <li class="active">Nuovo Podcast</li>
</ul>
<div class="span2">
</div>
<div class="span7">
<?php if(isset($errors)) { ?>
<div class="alert alert-danger">
    <button type="button" class="close" data-dismiss="alert">&times;</button>
    <?php foreach($errors as $error) {
        echo $error.'<br>';
    }
    ?>
</div>
<?php } ?>
    <form method="post">
        <div class="form-horizontal">
            <div class="control-group">
                <label class="control-label" for="inputData"><strong>Data podcast:</strong></label>
                <div class="controls">
                    <input id="datepicker" value="<?php echo date("d/m/Y"); ?>" name="data" type="text">
                    <?php /*
                    <select name="giorno" style="width: 55px;">
                        <?php for($a = 1; $a <= 31; $a++) { ?>
                        <option value="<?php echo $a < 10 ? '0'.$a : $a; ?>"<?php echo isset($_POST['giorno']) ? ((int)$_POST['giorno'] == $a ? 'selected' : '') : (date('d') == $a ? 'selected' : ''); ?>><?php echo $a < 10 ? '0'.$a : $a; ?></option>
                        <?php } ?>
                    </select>
                    <select name="mese" style="width: 100px;">
                        <?php
                        for($a = 1; $a < 13; $a++) { ?>
                        <option value="<?php echo $a; ?>"<?php echo isset($_POST['mese']) ? ((int)$_POST['mese'] == $a ? 'selected' : '') : (date('m') == $a ? 'selected' : ''); ?>><?php echo $mesiValue[$a]; ?></option>
                        <?php } ?>
                    </select>
                    <select name="anno" style="width: 70px;">
                        <?php for($a = date('Y'); $a >= 2007; $a--) { ?>
                        <option value="<?php echo $a; ?>"<?php echo isset($_POST['anno']) ? ((int)$_POST['anno'] == $a ? 'selected' : '') : (date('Y') == $a ? 'selected' : ''); ?>><?php echo $a; ?></option>
                        <?php } ?>
                    </select>
                    */ ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputLink"><strong>Link Mixcloud:</strong></label>
                <div class="controls">
                    <input class="input-big" name="link" type="text" id="inputLink" placeholder="http://www.mixcloud.com/nomeprogramma/nomepodcast" value="<?php if(isset($_POST['link'])) echo hfix($_POST['link']); ?>">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputLink2"><strong>Link Youtube:</strong></label>
                <div class="controls">
                    <input class="input-big" name="link_youtube" type="text" id="inputLink2" placeholder="https://www.youtube.com/watch?v=..." value="<?php if(isset($_POST['link_youtube'])) echo hfix($_POST['link_youtube']); ?>">
                </div>
            </div>
            <?php
            /*
            <div class="control-group">
                <label class="control-label" for="inputTags"><strong id="tagsLabel">Tags (0/5):</strong></label>
                <div class="controls">
                    <div id="tagError"></div>
                    <input data-role="tagsinput" type="text" name="tags" id="inputTags">
                </div>
            </div>
            */
            ?>
            <div class="control-group">
                <label class="control-label" for="inputVisibile"><strong>Visibile:</strong></label>
                <div class="controls">
                    <select name="visibile" id="inputVisibile" class="select-big">
                        <option value="0"<?php if(isset($_POST['visibile'])) { if($_POST['visibile'] == 0) echo ' selected'; } ?>>Non Visibile</option>
                        <option value="1"<?php if(isset($_POST['visibile'])) { if($_POST['visibile'] == 1) echo ' selected'; } else echo ' selected'; ?>>Visibile</option>
                    </select>
                </div>
            </div>
            <?php
            /*
            <div class="control-group">
                <label class="control-label" for="inputDescrizione"><strong>Descrizione<br>(per Instagram):</strong></label>
                <div class="controls">
                    <textarea id="inputDescrizione" style="width: 330px"></textarea>
                </div>
            </div>
            */
            ?>
            <div class="control-group">
                <div class="controls">
                    <button type="submit" class="btn btn-primary btn-medium">Crea Podcast</button>
                </div>
            </div>
        </div>
    </form>
</div>
<?php
/*
<script type="text/javascript">
    var $tags = <?php echo $allTags; ?>;
    var $tags_banned = <?php echo $allProgramTags; ?>;
<?php if(isset($_POST['tags'])) { ?>
    var add_tags = "<?php echo hfix($_POST['tags']); ?>";
<?php } ?>
    var $abs_url = '<?php echo $this->base_url;?>';
</script>
*/
?>
