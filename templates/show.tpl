<?php
    echo genShowCssStyle($show);
?>

<div id="show" class="container-<?php echo $show->tag; ?>">

    <div class="top-header container-<?php echo $show->tag; ?>">
        <h3 class="text-large-shadow"><?php echo $show->nome; ?></h3>
        <img src="<?php echo PRODUCTION_PATH . '/' . hfix($show->logo); ?>"/>
    </div>

    <div class="widget-bar"></div>

    <div style="width: calc(100% - 40px); margin-left: 20px;">
        <div class="container-border-color" style="border-style: none none solid none; border-width: 1px; padding: 1.5em 0;">
            <div class="social-icons-container">
                <?php
                    if($show->spotifydirect || $show->spotifylink){
                        $sp = $show->spotifydirect ? $show->spotifydirect : $show->spotifylink;

                        echo '<div class="social-icon-container"><a target="_blank" href="' . $sp . '" title="Spotify">
                                <i class="fab fa-spotify"></i>
                            </a></div>';
                    }

                    if($show->youtube){
                        echo '<div class="social-icon-container"><a target="_blank" href="' . $show->youtube . '" title="Youtube">
                                <i class="fab fa-youtube"></i>
                            </a></div>';
                    }

                    if($show->mixcloud){
                        echo '<div class="social-icon-container"><a target="_blank" href="' . $show->mixcloud . '" title="Mixcloud">
                                <i class="fab fa-mixcloud"></i>
                            </a></div>';
                    }

                    if($show->twitter){
                        echo '<div class="social-icon-container"><a target="_blank" href="' . $show->twitter . '" title="Twitter">
                                <i class="fab fa-twitter"></i>
                            </a></div>';
                    }

                    if($show->facebook){
                        echo '<div class="social-icon-container"><a target="_blank" href="' . $show->facebook . '" title="Facebook"
                             <i class="fab fa-facebook-f"></i>
                            </a></div>';
                    }

                    if($show->instagram){
                        echo '<div class="social-icon-container"><a target="_blank" href="' . $show->instagram . '" title="Instagram"
                             <i class="fab fa-instagram"></i>
                            </a></div>';
                    }

                    if($show->email){
                        echo '<div class="social-icon-container"><a target="_blank" href="mailto:' . $show->email . '" title="Email">
                                <i class="far fa-envelope"></i>
                            </a></div>';
                    }
                ?>

                <div class="clear"></div>
            </div>

            <div class="description">
                <?php echo $show->descrizionelunga; ?>
                <br><br>
                <?php echo listShowMembers($show); ?>
            </div>

            <div class="clear"></div>
        </div>

        <div class="show-contents container-border-color">
            <?php
                $latestNews = NewsProgrammi::find('first', array('order' => 'time DESC', 'conditions' => array('visibile = 1 AND programmi_id = ?', $show->id)));
                $latestPodcasts = PodcastProgrammi::find('all', array('order' => 'anno DESC, mese DESC, giorno DESC', 'limit' => 3, 'conditions' => array('visibile = 1 AND programmi_id = ?', $show->id)));


                if($latestNews){
                    echo '<div class="container-border-color news-box" style="background-image: url(\'' . PRODUCTION_PATH .'/photos/news/' . $show->tag . '/' . $latestNews->foto . '\');">

                            </div>';

                    if($latestPodcasts){
                        echo '<div class="container-border-color podcast-box" style="margin-right: 0;">
                                <iframe width="100%" height="100%" src="https://www.mixcloud.com/widget/iframe/?light=1&feed=' . urlencode($latestPodcasts[0]->link) . '" frameborder="0" scrolling="no" ></iframe>
                            </div>';
                    }

                    echo '<div class="clear"></div>';

                    echo '<div class="go-to-all-contents container-border-color" style="float: left; width: 633px;">
                            <a class="an hover-text-shadow" href="' . PATH . '/news/show/' . $show->id . '/' . format_text_url(hfix($show->nome)) . '">Tutte le news di ' . hfix($show->nome) . '
                            </a></div>';

                    if($latestPodcasts){
                        echo '<div class="go-to-all-contents container-border-color" style="float: right; width: 300px;">
                                <a class="an hover-text-shadow" href="' . PATH . '/podcast/' . $show->id . '/' . format_text_url(hfix($show->nome)) . '">Tutti i podcast di ' . hfix($show->nome) . '
                                </a></div>';
                    }

                    echo '<div class="clear"></div>';
                }else if($latestPodcasts){
                    $counter = 0;
                    foreach($latestPodcasts as $p){
                        $counter++;
                        echo '<div ' . ($counter == 3 ? 'style="margin-right: 0;"' : '') . ' class="container-border-color podcast-box"><iframe width="100%" height="100%" src="https://www.mixcloud.com/widget/iframe/?light=1&feed=' . urlencode($p->link) . '" frameborder="0" scrolling="no" ></iframe></div>';
                    }

                    echo '<div class="clear"></div>';
                    echo '<div class="container-border-color go-to-all-contents" style="width: 100%;">
                            <a class="an hover-text-shadow" href="' . PATH . '/podcast/' . $show->id . '/' . format_text_url(hfix($show->nome)) . '">Tutti i podcast di ' . hfix($show->nome) . '
                            </a></div>';
                }
            ?>
        </div>
    </div>
</div>
