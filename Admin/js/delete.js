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
            afficherMedicaments(data);
        })
        .catch(error => {
            console.error('Erreur lors du chargement des médicaments:', error);
        });
}

// Fonction pour afficher les médicaments
function afficherMedicaments(medicaments) {
    const conteneurs = document.querySelector('.deleteDivContainer');
    const pageIndicator = document.getElementById('pageIndicator');
    const elementsParPage = 9;
    let pageActuelle = 0;
    let currentProductId = null;

    if (!medicaments || medicaments.length === 0) {
        console.error('Aucun médicament trouvé dans le JSON');
        return;
    }

    const pages = diviserEnPages(medicaments, elementsParPage);

    function mettreAJourPage() {
        conteneurs.innerHTML = '';

        const medicamentsActuels = pages[pageActuelle];
        medicamentsActuels.forEach((med, index) => {
            const divMedicament = document.createElement('div');
            divMedicament.classList.add('group', 'relative', 'bg-white', 'p-6', 'rounded-lg', 'shadow-md', 'hover:shadow-lg', 'transition-shadow', 'transform', 'hover:scale-105', 'hover:border-green-500', 'hover:border-2', 'items-center', 'relative');

            const idSupprimer = `btn-supprimer-${index}-${med.nom.replace(/\s+/g, '-').replace(/[^\w-]/g, '')}`;

            divMedicament.innerHTML = `
               <h3 class="text-xl font-bold text-gray-800 mb-2 text-center">${med.nom}</h3>
                <img src="${med.image}" alt="${med.nom}" class="w-24 h-24 object-cover rounded-full mb-4 flex center mx-auto">
                <p class="text-sm text-gray-600 mb-4 text-center"><strong>Description:</strong> ${med.description}</p>
                <button class="red-btn absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 opacity-0 hover:opacity-100 transition-opacity duration-200 bg-red-500 text-white p-2 rounded-lg hover:bg-red-600" id="${idSupprimer}" data-id="${med.id}">
                    Supprimer
                </button>
            `;

            const boutonSupprimer = divMedicament.querySelector(`#${idSupprimer}`);
            boutonSupprimer.addEventListener('click', () => {
                currentProductId = med.id;
                if (confirm('Voulez-vous vraiment supprimer ce médicament ?')) {
                    supprimerMedicament(currentProductId);
                }
            });

            conteneurs.appendChild(divMedicament);
        });

        pageIndicator.textContent = `Page ${pageActuelle + 1} sur ${pages.length}`;
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

// Fonction pour supprimer un médicament
function supprimerMedicament(id) {
    fetch('../Admin/dataSiteElement.json')
        .then(response => response.json())
        .then(medicaments => {
            const updatedMedicaments = medicaments.filter(med => med.id !== id);
            updateJSON(updatedMedicaments);
        })
        .catch(error => console.error('Erreur lors de la suppression:', error));
}

// Fonction pour mettre à jour le fichier JSON
function updateJSON(updatedMedicaments) {
    fetch('../Admin/updateMedicaments.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(updatedMedicaments)
    })
    .then(response => {
        if (!response.ok) throw new Error('Erreur lors de la mise à jour du fichier JSON');
        console.log('Médicaments mis à jour avec succès');
        chargerMedicaments(); // Recharger la liste après mise à jour
    })
    .catch(error => console.error(error));
}

// Charger les médicaments
chargerMedicaments();
