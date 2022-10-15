<!DOCTYPE html>
<html lang="it" class="<?php if(isXtraTimezone()){ echo 'xtra'; } ?>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <meta property="fb:app_id" content="196874911103187"/>
    <meta property="og:title" content="<?php echo PAGE_TITLE; ?>"/>
    <meta property="og:type" content="<?php echo $GLOBALS["FACEBOOK_META_VALUES"]["type"]; ?>"/>
    <!--<meta property="og:url" content="http://www.poliradio.it/home"/>-->
    <meta property="og:site_name" content="POLI.RADIO"/>
    <meta property="og:locale" content="it_IT" />
    <meta property="og:image" content="<?php echo $GLOBALS["FACEBOOK_META_VALUES"]["image"]; ?>" />
    <meta property="og:description" content="<?php echo $GLOBALS["FACEBOOK_META_VALUES"]["description"]; ?>"/>

    <meta name="description" content="POLI.RADIO è la Web radio ufficiale degli studenti del Politecnico di Milano. Suona la musica che già conosci e quella che non hai mai sentito. Indie, alternative e rock 24 ore su 24, 7 giorni su 7!" />
    <meta name="keywords" content="poliradio, webradio, radio, radio universitaria, webradio universitaria, poli.radio, polimi, politecnico di milano, raduni, università">
    <meta name="copyright" content="POLI.RADIO">
    <meta name="theme-color" content="#59b7de">

    <title><?php echo PAGE_TITLE; ?></title>

    <link rel="shortcut icon" href="<?php echo PATH; ?>/images/favicon.ico">
    <link rel="stylesheet" href="<?php echo PATH; ?>/styles/fontawesome-free-5.15.3/css/all.min.css" />
    <link rel="stylesheet" media="screen" href="<?php echo PATH; ?>/styles/monolithic.css?100518" />

    <script type="text/javascript" src="<?php echo PATH; ?>/scripts/jquery-3.2.1.min.js"></script>
    <script type="text/javascript" src="<?php echo PATH; ?>/scripts/jquery-ui.min.js"></script>
    <script type="text/javascript" src="<?php echo PATH; ?>/scripts/wait-for-images.min.js"></script>
    <script type="text/javascript" src="<?php echo PATH; ?>/scripts/hammer.min.js"></script>
    <script type="text/javascript" src="<?php echo PATH; ?>/scripts/jquery.hammer.js"></script>
    <script type="text/javascript" src="<?php echo PATH; ?>/scripts/js.cookies.js"></script>
    <script type="text/javascript" src="<?php echo PATH; ?>/scripts/jquery.history.js"></script>
    <script type="text/javascript" src="<?php echo PATH; ?>/scripts/monolithic.js"></script>
    <script src= "https://player.twitch.tv/js/embed/v1.js"></script>

    <script type="text/javascript">
        window.FontAwesomeConfig = {
            searchPseudoElements: true
        }
        var PATH = "<?php echo PATH; ?>";
    </script>
