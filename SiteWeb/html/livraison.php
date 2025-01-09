<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Livraison</title>
    <link rel="stylesheet" href="../css/css/livraison.css">
</head>

<body>
    <form action="commande.php" method="post" class="form">
        <div class="entete">
            <img src="../assets\images/Logo.png" alt="logo">
            <h1> Faites vous livrer ! </h1>
        </div>
            <h3>Votre commande vous sera livrée directement grâce à votre Adresse et nous vous enverrons un email pour confirmer la réception de la commande  </h3>
        <div class="name-fields">
            <label>
                <input required="" placeholder="" type="text" class="input">
                <span>Nom</span>
            </label>
            <label>
                <input required="" placeholder="" type="text" class="input">
                <span>Prénoms</span>
            </label>
        </div>
        <div class="flex">
            <label>
                <input required="" placeholder="" type="email" class="input">
                <span>Email</span>
            </label>
        </div>
        <div class="flex">
            <label>
                <input required="" placeholder="" type="text" class="input" style="width: 510px ;">
                <span>Adresse</span>
            </label>
        </div>
        <button class="submit" type="submit">Envoyer</button>
    </form>
</body>
</html>