// Les variables
const userProfileBtn = document.getElementById('userProfile');
const addDrugBtn = document.getElementById('addDrug');
const delDrugBtn = document.getElementById('DelDrug');
const updateDrugBtn = document.getElementById('UpdateDRUG');
const notificationBtn = document.getElementById('notification');

// Récupération des conteneurs
const AddDrugCard = document.getElementById("addElement2");
const DeleteDrugCard = document.getElementById("addElement3");
const UpdateDrugCard = document.getElementById("addElement1");
const NotificationCard = document.getElementById("addElement4");

// Événements pour les boutons
addDrugBtn.addEventListener("click", () => {
    AddDrugCard.style.display = "flex";
    DeleteDrugCard.style.display = "none";
    UpdateDrugCard.style.display = "none";
    NotificationCard.style.display = "none"; 
});

delDrugBtn.addEventListener("click", () => {
    DeleteDrugCard.style.display = "flex";
    AddDrugCard.style.display = "none";
    UpdateDrugCard.style.display = "none";
    NotificationCard.style.display = "none"; 
});

updateDrugBtn.addEventListener("click", () => {
    UpdateDrugCard.style.display = "flex";
    AddDrugCard.style.display = "none";
    DeleteDrugCard.style.display = "none";
    NotificationCard.style.display = "none";
});

notificationBtn.addEventListener("click", () => {
    NotificationCard.style.display = "flex";
    AddDrugCard.style.display = "none";
    DeleteDrugCard.style.display = "none";
    UpdateDrugCard.style.display = "none"; 
});

