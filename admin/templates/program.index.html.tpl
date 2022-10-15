<div class="span6 myGridContainer">
	<div class="myGrid">
		<div class="myGridInside">
		<h4 class="myGridTitle"><i class="icon-list-alt"></i> News Popolari</h4>
		<?php if(count($newsPiuViste) == 0) { ?>
		<i>Nessuna news inserita!</i>
		<?php } else { ?>
		<table class="table table-hover">
			<tr>
				<td><strong>Titolo</strong></td>
				<td><strong>Data</strong></td>
				<td><strong>Views</strong></td>
			</tr>
		<?php foreach($newsPiuViste as $news) { ?>
			<tr>
				<td><a href="<?php echo str_replace('membri.', 'www.', $this->base_url); ?>news/<?php echo $news->id.'/'.format_text_url($news->titolo); ?>" target="_BLANK"><?php echo hfix($news->titolo); ?></a></td>
				<td><?php echo date('d-m-Y', $news->time); ?></td>
				<td><?php echo (int)$news->views; ?></td>
			</tr>
		<?php } ?>
		</table>
		<?php } ?>
		</div>
	</div>
</div>

<div class="span6 myGridContainer">
	<div class="myGrid">
		<div class="myGridInside">
		<h4 class="myGridTitle"><i class="icon-list-alt"></i> Ultime News Inserite</h4>
		<?php if(count($newsUltime) == 0) { ?>
		<i>Nessuna news inserita!</i>
		<?php } else { ?>
		<table class="table table-hover">
			<tr>
				<td><strong>Titolo</strong></td>
				<td><strong>Data</strong></td>
				<td><strong>Views</strong></td>
			</tr>
		<?php foreach($newsUltime as $news) { ?>
			<tr>
				<td><a href="http://www.poliradio.it/news/<?php echo $news->id.'/'.format_text_url($news->titolo); ?>" target="_BLANK"><?php echo hfix($news->titolo); ?></a></td>
				<td><?php echo date('d-m-Y', $news->time); ?></td>
				<td><?php echo (int)$news->views; ?></td>
			</tr>
		<?php } ?>
		</table>
		<?php } ?>
		</div>
	</div>
</div>

<div class="newLine"></div>

<?php
/*
<div class="span6 myGridContainer">
	<div class="myGrid">
		<div class="myGridInside">
		<h4 class="myGridTitle"><i class="icon-headphones"></i> Podcast Popolari</h4>
		<?php if(count($podcastPiuVisti) == 0) { ?>
		<i>Nessuna podcast inserito!</i>
		<?php } else { ?>
		<table class="table table-hover">
			<tr>
				<td><strong>Data</strong></td>
				<td><strong>Views</strong></td>
			</tr>
		<?php foreach($podcastPiuVisti as $podcast) { ?>
			<tr>
				<td><a href="#" target="_BLANK"><?php echo date('d-m-Y', $podcast->time); ?></a></td>
				<td><?php echo (int)$podcast->views; ?></td>
		<?php } ?>
		</table>
		<?php } ?>
		</div>
	</div>
</div>
*/
?>

