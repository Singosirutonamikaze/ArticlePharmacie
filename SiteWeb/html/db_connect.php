<?php
// Paramètres de connexion à la base de données
$host = "localhost";
$port = "5432";
$dbname = "Pharmacie_Gestion";
$user = "postgres";
$password = "elomvi07";

// Établir la connexion
$connection = pg_connect("host=$host port=$port dbname=$dbname user=$user password=$password");

// Vérification de la connexion
if (!$connection) {
    // Message générique pour ne pas exposer les détails
    die("Impossible de se connecter à la base de données.");
} else {
    echo "Connexion réussie à la base de données.";
}

// Fermer la connexion (à inclure après utilisation)
pg_close($connection);

