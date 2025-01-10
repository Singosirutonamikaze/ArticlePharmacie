async function fetchAndRenderProducts() {
    try {
        const response = await fetch('../Admin/dataSiteElement.json');
        const products = await response.json();

        const contentElements = document.querySelectorAll('#addElement1 .contentElement');
        const leftArrow = document.querySelector('.left_arrow');
        const rightArrow = document.querySelector('.right_arrow');

        let currentStartIndex = 0; // Index de départ pour afficher les images
        const visibleCount = contentElements.length; // Nombre d'éléments visibles en même temps

        // Fonction pour mettre à jour les images affichées
        function renderProducts() {
            contentElements.forEach((element, index) => {
                const productIndex = currentStartIndex + index;

                if (products[productIndex]) {
                    element.innerHTML = `
                        <span class='img'><img src="${products[productIndex].image}" alt="${products[productIndex].nom}"></span>
                        <span class='flex_span'>
                            <h3>${products[productIndex].nom}</h3>
                            <p>Prix : ${products[productIndex].prix} FCFA</p>
                        </span>
                        <button class="hoverButton" class ="update"> <a href="../Admin/update.php">Mis à jour</a></button>
                    `;
                    element.style.display = "block"; // Réaffiche l'élément
                } else {
                    element.innerHTML = ''; // Vider l'élément s'il n'y a pas de produit
                    element.style.display = "none"; // Masquer l'élément
                }
            });

            // Gérer la visibilité des flèches
            leftArrow.style.display = currentStartIndex === 0 ? 'none' : 'flex';
            rightArrow.style.display = currentStartIndex + visibleCount >= products.length ? 'none' : 'flex';
        }

        // Événement pour la flèche gauche (images précédentes)
        leftArrow.addEventListener('click', () => {
            if (currentStartIndex > 0) {
                currentStartIndex -= visibleCount;
                renderProducts();
            }
        });

        // Événement pour la flèche droite (images suivantes)
        rightArrow.addEventListener('click', () => {
            if (currentStartIndex + visibleCount < products.length) {
                currentStartIndex += visibleCount;
                renderProducts();
            }
        });

        // Premier rendu
        renderProducts();
    } catch (error) {
        console.error("Erreur lors du chargement des produits :", error);
    }
}

fetchAndRenderProducts();
