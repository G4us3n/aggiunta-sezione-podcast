<div class="right-col mobile-hidden">
    <form method="GET" id="articles-search" action="<?php echo PATH; ?>/news/search">
        <input name="search" class="search-field" type="text" placeholder="Cerca fra le news" autocomplete="off"/>
        <button title="Cerca" type="submit" class="search-submit">
            <i class="fas fa-search"></i>
        </button>
    </form>

    <div class="title">Archivio</div>
    <ul style="clear: both; margin-left: 0; padding-left: 1em; list-style: disc;">
    <?php
        $year = date('Y');
        $mnts = Database::getNewsMonths($year);
        $i = 0;
        foreach(array_reverse($mnts) as $month) {
            if($i > 4) { break; }
            echo '<li>
                <a class="an"
                   href="' . PATH . '/news/archivio/'.$month->anno.'/'.$month->mese.'/">
                        '.getItalianMonth($month->mese).' '.$month->anno.' ('.$month->n.')
                </a>
            </li>';
            $i++;
        }
        ?>
    </ul>
    <hr />

    <div class="title">Tag Popolari</div>
    <hr />
</div>