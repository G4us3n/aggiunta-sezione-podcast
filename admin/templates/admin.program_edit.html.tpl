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
    <li><a href="<?php echo $this->base_url; ?>programs.php">Statistiche Programmi</a> <span class="divider">/</span></li>
    <?php if($list >= 0) { ?>
    <li><a href="<?php echo $this->base_url.'programs.php?list='.$list; ?>"><?php echo $activePage; ?></a> <span class="divider">/</span></li>
    <?php } ?>
    <li><a href="<?php echo $this->base_url.'programs.php?list='.$list.'&p='.$program->id; ?>"><?php echo hfix($program->nome); ?></a> <span class="divider">/</span></li>
    <li class="pull-right"><a href="<?php echo $this->base_url.'programs.php?list='.$list.'&s='.$program->id; ?>" class="btn btn-success btn-mini"><i class="icon-user"></i> Membri</a></li>
    <li class="pull-right"><a href="javascript:" id="hextogglebutton" class="btn btn-success btn-mini"><i class="icon-user"></i> Hex Color</a></li>
    <li class="active">Modifica Programma</li>
</ul>

<?php if($isDirettoreProgrammi) { ?>
<ul id="myTab" class="nav nav-tabs">
    <li class="active"><a href="#info" data-toggle="tab">Info</a></li>
    <li><a href="#colors_tab" data-toggle="tab">Colori</a></li>
    <li><a href="#logo_tab" data-toggle="tab">Logo</a></li>
    <li><a href="#bg_image_tab" data-toggle="tab">Immagine Background</a></li>
    <li><a href="#leds_tab" data-toggle="tab">LEDs</a></li>
</ul>
<?php } ?>

