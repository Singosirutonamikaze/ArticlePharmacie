window.onload = () => {
    const addDrugBtn = document.getElementById('addDrug');
    const delDrugBtn = document.getElementById('DelDrug');
    const updateDrugBtn = document.getElementById('UpdateDRUG');
    const notificationBtn = document.getElementById('notification');
    const userProfileBtn = document.getElementById('userProfile');

    const addDrugCard = document.getElementById("addElement2");
    const deleteDrugCard = document.getElementById("addElement3");
    const updateDrugCard = document.getElementById("addElement1");
    const notificationCard = document.getElementById("addElement4");
    const firstPage = document.getElementById("addElement5");

    // Afficher la première page par défaut
    firstPage.classList.add("active");

    // Cacher tous les conteneurs
    const hideAllContainers = () => {
        const containers = document.querySelectorAll(".container");
        containers.forEach(container => container.classList.remove("active"));
    };

    userProfileBtn.addEventListener("click", () => {
        console.log("User Profile clicked");
        firstPage.style.display = "flex";
        hideAllContainers();
        firstPage.classList.add("active");
    });

    addDrugBtn.addEventListener("click", () => {
        console.log("Add Drug clicked");
        hideAllContainers();
        firstPage.style.display = "none";
        addDrugCard.classList.add("active");
    });

    delDrugBtn.addEventListener("click", () => {
        console.log("Delete Drug clicked");
        firstPage.style.display = "none";
        hideAllContainers();
        deleteDrugCard.classList.add("active");
    });

    updateDrugBtn.addEventListener("click", () => {
        console.log("Update Drug clicked");
        firstPage.style.display = "none";
        hideAllContainers();
        updateDrugCard.classList.add("active");
    });

    notificationBtn.addEventListener("click", () => {
        console.log("Notification clicked");
        firstPage.style.display = "none";
        hideAllContainers();
        notificationCard.classList.add("active");
    });

    // Récupérer les éléments
    const addProductBtn = document.getElementById('addProductBtn');
    const updateProductBtn = document.getElementById('updateProductBtn');
    const deleteProductBtn = document.getElementById('deleteProductBtn');
    const manageInfoBtn = document.getElementById('manageInfoBtn');
    const viewOrdersBtn = document.getElementById('viewOrdersBtn');

    // Récupérer les cartes/sections à afficher
    const addProductCard = document.getElementById("addElement2");
    const updateProductCard = document.getElementById("addElement1");
    const deleteProductCard = document.getElementById("addElement3");
    //const manageInfoCard = document.getElementById("addElement4");
    const viewOrdersCard = document.getElementById("addElement4");


    // Ajout d'événements aux boutons
    addProductBtn.addEventListener("click", () => {
        console.log("Ajouter des produits");
        firstPage.style.display = "none";
        hideAllContainers();
        addProductCard.classList.add("active");
    });

    updateProductBtn.addEventListener("click", () => {
        console.log("Mettre à jour les produits");
        firstPage.style.display = "none";
        hideAllContainers();
        updateProductCard.classList.add("active");
    });

    deleteProductBtn.addEventListener("click", () => {
        console.log("Supprimer des produits");
        firstPage.style.display = "none";
        hideAllContainers();
        deleteProductCard.style.display = "flex";
        deleteProductCard.classList.add("active");
    });

    manageInfoBtn.addEventListener("click", () => {
        console.log("Gérer les informations");
        hideAllContainers();
        //manageInfoCard.classList.add("active");
    });

    viewOrdersBtn.addEventListener("click", () => {
        console.log("Consulter les commandes");
        hideAllContainers();
        viewOrdersCard.classList.add("active");
    });
};
