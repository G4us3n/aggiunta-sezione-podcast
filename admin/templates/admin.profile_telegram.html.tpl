<div class="span2"></div>
<div class="span6">
	<form method="post" class="form-horizontal span6">
		<center>
			<h3>Modifica Telegram</h3>
		</center>
		<div class="control-group">
			<label class="control-label" for="telegram"><strong>Username di Telegram:</strong></label>
			<div class="controls">
				<div class="input-prepend">
					<span class="add-on">@</span>
					<input type="text" name="telegram" id="telegram" style="width: 170px;" placeholder="username" value="<?php echo hfix($userActions->getCurrentUser()->telegram); ?>">
				</div>
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
