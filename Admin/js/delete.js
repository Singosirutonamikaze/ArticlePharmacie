// Fonction pour charger les donnees JSON
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

// Fonction pour afficher les medicaments
function afficherMedicaments(medicaments) {
    const conteneur = document.querySelector('.deleteDivContainer');
    const conteneurFleches = document.querySelector('.deleteDivContainerRow');
    const elementsParPage = 5;
    let pageActuelle = 0;

    if (!medicaments || medicaments.length === 0) {
        console.error('Aucun medicament trouve dans le JSON');
        return;
    }

    const pages = diviserEnPages(medicaments, elementsParPage);

    function mettreAJourPage() {
        conteneur.innerHTML = '';

        const medicamentsActuels = pages[pageActuelle];
        if (medicamentsActuels) {
            medicamentsActuels.forEach((med, index) => {
                const divMedicament = document.createElement('div');
                divMedicament.classList.add('deleteDiv');

                const divContenuMedicament = document.createElement('div');
                divContenuMedicament.classList.add('deleteDivContent', 'contentElementLast');

                const idSupprimer = `btn-supprimer-${index}-${med.nom.replace(/\s+/g, '-').replace(/[^\w-]/g, '')}`;
                
                divContenuMedicament.innerHTML = `
                    <h3 id="med-name-${index}">${med.nom}</h3>
                    <img id="med-image-${index}" src="${med.image}" alt="${med.nom}" style="width: 100px;">
                    <p id="med-description-${index}"><strong>Description:</strong> ${med.description}</p>
                    <p id="med-prix-${index}"><strong>Prix:</strong> ${med.prix} CFA</p>
                    <button class="red-btn" id="${idSupprimer}">Supprimer</button>
                `;

                const boutonSupprimer = divContenuMedicament.querySelector(`#${idSupprimer}`);
                boutonSupprimer.addEventListener('click', () => {
                    divMedicament.remove();
                });

                divMedicament.appendChild(divContenuMedicament);
                conteneur.appendChild(divMedicament);
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
