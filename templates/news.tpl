<script type="text/javascript">
    var page = 1;
    var error_alert_shown = false;
    var loading_icon = $(".left-col .loading");
    var load_no_more = false;

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
        if( $(".left-col .article-card").length === 0 ){
            $("#sorry-msg").show();
        }

        $("#articles-search").submit(function(e) {
            e.preventDefault();
            var query = encodeURIComponent($("#articles-search input[name=search]").val());
            open_ajax_url(PATH + "/news/?search=" + query);
        });
    });

    function onBottomReached(){
        loading_icon.show();

        $.ajax({
            url: PATH + "/ajax/get_articles.php?page=" + (++page) + "<?php
            if( isset($userID) ) { echo '&uid=' . $userID; }
        if( isset($programID) ) { echo '&pid=' . $programID; }
        if( isset($tag) ) { echo '&t=' . $tag; }
        if( isset($search) ) { echo '&s=' . $search; }
        if( isset($archive_month) && isset($archive_year) ) { echo '&m=' . $archive_month . '&y=' . $archive_year; }
            ?>"
    }).done(function( data ) {
            if(data.length > 0){
                $(".left-col .article-card").last().after(data);
            }else {
                load_no_more = true;
            }
        }).fail(function(e) {
            if(!error_alert_shown){
                alert("Ci dispiace, non riusciamo a caricare altre news :(\n\nRiprova!");
                error_alert_shown = true;
            }
        }).always(function(){
            loading_icon.hide();
        });
    }

    function isNewsListPage(){ //This is ugly :(
        return $("#playground #content #news").length > 0 &&
                    $("#playground #content #news.single-view").length === 0;
    }
</script>
<div id="news">
    <div class="title text-shadow-big-default">news</div>
    <?php
        if(isset($filter)){
            echo '<div class="article-by">' . $filter . '</div>';
        }
    ?>
    <hr class="chr">

    <?php include dirname(__FILE__) . "/news.rightcol.tpl"; ?>

    <div class="left-col">
        <div id="sorry-msg">
            <i class="far fa-frown"></i><br>
            <?php echo $sorryMsg; ?>
        </div>

        <br>
        <?php include dirname(dirname(__FILE__)) . "/ajax/get_articles.php"; ?>

        <div class="loading"></div>
    </div>

    <div class="clear"></div>
</div>
