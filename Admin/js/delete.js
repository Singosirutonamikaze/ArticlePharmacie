// Fonction pour charger les médicaments depuis un fichier JSON
function chargerMedicaments() {
    fetch('../Admin/dataSiteElement.json')
        .then(response => {
            if (!response.ok) {
                throw new Error(`Erreur HTTP ! statut : ${response.status}`);
            }
            return response.json();
        })
        .then(data => {
            console.log('Données des médicaments chargées:', data);
            afficherMedicaments(data); // Appeler la fonction pour afficher les médicaments
        })
        .catch(error => {
            console.error('Erreur lors du chargement des médicaments:', error);
        });
}

// Fonction pour afficher les médicaments
function afficherMedicaments(medicaments) {
    const conteneurs = document.querySelectorAll('.deleteDivContainer'); // Sélectionner tous les conteneurs
    const conteneurFleches = document.querySelector('.deleteDivContainerRow');
    const warningDiv = document.getElementById('warbning');
    const acceptButton = warningDiv.querySelector('.acceptButton');
    const declineButton = warningDiv.querySelector('.declineButton');
    const elementsParPage = 9;
    let pageActuelle = 0;
    let currentProductId = null; // ID du produit à supprimer

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
                    <button class="red-btn" id="${idSupprimer}" data-id="${med.id}">Supprimer</button>
                `;

                const boutonSupprimer = divContenuMedicament.querySelector(`#${idSupprimer}`);
                boutonSupprimer.addEventListener('click', () => {
                    // Quand on clique sur un bouton, afficher l'alerte
                    currentProductId = med.id; // Associer l'ID du produit à supprimer
                    warningDiv.classList.add('show'); // Afficher l'alerte
                });

                divMedicament.appendChild(divContenuMedicament);
                conteneurs[conteneurIndex].appendChild(divMedicament);
            });
        }

        mettreAJourVisibiliteFleches();
    }

    // Gestion des actions dans la fenêtre de confirmation
    acceptButton.addEventListener('click', () => {
        // Supprimer le produit à la fois du DOM et de la base de données JSON
        if (currentProductId !== null) {
            // Supprimer du DOM
            const productElement = document.querySelector(`button[data-id="${currentProductId}"]`).closest('.deleteDiv');
            if (productElement) {
                productElement.remove();
            }

            // Supprimer du tableau JSON et mettre à jour
            const updatedMedicaments = medicaments.filter(med => med.id !== currentProductId);
            // Mettre à jour le fichier JSON (cela nécessitera une fonction côté serveur)
            updateJSON(updatedMedicaments);

            // Cacher la fenêtre de confirmation
            warningDiv.classList.remove('show');
        }
    });

    declineButton.addEventListener('click', () => {
        // Fermer la fenêtre de confirmation sans rien faire
        warningDiv.classList.remove('show');
    });

    // Gérer la pagination
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

    // Gestion des flèches de pagination
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

// Fonction pour mettre à jour le fichier JSON (requiert une API côté serveur)
function updateJSON(updatedMedicaments) {
    fetch('../Admin/updateMedicaments.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(updatedMedicaments)
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Erreur lors de la mise à jour du fichier JSON');
        }
        console.log('Médicaments mis à jour avec succès');
    })
    .catch(error => {
        console.error(error);
    });
}

// Charger les médicaments et initialiser les événements
chargerMedicaments();
