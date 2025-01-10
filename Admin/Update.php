<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Charger les données JSON existantes
    $jsonFile = '../Admin/dataSiteElement.json';
    $jsonData = file_get_contents($jsonFile);
    $products = json_decode($jsonData, true);

    // Récupérer les données soumises
    $nom = $_POST['nom'];
    $stock = $_POST['stock'];
    $prix = $_POST['prix'];
    $description = $_POST['description'];
    $image = $_FILES['image']['name'] ? 'uploads/' . $_FILES['image']['name'] : null;

    // Mettre à jour les données dans le JSON
    foreach ($products as &$product) {
        if ($product['nom'] === $nom) {
            $product['stock'] = $stock;
            $product['prix'] = $prix;
            $product['description'] = $description;
            if ($image) {
                $product['image'] = $image;
                // Sauvegarder l'image téléchargée
                move_uploaded_file($_FILES['image']['tmp_name'], $image);
            }
            break;
        }
    }
    file_put_contents($jsonFile, json_encode($products, JSON_PRETTY_PRINT));

    // Mettre à jour la base de données
    require_once("../Admin/php/db_connction.php");

    // Rediriger avec un message de confirmation
    // header('Location: Update.php?success=1');
    // exit;
}
?>

<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mettre à jour le produit</title>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const productData = localStorage.getItem('selectedProduct');
            if (productData) {
                const product = JSON.parse(productData);

                // Pré-remplir les champs du formulaire
                document.getElementById('nom').value = product.nom;
                document.getElementById('stock').value = product.stock || '';
                document.getElementById('prix').value = product.prix || '';
                document.getElementById('description').value = product.description || '';
                document.getElementById('imagePreview').src = product.image;
            }
        });
    </script>
    <!-- Lien vers le fichier JavaScript principal pour gérer les interactions et les fonctions dynamiques de la page -->
    <script src="../Admin/js/appAdmin.js" defer></script>
    <script type="module" src="../Admin/js/formulaire.js" defer></script>
    <script type="module" src="../Admin/js/ProduitFormulaire.js" defer></script>
    <script src="../Admin/js/update.js" defer></script>
    <script src="../Admin/js/delete.js" defer></script>

    <!-- Lien vers la feuille de style CSS principale pour les styles généraux de la page -->
    <link rel="stylesheet" href="../Admin/css/Admin.css">
    <link rel="stylesheet" href="../Admin/css/uploadimage.css">
    <link rel="stylesheet" href="../Admin/css/cardCSS.css">
</head>

<body>
    <div class="form-container">
        <h1>Mettre à jour le produit</h1>
        <form action="updateProduct.php" method="POST" enctype="multipart/form-data">
            <div class="form-group">
                <label for="nom">Nom :</label>
                <input type="text" id="nom" name="nom" required readonly>
            </div>

            <div class="form-group">
                <label for="image">Image :</label>
                <img id="imagePreview" alt="Aperçu de l'image">
                <input type="file" id="image" name="image">
            </div>

            <div class="form-group">
                <label for="stock">Stock :</label>
                <input type="number" id="stock" name="stock" required>
            </div>

            <div class="form-group">
                <label for="prix">Prix :</label>
                <input type="number" id="prix" name="prix" required>
            </div>

            <div class="form-group">
                <label for="description">Description :</label>
                <textarea id="description" name="description" required></textarea>
            </div>

            <button class="form-submit-btn" type="submit"><a href="../Admin/Admin.html">Mettre à jour</a></button>
        </form>
    </div>
</body>

</html>