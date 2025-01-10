<?php 
if ($_SERVER["REQUEST_METHOD"] == "POST") { 
    $nom = $_POST["nom"]; 
    $prenom = $_POST["prenom"]; 
    $email = $_POST["email"]; 
    $adresse = $_POST["adresse"]; 
    // Vérifier si le client existe déjà 
    $query = "SELECT * FROM utilisateurs WHERE email = $1"; 
    $result = pg_query_params($connection, $query, array($email)); 
    if (pg_num_rows($result) > 0) { 
        // Si le client existe, afficher un message 
        echo "Un client avec cet email existe déjà."; 
    } else { 
        // Si le client n'existe pas, insérer la commande dans la base de données 
        $query = "INSERT INTO commandes (nom, prenom, email, adresse) VALUES ($1, $2, $3, $4)"; 
        $result = pg_query_params($connection, $query, array($nom, $prenom, $email, $adresse)); 
        if ($result) { 
            // Envoyer un email de confirmation 
            mail($email, "Confirmation de commande", "Votre commande a été reçue et sera traitée sous peu."); 
            echo "Commande envoyée et email de confirmation envoyé."; 
        } else { 
            echo "Erreur : " . pg_last_error($connection); 
        } 
    } 
} 
