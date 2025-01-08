// Fonction pour charger les données JSON
async function chargerMedicaments() {
    try {
        const reponse = await fetch('../Admin/dataSiteElement.json');
        if (!reponse.ok) {
            throw new Error('Erreur lors du chargement du fichier JSON');
        }
        const medicaments = await reponse.json();
        afficherMedicaments(medicaments);
    } catch (error) {
        console.error('Erreur:', error);
    }
}

// Fonction pour afficher les médicaments
function afficherMedicaments(medicaments) {
    const conteneurs = document.querySelectorAll('.deleteDivContainer'); // Sélectionner tous les conteneurs
    const conteneurFleches = document.querySelector('.deleteDivContainerRow');
    const elementsParPage = 9;
    let pageActuelle = 0;

    if (!medicaments || medicaments.length === 0) {
        console.error('Aucun médicament trouvé dans le JSON');
        return;
    }

    const pages = diviserEnPages(medicaments, elementsParPage);

    function mettreAJourPage() {
        // Réinitialiser tous les conteneurs à chaque mise à jour de page
        conteneurs.forEach(conteneur => conteneur.innerHTML = '');

        const medicamentsActuels = pages[pageActuelle];
        if (medicamentsActuels) {
            // Diviser les médicaments entre les conteneurs disponibles
            medicamentsActuels.forEach((med, index) => {
                // Déterminer quel conteneur utiliser en fonction de l'index
                const conteneurIndex = index % conteneurs.length;
                const divMedicament = document.createElement('div');
                divMedicament.classList.add('deleteDiv');

                const divContenuMedicament = document.createElement('div');
                divContenuMedicament.classList.add('deleteDivContent', 'contentElementLas');

                const idSupprimer = `btn-supprimer-${index}-${med.nom.replace(/\s+/g, '-').replace(/[^\w-]/g, '')}`;

                divContenuMedicament.innerHTML = `
                    <h3 id="med-name-${index}">${med.nom}</h3>
                    <img id="med-image-${index}" src="${med.image}" alt="${med.nom}" style="width: 100px;">
                    <p id="med-description-${index}"><strong>Description:</strong> ${med.description}</p>
                    <button class="red-btn" id="${idSupprimer}">Supprimer</button>
                `;

                const boutonSupprimer = divContenuMedicament.querySelector(`#${idSupprimer}`);
                boutonSupprimer.addEventListener('click', () => {
                    divMedicament.remove();
                });

                divMedicament.appendChild(divContenuMedicament);
                conteneurs[conteneurIndex].appendChild(divMedicament);
            });
        }

        mettreAJourVisibiliteFleches();
    }

    function diviserEnPages(tableau, taille) {
        const resultat = [];
        for (let i = 0; i < tableau.length; i += taille) {
            resultat.push(tableau.slice(i, i + taille));
        }
        return resultat;
    }

    function mettreAJourVisibiliteFleches() {
        const flecheGauche = document.querySelector('.left_arrowR');
        const flecheDroite = document.querySelector('.right_arrowR');

        if (pages.length > 1) {
            conteneurFleches.style.display = 'flex';
        } else {
            conteneurFleches.style.display = 'none';
        }

        flecheGauche.style.display = pageActuelle === 0 ? 'none' : 'block';
        flecheDroite.style.display = pageActuelle === pages.length - 1 ? 'none' : 'block';
    }

    document.querySelector('.left_arrowR').addEventListener('click', () => {
        if (pageActuelle > 0) {
            pageActuelle--;
            mettreAJourPage();
        }
    });

    document.querySelector('.right_arrowR').addEventListener('click', () => {
        if (pageActuelle < pages.length - 1) {
            pageActuelle++;
            mettreAJourPage();
        }
    });

    mettreAJourPage();
}

chargerMedicaments();

document.addEventListener('DOMContentLoaded', function () {
    // Récupération des éléments
    const deleteButtons = document.querySelectorAll('.red-btn');
    const warningDiv = document.querySelector('.warning');
    const acceptButton = document.querySelector('.acceptButton');
    const declineButton = document.querySelector('.declineButton');
    
    let currentProductId = null; // ID du produit actuel à supprimer

    // Affichage de l'alerte lors du clic sur "Supprimer"
    deleteButtons.forEach(button => {
        button.addEventListener('click', function () {
            currentProductId = this.dataset.id; // Associer l'ID du produit (via un attribut data-id)
            warningDiv.style.display = 'block';
        });
    });

    // Gestion du bouton "Oui" (supprimer le produit)
    acceptButton.addEventListener('click', function () {
        if (currentProductId) {
            fetch(`/delete-product/${currentProductId}`, {
                method: 'DELETE',
            })
                .then(response => {
                    if (response.ok) {
                        alert('Produit supprimé avec succès.');
                        // Rafraîchir la page ou retirer le produit du DOM
                        location.reload();
                    } else {
                        alert('Une erreur est survenue lors de la suppression.');
                    }
                })
                .catch(error => console.error('Erreur:', error));
        }
        warningDiv.style.display = 'none'; // Cacher la boîte d'alerte
    });

    // Gestion du bouton "Non" (annuler la suppression)
    declineButton.addEventListener('click', function () {
        warningDiv.style.display = 'none'; // Cacher la boîte d'alerte
    });
});

