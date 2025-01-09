<?php 
include  'db_connect.php';
if ($_SERVER["REQUEST_METHOD"] == "POST") { 
    // Récupérer les valeurs des champs du formulaire 
    $nom = $_POST["nom"]; 
    $prenom = $_POST["prenom"]; 
    $email = $_POST["email"]; 
    $mot_de_passe = $_POST["mot_de_passe"]; 
    $confirmation_mot_de_passe = $_POST["conf_mot_de_passe"];
    
    // Validation des champs 
    if (empty($nom) || empty($prenom) || empty($email) || empty($mot_de_passe) || empty($confirmation_mot_de_passe)) {
         echo "Tous les champs sont obligatoires."; 
         } else { 
            if ($mot_de_passe == $confirmation_mot_de_passe) { 
                $query = "INSERT INTO users (nom, email, mot_de_passe) VALUES ('$nom', '$email', '$mot_de_passe')"; 
                pg_query_params($connection, $query); 
            } else { 
                echo "Les mots de passe ne correspondent pas, veuillez faire une vérification."; 
            }
            // Vérifier si le client existe déjà 
            $query = "SELECT * FROM utilisateurs WHERE email = $1"; 
            $result = pg_query_params($connection, $query, array($email)); 
                if (pg_num_rows($result) > 0) { 
                    // Si le client existe, afficher un message 
                    echo "Un client avec cet email existe déjà."; 
                } else {
                    // Insérer dans la base de données 
                    $query = "INSERT INTO utilisateurs (nom, prenom, email, mot_de_passe) VALUES ($1, $2, $3, $4)"; 
                    $result = pg_query_params($connection, $query, array($nom, $prenom, $email, password_hash($mot_de_passe, PASSWORD_BCRYPT))); 
                    if ($result) { 
                        echo "Inscription réussie."; 
                    } else { 
                        echo "Erreur : " . pg_last_error($connection); 
                    } 
                } 
        } 
}
?>
