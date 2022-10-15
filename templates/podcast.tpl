<?php
    if($show != null){
        echo genShowCssStyle($show);
    }
?>

<script type="text/javascript">
    var page = 1;
    var error_alert_shown = false;
    var load_no_more = false;
    var sorry_msg = $("#sorry-msg");

    $(document).on('scroll', function() {
        if($(window).scrollTop() + $(window).innerHeight() >= $(document).height()-$("#dock").height()
            && isMobileTemplate() && !load_no_more && isNewsListPage()) {
            onBottomReached()
        }
    });

    $('#content').on('scroll', function() {
        if(Math.ceil($(this).scrollTop() + $(this).innerHeight()) >= $(this)[0].scrollHeight
            && !load_no_more && !isMobileTemplate() && isNewsListPage()) {
            onBottomReached()
        }
    });

    $(document).ready(function(){
        $("#podcast #loading").hide();

        if( $("#items .item").length === 0 ) {
            $("#sorry-msg").show();
        }
    });

    function onBottomReached(){
        $("#podcast #loading").show();

        $.ajax({
            url: PATH + "/ajax/get_podcasts.php?page=" + (++page) + "&week=<?php echo ($of_week ? 1 : 0); ?>&pid=<?php echo ($show != null ? $show->id : ''); ?>"
    }).done(function( data ) {
            if(data.length > 0){
                $("#items .item").last().after(data);
            }else {
                load_no_more = true;
            }
        }).fail(function(e) {
            if(!error_alert_shown){
                alert("Ci dispiace, non riusciamo a caricare altri podcast :(\n\nRiprova!");
                error_alert_shown = true;
            }
        }).always(function() {
            $("#podcast #loading").hide();
        });
    }

    function isNewsListPage(){ //This is ugly :(
        return $("#playground #content #podcast").length > 0;
    }
</script>

<div id="podcast" class="<?php if($show != null) { echo 'container-' . $show->tag; } ?>">
    <div class="title text-large-shadow">PODCAST
        <?php
            if($show != null){
                echo "<span>di " . $show->nome . "</span>";
            }else if($of_week){
                echo "<span>della settimana</span>";
            }
        ?>
    </div>
    <hr class="chr">

    <div id="items">
        <?php
            include dirname(dirname(__FILE__)) . "/ajax/get_podcasts.php";
        ?>

        <div class="clear"></div>
    </div>

    <div id="sorry-msg">
        <i class="far fa-meh"></i>
        <p>Ancora nessun podcast</p>
    </div>

    <div id="loading"></div>
</div>
