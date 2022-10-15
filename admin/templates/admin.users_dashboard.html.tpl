<ul class="breadcrumb">
    <li><a href="<?php echo $this->base_url; ?>">Home</a> <span class="divider">/</span></li>
    <li class="active">Statistiche Membri</li>
</ul>
<center>
<table class="table table-hover table-striped" style="width: 350px;">
    <tr>
        <td><strong><a href="<?php $this->base_url; ?>users.php?list=0">Membri Totali:</a></strong></td>
        <td><?php echo $membriTotali; ?></td>
    </tr>
    <tr>
        <td><strong><a href="<?php $this->base_url; ?>users.php?list=15">Membri 'Socio Ordinario':</a></strong></td>
        <td><?php echo $socio_ordinario; ?></td>
    </tr>
    <tr>
        <td><strong><a href="<?php $this->base_url; ?>users.php?list=16">Membri 'Socio Onorario':</a></strong></td>
        <td><?php echo $socio_onorario; ?></td>
    </tr>
    <tr>
        <td><strong><a href="<?php $this->base_url; ?>users.php?list=17">Membri 'Collaboratori':</a></strong></td>
        <td><?php echo $collaboratori; ?></td>
    </tr>
    <tr>
        <td><strong><a href="<?php $this->base_url; ?>users.php?list=1">Membri attivi:</a></strong></td>
        <td><?php echo $membriAttivi; ?></td>
    </tr>
    <tr<?php echo $membriAttivare1 > 0 ? ' class="info"' : ''; ?>>
        <td><strong><a href="<?php $this->base_url; ?>users.php?list=2">Membri da attivare (step 1):</a></strong></td>
        <td><?php echo $membriAttivare1; ?></td>
    </tr>
    <tr<?php echo $membriAttivare2 > 0 ? ' class="info"' : ''; ?>>
        <td><strong><a href="<?php $this->base_url; ?>users.php?list=3">Membri da attivare (step 2):</a></strong></td>
        <td><?php echo $membriAttivare2; ?></td>
    </tr>
    <tr>
        <td><strong><a href="<?php $this->base_url; ?>users.php?list=4">Membri Non Attivi:</a></strong></td>
        <td><?php echo $membriNonAttivi; ?></td>
    </tr>
    <tr>
        <td><strong><a href="<?php $this->base_url; ?>users.php?list=5">Membri Uomini:</a></strong></td>
        <td><?php echo $membriUomini; ?></td>
    </tr>
    <tr>
        <td><strong><a href="<?php $this->base_url; ?>users.php?list=6">Membri Donna:</a></strong></td>
        <td><?php echo $membriDonna; ?></td>
    </tr>
    <tr>
        <td><strong><a href="<?php $this->base_url; ?>users.php?list=7">Membri Altro Sesso:</a></strong></td>
        <td><?php echo $membriAltro; ?></td>
    </tr>
    <tr<?php echo $membriQuota > 0 ? ' class="info"' : ''; ?>>
        <td><strong><a href="<?php $this->base_url; ?>users.php?list=8">Membri con quota non pagata:</a></strong></td>
        <td><?php echo $membriQuota; ?></td>
    </tr>
    <tr<?php echo $membriFirma > 0 ? ' class="info"' : ''; ?>>
        <td><strong><a href="<?php $this->base_url; ?>users.php?list=9">Membri con liberatoria da firmare:</a></strong></td>
        <td><?php echo $membriFirma; ?></td>
    </tr>
    <tr<?php echo $membriFirmaQuota > 0 ? ' class="info"' : ''; ?>>
        <td><strong><a href="<?php $this->base_url; ?>users.php?list=10">Membri con quota non pagata e liberatoria non firmata:</a></strong></td>
        <td><?php echo $membriFirmaQuota; ?></td>
    </tr>
    <tr>
        <td><strong><a href="<?php $this->base_url;?>users.php?list=11">Amministratori:</a></strong></td>
        <td><?php echo $membriAdministrator; ?></td>
    </tr>
    <tr>
        <td><strong><a href="<?php $this->base_url;?>users.php?list=12">Membri del Direttivo:</a></strong></td>
        <td><?php echo $membriDirettivo; ?></td>
    </tr>
    <tr>
        <td><strong><a href="<?php $this->base_url;?>users.php?list=13">Membri senza accesso alla Redazione:</a></strong></td>
        <td><?php echo $membriNoRedazione; ?></td>
    </tr>
    <tr>
        <td><strong><a href="<?php $this->base_url;?>users.php?list=14">Membri con accesso alla Redazione:</a></strong></td>
        <td><?php echo $membriRedazione; ?></td>
    </tr>
    <tr>
        <td><strong><a href="<?php $this->base_url;?>users.php?list=18">Membri con accesso Amministratore alla Redazione:</a></strong></td>
        <td><?php echo $membriAdminRedazione; ?></td>
    </tr>
    <tr>
        <td><strong><a href="<?php $this->base_url;?>users.php?list=19">Membri con accesso OTP:</a></strong></td>
        <td><?php echo $membriAccessoOTP; ?></td>
    </tr>
</table>
</center>
