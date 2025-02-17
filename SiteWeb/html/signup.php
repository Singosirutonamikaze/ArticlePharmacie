<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="../css/css/signup.css">
</head>

<body>
    <form method="post" action="inscription.php" class="form">
        <p class="title">Bienvenue sur votre pharmacie en ligne !</p>
        <div class="entete">
            <img src="../assets\images/Logo.png" alt="logo">
            <h2>S'inscrire </h2>
        </div>
        <div class="name-fields">
                <label>
                    <input name="nom"    required="" placeholder="" type="text" class="input">
                    <span>Nom</span>
                </label>
                <label>
                    <input name="prenom"  required="" placeholder="" type="text" class="input">
                    <span>Prénoms</span>
                </label>
        </div>
        <div class="flex">
            <label>
                <input name="email" required="" placeholder="" type="email" class="input">
                <span>Email</span>
            </label>
        </div>
        <div class="flex">
            <label>
                <input name="mot_de_passe" required="" placeholder="" type="password" class="input">
                <span>Mot de passe</span>
            </label>
        </div>
        <div class="flex">
            <label>
                <input name="conf_mot_de_passe"required="" placeholder="" type="password" class="input">
                <span>Confirmer mot de passe</span>
            </label>
        </div>
        <button class="submit">Envoyer</button>
        <p class="signin">Déjà inscrit ? <a href="signIn.php">Se connecter</a> </p>
    </form>
</body>

</html>