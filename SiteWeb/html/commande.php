<?php
// livraison.php

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Récupération et nettoyage des données du formulaire
    $nom      = isset($_POST['nom']) ? trim($_POST['nom']) : '';
    $prenoms  = isset($_POST['prenoms']) ? trim($_POST['prenoms']) : '';
    $email    = isset($_POST['email']) ? trim($_POST['email']) : '';
    $adresse  = isset($_POST['adresse']) ? trim($_POST['adresse']) : '';

    // Vérifier que tous les champs sont renseignés
    if (empty($nom) || empty($prenoms) || empty($email) || empty($adresse)) {
        echo "Tous les champs sont requis.";
        exit;
    }

    // Validation avancée
    // Vérification de la validité de l'email
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        echo "L'adresse email n'est pas valide.";
        exit;
    }

    // Validation du nom et des prénoms : seules les lettres, espaces, apostrophes et tirets sont autorisés
    $pattern = "/^[a-zA-ZÀ-ÿ\s'-]+$/";
    if (!preg_match($pattern, $nom) || !preg_match($pattern, $prenoms)) {
        echo "Le nom et les prénoms doivent contenir uniquement des lettres, espaces, apostrophes ou tirets.";
        exit;
    }

    // Génération d'un identifiant de commande unique et ajout d'un timestamp
    $order_id = uniqid('cmd_', true);
    $timestamp = date("Y-m-d H:i:s");

    // Création du tableau associatif pour la commande
    $order = array(
        "order_id"  => $order_id,
        "timestamp" => $timestamp,
        "nom"       => $nom,
        "prenoms"   => $prenoms,
        "email"     => $email,
        "adresse"   => $adresse
    );

    // Fichier de stockage des commandes
    $filename = "livraison.json";

    // Lecture des commandes existantes s'il y en a déjà
    $orders = array();
    if (file_exists($filename)) {
        $jsonData = file_get_contents($filename);
        $orders = json_decode($jsonData, true);
        if (!is_array($orders)) {
            $orders = array();
        }
    }

    // Ajout de la nouvelle commande au tableau des commandes existantes
    $orders[] = $order;

    // Encodage du tableau en JSON avec une mise en forme lisible
    $jsonLivraison = json_encode($orders, JSON_PRETTY_PRINT);

    // Enregistrement du JSON dans le fichier avec verrouillage exclusif pour éviter les écritures concurrentes
    if (file_put_contents($filename, $jsonLivraison, LOCK_EX) !== false) {
        // Envoi d'un email de confirmation (optionnel)
        $to      = $email;
        $subject = "Confirmation de votre commande";
        $message = "Bonjour $prenoms,\n\nVotre commande (ID: $order_id) a été enregistrée avec succès le $timestamp.\nNous vous remercions de votre confiance.\n\nCordialement,\nL'équipe Livraison";
        $headers = "From: no-reply@votresite.com\r\n";
        // Décommentez la ligne suivante si votre serveur est configuré pour envoyer des emails
        // mail($to, $subject, $message, $headers);

        // Redirection vers index.html
        header("Location: index.html");
        exit;
    } else {
        echo "Erreur lors de l'enregistrement de la commande.";
    }
} else {
    echo "Méthode non autorisée.";
}
