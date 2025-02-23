const urls = {
    clients: '../Admin/json/clients.json',
    employes: '../Admin/json/employes.json',
    livreurs: '../Admin/json/livreurs.json',
    fournisseurs: '../Admin/json/fournisseurs.json'
};

function chargerDonnees() {
    axios.all([
        axios.get(urls.clients),
        axios.get(urls.employes),
        axios.get(urls.livreurs),
        axios.get(urls.fournisseurs)
    ])
        .then(axios.spread((clientsRes, employesRes, livreursRes, fournisseursRes) => {
            const clients = clientsRes.data;
            const employes = employesRes.data;
            const livreurs = livreursRes.data;
            const fournisseurs = fournisseursRes.data;

            afficherClients(clients);
            afficherEmployes(employes);
            afficherLivreurs(livreurs);
            afficherFournisseurs(fournisseurs);
        }))
        .catch(error => {
            console.error("Erreur de chargement des données", error);
            afficherAlert("Erreur lors du chargement des données.", "error");
        });
}

function afficherClients(clients) {
    const clientListElement = document.getElementById('client-list');
    const clientHorairesElement = document.getElementById('client-horaires');

    clientListElement.innerHTML = "";
    clientHorairesElement.innerHTML = "";

    clients.forEach((client, index) => {
        // Ajout des clients dans la liste
        const clientDiv = document.createElement('div');
        clientDiv.classList.add('bg-white', 'p-6', 'rounded-lg', 'shadow-md', 'hover:shadow-lg', 'transition-shadow', 'h-64', 'fade-in');
        clientDiv.innerHTML = `
                    <p class="text-lg font-semibold text-gray-800">${client.nom} ${client.prenom}</p>
                    <p class="text-sm text-gray-600 mt-2"><span class="font-medium">Email:</span> ${client.email}</p>
                    <p class="text-sm text-gray-600"><span class="font-medium">Adresse:</span> ${client.adresse}</p>
                    <p class="text-sm text-gray-600"><span class="font-medium">Téléphone:</span> ${client.telephone}</p>
                    <button class="mt-4 bg-red-500 text-white px-4 py-2 rounded-md hover:bg-red-600 transition-colors" onclick="supprimerClient(${index})">Supprimer</button>
                `;
        clientListElement.appendChild(clientDiv);

        // Ajout des horaires dans le tableau
        const row = document.createElement('tr');
        row.innerHTML = `
                    <td class="border border-gray-300 p-2">${client.nom}</td>
                    <td class="border border-gray-300 p-2">${client.prenom}</td>                
                `;
        clientHorairesElement.appendChild(row);
    });
}

function afficherEmployes(employes) {
    const employeListElement = document.getElementById('employe-list');
    const employeHorairesElement = document.getElementById('employe-horaires');

    employeListElement.innerHTML = "";
    employeHorairesElement.innerHTML = "";

    employes.forEach((employe, index) => {
        // Ajout des employés dans la liste
        const employeDiv = document.createElement('div');
        employeDiv.classList.add('bg-white', 'p-6', 'rounded-lg', 'shadow-md', 'hover:shadow-lg', 'transition-shadow', 'h-64', 'fade-in');
        employeDiv.innerHTML = `
                    <p class="text-lg font-semibold text-gray-800">${employe.nom} ${employe.prenom}</p>
                    <p class="text-sm text-gray-600 mt-2"><span class="font-medium">Email:</span> ${employe.email}</p>
                    <p class="text-sm text-gray-600"><span class="font-medium">Adresse:</span> ${employe.adresse}</p>
                    <p class="text-sm text-gray-600"><span class="font-medium">Téléphone:</span> ${employe.telephone}</p>
                    <button class="mt-4 bg-red-500 text-white px-4 py-2 rounded-md hover:bg-red-600 transition-colors" onclick="supprimerEmploye(${index})">Supprimer</button>
                `;
        employeListElement.appendChild(employeDiv);

        // Ajout des horaires dans le tableau
        const row = document.createElement('tr');
        row.innerHTML = `
                    <td class="border border-gray-300 p-2">${employe.nom}</td>
                    <td class="border border-gray-300 p-2">${employe.prenom}</td>
                    <td class="border border-gray-300 p-2">${employe.salaire || 'Non spécifié'}</td>
                `;
        employeHorairesElement.appendChild(row);
    });
}

function afficherLivreurs(livreurs) {
    const livreurListElement = document.getElementById('livreur-list');
    const livreurHorairesElement = document.getElementById('livreur-horaires');

    livreurListElement.innerHTML = "";
    livreurHorairesElement.innerHTML = "";

    livreurs.forEach((livreur, index) => {
        // Ajout des livreurs dans la liste
        const livreurDiv = document.createElement('div');
        livreurDiv.classList.add('bg-white', 'p-6', 'rounded-lg', 'shadow-md', 'hover:shadow-lg', 'transition-shadow', 'h-64', 'fade-in');
        livreurDiv.innerHTML = `
                    <p class="text-lg font-semibold text-gray-800">${livreur.nom} ${livreur.prenom}</p>
                    <p class="text-sm text-gray-600 mt-2"><span class="font-medium">Email:</span> ${livreur.email}</p>
                    <p class="text-sm text-gray-600"><span class="font-medium">Véhicule:</span> ${livreur.vehicule}</p>
                    <button class="mt-4 bg-red-500 text-white px-4 py-2 rounded-md hover:bg-red-600 transition-colors" onclick="supprimerLivreur(${index})">Supprimer</button>
                `;
        livreurListElement.appendChild(livreurDiv);

        // Ajout des horaires dans le tableau
        const row = document.createElement('tr');
        row.innerHTML = `
                    <td class="border border-gray-300 p-2">${livreur.nom}</td>
                    <td class="border border-gray-300 p-2">${livreur.prenom}</td>
                    <td class="border border-gray-300 p-2">${formatHoraires(livreur.horaires)}</td>
                    <td class="border border-gray-300 p-2">${livreur.vehicule || 'Non spécifié'}</td>
                `;
        livreurHorairesElement.appendChild(row);
    });
}