<form method="post">
<div id="myTabContent" class="tab-content">
    <div class="tab-pane fade in active" id="info">
        <div class="span2">
        </div>
        <div class="span7">
            <?php if(isset($errors)) { ?>
            <div class="alert alert-danger">
                <button type="button" class="close" data-dismiss="alert">&times;</button>
                <?php foreach($errors as $error) {
                    echo $error.'<br>';
                }
                ?>
            </div>
            <?php } ?>
            <?php if(count($_POST) > 0 && !isset($errors)) { ?>
            <div class="alert alert-success">
                <button type="button" class="close" data-dismiss="alert">&times;</button>
                Programma modificato con successo!
            </div>
            <?php } ?>
                <div class="form-horizontal">
                    <?php if($isDirettoreProgrammi) { ?>
                    <div class="control-group">
                        <label class="control-label" for="inputNome"><strong>Nome programma:</strong></label>
                        <div class="controls">
                            <input class="input-big" name="nome" type="text" id="inputNome" placeholder="Nome programma" value="<?php echo hfix($program->nome); ?>">
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="inputTag"><strong>Tag programma:</strong></label>
                        <div class="controls">
                            <input class="input-big" name="tag" type="text" id="inputTag" placeholder="Tag programma" value="<?php echo hfix($program->tag); ?>">
                        </div>
                    </div>
                    <?php } ?>
                    <div class="control-group">
                        <label class="control-label" for="inputDescrizione"><strong>Descrizione:</strong></label>
                        <div class="controls">
                            <textarea class="input-big" name="descrizione" id="inputDescrizione" placeholder="Descrizione"><?php echo hfix($program->descrizione); ?></textarea>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="inputDescrizioneLunga"><strong>Descrizione Lunga:</strong></label>
                        <div class="controls">
                            <textarea class="input-big" name="descrizionelunga" id="inputDescrizioneLunga" placeholder="Descrizione Lunga"><?php echo hfix($program->descrizionelunga); ?></textarea>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="inputEmail"><strong>Email:</strong></label>
                        <div class="controls">
                            <input class="input-big" name="email" type="text" id="inputEmail" placeholder="Email" value="<?php echo hfix($program->email); ?>">
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="inputFacebook"><strong>Link pagina facebook:</strong></label>
                        <div class="controls">
                            <input class="input-big" name="facebook" type="text" id="inputFacebook" placeholder="https://www.facebook.com/PaginaProgramma" value="<?php echo hfix($program->facebook); ?>">
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="inputInstagram"><strong>Link pagina instagram:</strong></label>
                        <div class="controls">
                            <input class="input-big" name="instagram" type="text" id="inputInstagram" placeholder="https://www.instagram.com/PaginaProgramma" value="<?php echo hfix($program->instagram); ?>">
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="inputTwitter"><strong>Link profilo twitter:</strong></label>
                        <div class="controls">
                            <input class="input-big" name="twitter" type="text" id="inputTwitter" placeholder="https://twitter.com/ProfiloProgramma" value="<?php echo hfix($program->twitter); ?>">
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="inputYoutube"><strong>Link account youtube:</strong></label>
                        <div class="controls">
                            <input class="input-big" name="youtube" type="text" id="inputYoutube" placeholder="https://www.youtube.com/user/AccountProgramma" value="<?php echo hfix($program->youtube); ?>">
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="inputMixcloud"><strong>Link account mixcloud:</strong></label>
                        <div class="controls">
                            <input class="input-big" name="mixcloud" type="text" id="inputMixcloud" placeholder="http://www.mixcloud.com/NomeProgramma" value="<?php echo hfix($program->mixcloud); ?>">
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="inputSpotifyDirect"><strong>Link diretto playlist spotify:</strong></label>
                        <div class="controls">
                            <input class="input-big" name="spotifyDirect" type="text" id="inputSpotifyDirect" placeholder="spotify:user:poliradio:playlist:..." value="<?php echo hfix($program->spotifydirect); ?>">
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="inputSpotifyHTTP"><strong>Link HTTP playlist spotify:</strong></label>
                        <div class="controls">
                            <input class="input-big" name="spotifyHTTP" type="text" id="inputSpotifyHTTP" placeholder="https://open.spotify.com/user/poliradio/playlist/..." value="<?php echo hfix($program->spotifylink); ?>">
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="led_color"><strong>Colore LED Studio:</strong></label>
                        <div class="controls">
                            <input class="input-big colorpicker" name="led_color" type="text" id="led_color" placeholder="" value="<?php echo hfix($program->led_color); ?>">
                        </div>
                    </div>
                    <?php if($isDirettoreProgrammi) { ?>
                    <div class="control-group">
                        <label class="control-label" for="inputStatus"><strong>Stato:</strong></label>
                        <div class="controls">
                            <select name="status" id="inputStatus" class="select-big">
                                <option value=""></option>
                                <option value="0"<?php if($program->status == 0) echo ' selected'; ?>>Attivo e Visibile</option>
                                <option value="1"<?php if($program->status == 1) echo ' selected'; ?>>Attivo e non Visibile</option>
                                <option value="2"<?php if($program->status == 2) echo ' selected'; ?>>Non Attivo e Visibile</option>
                                <option value="3"<?php if($program->status == 3) echo ' selected'; ?>>Disabilitato</option>
                            </select>
                        </div>
                    </div>
                    <?php } ?>
                    <div class="control-group">
                        <div class="controls">
                            <?php if($isDirettoreProgrammi) { ?><a href="#modalDeleteProgram" data-toggle="modal" class="btn btn-danger btn-medium"><i class="icon-trash"></i> Elimina programma</a> <?php } ?>
                            <button type="submit" class="btn btn-primary btn-medium"><i class="icon-ok"></i> Salva</button>
                        </div>
                    </div>
                </div>
        </div>
    </div>

    <?php
    $led_colors = json_decode($program->led_color, true);
    ?>
    <div class="tab-pane fade in" id="leds_tab">
        <div class="span2"></div>
        <div class="span6">
            <div class="form-horizontal">
                <div class="control-group">
                    <label class="control-label" for="inputLEDStudio"><strong>LED Studio:</strong></label>
                    <div class="controls">
                        <!--<div class="input-prepend">
                            <span class="add-on">#</span>
                            <input class="input-big colorpicker" name="led_studio" type="text" id="inputLEDStudio" placeholder="XXXXXX" value="<?php if(isset($led_colors['studio'])) echo hfix($led_colors['studio']); ?>">
                        </div>-->
			<input class="input-big" name="led_studio" type="color" id="inputLEDStudio" style="height:30px" value="#<?php if(isset($led_colors['studio'])) echo hfix($led_colors['studio']); ?>">
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="inputLEDScrivanie"><strong>LED Scrivanie:</strong></label>
                    <div class="controls">
                        <!--<div class="input-prepend">
                            <span class="add-on">#</span>
                            <input class="input-big colorpicker" name="led_tavoli" type="text" id="inputLEDScrivanie" placeholder="XXXXXX" value="<?php if(isset($led_colors['scrivanie'])) echo hfix($led_colors['scrivanie']); ?>">
                        </div>-->
                        <input class="input-big" name="led_tavoli" type="color" id="inputLEDSscrivanie" style="height:30px" value="#<?php if(isset($led_colors['scrivanie'])) echo hfix($led_colors['scrivanie']); ?>">
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="inputLampadaOnAir"><strong>Lampada OnAir:</strong></label>
                    <div class="controls">
                        <!--<div class="input-prepend">
                            <span class="add-on">#</span>
                            <input class="input-big colorpicker" name="led_on_air" type="text" id="inputLampadaOnAir" placeholder="XXXXXX" value="<?php if(isset($led_colors['on_air'])) echo hfix($led_colors['on_air']); ?>">
                        </div>-->
                        <input class="input-big" name="led_on_air" type="color" id="inputLampadaOnAir" style="height:30px" value="#<?php if(isset($led_colors['on_air'])) echo hfix($led_colors['on_air']); ?>">
                    </div>
                </div>
                <div class="control-group">
                    <div class="controls">
                        <button type="submit" class="btn btn-primary btn-medium"><i class="icon-ok"></i> Salva</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <?php if($isDirettoreProgrammi) { 
        $colors = json_decode($program->colors, true);
    ?>
    <div class="tab-pane fade in" id="colors_tab">
        <div class="span2"></div>
        <div class="span6">
            <div class="form-horizontal">
                <div class="control-group">
                    <label class="control-label" for="inputColoreTesto"><strong>Colore testo:</strong></label>
                    <div class="controls">
                        <!--<div class="input-prepend">
                            <span class="add-on">#</span>
                            <input class="input-big colorpicker" name="text" type="text" id="inputColoreTesto" placeholder="XXXXXX" value="<?php if(isset($colors['text'])) echo hfix($colors['text']); ?>">
                        </div>-->
                        <input class="input-big" name="text" type="color" id="inputColoreTesto" style="height:30px" value="#<?php if(isset($colors['text'])) echo hfix($colors['text']); ?>">
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="inputColoreHover"><strong>Colore hover:</strong></label>
                    <div class="controls">
                        <!--<div class="input-prepend">
                            <span class="add-on">#</span>
                            <input class="input-big colorpicker" name="hover" type="text" id="inputColoreHover" placeholder="XXXXXX" value="<?php if(isset($colors['hover'])) echo hfix($colors['hover']); ?>">
                        </div>-->
                        <input class="input-big" name="hover" type="color" id="inputColoreHover" style="height:30px" value="#<?php if(isset($colors['hover'])) echo hfix($colors['hover']); ?>">
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="inputColoreBackground"><strong>Colore Background:</strong></label>
                    <div class="controls">
                        <!--<div class="input-prepend">
                            <span class="add-on">#</span>
                            <input class="input-big colorpicker" name="background_color" type="text" id="inputColoreBackground" placeholder="XXXXXX" value="<?php if(isset($colors['background_color'])) echo hfix($colors['background_color']); ?>">
                        </div>-->
                        <input class="input-big" name="background_color" type="color" id="inputColoreBackground" style="height:30px" value="#<?php if(isset($colors['background_color'])) echo hfix($colors['background_color']); ?>">
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="inputColoreBorder"><strong>Colore border:</strong></label>
                    <div class="controls">
                        <!--<div class="input-prepend">
                            <span class="add-on">#</span>
                            <input class="input-big colorpicker" name="border" type="text" id="inputColoreBorder" placeholder="XXXXXX" value="<?php if(isset($colors['border'])) echo hfix($colors['border']); ?>">
                        </div>-->
                        <input class="input-big" name="border" type="color" id="inputColoreBorder" style="height:30px" value="#<?php if(isset($colors['border'])) echo hfix($colors['border']); ?>">
                    </div>
                </div>
                <div class="control-group">
                    <div class="controls">
                        <button type="submit" class="btn btn-primary btn-medium"><i class="icon-ok"></i> Salva</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
<?php } ?>
</form>
<?php if($isDirettoreProgrammi) { ?>
    <div class="tab-pane fade in" id="logo_tab">
        <div class="span2"></div>
        <div class="span6">
            <form method="post" enctype="multipart/form-data" id="MyUploadForm" class="form-horizontal span6">
                <div id="output"></div>
                <center>
                    <h3>Modifica Logo</h3>
                <img src="<?php echo $program->logo != '' ? $this->base_url.'../'.$program->logo : 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIwAAACMCAIAAAAhotZpAAAACXBIWXMAAAsSAAALEgHS3X78AAABWUlEQVR42u3RQQ0AIAzAwPkXiwYk7AlN7hQ06Ry+N68D2JkUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFLABZMilhyJuwqMAAAAAElFTkSuQmCC'; ?>" style="max-width: 450px;" id="logo" class="img-polaroid"><br><br>
                    <a class="btn btn-info" href="#" onclick="rotate_myimg(-90);"><i class="icon-repeat"></i><i class="icon-arrow-left"></i></a>
                    <a class="btn btn-info" href="#" onclick="rotate_myimg(180);"><i class="icon-repeat"></i><i class="icon-arrow-down"></i></a>
                    <a class="btn btn-info" href="#" onclick="rotate_myimg(90);"><i class="icon-repeat"></i><i class="icon-arrow-right"></i></a>
                </center>
                <br>
                <div class="control-group">
                    <label class="control-label" for="FileInput"><strong>Logo:</strong></label>
                    <div class="controls">
                        <input name="FileInput" id="FileInput" type="file" />
                    </div>
                </div>
                <div class="control-group">
                    <div class="controls">
                        <input type="submit" id="submit-btn" class="btn btn-info btn-small" value="Upload" />
                    </div>
                </div>
                <div class="control-group" id="uploadProgress" style="display: none;">
                    <div class="progress progress-striped active">
                        <div class="bar" style="width: 0%;" id="progressbar">0%</div>
                    </div>
                </div>
            </form>
        </div>
        <script type="text/javascript">
            function rotate_myimg(deg){
                $.get('<?php echo $this->base_url; ?>rotator.php', {'rot': deg, 'p':'<?php echo $program->id; ?>'}, function(data){
                    var myimg = $('#logo').attr('src');
                    $('#logo').attr('src', myimg+'?'+Math.floor((Math.random()*1000)+1));
                });
            }
            function afterSuccess() {
                $('#submit-btn').show();
                $('#loading-img').hide();
                $('#uploadProgress').delay( 1000 ).fadeOut();
                var photo = $('#logo').attr('src');
                if(photo.search('base64') >= 0) {
                    $.get('<?php echo $this->base_url; ?>rotator.php?purlOf=<?php echo $program->id; ?>', function(data){
                        if(data.search('base64') == -1) {
                            $('#logo').attr('src', data);
                        }
                    });
                }
                else {
                    $('#logo').attr('src', photo+'?rand='+ Math.random());
                }
                $('#logo').show();
            }
	    document.addEventListener('DOMContentLoaded', _ => {
		//document.querySelector('#hextogglebutton').setAttribute('href', 'javascript:');
		let els = document.querySelectorAll('input[type="color"]');

		let active = false;
		document.querySelector('#hextogglebutton').addEventListener('click', _ => {
			els.forEach(item => item.setAttribute('type', (active?'color':'text')));
			active = !active;
		});
		//document.querySelectorAll('input[type="color"]').forEach(item => item.setAttribute('type', 'text'));
	    });
        </script>
    </div>
<?php } ?>

