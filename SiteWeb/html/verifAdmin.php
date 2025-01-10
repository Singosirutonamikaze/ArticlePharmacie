<?php
$hote = "localhost";
$password = "elomvi07"; // Mot de passe de la base de données
$ma_base = "nom_de_la_base"; // Nom de votre base de données
$port = "5432";
$utilisateur = "postgres"; // Utilisateur de la base de données

try {
    // Connexion à la base de données PostgreSQL avec PDO
    $bdd = new PDO("pgsql:host=$hote;port=$port;dbname=$ma_base", $utilisateur, $password);

    // Configuration de PDO pour gérer les erreurs
    $bdd->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $bdd->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);

    echo "Connexion à la base de données réussie.<br>";

    // Simulation des données de connexion d'un administrateur
    $admin_nom = $_POST['nom'] ?? null; // Récupération du nom via formulaire
    $admin_mot_de_passe = $_POST['mot_de_passe'] ?? null; // Récupération du mot de passe via formulaire

    if (!$admin_nom || !$admin_mot_de_passe) {
        echo "Veuillez fournir un nom d'utilisateur et un mot de passe.";
        exit;
    }

    // Vérification des informations dans la base de données
    $query = "SELECT * FROM employe WHERE nom = :nom AND roles = 'admin'";
    $stmt = $bdd->prepare($query);
    $stmt->bindParam(':nom', $admin_nom);
    $stmt->execute();

    $admin = $stmt->fetch();

    if ($admin) {
        // Vérifier si le mot de passe est correct
        if (password_verify($admin_mot_de_passe, $admin['mot_de_passe'])) {
            echo "Connexion réussie. Bienvenue, administrateur !";
            header('Location : ../Admin/Admin.html');
        } else {
            echo "Mot de passe incorrect.";
        }
    } else {
        echo "Administrateur introuvable.";
    }
} catch (PDOException $e) {
    echo "Erreur de connexion à la base de données : " . $e->getMessage();
}
