<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administration</title>
    <link rel="stylesheet" href="../css/css/admin.css">
</head>

<body>
    <form method="post" action="verifyAdmin.php" class="form">
        <div class="entete">
            <img src="../assets/images/Logo.png" alt="logo">
            <h1>Connectez-vous à votre compte ! </h1>
        </div>

        <?php if (!empty($generalError)) : ?>
            <div style="color:red;"><?= $generalError; ?></div>
        <?php endif; ?>

        <div class="flex-column">
            <label for="email">Email</label>
        </div>
        <div class="inputForm">
            <input id="email" placeholder="Entrez votre Email" class="input" type="text" name="email" value="<?= $email ?>" required>
            <?php if (!empty($emailError)) : ?>
                <div style="color:red;"><?= $emailError; ?></div>
            <?php endif; ?>
        </div>

        <div class="flex-column">
            <label for="password">Mot de passe</label>
        </div>
        <div class="inputForm">
            <input id="password" placeholder="Entrez mot de passe administrateur" class="input" type="password" name="password" required>
            <?php if (!empty($passwordError)) : ?>
                <div style="color:red;"><?= $passwordError; ?></div>
            <?php endif; ?>
        </div>

        <button type="submit" class="button" name="submit">Se Connecter</button>
    </form>
</body>

</html>
