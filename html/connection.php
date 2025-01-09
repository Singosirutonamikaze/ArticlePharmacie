<?php 
include 'db_connect.php'; 
if ($_SERVER["REQUEST_METHOD"] == "POST") { 
    $email = $_POST["email"]; 
    $mot_de_passe = $_POST["mot_de_passe"]; 
    // Vérification des informations de connexion 
    $query = "SELECT * FROM utilisateurs WHERE email = $1"; 
    $result = pg_query_params($connection, $query, array($email)); 
    if (pg_num_rows($result) > 0) { 
        $user = pg_fetch_assoc($result); 
        if (password_verify($mot_de_passe, $user['mot_de_passe'])) { 
            echo "Connexion réussie. Bienvenue, " . $user['prenom']; 
        } else {
            echo "Mot de passe incorrect."; 
        } 
    } else { 
        echo "Email non trouvé."; 
    } 
}
?>