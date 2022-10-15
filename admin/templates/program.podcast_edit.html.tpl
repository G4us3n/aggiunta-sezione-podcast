<ul class="breadcrumb">
    <li><a href="<?php echo $this->base_url; ?>">Home</a> <span class="divider">/</span></li>
    <li><a href="<?php echo $this->base_url; ?>podcast.php">Podcast (<?php echo $count; ?>)</a> <span class="divider">/</span></li>
    <li class="active">Modifica Podcast</li>
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
<?php if(count($_POST) > 0 && !isset($errors)) { ?>
<div class="alert alert-success">
    <button type="button" class="close" data-dismiss="alert">&times;</button>
    Podcast modificato con successo!
</div>
<?php } ?>
<?php
function append_zero($date) {
    if($date < 10) return '0'.$date;
    return $date;
}
?>
    <form method="post">
        <div class="form-horizontal">
            <div class="control-group">
                <label class="control-label" for="inputData"><strong>Data podcast:</strong></label>
                <div class="controls">
                    <input id="datepicker" value="<?php echo append_zero($podcast->giorno)."/".append_zero($podcast->mese)."/".append_zero($podcast->anno); ?>" name="data" type="text">
                    <?php /*
                    <select name="giorno" style="width: 55px;">
                        <?php for($a = 1; $a <= 31; $a++) { ?>
                        <option value="<?php echo $a < 10 ? '0'.$a : $a; ?>"<?php echo $podcast->giorno == $a ? ' selected' : ''; ?>><?php echo $a < 10 ? '0'.$a : $a; ?></option>
                        <?php } ?>
                    </select>
                    <select name="mese" style="width: 100px;">
                        <?php
                        for($a = 1; $a < 13; $a++) { ?>
                        <option value="<?php echo $a; ?>"<?php echo $podcast->mese == $a ? ' selected' : ''; ?>><?php echo $mesiValue[$a]; ?></option>
                        <?php } ?>
                    </select>
                    <select name="anno" style="width: 70px;">
                        <?php for($a = date('Y'); $a >= 2007; $a--) { ?>
                        <option value="<?php echo $a; ?>"<?php echo $podcast->anno == $a ? ' selected' : ''; ?>><?php echo $a; ?></option>
                        <?php } ?>
                    </select>
                    */ ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputLink"><strong>Link Mixcloud:</strong></label>
                <div class="controls">
                    <input class="input-big" name="link" type="text" id="inputLink" placeholder="http://www.mixcloud.com/nomeprogramma/nomepodcast" value="<?php echo hfix($podcast->link); ?>">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputLink2"><strong>Link Youtube:</strong></label>
                <div class="controls">
                    <input class="input-big" name="link_youtube" type="text" id="inputLink2" placeholder="https://www.youtube.com/watch?v=..." value="<?php echo hfix($podcast->link_youtube); ?>">
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
                <label class="control-label" for="inputNews"><strong>News Associate:</strong></label>
                <div class="controls">
                    <table class="table table-hover">
                    <?php
                    $news = $podcast->news_programmi;
                    foreach($news as $n) {
                    ?>
                    <tr>
                        <td><a target="_BLANK" href="<?php echo $this->base_url;?>news.php?edit=<?php echo $n->id; ?>"><?php echo hfix($n->titolo); ?></a></td>
                    </tr>
                    <?php } ?>
                    </table>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputVisibile"><strong>Visibile:</strong></label>
                <div class="controls">
                    <select name="visibile" id="inputVisibile" class="select-big">
                        <option value="0"<?php if($podcast->visibile == 0) echo ' selected'; ?>>Non Visibile</option>
                        <option value="1"<?php if($podcast->visibile == 1) echo ' selected'; ?>>Visibile</option>
                    </select>
                </div>
            </div>
            <?php /*
            <div class="control-group">
                <label class="control-label" for="downloadStatus"><strong>Download:</strong></label>
                <div class="controls" style="position: relative; top: 5px;">
                    <?php
                    switch($podcast->download) {
                        case 0:
                            echo 'In coda';
                            break;
                        case 1:
                            $ratio = filesize('../tmp/'.$singlePodcast->filedownload)/$singlePodcast->filesize;
                            if($ratio == 1) echo 'In elaborazione (100% completato)';
                            else echo round($ratio*100, 2).'%';
                            break;
                        default:
                            echo 'Completato. <a href="'.$this->base_url.'podcast.php?dw='.$podcast->id.'">Download</a>';
                            break;
                    }
                    ?>
                </div>
            </div
            <?php */ ?>
            <div class="control-group">
                <div class="controls">
                    <button type="submit" class="btn btn-primary btn-medium">Modifica Podcast</button>
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
    var add_tags = "<?php echo hfix($tags); ?>";
    var $abs_url = '<?php echo $this->base_url;?>';
</script>
*/
?>
