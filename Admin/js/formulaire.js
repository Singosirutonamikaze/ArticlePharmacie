// Déclaration des variables
const champNomProduit = document.querySelector('input[placeholder="Entrez le nom du projet"]');
const champPrixProduit = document.querySelector('input[placeholder="Entrez le prix du produit"]');
const champImageProduit = document.querySelector('#file-input');
const champDescriptionProduit = document.querySelector('textarea[placeholder="Fournissez une description complète du projet"]');
const champMaladiesProduit = document.querySelector('input[placeholder="Listez les maladies concernées"]');
const champUtilisationsProduit = document.querySelector('textarea[placeholder="Indiquez les utilisations principales"]');
const champPosologieProduit = document.querySelector('textarea[placeholder="Ajoutez des détails sur la posologie"]');
const champPrecautionsProduit = document.querySelector('textarea[placeholder="Ajoutez des précautions importantes"]');
const champLiensProduit = document.querySelector('input[placeholder="Ajoutez des liens de référence"]');

// Récupération du formulaire
const formulaire = document.querySelector('form');
formulaire.addEventListener('submit', function(event) {
    event.preventDefault(); // Empêcher l'envoi du formulaire

    // Récupérer les données du formulaire à partir des champs déclarés
    const nomProduit = champNomProduit.value;
    const prixProduit = champPrixProduit.value;
    const imageProduit = champImageProduit.files[0]; // Récupérer l'image
    const descriptionProduit = champDescriptionProduit.value;
    const maladiesProduit = champMaladiesProduit.value;
    const utilisationsProduit = champUtilisationsProduit.value;
    const posologieProduit = champPosologieProduit.value;
    const precautionsProduit = champPrecautionsProduit.value;
    const liensProduit = champLiensProduit.value;

    // Créer un objet FormData pour envoyer l'image et les données
    const formData = new FormData();
    formData.append('nomProduit', nomProduit);
    formData.append('prixProduit', prixProduit);
    formData.append('imageProduit', imageProduit);
    formData.append('descriptionProduit', descriptionProduit);
    formData.append('maladiesProduit', maladiesProduit);
    formData.append('utilisationsProduit', utilisationsProduit);
    formData.append('posologieProduit', posologieProduit);
    formData.append('precautionsProduit', precautionsProduit);
    formData.append('liensProduit', liensProduit);

    // Envoyer les données via Fetch à un fichier PHP
    fetch('index.php', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())  // Attendre une réponse JSON
    .then(data => {
        if (data.success) {
            alert('Produit ajouté avec succès!');
        } else {
            alert('Erreur lors de l\'ajout du produit.');
        }
    })
    .catch(error => {
        console.error('Erreur:', error);
        alert('Une erreur s\'est produite.');
    });
});
