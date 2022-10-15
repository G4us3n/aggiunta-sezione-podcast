<script type="text/javascript">
    var Homepage = {
        current_slide: 1,

        slide_interval: undefined,
        slide_interval_paused: false,

        init: function(){
            var elms = $(".slider .slide");
            for(var i = 0; i < elms.length; i++){
                var s = elms[i];
                var s_child = $(s).children()[0];

                if( ! $(s_child).is("img") ){
                    var bg = $(s).css("background-image");
                    bg = bg.replace('url(','').replace(')','').replace(/\"/gi, "");

                    $(s).append("<img src=\"" + bg + "\" />");
                }
            }
        },

        slide_to: function(n){
            var target_slide = $(".slider .slide:eq(" + (n-1) + ")");
            var loading_elm = $("#slide-loading")
            var i;

            loading_elm.removeClass("slide-loading-hidden");

            target_slide.waitForImages(function() {
                loading_elm.addClass("slide-loading-hidden");

                if(n > Homepage.current_slide){
                    $(".slider .visible").addClass("hidden-left").removeClass("visible");

                    for(i = Homepage.current_slide; i < n-1; i++){
                        $(".slider .slide:eq(" + (i) + ")").removeClass("hidden-right").addClass("hidden-left");
                    }

                    target_slide.removeClass("hidden-right").addClass("visible");

                }else if(n < Homepage.current_slide){
                    $(".slider .visible").addClass("hidden-right").removeClass("visible");

                    for(i = Homepage.current_slide-2; i > n-1; i--){
                        $(".slider .slide:eq(" + (i) + ")").removeClass("hidden-left").addClass("hidden-right");
                    }

                    target_slide.removeClass("hidden-left").addClass("visible");
                }

                Homepage.current_slide = n;
                $("#homepage .quick-navigation .active").removeClass("active");
                $("#homepage .quick-navigation a:eq(" + (Homepage.current_slide-1) + ")").addClass("active");
            });
        },

        autoslide: function(additional_interval = 0){
            if(Homepage.slide_interval !== undefined){
                clearInterval(Homepage.slide_interval);
            }

            Homepage.slide_interval = setInterval(function() {
                if( $("#homepage").length && !isMobileTemplate() ) {
                    var ns = Homepage.current_slide < 5 ? Homepage.current_slide + 1 : 1;
                    Homepage.slide_to(ns);
                }else{
                    clearInterval(Homepage.slide_interval);
                }
            }, (10000+additional_interval))
        }
    }

    $(document).ready(function() {
        Homepage.init();

        $("#homepage .quick-navigation a").on("click", function(e){
            e.preventDefault();
            Homepage.autoslide(5000);
            Homepage.slide_to($(this).data("v"));
        });

        $("#homepage #left-arrow").on("click", function() {
            var ns = Homepage.current_slide > 1 ? (Homepage.current_slide - 1) : 5;
            Homepage.autoslide(5000);
            Homepage.slide_to(ns)
        });

        $("#homepage #right-arrow").on("click", function() {
            var ns = Homepage.current_slide < 5 ? (Homepage.current_slide + 1) : 1;
            Homepage.autoslide(5000);
            Homepage.slide_to(ns)
        });

        Homepage.autoslide();

        $(window).focus(function() {
            if(Homepage.slide_interval_paused){
                Homepage.autoslide();
                Homepage.slide_interval_paused = false;
            }
        });

        $(window).blur(function() {
            clearInterval(Homepage.slide_interval);
            Homepage.slide_interval_paused = true;
        });
    });
</script>

<div id="homepage">
    <div class="arrow-container mobile-hidden">
        <div id="left-arrow" class="arrow"><i class="fa fa-chevron-left" aria-hidden="false"></i></div>
    </div>

    <div class="arrow-container right-arrow-container mobile-hidden">
        <div id="right-arrow" class="arrow"><i class="fa fa-chevron-right" aria-hidden="false"></i></div>
    </div>

    <div class="quick-navigation mobile-hidden">
        <div id="slide-loading" class="slide-loading-hidden"></div>

        <a class="active" href="#" data-v="1">1</a>
        <a href="#" data-v="2">2</a>
        <a href="#" data-v="3">3</a>
        <a href="#" data-v="4">4</a>
        <a href="#" data-v="5">5</a>
    </div>

    <div class="slider">
        <?php
            for($i = 0; $i < 5; $i++){
                if( !isset($contents[$i]) ){
                    continue;
                }

                $c = $contents[$i];
                echo '<div class="slide s' . ($i+1) . ' ' . ($i == 0 ? 'visible' : 'hidden-right') . '" style="background-image: url(\'' . $c->bg . '\')">
                        <div class="captions">
                            ' . ($c->upTitle != NULL ? '<div class="sub-under-title">' . $c->upTitle . '</div>' : '') . '
                            <div class="title"><a class="an" href="' . $c->buttonUrl . '">' . $c->title . '</a></div>
                            ' . ($c->underTitle != NULL ? '<div class="sub-under-title under-title">' . $c->underTitle . '</div>' : '') . '

                            <div class="btn mobile-hidden"><a href="' . $c->buttonUrl . '" class="an ' . $c->buttonClass . ' text-shadow-default">' . $c->button . '</a></div>
                        </div>

                        ' . ($i == 0 ? '<img src="' . $c->bg . '" />' : '') . '
                    </div>';
            }
        ?>
    </div>
</div>