
document.querySelectorAll('.hoverButton').forEach(button => {
    button.addEventListener('click', (event) => {
        const parentElement = event.target.closest('.contentElement');
        
        // Element retrieval with checks
        const h3Element = parentElement.querySelector('h3');
        const imgElement = parentElement.querySelector('img');
        const pElement = parentElement.querySelector('p');

        if (!h3Element || !imgElement || !pElement) {
            console.error("Required elements not found");
            return; // Exit if elements are missing
        }

        const product = {
            nom: h3Element.textContent,
            image: imgElement.src,
            prix: pElement.textContent.match(/\d+/)[0] || '0', // Default to '0' if no match
            description: 'Description à compléter',
            stock: 'Stock à compléter'
        };

        // Store the product in localStorage
        try {
            localStorage.setItem('selectedProduct', JSON.stringify(product));
        } catch (e) {
            console.error("Local Storage limit exceeded:", e);
        }

        // Verify the product in localStorage
        console.log(localStorage.getItem('selectedProduct'));

        // Redirect to the update page
        window.location.href = 'update.php'; // Ensure this path is correct
    });
});
