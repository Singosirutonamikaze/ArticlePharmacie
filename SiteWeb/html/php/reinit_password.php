<?php 
if ($_SERVER["REQUEST_METHOD"] == "POST") { 
    $email = $_POST["email"]; 
    // Vérifier si l'email existe dans la base de données 
    $query = "SELECT * FROM utilisateurs WHERE email = $1"; 
    $result = pg_query_params($connection, $query, array($email)); 
    if (pg_num_rows($result) > 0) { 
        // Générer un lien de réinitialisation 
        $reset_link = "https://votre_site.com/reset_password.php?email=" . urlencode($email); 
        // Envoyer un email 
        mail($email, "Réinitialisation du mot de passe", "Cliquez sur ce lien pour réinitialiser votre mot de passe : " . $reset_link); 
        echo "Un email de réinitialisation a été envoyé."; 
    } else { 
        echo "Cet email n'est pas enregistré."; 
    } 
} 















