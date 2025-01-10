<?php 
include 'db_connect.php'; 
if ($_SERVER["REQUEST_METHOD"] == "POST") { 
    $email = $_POST["email"]; 
    $mot_de_passe = $_POST["mot_de_passe"]; 
    // Vérification des informations de connexion 
    $query = "SELECT * FROM utilisateurs WHERE email = :email"; 
    $stmt = $connection->prepare($query); 
    $stmt->bindParam(':email', $email); 
    $stmt->execute(); 
    $user = $stmt->fetch(PDO::FETCH_ASSOC); 
    if ($user) { 
        if (password_verify($mot_de_passe, $user['mot_de_passe'])) { 
            echo "Connexion réussie. Bienvenue, " . $user['prenom']; 
            header("Location : ../SiteWeb/produit.html");
        } else {
            echo "Mot de passe incorrect."; 
        } 
    } else { 
        echo "Email non trouvé."; 
    } 
} 
