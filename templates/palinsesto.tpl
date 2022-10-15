<script type="text/javascript">
    $(document).ready(function() {
        $("#palinsesto .nav-tab-container .nav-tab").click(function() {
            $(".nav-tab.selected").removeClass("selected");
            $(this).addClass("selected");

            switchToPanel($(this).data("day"));
        });

        $("#palinsesto .nav-selector").change(function() {
            switchToPanel($(this).val());
        });

        $("#palinsesto .day-panel-container .day-panel .show-info-container a").mouseenter(function() {
            $(this).next(".bubble").fadeToggle(300);
        }).mouseleave(function() {
            $(this).next(".bubble").fadeToggle(300);
        });

        var current_day = (new Date()).getDay();
        current_day = (current_day !== 0 ? current_day-1 : 6);

        if(isMobileTemplate()){
            $("#palinsesto .nav-selector").val(current_day);
            switchToPanel(current_day)
        }else{
            $("#palinsesto .nav-tab-container .nav-tab[data-day='" + current_day + "']").click();
        }
    });

    function switchToPanel(day){
        $(".day-panel").hide();
        $(".day-panel[data-day='" + day + "']").show();
    }
</script>

<div id="palinsesto">
    <div class="join-us new-palinsesto" style="margin-bottom: 1em;">
        <span style="display:none; font-weight: bold; font-size: 1.3em; color: #59b7de;">NUOVO PALINSESTO IN ARRIVO <i class="fab fa-hotjar"></i> </span>
        <p style="margin-bottom: 0; padding-bottom: 0;">
            Hai un idea per un programma? Vuoi entrare nella nostra squadra? Non vediamo l'ora <i class="far fa-hand-peace"></i>
        </p>
        <div style="margin-top: 1.5em;" class="join"><a class="an" href="/contatti">CONTATTACI</a></div>
    </div>

    <div class="nav-tab-container mobile-hidden">
        <div class="nav-tab" data-day="0">Lunedì</div>
        <div class="nav-tab" data-day="1">Martedì</div>
        <div class="nav-tab" data-day="2">Mercoledì</div>
        <div class="nav-tab" data-day="3">Giovedì</div>
        <div class="nav-tab" data-day="4">Venerdì</div>
        <div class="nav-tab" data-day="5">Sabato</div>

        <div class="clear"></div>
    </div>

    <select class="nav-selector desktop-hidden">
        <option value="0">Lunedì</option>
        <option value="1">Martedì</option>
        <option value="2">Mercoledì</option>
        <option value="3">Giovedì</option>
        <option value="4">Venerdì</option>
        <option value="5">Sabato</option>
    </select>

    <div class="day-panel-container">
        <?php
            for($i = 0; $i < 7; $i++){
                echo '<div class="day-panel" data-day="' . $i . '">';

                for($a = 0; $a < count($palinsesto[$i]); $a++){
                    $record = $palinsesto[$i][$a];
                    $program = Database::programExists($record->programmi_id, 2);

                    echo genShowCssStyle($program);

                    echo '<div class="show-row container-' . $program->tag .'">
                            <div class="time-container">
                                ' . addLeadingZero($record->ora_inizio) . ':' . addLeadingZero($record->minuto_inizio) . '
                                <span class="desktop-hidden">' . addLeadingZero($record->ora_fine) . ':' . addLeadingZero($record->minuto_fine) . '</span>
                            </div>
                            <div class="show-info-container">
                                <a href="' . PATH . '/show/' . $program->id . '/' . format_text_url(hfix($program->nome)) . '" class="an hover-text-shadow">' . hfix($program->nome) . '</a>

                                <div class="bubble mobile-hidden container-' . $program->tag . '">
                                    <img src="' . PRODUCTION_PATH . '/' . hfix($program->logo) . '"/>
                                    <p>' . bb_parse($program->descrizione) . '</p>
                                </div>
                            </div>
                            <div class="time-container mobile-hidden">
                                ' . addLeadingZero($record->ora_fine) . ':' . addLeadingZero($record->minuto_fine) . '
                            </div>

                            <div class="clear"></div>
                        </div>';
                }

                if(count($palinsesto[$i]) == 0){
                    echo '<div class="sorry-box"><i class="far fa-bell"></i>
                            <p>A quanto pare a nessuno piace fare programmi di <b>' . getItalianDayOfWeek($i) .'</b>!
                            <br>A te piacerebbe?</p>
                            <div class="propose"><a class="an" href="' . PATH . '/contatti">Contattaci</a></div>';
                }
		# fix per chi ha il monitor da povery
		for($giovannicassani = 0; $giovannicassani < 12; $giovannicassani++) echo '<br>';
                echo '</div>';
            }
        ?>
    </div>
</div>
