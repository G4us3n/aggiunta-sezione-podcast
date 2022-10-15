<?php if($isDirettoreProgrammi) { ?>
<form method="post">
    <div class="modal hide fade" id="modalDeleteProgram">
        <input type="hidden" name="delete_program" value="<?php echo $program->id; ?>">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h3>Elimina Programma</h3>
        </div>
        <div class="modal-body" id="delete_text">
        Sei sicuro di voler eliminare il programma #<?php echo $program->id;?> <b><?php echo hfix($program->nome); ?></b>?
        </div>
        <div class="modal-footer">
            <a href="#" data-dismiss="modal" class="btn">Annulla</a>
            <button type="submit" class="btn btn-danger"><i class="icon-trash"></i>Elimina</button>
        </div>
    </div>
</form>
<?php } ?>

<ul class="breadcrumb">
    <li><a href="<?php echo $this->base_url; ?>">Home</a> <span class="divider">/</span></li>
    <?php if($isDirettivo) { ?>
    <li><a href="<?php echo $this->base_url; ?>programs.php">Statistiche Programmi</a> <span class="divider">/</span></li>  
    <?php } ?>
    <?php if($list >= 0) { ?>
    <li><a href="<?php echo $this->base_url.'programs.php?list='.$list; ?>"><?php echo $activePage; ?></a> <span class="divider">/</span></li>
    <?php } ?>
    <li class="active"><?php echo hfix($program->nome); ?></li>
    <li class="pull-right">
    <a href="<?php echo $this->base_url.'programs.php?list='.$list.'&s='.$program->id; ?>" class="btn btn-success btn-mini"><i class="icon-user"></i> Membri</a> 
    <?php if($isDirettoreProgrammi || $isProgramMember) { ?>
    <a href="<?php echo $this->base_url.'programs.php?list='.$list; ?>&m=<?php echo $program->id; ?>" class="btn btn-warning btn-mini"><i class="icon-edit"></i> Modifica</a> <?php } ?><?php if($isDirettoreProgrammi) { ?>
    <a href="#modalDeleteProgram" data-toggle="modal" class="btn btn-danger btn-mini"><i class="icon-trash"></i> Elimina programma</a></li>
    <?php } ?>
</ul>
<ul id="myTab" class="nav nav-tabs">
    <li class="active"><a href="#info" data-toggle="tab">Info</a></li>
    <li><a href="#colors_tab" data-toggle="tab">Colori</a></li>
    <li><a href="#logo_tab" data-toggle="tab">Logo</a></li>
    <li><a href="#leds_tab" data-toggle="tab">LEDs</a></li>
</ul>

<div id="myTabContent" class="tab-content">
    <div class="tab-pane fade in active" id="info">
        <div class="span3">
        </div>  
        <div class="form-horizontal span7">
            <div class="control-group">
                <label class="control-label"><strong>Nome programma:</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($program->nome); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Tag programma:</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($program->tag); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Descrizione:</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($program->descrizione); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Descrizione Lunga:</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($program->descrizionelunga); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Email:</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($program->email); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Link pagina facebook:</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($program->facebook); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Link pagina instagram:</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($program->instagram); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Link profilo twitter:</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($program->twitter); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Link account youtube:</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($program->youtube); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Link account mixcloud:</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($program->mixcloud); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Playlist spotify (collegamento diretto):</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($program->spotifydirect); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Playlist spotify (collegamento HTTP):</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($program->spotifylink); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Colore LED Studio:</strong></label>
                <div class="controls controls-text">
                    <?php echo hfix($program->led_color); ?>
                </div>
            </div>
            <?php if($isDirettivo) { ?>
            <div class="control-group">
                <label class="control-label"><strong>Stato:</strong></label>
                <div class="controls controls-text">
                    <?php echo $statusProgramma[$program->status]; ?>
                </div>
            </div>
            <?php } ?>
            <div class="control-group">
                <label class="control-label"><strong>Referente:</strong></label>
                <div class="controls controls-text">
                    <?php
                    if(is_object($referente)) {
                        echo '<a href="'.$this->base_url.'users.php?list=0&u='.$referente->id.'" target="_blank">'.hfix($referente->nome." ".$referente->cognome).'</a>';
                    }
                    ?>
                </div>
            </div>
        </div>
    </div>
    <?php $led_colors = json_decode($program->led_color, true); ?>
    <div class="tab-pane fade in" id="leds_tab">
        <div class="span3"></div>
        <div class="form-horizontal span7">
            <div class="control-group">
                <label class="control-label"><strong>LED Studio:</strong></label>
                <div class="controls controls-text">
                        <?php if(isset($led_colors['studio'])) echo hfix($led_colors['studio']); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>LED Scrivanie:</strong></label>
                <div class="controls controls-text">
                        <?php if(isset($led_colors['scrivanie'])) echo hfix($led_colors['scrivanie']); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Lampada OnAir:</strong></label>
                <div class="controls controls-text">
                        <?php if(isset($led_colors['on_air'])) echo hfix($led_colors['on_air']); ?>
                </div>
            </div>
        </div>
    </div>

    <?php $colors = json_decode($program->colors, true); ?>
    <div class="tab-pane fade in" id="colors_tab">
        <div class="span3">
        </div>  
        <div class="form-horizontal span7">
            <div class="control-group">
                <label class="control-label"><strong>Colore testo:</strong></label>
                <div class="controls controls-text">
                    <?php if(isset($colors['text'])) echo hfix($colors['text']); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Colore hover:</strong></label>
                <div class="controls">
                    <?php if(isset($colors['hover'])) echo hfix($colors['hover']); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Colore Background:</strong></label>
                <div class="controls controls-text">
                    <?php if(isset($colors['background_color'])) echo hfix($colors['background_color']); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Immagine Background:</strong></label>
                <div class="controls controls-text">
                    <?php if(isset($colors['background_image'])) echo hfix($colors['background_image']); ?>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><strong>Colore border:</strong></label>
                <div class="controls controls-text">
                    <?php if(isset($colors['border'])) echo hfix($colors['border']); ?>
                </div>
            </div>
        </div>
    </div>
    <div class="tab-pane fade in" id="logo_tab">
        <center>
            <img src="<?php echo $program->logo != '' ? $this->base_url.'../'.$program->logo : 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIwAAACMCAIAAAAhotZpAAAACXBIWXMAAAsSAAALEgHS3X78AAABWUlEQVR42u3RQQ0AIAzAwPkXiwYk7AlN7hQ06Ry+N68D2JkUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFLABZMilhyJuwqMAAAAAElFTkSuQmCC'; ?>" style="max-width: 450px;" id="logo" class="img-polaroid"><br>&nbsp;
        </center>
    </div>
</div>
