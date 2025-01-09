
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password </title>
    <link rel="stylesheet" href="../css/forgotPassword.css">
</head>

<body>
   
    <form action="reinit_password.php" method="post">
        <div class=" main-container">
            <div class="form-container">
                <form action="" class="form">
                    <img src="../assets\images/Logo.png" alt="logo">
                    <h1>Mot de passe oublié ? </h1>
                    <p>Entrez votre adresse email et nous vous enverrons un lien pour réinitialiser votre mot de passe</p>
                    <div class="flex-column>
                        <label for=" email">Email</label>
                    </div>
                    <div class="inputForm">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" viewBox="0 0 32 32" height="20">
                            <g data-name="Layer 3" id="Layer_3">
                                <path
                                    d="m30.853 13.87a15 15 0 0 0 -29.729 4.082 15.1 15.1 0 0 0 12.876 12.918 15.6 15.6 0 0 0 2.016.13 14.85 14.85 0 0 0 7.715-2.145 1 1 0 1 0 -1.031-1.711 13.007 13.007 0 1 1 5.458-6.529 2.149 2.149 0 0 1 -4.158-.759v-10.856a1 1 0 0 0 -2 0v1.726a8 8 0 1 0 .2 10.325 4.135 4.135 0 0 0 7.83.274 15.2 15.2 0 0 0 .823-7.455zm-14.853 8.13a6 6 0 1 1 6-6 6.006 6.006 0 0 1 -6 6z">
                                </path>
                            </g>
                        </svg>
                        <input type="text" placeholder="Entrez votre email" class="input" id="email">
                    </div>
                    <button class="button-submit">Envoyer Email</button>
                    <p class="signin-link">Vous souvenez vous de votre mot de passe ? <a href="signIn.html" class="signin-link link">Se connecter</a></p>
                </form>
            </div>
        </div>
    </form>
</body>

</html>