<div id="shows">
    <?php
        $i = 1;
        foreach($active_shows as $s){
            echo genShowCssStyle($s);
            echo '<div class="container-' . $s->tag . ' square-block ' . ($i%3 == 0 ? 'no-margin' : '') . '">
                <a href="' . PATH . '/show/' . $s->id . '/' . format_text_url(hfix($s->nome)) . '" class="an">
                    <img src="' . PRODUCTION_PATH . '/' . hfix($s->logo) . '"/>
                </a>
            </div>';
        }
    ?>

    <h1 class="text-shadow-big-default">Vecchie Glorie</h1>
    <h3>Programmi non più in onda che sono sempre nel nostro <i class="fas fa-heart"></i></h3>

    <?php
        $i = 1;
        foreach($old_shows as $s){
            echo genShowCssStyle($s);
            echo '<div class="container-' . $s->tag . ' square-block ' . ($i%3 == 0 ? 'no-margin' : '') . '">
                <a href="' . PATH . '/show/' . $s->id . '/' . format_text_url(hfix($s->nome)) . '" class="an">
                <img src="' . PRODUCTION_PATH . '/' . hfix($s->logo) . '"/>
                </a>
            </div>';
        }
    ?>

    <div class="join-us">
        <p style="margin-top: 0;"><b>UNISCITI A NOI!</b></p>
        <p>Hai un'idea per un programma? Raccontacela <i class="fab fa-angellist"></i></p>
        <div class="join"><a class="an" href="<?php echo PATH; ?>/contatti">CONTATTACI</a></div>
    </div>
</div>