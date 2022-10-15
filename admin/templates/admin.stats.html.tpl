<ul class="breadcrumb">
	<li><a href="<?php echo $this->base_url; ?>">Home</a> <span class="divider">/</span></li>
	<li class="active">Statistiche <?php echo isset($_GET['listeners']) ? 'ascoltatori' : 'visitatori'; ?></li>
</ul>

<?php if(isset($_GET['listeners'])) { ?><div id="dayRecordsGraph" style="height: 300px; width: 100%;"></div><br><?php } ?>
<div id="weekGraph" style="height: 300px; width: 100%;"></div><br>
<div id="lastMonthGraph" style="height: 300px; width: 100%;"></div><br>
<div id="monthRecordsGraph" style="height: 300px; width: 100%;"></div><br>
<!--
<div class="span12 myGridContainer">
	<div class="myGrid">
		<div class="myGridInside">
		<div id="weekGraph" style="height: 300px; width: 100%;"></div>
		</div>
	</div>
</div>

<div class="span12 myGridContainer">
	<div class="myGrid">
		<div class="myGridInside">
		<div id="lastMonthGraph" style="height: 300px; width: 100%;"></div>
		</div>
	</div>
</div>

<div class="span12 myGridContainer">
	<div class="myGrid">
		<div class="myGridInside">
		<div id="monthRecordsGraph" style="height: 300px; width: 100%;"></div>
		</div>
	</div>
</div>
-->
<br>