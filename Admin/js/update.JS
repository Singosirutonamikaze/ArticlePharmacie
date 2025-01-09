document.querySelectorAll('.hoverButton').forEach(button => {
    button.addEventListener('click', event => {
        const parentElement = event.target.closest('.contentElement');
        const product = {
            nom: parentElement.querySelector('h3').textContent,
            image: parentElement.querySelector('img').src,
            prix: parentElement.querySelector('p').textContent.match(/\d+/)[0],
            description: 'Description à compléter',
            stock: 'Stock à compléter'
        };

        // Enregistrer le produit sélectionné dans le localStorage
        localStorage.setItem('selectedProduct', JSON.stringify(product));

        // Vérification du produit dans le localStorage
        console.log(localStorage.getItem('selectedProduct')); // Pour vérifier que le produit est bien enregistré

        // Ouvrir le formulaire de mise à jour
        window.location.href = 'Update.php'; // Assurez-vous que ce chemin est correct
    });
});
