<?php
$allow = array(
  'login.js',
  'admin.js',
  'admin.profile_photo.js',
  'admin.palinsesto.js',
  'program.news.js',
  'program.news_new.js',
  'program.podcast.js',
  'program.podcast_new.js',
  'admin.notification_send.js',
  'admin.linkindex.js',
  'admin.noticeSpeaker.js',
  'register.js'
);
$file = '../templates/'.$_GET['j'].'.tpl';

if(in_array($_GET['j'], $allow) && is_file($file)) {
  header("Content-type: text/javascript");
  echo file_get_contents($file);
}
else {
  header("HTTP/1.0 404 Not Found");
  echo "<h1>Error 404 Not Found</h1>";
    echo "The page that you have requested could not be found.";
}
?>
