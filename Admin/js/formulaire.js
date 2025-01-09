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


document.addEventListener("DOMContentLoaded", function () {
    const jsonURL = "../Admin/dataSiteElement.json"; // Chemin vers ton fichier JSON

    // Charger le fichier JSON
    async function chargerProduits() {
        try {
            const response = await fetch(jsonURL);
            if (!response.ok) {
                console.error(`Erreur HTTP : ${response.status} - ${response.statusText}`);
                return [];
            }
            const produits = await response.json();
            return produits;
        } catch (error) {
            console.error("Erreur lors du chargement des produits :", error);
            return [];
        }
    }
    

    // Ajouter un nouveau produit
    async function ajouterProduit(event) {
        event.preventDefault(); // Empêche la soumission par défaut

        // Récupération des valeurs du formulaire
        const nomInput = document.getElementById("nomProduit");
        const prixInput = document.getElementById("prixProduit");
        const imageInput = document.getElementById("imageProduit");
        const descriptionInput = document.getElementById("descriptionProduit");
        const maladiesInput = document.getElementById("maladiesProduit");
        const utilisationsInput = document.getElementById("utilisationsProduit");
        const posologieInput = document.getElementById("posologieProduit");
        const precautionsInput = document.getElementById("precautionsProduit");
        const liensReferenceInput = document.getElementById("liensProduit");
        const stockproduit = document.getElementById("stockproduit");

        // Vérification des champs
        if (!nomInput || !prixInput || !imageInput || !descriptionInput || !maladiesInput || 
            !utilisationsInput || !posologieInput || !precautionsInput || !liensReferenceInput || !stockproduit) {
            console.error("Certains champs de formulaire sont introuvables !");
            return;
        }

        // Récupérer les valeurs
        const nom = nomInput.value;
        const prix = parseFloat(prixInput.value);
        const imageFile = imageInput.files[0];
        const description = descriptionInput.value;
        const maladies = maladiesInput.value.split(",");
        const utilisations = utilisationsInput.value.split("\n");
        const posologie = posologieInput.value.split("\n");
        const precautions = precautionsInput.value.split("\n");
        const liens_de_reference = liensReferenceInput.value;
        const stock = stockproduit.value;

        // Vérification des champs obligatoires
        if (!imageFile) {
            alert("Veuillez ajouter une image pour le produit !");
            return;
        }

        // Conversion de l'image en Base64
        const image = await convertirImageBase64(imageFile);

        // Création du nouvel objet produit
        const nouveauProduit = {
            nom,
            prix,
            image,
            description,
            maladies,
            utilisations,
            posologie,
            precautions,
            liens_de_reference,
            stock
        };

        // Charger le JSON existant
        const produits = await chargerProduits();

        // Ajouter le nouveau produit au tableau
        produits.push(nouveauProduit);

        // Afficher le JSON mis à jour (ou proposer un téléchargement)
        console.log("JSON mis à jour :", produits);
        sauvegarderJSON(produits);
    }

    // Convertir une image en Base64
    function convertirImageBase64(file) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.onload = () => resolve(reader.result);
            reader.onerror = (error) => reject(error);
            reader.readAsDataURL(file);
        });
    }

    // Proposer le téléchargement du JSON mis à jour
    function sauvegarderJSON(data) {
        const dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(data, null, 2));
        const downloadAnchor = document.createElement("a");
        downloadAnchor.setAttribute("href", dataStr);
        downloadAnchor.setAttribute("download", "produits.json");
        downloadAnchor.click();
    }

    // Écouter la soumission du formulaire
    const formulaire = document.getElementById("productForm");
    if (formulaire) {
        formulaire.addEventListener("submit", ajouterProduit);
    } else {
        console.error("Formulaire introuvable !");
    }
});
