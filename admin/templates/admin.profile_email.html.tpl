<div class="span2"></div>
<div class="span6">
	<form method="post" class="form-horizontal span6">
		<center>
			<h3>Modifica Email</h3>
		</center>
		<div class="control-group">
			<label class="control-label" for="email"><strong>Email:</strong></label>
			<div class="controls">
				<input type="text" name="email" id="email" placeholder="Email" value="<?php echo hfix($userActions->getCurrentUser()->email); ?>">
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
				<button type="submit" class="btn">Modifica Email</button>
			</div>
		</div>
	</form>
</div>