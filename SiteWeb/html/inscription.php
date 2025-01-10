<?php
include 'db_connect.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Récupérer les valeurs des champs du formulaire
    $nom = trim($_POST["nom"]);
    $prenom = trim($_POST["prenom"]);
    $email = trim($_POST["email"]);
    $mot_de_passe = $_POST["mot_de_passe"];
    $confirmation_mot_de_passe = $_POST["conf_mot_de_passe"];

    // Validation des champs
    if (empty($nom) || empty($prenom) || empty($email) || empty($mot_de_passe) || empty($confirmation_mot_de_passe)) {
        echo "Tous les champs sont obligatoires.";
    } else {
        // Vérification des mots de passe
        if ($mot_de_passe !== $confirmation_mot_de_passe) {
            echo "Les mots de passe ne correspondent pas, veuillez faire une vérification.";
        } else {
            // Vérifier si l'utilisateur existe déjà
            $query_check = "SELECT * FROM client WHERE email = $1";
            $result_check = pg_query_params($connection, $query_check, array($email));

            if (pg_num_rows($result_check) > 0) {
                echo "Un utilisateur avec cet email existe déjà.";
            } else {
                // Insérer dans la base de données
                $query_insert = "INSERT INTO utilisateurs (nom, prenom, email, mot_de_passe) VALUES ($1, $2, $3, $4)";
                $hashed_password = password_hash($mot_de_passe, PASSWORD_BCRYPT);
                $result_insert = pg_query_params($connection, $query_insert, array($nom, $prenom, $email, $hashed_password));

                if ($result_insert) {
                    echo "Inscription réussie.";
                } else {
                    echo "Erreur lors de l'inscription : " . pg_last_error($connection);
                }
            }
        }
    }
}
