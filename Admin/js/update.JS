// Fonction utilitaire pour convertir une image en base64
function getBase64Image(img) {
    // Créer un canvas et régler ses dimensions sur celles de l'image
    const canvas = document.createElement("canvas");
    canvas.width = img.naturalWidth;
    canvas.height = img.naturalHeight;
    const ctx = canvas.getContext("2d");
    // Dessiner l'image sur le canvas
    ctx.drawImage(img, 0, 0);
    // Retourner l'image sous forme de chaîne base64 en format PNG
    return canvas.toDataURL("image/png");
}

// Gestion du clic sur chaque bouton de modification (délégation d'événements)
document.getElementById('addElement1').addEventListener('click', (event) => {
    // Vérifier si le clic provient d'un bouton avec la classe .update
    if (event.target.classList.contains('update')) {
        const parentElement = event.target.closest('.contentElement');

        if (!parentElement) {
            console.error("Le parent .contentElement est introuvable");
            return;
        }

        // Récupération des éléments dans la carte
        const h3Element = parentElement.querySelector('h3');
        const imgElement = parentElement.querySelector('img');
        const pElement = parentElement.querySelector('p');

        if (!h3Element || !imgElement || !pElement) {
            console.error("Éléments requis non trouvés");
            return; // Sortir si des éléments sont manquants
        }

        // Extraction des données du produit avec conversion de l'image en base64
        const product = {
            id: event.target.getAttribute('data-product-id'), // Récupérer l'ID du produit
            nom: h3Element.textContent.trim(),
            image: getBase64Image(imgElement), // Conversion de l'image en chaîne base64
            // Extraction du nombre (prix) via une expression régulière
            prix: pElement.textContent.match(/\d+/) ? pElement.textContent.match(/\d+/)[0] : '0',
            description: 'Description à compléter',
            stock: 'Stock à compléter'
        };

        // Remplissage du formulaire avec les données du produit
        document.getElementById('productName').value = product.nom;
        document.getElementById('productImage').value = product.image; // Valeur base64 de l'image
        document.getElementById('productPrice').value = product.prix;
        document.getElementById('productDescription').value = product.description;
        document.getElementById('productStock').value = product.stock;

        // Afficher la modale de mise à jour
        document.getElementById('updateModal').classList.remove('hidden');
    }
});

// Gestion de l'annulation de la modification
document.getElementById('cancelBtn').addEventListener('click', () => {
    // Cacher la modale
    document.getElementById('updateModal').classList.add('hidden');
});

// Gestion de la soumission du formulaire pour mettre à jour le produit
document.getElementById('updateForm').addEventListener('submit', (event) => {
    event.preventDefault();

    // Récupération des données mises à jour
    const updatedProduct = {
        id: document.querySelector('.update').getAttribute('data-product-id'), // Récupérer l'ID du produit
        nom: document.getElementById('productName').value,
        image: document.getElementById('productImage').value, // Contient la chaîne base64 de l'image
        prix: document.getElementById('productPrice').value,
        description: document.getElementById('productDescription').value,
        stock: document.getElementById('productStock').value,
    };

    // Enregistrement du produit mis à jour dans le localStorage
    try {
        localStorage.setItem('selectedProduct', JSON.stringify(updatedProduct));
        console.log("Produit mis à jour :", updatedProduct);
    } catch (e) {
        console.error("Erreur lors de la mise à jour du localStorage :", e);
    }

    // Cacher la modale après la mise à jour
    document.getElementById('updateModal').classList.add('hidden');
});
