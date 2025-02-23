window.onload = () => {
    const addDrugBtn = document.getElementById('addDrug');
    const delDrugBtn = document.getElementById('DelDrug');
    const updateDrugBtn = document.getElementById('UpdateDRUG');
    const notificationBtn = document.getElementById('notification');
    const userProfileBtn = document.getElementById('userProfile');
    const managementInfoBtn = document.getElementById('manageInfo');
    const dashboard = document.getElementById('dashboard');

    const addDrugCard = document.getElementById("addElement2");
    const deleteDrugCard = document.getElementById("addElement3");
    const updateDrugCard = document.getElementById("addElement1");
    const notificationCard = document.getElementById("addElement4");
    const firstPage = document.getElementById("addElement5");
    const userProfileCard = document.getElementById("addElement6");
    const dashboardCard = document.getElementById("addElement7");

    // Afficher la première page par défaut
    firstPage.classList.add("active");

    // Cacher tous les conteneurs
    const hideAllContainers = () => {
        const containers = document.querySelectorAll(".container");
        containers.forEach(container => {
            container.classList.remove("active");
            container.style.display = "none";
        });
    };

    // Afficher un conteneur spécifique
    const showContainer = (container) => {
        hideAllContainers();
        container.style.display = "flex";
        container.classList.add("active");
    };

    // Gestion des clics sur les boutons
    userProfileBtn.addEventListener("click", () => {
        console.log("User Profile clicked");
        showContainer(firstPage);
    });

    addDrugBtn.addEventListener("click", () => {
        console.log("Add Drug clicked");
        showContainer(addDrugCard);
    });

    delDrugBtn.addEventListener("click", () => {
        console.log("Delete Drug clicked");
        showContainer(deleteDrugCard);
    });

    updateDrugBtn.addEventListener("click", () => {
        console.log("Update Drug clicked");
        showContainer(updateDrugCard);
    });

    notificationBtn.addEventListener("click", () => {
        console.log("Notification clicked");
        showContainer(notificationCard);
    });

    managementInfoBtn.addEventListener("click", () => {
        console.log("Manage Information clicked");
        showContainer(userProfileCard);
    });

    dashboard.addEventListener("click", () => {
        console.log("Dashboard clicked");
        showContainer(dashboardCard);
    });

    // Gestion des boutons de la première page
    const addProductBtn = document.getElementById('addProductBtn');
    const updateProductBtn = document.getElementById('updateProductBtn');
    const deleteProductBtn = document.getElementById('deleteProductBtn');
    const manageInfoBtnPage = document.getElementById('manageInfoBtn');
    const viewOrdersBtn = document.getElementById('viewOrdersBtn');
    const dashboardBtn = document.getElementById('DashboardBtn');

    addProductBtn.addEventListener("click", () => {
        console.log("Ajouter des produits");
        showContainer(addDrugCard);
    });

    updateProductBtn.addEventListener("click", () => {
        console.log("Mettre à jour les produits");
        showContainer(updateDrugCard);
    });

    deleteProductBtn.addEventListener("click", () => {
        console.log("Supprimer des produits");
        showContainer(deleteDrugCard);
    });

    manageInfoBtnPage.addEventListener("click", () => {
        console.log("Gérer les informations");
        showContainer(userProfileCard);
    });

    viewOrdersBtn.addEventListener("click", () => {
        console.log("Consulter les commandes");
        showContainer(notificationCard);
    });

    dashboardBtn.addEventListener("click", () => {
        console.log("Dashboard");
        showContainer(dashboardCard);
    });
};
