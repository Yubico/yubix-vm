<?php

define('FILENAME', '/var/www/html/yubix/conf_done');

if(file_exists(FILENAME)) {
	header("Location: http://".$_SERVER['SERVER_NAME'].":8080/");
	die();
}

if(isset($_POST['username'])) {
	if(strlen($_POST['password']) > 3 && $_POST['password'] == $_POST['verify']) {
		$ch = curl_init('http://127.0.0.1:8080/admin/general');
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($ch, CURLOPT_USERPWD, "yubiadmin:yubiadmin");
		curl_setopt($ch, CURLOPT_POST, 1);
		curl_setopt($ch, CURLOPT_POSTFIELDS, "interface=0.0.0.0&port=8080&username=".$_POST['username']."&password=".$_POST['password']);
		curl_exec($ch);

		curl_setopt($ch, CURLOPT_URL, "http://127.0.0.1:8080/admin/restart");
		curl_exec($ch);
		curl_close($ch);

		$fp = fopen(FILENAME, 'w');
		fwrite($fp, "");
		fclose($fp);

		sleep(5);

		header("Location: http://".$_SERVER['SERVER_NAME'].":8080/");
		die();
	} else {
		$error=true;
	}
}

?><!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<title>YubiX</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width">

        <link rel="stylesheet" href="/yubix/css/bootstrap.min.css">
        <style>
            body {
                padding-top: 60px;
                padding-bottom: 40px;
            }
        </style>
        <link rel="stylesheet" href="/yubix/css/bootstrap-responsive.min.css">
        <link rel="stylesheet" href="/yubix/css/main.css">
    </head>
    <body>
        <!--[if lt IE 7]>
            <p class="chromeframe">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> or <a href="http://www.google.com/chromeframe/?redirect=true">activate Google Chrome Frame</a> to improve your experience.</p>
        <![endif]-->

        <!-- This code is taken from http://twitter.github.com/bootstrap/examples/hero.html -->

	<div class="container">
	<div class="row">
	<div class="well span8 offset2">
		<h1>Welcome to YubiX!</h1>
		<br />
		<p>Before you get started, you need to set a username and password to restrict access to the admin interface.</p>
		<br /><br />
		<?php if($error) : ?>
		<div class="alert alert-error">
		There was a problem with your submitted data! Please ensure that you enter a valid username and a password of at least 4 characters.
		</div>
		<?php endif ?>
		<form method="post" class="form-horizontal">
			<div class="control-group">
			<label for="username" class="control-label">Username</label>
			<div class="controls">
			<input type="text" id="username" name="username" placeholder="Choose a username..." />
			</div>
			</div>
			<div class="control-group">
			<label for="password" class="control-label">Password</label>
			<div class="controls">
			<input type="password" id="password" name="password" placeholder="Choose a password..." />
			</div>
			</div>
			<div class="control-group">
			<label for="verify" class="control-label">Repeat password</label>
			<div class="controls">
			<input type="password" id="verify" name="verify" placeholder="Repeat the password..." />
			</div>
			</div>
			<div class="control-group">
			<div class="controls">
			<input type="submit" class="btn btn-primary pull-right" value="Set credentials" />
			</div>
			</div>
		</form>
	</div>
	</div>
	</div>

    </body>
</html>
