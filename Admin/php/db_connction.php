<?php
// Connexion A postgres SQL

$hote = 'localhost'; 
$port = '5432';
$nom_base = 'Pharmacie_Gestion';
$utilisateur = 'postgres';
$mot_de_passe = 'goruaang12345';

try {
    // Créer une connexion PDO
    $dsn = "pgsql:host=$hote;port=$port;dbname=$nom_base";
    $connexion = new PDO($dsn, $utilisateur, $mot_de_passe);

    // Définir le mode d'erreur (optionnel mais utile)
    $connexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    echo "Connexion réussie à PostgreSQL avec PDO !";
} catch (PDOException $e) {
    echo "Erreur de connexion : " . $e->getMessage();
}


