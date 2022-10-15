<div class="span2"></div>
<div class="span6">
	<form method="post" class="form-horizontal span6">
		<center>
			<h3>Modifica Pseudonimo</h3>
		</center>
		<div class="control-group">
			<label class="control-label" for="pseudonimo"><strong>Pseudonimo:</strong></label>
			<div class="controls">
				<input type="text" name="pseudonimo" id="pseudonimo" placeholder="pseudonimo" value="<?php echo hfix($userActions->getCurrentUser()->pseudonimo); ?>">
			</div>
		</div>
		<div class="control-group">
			<label class="control-label" for="inputPassword"><strong>Password:</strong></label>
			<div class="controls">
				<input type="password" name="password" id="inputPassword" placeholder="Password">
			</div>
		</div>
		<div class="control-group">
			<div class="controls">
				<button type="submit" class="btn btn-primary">Modifica</button>
			</div>
		</div>
	</form>
</div>
