<script type="text/javascript">
    $(document).ready(function() {
        FB.XFBML.parse();
    });
</script>
<div id="chat">
    <div id="twitch-player"></div>

    <div class="current-show-box">
        <?php include dirname(dirname(__FILE__)) . "/ajax/get_current_show_box.php"; ?>
    </div>

    <script type="text/javascript">
        var twitch_player;
        var main_player_volume_to_restore = undefined;

        var options = {
            width: "100%",
            height: "100%",
            channel: "poliradioit",
            autoplay: false
        };

        $(document).ready(function(){
            twitch_player = new Twitch.Player("twitch-player", options);
            twitch_player.setVolume(audio_player.volume);

            twitch_player.addEventListener(Twitch.Player.PLAY, function(){
                if(!twitch_player.getEnded()) {
                    main_player_volume_to_restore = audio_player.volume;
                    audio_player.volume = 0;

                    $("#dock .controls-navigation .controls").addClass("disabled");
                    $("#dock .controls-navigation .controls #controls-disabled").show();
                }
            });

            twitch_player.addEventListener(Twitch.Player.ENDED, function(){ restore_main_audio_player() });
            twitch_player.addEventListener(Twitch.Player.PAUSE, function(){ restore_main_audio_player() });
            twitch_player.addEventListener(Twitch.Player.OFFLINE, function(){ restore_main_audio_player() });

            setInterval(function(){
                $.ajax( "/ajax/get_current_show_box.php" )
                    .done(function(data) {
                        $(".current-show-box").html(data);
                    });
            }, 60 * 1000);
        });

        $("#playground").on( "click", ".an", function(e) {
            e.preventDefault();
            restore_main_audio_player();
        });

        function restore_main_audio_player(){
            if(main_player_volume_to_restore !== undefined){
                audio_player.volume = main_player_volume_to_restore;
                $("#dock .controls-navigation .controls").removeClass("disabled");
                $("#dock .controls-navigation .controls #controls-disabled").hide();
                main_player_volume_to_restore = undefined;
            }
        }
    </script>

    <div class="clear"></div>

    <div class="interact-box">
        <span>MANDACI UN MESSAGGINO <i class="mobile-hidden far fa-hand-point-right"></i><i class="desktop-hidden far fa-hand-point-down"></i></span>

        <a class="interaction" href="https://api.whatsapp.com/send?phone=393203205652" target="_blank">
            <i class="fab fa-whatsapp"></i> +39 320 320 5652
        </a>
        <a class="interaction" href="http://telegram.me/poliradiobot" target="_blank">
            <i class="fab fa-telegram-plane"></i> @poliradiobot
        </a>
    </div>

    <div style="margin-top: 1em; display: none">
        <div class="fb-comments" data-width="100%" data-href="http://www.poliradio.it/chat" data-numposts="15" data-colorscheme="light" data-order-by="reverse_time"></div>
    </div>
</div>
