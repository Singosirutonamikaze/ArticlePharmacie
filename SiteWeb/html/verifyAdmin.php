<?php
session_start();

$email = $password = '';
$emailError = $passwordError = $generalError = '';

if (isset($_SESSION['admin']) && $_SESSION['admin'] == true) {
    header('Location: /ProjetBaseDeDonnées/ArticlePharmacie/Admin/Admin.html');
    exit;
}

if (isset($_POST["submit"])) {
    $email = htmlspecialchars(trim($_POST["email"]));
    $password = htmlspecialchars(trim($_POST["password"]));

    $adminEmail = "adminConnexion@example.com";
    $adminPasswordHash = '$2y$10$1Q6Z'; // Ceci doit être remplacé par un vrai hash du mot de passe admin
    $errors = false;

    if (empty($email)) {
        $emailError = "L'email est requis.";
        $errors = true;
    } elseif ($email != $adminEmail) {
        $emailError = "L'email n'est pas valide.";
        $errors = true;
    }

    if (empty($password)) {
        $passwordError = "Le mot de passe est requis.";
        $errors = true;
    } elseif (!password_verify($password, $adminPasswordHash)) {
        $passwordError = "Le mot de passe est incorrect.";
        $errors = true;
    }

    if (!$errors) {
        $_SESSION['admin'] = true;
        header('Location: /ProjetBaseDeDonnées/ArticlePharmacie/Admin/Admin.html');
        exit;
    } else {
        $generalError = "Veuillez corriger les erreurs ci-dessous.";
    }
}
?>