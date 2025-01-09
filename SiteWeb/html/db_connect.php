<?php 
$host = "localhost"; 
$port = "5432"; 
$dbname = "Pharmacie_Gestion"; 
$user = "postgres"; 
$password = "elomvi07"; 
$connection = pg_connect("host=$host port=$port dbname=$dbname user=$user password=$password"); 
if (!$connection) { 
    die("Connexion échouée : " . pg_last_error()); 
    } 
?>