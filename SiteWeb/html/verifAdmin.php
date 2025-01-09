<?php
$hote = "localhost";
$password = "elomvi07";
$ma_base = " nom_de_la_base";
$port = " 5432";

try {
    $bdd = new PDO("pgsql:");
} catch (\Throwable $th) {
    //throw $th;
}





