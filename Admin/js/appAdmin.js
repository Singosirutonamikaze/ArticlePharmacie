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

// // Afficher la première page par défaut
firstPage.classList.add("active");

// Cacher tous les conteneurs
const hideAllContainers = () => {
    const containers = document.querySelectorAll(".container");
    containers.forEach(container => container.classList.remove("active"));
};

userProfileBtn.addEventListener("click", () => {
    hideAllContainers();
    firstPage.classList.add("active");
});

addDrugBtn.addEventListener("click", () => {
    hideAllContainers();
    addDrugCard.classList.add("active");
});

delDrugBtn.addEventListener("click", () => {
    hideAllContainers();
    deleteDrugCard.classList.add("active");
});

updateDrugBtn.addEventListener("click", () => {
    hideAllContainers();
    updateDrugCard.classList.add("active");
});

notificationBtn.addEventListener("click", () => {
    hideAllContainers();
    notificationCard.classList.add("active");
});
