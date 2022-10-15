<script type="text/javascript">
    $(document).ready(function() {
        FB.XFBML.parse();
    });
</script>

<div id="news" class="single-view">

    <?php include dirname(__FILE__) . "/news.rightcol.tpl"; ?>

    <?php
        $articleUrl = PATH . '/news/'.$article->id.'/'.format_text_url($article->titolo);

        if($article->programmi_id == 0) {
            $idProgramma   =  0;
            $nomeProgramma = 'Redazione';
            $tagProgramma  = 'redazione';
            $logo = 'images/logo.svg';
        } else {
            $idProgramma   = $article->programmi_id;
            $nomeProgramma = hfix($article->programmi->nome);
            $tagProgramma  = hfix($article->programmi->tag);
            $logo = hfix($article->programmi->logo);
        }

    ?>

    <div class="left-col">
        <div class="article-card">
            <div class="article-title">
                <?php echo hfix($article->titolo); ?>
            </div>

            <div class="article-subtitle"><?php echo hfix($article->sottotitolo) ?></div>

            <div class="article-refs">
                <i class="fas fa-calendar-alt"></i>&nbsp;&nbsp;
                <?php echo date("d", $article->time) . ' ' .  getItalianMonth($article->mese, true) . ' ' . $article->anno; ?>
                &nbsp;&nbsp;|&nbsp;&nbsp;

                <a class="an" href="<?php echo PATH . '/news/show/' . $idProgramma . '/' . format_text_url(hfix($nomeProgramma)); ?>">
                    <i class="fas fa-music"></i>&nbsp;&nbsp;<?php echo $nomeProgramma; ?>
                </a>&nbsp;&nbsp;|&nbsp;&nbsp;

                <a class="an" href="<?php echo PATH . '/news/author/' . $article->utenti->id . '/' . format_text_url(hfix($article->utenti->nome . ' ' . $article->utenti->cognome)); ?>">
                    <i class="fas fa-pencil-alt"></i>&nbsp;&nbsp;<?php echo hfix($article->utenti->nome . ' ' . $article->utenti->cognome); ?>
                </a>&nbsp;&nbsp;|&nbsp;&nbsp;

                <a class="an" href="<?php echo $articleUrl; ?>">
                    <i class="fas fa-link"></i>&nbsp;&nbsp;permalink
                </a>&nbsp;&nbsp;|&nbsp;&nbsp;

                <a class="an" href="<?php echo $articleUrl; ?>#comments">
                    <i class="fas fa-comments"></i>&nbsp;&nbsp;<fb:comments-count href="<?php echo $articleUrl; ?>"></fb:comments-count> commenti
                </a>
            </div>

            <?php

            if($article->copyright == 0): ?>
            <div class="article-image" style="background-position: center center; background-image: url('<?php echo PRODUCTION_PATH .  '/photos/covers/default_logo.jpg'; ?>');"></div>
            <?php else: ?>
            <div class="article-image" style="background-position: center <?php echo $article->cover_alignment; ?>; background-image: url('<?php echo PRODUCTION_PATH .  '/photos/news/' . $tagProgramma . '/' . $article->foto; ?>');"></div>
            <?php endif; ?>
            <div class="article-content">
                <?php echo bb_parse($article->testo); ?>

                <?php
                    $podcasts = $article->podcast_programmi;

                    if($podcasts) {
                        echo '<br>';

                        foreach($podcasts as $podcast) {
                            echo '<iframe width="100%" height="120" src="https://www.mixcloud.com/widget/iframe/?feed=' . urlencode($podcast->link) . '&hide_cover=1&light=1" frameborder="0" scrolling="no"></iframe>';
                        }
                    }

                    $medias = json_decode($article->media, true);
                    if($medias != NULL) {
                        $medias = $medias['media'];
                        foreach($medias as $media) {
                            switch($media['mediaType']) {
                                case 'youtube':
                                    echo '<br><br><iframe width="100%" height="389" src="https://www.youtube.com/embed/'.hfix($media['mediaUrl']).'" frameborder="0" allowfullscreen></iframe>';
                                    break;

                                case 'vimeo':
                                    echo '<br><br><iframe src="https://player.vimeo.com/video/'.hfix($media['mediaUrl']).'" width="100%" height="389" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>';
                                    break;

                                case 'soundcloud':
                                    echo '<br><br><iframe width="100%" height="166" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/'.hfix($media['mediaUrl']).'&amp;color=ff5500&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false"></iframe>';
                                    break;
				case 'anchor':
				    echo '<br><br><iframe src="'.hfix($media['mediaUrl']).'" height="102px" width="100%" frameborder="0" scrolling="no"></iframe>';
				    break;
                            }
                        }
                    }
                ?>
            </div>

            <div class="article-refs">
                <i class="fas fa-hashtag"></i>
                <?php
                    $tags = $article->news_programmi_tags;
                    for($a = 0; $a < count($tags); $a++) {
                        echo '<a class="an" href="'.PATH.'/news/tag/'.hfix($tags[$a]->tag).'" ">'.hfix($tags[$a]->tag).'</a>';
                        if($a+1 < count($tags)) {
                            echo ', ';
                        }
                    }
                ?>
            </div>

            <hr>

            <section id="fb-comments">
                <div class="zero wide divider bar line"></div>
                <div class="fb-comments" data-width="100%" data-href="<?php echo $articleUrl; ?>" data-numposts="5" data-colorscheme="light" data-order-by="reverse_time"></div>

            </section>
        </div>
    </div>
</div>