<?php if($isDirettoreProgrammi) { ?>
    <div class="tab-pane fade in" id="bg_image_tab">
        <div class="span2"></div>
        <div class="span6">
            <form method="post" enctype="multipart/form-data" id="BgImageUploadForm" class="form-horizontal span6">
                <div id="outputText" style="list-style-type:none"></div>
                <center>
                    <h3>Immagine Background</h3>
                <img src="<?php echo $program->logo != '' ? $this->base_url.'../'.$program->background_image : 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIwAAACMCAIAAAAhotZpAAAACXBIWXMAAAsSAAALEgHS3X78AAABWUlEQVR42u3RQQ0AIAzAwPkXiwYk7AlN7hQ06Ry+N68D2JkUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFKASQEmBZgUYFLABZMilhyJuwqMAAAAAElFTkSuQmCC'; ?>" style="max-width: 450px;" id="background_image" class="img-polaroid"><br><br>
                </center>
                <br>
                <div class="control-group">
                    <label class="control-label" for="BackgroundImageInput"><strong>Immagine Background:</strong></label>
                    <div class="controls">
                        <input name="BackgroundImageInput" id="BackgroundImageInput" type="file" />
                    </div>
                </div>
                <div class="control-group">
                    <div class="controls">
                        <input type="button" id="submit-btn" class="btn btn-info btn-small" value="Upload" onclick="upload(event);" />
                    </div>
                </div>
                <div class="control-group" id="uploadProgress" style="display: none;">
                    <div class="progress progress-striped active">
                        <div class="bar" style="width: 0%;" id="progressbar">0%</div>
                    </div>
                </div>
            </form>
        </div>
        <script>
        async function upload(e) {
            e.preventDefault();
            const response = await fetch(window.location.href, {
                method: 'POST',
                body: new
            FormData(document.getElementById('BgImageUploadForm'))
            });

            document.getElementById('outputText').innerHTML += await response.text();

            //alert(await response.text())
        }
        </script>
    </div>
<?php } ?>

</div>
