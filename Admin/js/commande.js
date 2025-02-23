let totalCommandes = 0;

function updateNotificationCount() {
    const notificationCount = document.getElementById('notificationCount');
    if (notificationCount) {
        notificationCount.textContent = totalCommandes > 0 ? totalCommandes : '';
    }
}

async function fetchAndRenderCommandes() {
    try {
        const response = await fetch('../SiteWeb/html/livraison.json');
        if (!response.ok) {
            throw new Error(`Erreur HTTP : ${response.status}`);
        }
        const commandes = await response.json();
        totalCommandes = commandes.length;
        updateNotificationCount();

        const contentElements = document.querySelector('#addElement4 .CommandeEnvoye');
        if (contentElements) {
            contentElements.innerHTML = '';

            const commandeH2 = document.createElement('h2');
            commandeH2.classList.add('text-2xl', 'font-bold', 'mb-4', 'text-center');
            commandeH2.textContent = 'Commandes à livrer/ Notification';
            contentElements.appendChild(commandeH2);

            const commandeP = document.createElement('p');
            commandeP.classList.add('text-center', 'text-gray-700');
            commandeP.textContent = 'Cliquez sur le bouton "Valider" pour confirmer la livraison de la commande';
            contentElements.appendChild(commandeP);

            const gridElement = document.createElement('div');
            gridElement.classList.add('grid', 'grid-cols-2', 'md:grid-cols-4', 'gap-4', 'mt-4');
            contentElements.appendChild(gridElement);

            commandes.forEach(commande => {
                const commandeElement = document.createElement('div');
                commandeElement.classList.add(
                    'bg-white',
                    'shadow-lg',
                    'p-6',
                    'rounded-lg',
                    'flex',
                    'flex-col',
                    'justify-between',
                    'hover:shadow-xl',
                    'transition',
                    'duration-300'
                );
                commandeElement.innerHTML = `
                    <div>
                        <p class="text-lg font-bold">Commande n°${commande.order_id}</p>
                        <p class="text-gray-700">Date : ${commande.timestamp}</p>
                        <p class="text-gray-700">Client : ${commande.nom} ${commande.prenoms}</p>
                        <p class="text-gray-700">Adresse : ${commande.adresse}</p>
                    </div>
                    <button class="mt-4 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded validerCommandeForm" data-order-id="${commande.order_id}">
                        Valider
                    </button>
                `;
                gridElement.appendChild(commandeElement);
            });

            document.querySelectorAll('.validerCommandeForm').forEach(button => {
                button.addEventListener('click', (event) => {
                    const orderId = event.target.getAttribute('data-order-id');
                    afficherFormulaireValidation(orderId);
                });
            });

            if (commandes.length > 0) {
                const notificationArea = document.querySelector('#notificationArea');
                if (notificationArea) {
                    notificationArea.classList.remove('hidden');
                }
            }
        }
    } catch (error) {
        console.error("Erreur lors du chargement des commandes :", error);
    }
}

function afficherFormulaireValidation(orderId) {
    if (document.querySelector('#formulaireValidation')) return;

    const overlay = document.createElement('div');
    overlay.id = 'formulaireValidation';
    overlay.classList.add('fixed', 'inset-0', 'bg-black', 'bg-opacity-50', 'flex', 'justify-center', 'items-center', 'z-50');

    const form = document.createElement('div');
    form.classList.add('bg-white', 'p-8', 'rounded-lg', 'shadow-lg', 'w-96');
    form.innerHTML = `
        <h2 class="text-xl font-bold mb-4 text-center">Validation de la commande n°${orderId}</h2>
        <label class="block mb-2">Nom du livreur:</label>
        <input type="text" id="livreurNom" class="w-full p-2 border rounded mb-4" placeholder="Entrez le nom du livreur">
        
        <label class="block mb-2">Date de livraison:</label>
        <input type="date" id="dateLivraison" class="w-full p-2 border rounded mb-4">

        <div class="flex justify-between">
            <button id="confirmerLivraison" class="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded">Confirmer</button>
            <button id="annulerLivraison" class="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded">Annuler</button>
        </div>
    `;

    overlay.appendChild(form);
    document.body.appendChild(overlay);

    document.getElementById('confirmerLivraison').addEventListener('click', () => {
        const livreurNom = document.getElementById('livreurNom').value.trim();
        const dateLivraison = document.getElementById('dateLivraison').value.trim();

        if (!livreurNom || !dateLivraison) {
            alert('Veuillez remplir tous les champs.');
            return;
        }

        console.log(`Commande ${orderId} validée par ${livreurNom} pour le ${dateLivraison}`);
        alert(`Commande ${orderId} validée avec succès !`);
        document.body.removeChild(overlay);
    });

    document.getElementById('annulerLivraison').addEventListener('click', () => {
        document.body.removeChild(overlay);
    });
}

function validerCommande(orderId) {
    totalCommandes = Math.max(0, totalCommandes - 1);
    updateNotificationCount();
    alert(`Commande ${orderId} validée avec succès !`);
}

document.addEventListener('DOMContentLoaded', function () {
    fetchAndRenderCommandes();
});
