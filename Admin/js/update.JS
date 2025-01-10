document.querySelectorAll('.update').forEach(button => {
    button.addEventListener('click', (event) => {
        const parentElement = event.target.closest('.contentElement');
        
        if (!parentElement) {
            console.error("Le parent .contentElement est introuvable");
            return;
        }

        const h3Element = parentElement.querySelector('h3');
        const imgElement = parentElement.querySelector('img');
        const pElement = parentElement.querySelector('p');

        if (!h3Element || !imgElement || !pElement) {
            console.error("Éléments requis non trouvés");
            return; // Sortir si les éléments sont manquants
        }

        const product = {
            nom: h3Element.textContent,
            image: imgElement.src,
            prix: pElement.textContent.match(/\d+/)[0] || '0', // Valeur par défaut '0' si aucun match
            description: 'Description à compléter',
            stock: 'Stock à compléter'
        };

        // Enregistrer le produit dans le localStorage
        try {
            localStorage.setItem('selectedProduct', JSON.stringify(product));
        } catch (e) {
            console.error("Limite du localStorage dépassée :", e);
        }

        // Vérifier le produit dans le localStorage
        console.log(localStorage.getItem('selectedProduct'));

        // Assurez-vous que le lien est correct
        if (window.location.href !== 'update.php') {
            alert("Redirection vers update.php");
            window.location.href = '../Admin/update.php';
        }
    });
});
