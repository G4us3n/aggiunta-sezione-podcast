<ul class="breadcrumb">
	<li><a href="<?php echo $this->base_url; ?>">Home</a> <span class="divider">/</span></li>
	<li class="active">OTP</li>
</ul>

<div class="progress progress-info">
  <div id="remaining_seconds" class="bar" style="width: <?php echo floor($remaining_seconds/30*100); ?>%"><b><?php echo $remaining_seconds; ?>s</b></div>
</div>

<table class="table table-hover table-striped">
	<thead>
		<tr>
			<th>Account</th>
			<th>Codice OTP</th>
		</tr>
	</thead>
	<tbody>
		<?php foreach($codes as $account => $code) { ?>
		<tr>
			<td><?php echo $account; ?></td>
			<td><?php echo $code; ?></td>
		</tr>
		<?php } ?>
	</tbody>
</table>

<script type="text/javascript">
	var remaining_seconds = <?php echo $remaining_seconds; ?>;
	setTimeout(function() { location.reload(); }, <?php echo $remaining_seconds * 1000; ?>);
	setInterval(function(){
		remaining_seconds = remaining_seconds - 0.1;
		w = remaining_seconds / 30 * 100;

		if(remaining_seconds >= 0) {
			$('#remaining_seconds').css('width', w.toString()+'%');
			$('#remaining_seconds').html('<b>'+Math.floor(remaining_seconds).toString()+'s</b>');
		}
		
	}, 100);
</script>