</head>
<body class="<?php if(isXtraTimezone()){ echo 'xtra'; } ?>">
    <div id="fb-root"></div>
    <script type="text/javascript">
        (function(d, s, id) {
            var js, fjs = d.getElementsByTagName(s)[0];
            if (d.getElementById(id)) return;
            js = d.createElement(s); js.id = id;
            js.src = "//connect.facebook.net/it_IT/sdk.js#xfbml=1&version=v2.4&appId=196874911103187";
            fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'facebook-jssdk'));
    </script>
    
  <?php if ($_SERVER['REMOTE_ADDR']=='131.175.119.96'):?>

    <audio id="audio-player" autoplay="" preload="none">
        <source id="ogg-stream" src="http://10.48.102.97/hq" type="audio/ogg">
        <source id="ogg-stream" src="http://10.48.102.97/main" type="audio/ogg">
        <source id="mobile-stream" src="http://10.48.102.97/lq" type="audio/ogg">
        <source id="backup" src="http://10.48.102.97/mp3" type="audio/mpeg">
    </audio>
    <?php else: ?>
    <audio id="audio-player" autoplay="" preload="none">
        <source id="ogg-stream" src="https://streaming.poliradio.it/hq" type="audio/ogg">
        <source id="ogg-stream" src="https://streaming.poliradio.it/main" type="audio/ogg">
        <source id="mobile-stream" src="https://streaming.poliradio.it/lq" type="audio/ogg">
        <source id="backup" src="https://streaming.poliradio.it/mp3" type="audio/mpeg">
    </audio>
    <?php endif; ?>
    <div id="playground">
        <div id="loading-overlay"></div>

        <div id="dock">
            <div class="controls-navigation">
                <div class="logo-container">
                    <img src="<?php echo PATH; ?>/images/logo.svg">
                </div>

                <div class="controls">
                    <div id="controls-disabled"><p>IN RIPRODUZIONE</p><p>DA WEBCAM</p></div>

                    <i id="play-pause-toggle" class="fa fa-play-custom fa-play" aria-hidden="false"></i>
                    <div id="volume-slider" class="mobile-hidden"></div>
                    <i id="volume-mute-toggle" class="mobile-hidden fa fa-volume-up" aria-hidden="false"></i>

                    <div class="mobile-hidden loading">ASCOLTACI!</div>
                </div>

                <div class="navigation">
                    <ul class="text-shadow-default">
                        <li data-cat="home" class="<?php echo(PAGE_CATEGORY == "home" ? "current" : ""); ?>"><a class="an" href="<?php echo PATH; ?>">HOME</a></li>
                        <li data-cat="news" class="<?php echo(PAGE_CATEGORY == "news" ? "current" : ""); ?>"><a class="an"  href="<?php echo PATH; ?>/news">NEWS</a></li>
                        <li data-cat="palinsesto" class="<?php echo(PAGE_CATEGORY == "palinsesto" ? "current" : ""); ?>"><a class="an" href="<?php echo PATH; ?>/palinsesto">PALINSESTO</a></li>
                        <li data-cat="programmi" class="<?php echo(PAGE_CATEGORY == "programmi" ? "current" : ""); ?>"><a class="an" href="<?php echo PATH; ?>/programmi">PROGRAMMI</a></li>
                        <li data-cat="live" class="<?php echo(PAGE_CATEGORY == "live" ? "current" : ""); ?>"><a class="an" href="<?php echo PATH; ?>/live">LIVE</a></li>
                        <li data-cat="podcast" class="<?php echo(PAGE_CATEGORY == "podcast" ? "current" : ""); ?>"><a class="an" href="<?php echo PATH; ?>/podcast">PODCAST</a></li>
                        <li data-cat="contatti" class="<?php echo(PAGE_CATEGORY == "contatti" ? "current" : ""); ?>"><a class="an" href="<?php echo PATH; ?>/contatti">INFO</a></li>
                    </ul>
                    <p class="desktop-hidden">Iniziativa realizzata con il contributo del POLITECNICO DI MILANO</p>
                </div>

                <i id="navigation-hamburger" class="fa fa-bars desktop-hidden" aria-hidden="false"></i>
            </div>

            <div class="disclaimer-social mobile-hidden">
                <div class="disclaimer">
                    <p>LICENZA SIAE 202200000075   |   LICENZA SCF 937/14   |  C.F. 97703440152 </p>
                    <p>&copy; 2008-<?php echo date('Y'); ?> POLI.RADIO   |   TUTTI I DIRITTI RISERVATI | Iniziativa realizzata con il contributo del <a href="https://www.polimi.it/" target="_BLANK">POLITECNICO DI MILANO</a></p>
                </div>

                <div class="social">
                    seguici su
                    <a href="https://www.facebook.com/poliradio/" title="Facebook" target="_blank"><i class="fab fa-facebook-f"></i></a>
                    <a href="https://twitter.com/poliradio" title="Twitter" target="_blank"><i class="fab fa-twitter" aria-hidden="false"></i></a>
                    <a href="https://www.instagram.com/poliradio/" title="Instagram" target="_blank"><i class="fab fa-instagram" aria-hidden="false"></i></a>
                    <a href="https://www.youtube.com/user/PoliRadioRock" title="Youtube" target="_blank"><i class="fab fa-youtube" aria-hidden="false"></i></a>
                    <a href="https://open.spotify.com/user/poliradio?si=Xraft2w6SIGtlMrzqr7Q9Q" title="Spotify" target="_blank"><i class="fab fa-spotify" aria-hidden="false"></i></a>
                </div>

                <div class="clear"></div>
            </div>

            <div id="dock-toggle" class="mobile-hidden">
                <span class="text-shadow-default">Nascondi dock</span>
                <span class="text-shadow-default">Mostra dock</span>
                <i class="fas fa-arrow-circle-down" aria-hidden="true"></i>
            </div>

            <div id="current-song" class="mobile-hidden">
                <svg version="1.2" baseProfile="tiny" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="100%" height="100%" viewBox="0 0 200 200" preserveAspectRatio="none">
                    <defs>
                        <pattern id="image" x="0" y="0" patternUnits="userSpaceOnUse" height="100%" width="100%">
                            <image id="current-song-image" x="0" y="0" height="100%" width="100%" xlink:href="<?php echo PATH; ?>/images/no-album.png"></image>
                        </pattern>
                    </defs>
                    <path d="M0,0h200v200H0v-71.996c18.392,0,28.003-15.697,28.003-28.003c0-12.308-9.307-28.004-28.003-28.004V0z" fill="url(#image)"></path>
                </svg>
            </div>

            <div id="current-song-bubble" class="text-shadow-default mobile-hidden">
                <div id="current-song-bubble-content">
                    <p>Very Long Song Artist</p>
                    <p>Very Long Song Title</p>
                </div>

                <div class="corner"></div>
            </div>
        </div>

        <!-- STARTING THE CONTENT SECTION -->
        <div id="content">