<?php if($program->status == 0) { ?>
<div class="span6 myGridContainer">
	<div class="myGrid">
		<div class="myGridInside">
		<?php if(isset($onair_error)) { ?>
			<div class="alert alert-error">
				<button type="button" class="close" data-dismiss="alert">&times;</button>
			    <?php echo $onair_error; ?>
			</div>
		<?php } ?>
		<h4 class="myGridTitle"><i class="icon-headphones"></i> <?php echo (count($palinsesto) > 1) ? 'Prossime dirette:' : 'Prossima diretta'; ?>
		<?php $vacanza = $palinsesto[0]->vacanza; ?>
		<a class="pull-right btn btn-mini <?php echo $vacanza ? 'btn-warning' : 'btn-success'; ?>" href="<?php echo $this->base_url; ?>index.php?v=<?php echo (1-$vacanza); ?>"><?php echo $vacanza ? 'Imposta Non in Vacanza' : 'Imposta in Vacanza'; ?></a>
		</h4>
		<table class="table table-hover">
			<tr>
				<td><strong>Data</strong></td>
				<td><strong>OnAir</strong></td>
			</tr>
			<?php
			$cells = array();
			$days = array('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');
			$reverseDays = array_flip($days);
			foreach($palinsesto as $p) { ?>
				<?php
				$day = $days[$p->giorno];
				$currentDatabaseTime = convertToTime($reverseDays[date('l')], date('H'), date('i'))+date('s');
				if(strtolower(date("l")) == strtolower($day) && $currentDatabaseTime < $p->t_f) {
					$cella = 'Oggi';
					$time = time();
				} else {
					$time = strtotime('next '.$day);
					$cella = $settimana[$p->giorno].' '.date('d-m-Y', $time);
				}
				$status = date('d-m-Y', $time) == $p->notonair;
				$cella = '<tr class="'.($p->vacanza == 1 ? 'warning' : ($status ? 'error' : 'success')).'">'."\n".'<td>'.$cella;
				$cella .= ' dalle '.(($p->ora_inizio < 10) ? '0' : '').$p->ora_inizio.':'.(($p->minuto_inizio < 10) ? '0' : '').$p->minuto_inizio.' alle '.(($p->ora_fine < 10) ? '0' : '').$p->ora_fine.':'.(($p->minuto_fine < 10) ? '0' : '').$p->minuto_fine;
				$cella .= "</td>\n";
				$cella .= '<td>';
				if($vacanza) $cella .= 'Vacanza';
				else $cella .= '<a class="btn btn-mini '.($status ? 'btn-danger' : 'btn-success').'" href="'.$this->base_url.'index.php?pl='.$p->giorno.'&onair='.($status ? '1' : '0').'">'.($status ? '<i class="icon-volume-off"></i> No' : '<i class="icon-volume-up"></i> Si').'</a>';
				$cella .= '</td>';
				$cella .= "</tr>\n";
				$cells[$time] = $cella;
			} 
			ksort($cells);
			foreach($cells as $cell) {
				echo $cell;
			}
			?>
		</table>
		</div>
	</div>
</div>
<?php } ?>
<div class="span6 myGridContainer">
	<div class="myGrid">
		<div class="myGridInside">
		<h4 class="myGridTitle"><i class="icon-headphones"></i> Ultimi Podcast Inseriti</h4>
		<?php if(count($podcastUltimi) == 0) { ?>
		<i>Nessuna podcast inserito!</i>
		<?php } else { ?>
		<table class="table table-hover">
			<tr>
				<td><strong>Data</strong></td>
				<?php /*<td><strong>Views</strong></td>*/ ?>
			</tr>
		<?php foreach($podcastUltimi as $podcast) { ?>
			<tr>
				<td><?php echo ($podcast->giorno < 10 ? 0 : '').$podcast->giorno."-".($podcast->mese < 10 ? 0 : '').$podcast->mese."-".$podcast->anno; ?></td>
				<?php /*<td><?php echo (int)$podcast->views; ?></td>*/ ?>
		<?php } ?>
		</table>
		<?php } ?>
		</div>
	</div>
</div>

<div class="newLine"></div>