function afficherFournisseurs(fournisseurs) {
    const fournisseurListElement = document.getElementById('fournisseur-list');
    const fournisseurHorairesElement = document.getElementById('fournisseur-horaires');

    fournisseurListElement.innerHTML = "";
    fournisseurHorairesElement.innerHTML = "";

    fournisseurs.forEach((fournisseur, index) => {
        // Ajout des fournisseurs dans la liste
        const fournisseurDiv = document.createElement('div');
        fournisseurDiv.classList.add('bg-white', 'p-6', 'rounded-lg', 'shadow-md', 'hover:shadow-lg', 'transition-shadow', 'h-64', 'fade-in');
        fournisseurDiv.innerHTML = `
                    <p class="text-lg font-semibold text-gray-800">${fournisseur.nom}</p>
                    <p class="text-sm text-gray-600 mt-2"><span class="font-medium">Email:</span> ${fournisseur.email}</p>
                    <p class="text-sm text-gray-600"><span class="font-medium">Adresse:</span> ${fournisseur.adresse}</p>
                    <p class="text-sm text-gray-600"><span class="font-medium">Téléphone:</span> ${fournisseur.telephone}</p>
                    <button class="mt-4 bg-red-500 text-white px-4 py-2 rounded-md hover:bg-red-600 transition-colors" onclick="supprimerFournisseur(${index})">Supprimer</button>
                `;
        fournisseurListElement.appendChild(fournisseurDiv);

        // Ajout des horaires dans le tableau
        const row = document.createElement('tr');
        row.innerHTML = `
                    <td class="border border-gray-300 p-2">${fournisseur.nom}</td>
                    <td class="border border-gray-300 p-2">${fournisseur.prenom || 'Non spécifié'}</td>
                    <td class="border border-gray-300 p-2">${fournisseur.email}</td>
                    <td class="border border-gray-300 p-2">${fournisseur.telephone}</td>
                    <td class="border border-gray-300 p-2">${fournisseur.adresse}</td>
                    <td class="border border-gray-300 p-2">${fournisseur.responsable}</td>
                    <td class="border border-gray-300 p-2">${formatHoraires(fournisseur.horaires)}</td>
                `;
        fournisseurHorairesElement.appendChild(row);
    });
}

function formatHoraires(horaires) {
    if (!horaires) return 'Non spécifié';
    if (Array.isArray(horaires)) {
        return horaires.map(h => `${h.jour}: ${h.heures}`).join('<br>');
    } else if (typeof horaires === 'object') {
        return Object.entries(horaires).map(([jour, heures]) => `${jour}: ${heures}`).join('<br>');
    }
    return horaires;
}

function afficherAlert(message, type) {
    const alertContainer = document.getElementById('alertContainer');
    const alertDiv = document.createElement('div');
    alertDiv.classList.add('alert', type === 'error' ? 'bg-red-100' : 'bg-green-100');
    alertDiv.innerHTML = `
                <span>${message}</span>
                <span class="close ml-4 cursor-pointer" onclick="this.parentElement.remove()">X</span>
            `;
    alertContainer.appendChild(alertDiv);
}

function supprimerClient(index) {
    if (confirm("Êtes-vous sûr de vouloir supprimer ce client ?")) {
        axios.delete(urls.clients + `/${index}`)
            .then(response => {
                afficherAlert("Client supprimé avec succès.", "success");
                chargerDonnees();
            })
            .catch(error => {
                console.error("Erreur lors de la suppression du client", error);
                afficherAlert("Erreur lors de la suppression du client.", "error");
            });
    }
}

function supprimerLivreur(index) {
    if (confirm("Êtes-vous sûr de vouloir supprimer ce livreur ?")) {
        axios.delete(urls.livreurs + `/${index}`)
            .then(response => {
                afficherAlert("Livreur supprimé avec succès.", "success");
                chargerDonnees();
            })
            .catch(error => {
                console.error("Erreur lors de la suppression du livreur", error);
                afficherAlert("Erreur lors de la suppression du livreur.", "error");
            });
    }
}

function supprimerEmploye(index) {
    if (confirm("Êtes-vous sûr de vouloir supprimer cet employé ?")) {
        axios.delete(urls.employes + `/${index}`)
            .then(response => {
                afficherAlert("Employé supprimé avec succès.", "success");
                chargerDonnees();
            })
            .catch(error => {
                console.error("Erreur lors de la suppression de l'employé", error);
                afficherAlert("Erreur lors de la suppression de l'employé.", "error");
            });
    }
}

// Charger les données au démarrage
chargerDonnees();