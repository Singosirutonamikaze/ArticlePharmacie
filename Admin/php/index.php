<?php
// Inclure la connexion à la base de données
include('db_connction.php');

// Vérifier si la requête est une requête POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    // Récupérer les données envoyées via FormData
    $productName = $_POST['productName'];
    $productPrice = $_POST['productPrice'];
    $productDescription = $_POST['productDescription'];
    $productDiseases = $_POST['productDiseases'];
    $productUses = $_POST['productUses'];
    $productDosage = $_POST['productDosage'];
    $productPrecautions = $_POST['productPrecautions'];
    $productLinks = $_POST['productLinks'];
    $productstock = $_POST['productstock'];

    // Traitement de l'image
    if (isset($_FILES['productImage']) && $_FILES['productImage']['error'] === UPLOAD_ERR_OK) {
        $imageTmpName = $_FILES['productImage']['tmp_name'];
        $imageName = $_FILES['productImage']['name'];
        $imagePath = 'uploads/' . $imageName;  // Répertoire où l'image sera stockée

        // Déplacer l'image téléchargée
        move_uploaded_file($imageTmpName, $imagePath);
    } else {
        $imagePath = null;
    }

    // Préparer la requête SQL pour insérer les données dans la base de données
    $stmt = $conn->prepare("INSERT INTO products (name, price, image, description, diseases, uses, dosage, precautions, links, stock) 
                            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("sssssssss", $productName, $productPrice, $imagePath, $productDescription, $productDiseases, 
                      $productUses, $productDosage, $productPrecautions, $productLinks, $productstock);

    if ($stmt->execute()) {
        echo json_encode(['success' => true]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Erreur lors de l\'insertion dans la base de données.']);
    }

    $stmt->close();
    $conn->close();
}