<div class="span6 myGridContainer">
	<div class="myGrid">
		<div class="myGridInside">
		<h4 class="myGridTitle"><i class="icon-bell"></i> Notifiche <span class="label label-info pull-right"><?php echo $unseenNotificationsCount; ?></span></h4>
		<i><?php
			if($unseenNotificationsCount+$seenNotificationsCount == 0) echo 'Al momento non ci sono notifiche!';
			else {
			?>
			<table class="table table-hover table-bordered">
				<tr>
					<th>Titolo</th>
					<th>Data</th>
					<th></th>
				</tr>
				<?php
				$i = 0;
				foreach($unseenNotifications as $notification) { 
					$i++;
					?>
				<tr class="info">
					<td><?php echo hfix($notification->titolo); ?></td>
					<td><?php echo date('d-m-Y H:i:s', $notification->time); ?></td>
					<td><a href="#" class="btn btn-mini btn-info" title="visualizza" onclick="$('#notificationID').val('<?php echo $notification->id; ?>'); $('#notificationTitle').html('<?php echo str_replace("'", "\'", hfix($notification->titolo)); ?>'); $('#notificationContent').html('<?php echo str_replace(array("\r\n", "'"), array('<br>', "\'"), hfix($notification->contenuto)); ?>'); $('#notificationModal').modal('toggle')"><i class="icon-zoom-in"></i></a> <a href="#" title="elimina" class="btn btn-mini btn-danger" onclick="$('#notificationDelete').modal('toggle'); $('#notificationDeleteID').val('<?php echo $notification->id; ?>'); $('#notificationDeleteContent').html('Eliminare la notifica \'<?php echo str_replace("'", "\'", hfix($notification->titolo)); ?>\'?');"><i class="icon-trash"></i></a></td>
				</tr>
				<?php 
					if($i > 10) goto endnotifications;
				}
				foreach($seenNotifications as $notification) { 
					$i++;?>
				<tr class="warning">
					<td><?php echo hfix($notification->titolo); ?></td>
					<td><?php echo date('d-m-Y H:i:s', $notification->time); ?></td>
					<td><a href="#" class="btn btn-mini btn-info" title="visualizza" onclick="$('#notificationID').val('<?php echo $notification->id; ?>'); $('#setSeenButton').hide(); $('#notificationTitle').html('<?php echo str_replace("'", "\'", hfix($notification->titolo)); ?>'); $('#notificationContent').html('<?php echo str_replace(array("\r\n", "'"), array('<br>', "\'"), hfix($notification->contenuto)); ?>'); $('#notificationModal').modal('toggle')"><i class="icon-zoom-in"></i></a> <a href="#" title="elimina" class="btn btn-mini btn-danger" onclick="$('#notificationDelete').modal('toggle'); $('#notificationDeleteID').val('<?php echo $notification->id; ?>'); $('#notificationDeleteContent').html('Eliminare la notifica \'<?php echo str_replace("'", "\'", hfix($notification->titolo)); ?>\'?');"><i class="icon-trash"></i></a></td>
				</tr>
				<?php 
					if($i > 10) goto endnotifications;
				}
				endnotifications:
				?>
			</table>
			<?php } ?></i>
		</div>
	</div>
</div>


<div class="span3 myGridContainer">
	<div class="myGrid">
		<div class="myGridInside">
		<h4 class="myGridTitle"><i class="icon-tags"></i> Tags pi&ugrave; usati</h4>
		<?php if(count($tagsPiuUsati) == 0) { ?>
		<i>Non hai usato alcun tag!</i>
		<?php } else { ?>
		<table class="table table-hover">
			<tr>
				<td><strong>Tag</strong></td>
				<td><strong>Utilizzi</strong></td>
			</tr>
		<?php foreach($tagsPiuUsati as $tag) { ?>
			<tr>
				<td><a href="http://www.poliradio.it/news/tag/<?php echo hfix($tag->tag); ?>" target="_BLANK"><?php echo hfix("#".$tag->tag); ?></a></td>
				<td><?php echo (int)$tag->used; ?></td>
			</tr>
		<?php } ?>
		</table>
		<?php } ?>
		</div>
	</div>
</div>
<div class="span3 myGridContainer">
	<div class="myGrid">
		<div class="myGridInside">
		<h4 class="myGridTitle"><i class="icon-tags"></i> Tags Popolari</h4>
		<?php if(count($tagsPiuVisti) == 0) { ?>
		<i>Non hai usato alcun tag!</i>
		<?php } else { ?>
		<table class="table table-hover">
			<tr>
				<td><strong>Tag</strong></td>
				<td><strong>Views</strong></td>
			</tr>
		<?php foreach($tagsPiuVisti as $tag) { ?>
			<tr>
				<td><a href="http://www.poliradio.it/news/tag/<?php echo hfix($tag->tag); ?>" target="_BLANK"><?php echo hfix("#".$tag->tag); ?></a></td>
				<td><?php echo (int)$tag->views; ?></td>
			</tr>
		<?php } ?>
		</table>
		<?php } ?>
		</div>
	</div>
</div>
<?php if($program->status == 0) { ?>
<div class="span12 myGridContainer">
	<div class="myGrid">
		<div class="myGridInside">
			<div id="listenersGraph" style="height: 300px; width: 100%;"></div>
		</div>
	</div>
</div>
<?php } ?>
