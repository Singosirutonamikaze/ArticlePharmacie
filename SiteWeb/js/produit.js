async function loadProducts() {
    try {
        const response = await fetch('../dataSiteElement.json');
        if (!response.ok) {
            throw new Error(`Erreur HTTP : status: ${response.status}`);
        }
        const data = await response.json();
        getProducts(data);
    } catch (error) {
        console.error('Erreur lors du chargement des produits :', error);
    }
}

let nbreAjoutPanier = 0;
const number = document.querySelector(".number span");
let nbre = 0;
number.innerHTML = nbre;

// ecouter un evenement sur le bouton acheter pour ajouter le medicament au panier
const sectionCommande = document.querySelector(".commande");
const boxCommande = document.querySelector(".box_commande");


function getProducts(piece) {
    const firstSection = document.querySelector(".first_section");
    if (!firstSection) {
        console.error('Élément avec la classe "first_section" non trouvé.');
        return;
    }


    for (let i = 0; i < 9; i++) {
        const medicaments = piece[i];

        // Créer une balise pour chaque medicament
        const pieceMedicaments = document.createElement("article");

        // Créer une balise img pour chaque medicament
        const image = document.createElement("img");
        image.src = medicaments.image;

        const name = document.createElement("h4");
        name.textContent = medicaments.nom;

        // Ajouter un bouton voir plus sur chaque medicament
        const voirPlus = document.createElement("button");
        voirPlus.textContent = "Voir plus";

        voirPlus.addEventListener("click", () => {
            const contentInfo = document.querySelector(".content_info");


            // creer une div pour recuperer l'image et les maladies concernés avec des li
            const div = document.createElement("div");
            // ajouter une classe a la div pour pouvoir l'utiliser dans le css
            div.classList.add("entete_info");
            const imageInfo = document.createElement("img");
            imageInfo.src = medicaments.image;
            const ul = document.createElement("ul");
            //ecrire le code pour recuperer les elements qui se trouve dans le tableau maladies dans le json
            const titleMaladies = document.createElement("h3");
            titleMaladies.textContent = "Maladies";
            ul.appendChild(titleMaladies);
            for (let j = 0; j < medicaments.maladies.length; j++) {
                const li = document.createElement("li");
                li.textContent = medicaments.maladies[j];
                ul.appendChild(li);
            }

            // mettre en place une div pour la description du produit
            const divDescription = document.createElement("div");
            divDescription.classList.add("description");
            const p = document.createElement("p");
            p.textContent = medicaments.description;
            divDescription.appendChild(p);
            // mettre en place une div pour l'utilisations et la posologie
            const div2 = document.createElement("div");
            div2.classList.add("utili_poso");
            

            const divUtili = document.createElement("div");
            divUtili.classList.add("utilisations");
            const divPoso = document.createElement("div");
            divPoso.classList.add("posologie");
            const ulUtili = document.createElement("ul");
            const ulPoso = document.createElement("ul");
            //ecrire le code pour recuperer les elements qui se trouve dans le tableau utilisations dans le json
            const titleUtil = document.createElement("h3");
                titleUtil.textContent = "Utilisations";
                divUtili.appendChild(titleUtil);
            for (let j = 0; j < medicaments.utilisations.length; j++) {
                const li = document.createElement("li");
                li.textContent = medicaments.utilisations[j];
                ulUtili.appendChild(li);
            }
            //ecrire le code pour recuperer les elements qui se trouve dans le tableau posologie dans le json

            const titlePoso = document.createElement("h3");
                titlePoso.textContent = "Posologie";
                divPoso.appendChild(titlePoso);
            for (let j = 0; j < medicaments.posologie.length; j++) {
                const li = document.createElement("li");
                li.textContent = medicaments.posologie[j];
                ulPoso.appendChild(li);
            }

            // mettre en place une div pour les precautions
            const div3 = document.createElement("div");
            div3.classList.add("precautions");
            const ulPreco = document.createElement("ul");
            //ecrire le code pour recuperer les elements qui se trouve dans le tableau precautions dans le json
            const titlePreca = document.createElement("h3");
                titlePreca.textContent = "Precautions";
                div3.appendChild(titlePreca);
            for (let j = 0; j < medicaments.precautions.length; j++) {
                const li = document.createElement("li");
                li.textContent = medicaments.precautions[j];
                ulPreco.appendChild(li);
            }


            // mettre en place une div pour prix et le nombre de medocs achetable
            const div4 = document.createElement("div");
            div4.classList.add("prix_achat");
            const divPrix = document.createElement("div");

            const titlePrix = document.createElement("h3");
            titlePrix.textContent = "Prix";
            divPrix.appendChild(titlePrix);

            const prix = document.createElement("button");
            prix.textContent = `${medicaments.prix} fcfa`;
            divPrix.appendChild(prix);

            // creer un input da saisie pour le nombre de medocs a payer 

            const divInput = document.createElement("div");
            const titleInput = document.createElement("h3");
            titleInput.textContent = "Quantité";
            divInput.appendChild(titleInput);

            const input = document.createElement("input");
            input.type = "number";
            input.min = "0";
            input.max = "25";
            input.value = "1";
            divInput.appendChild(input);
            // ecouter un evenement sur l'inut quantite pour mettre a jour le prix
            input.addEventListener("input", () => {
                const quantite = input.value;
                const total = medicaments.prix * quantite;
                prix.textContent = `${total} fcfa`;
            })

            // mettre en place un bouton pour acheter le medicament
            const divAchat = document.createElement("div");
            divAchat.classList.add("achat");
            const acheter = document.createElement("button");
            acheter.textContent = "Ajouter au panier";
            
            divAchat.appendChild(acheter);

            
                acheter.addEventListener("click", () => {
                    sectionCommande.style.display = "block";
                    const quantite = input.value;
                    if(quantite > 0){
                        
                        nbreAjoutPanier++;
                        nbre = nbreAjoutPanier
                        number.innerHTML = nbre;

                        const articleCommande = document.createElement("article");
                        const imageCommande = document.createElement("img");
                        imageCommande.src = medicaments.image;
                        const titleCommande = document.createElement("h3");
                        titleCommande.textContent = medicaments.nom;
                        const quantiteCommande = document.createElement("p");
                        quantiteCommande.textContent = `Quantité : ${quantite}`;
                        const prixCommande = document.createElement("p");
                        prixCommande.textContent = `Prix total : ${medicaments.prix * quantite} fcfa`;
                        const supprimerCommande = document.createElement("button");
                        supprimerCommande.textContent = "Supprimer";
    
                        articleCommande.appendChild(imageCommande);
                        articleCommande.appendChild(titleCommande);
                        articleCommande.appendChild(quantiteCommande);
                        articleCommande.appendChild(prixCommande);
                        articleCommande.appendChild(supprimerCommande);
                        
                        boxCommande.appendChild(articleCommande);
                        
                        // supprimer un produit du panier 
                        supprimerCommande.addEventListener("click", () => {
                            boxCommande.removeChild(articleCommande);
                            nbreAjoutPanier--;
                            nbre = nbreAjoutPanier
                            number.innerHTML = nbre;
                            if(nbre == 0){
                                sectionCommande.style.display = "none";
                            }
                        })
                    }
                    contentInfo.innerHTML = "" ;
                });
            
            div.appendChild(imageInfo);
            div.appendChild(ul);
            divUtili.appendChild(ulUtili);
            divPoso.appendChild(ulPoso);
            div2.appendChild(divUtili);
            div2.appendChild(divPoso);
            div3.appendChild(ulPreco);
            div4.appendChild(divPrix);
            div4.appendChild(divInput);

            //  vider le contenu précédent
            contentInfo.innerHTML = '';

            contentInfo.appendChild(div);
            contentInfo.appendChild(divDescription);
            contentInfo.appendChild(div2);
            contentInfo.appendChild(div3);
            contentInfo.appendChild(div4);
            contentInfo.appendChild(divAchat);
        })

        // Ajouter les éléments au DOM
        pieceMedicaments.appendChild(image);
        pieceMedicaments.appendChild(name);
        pieceMedicaments.appendChild(voirPlus);
        firstSection.appendChild(pieceMedicaments);
    }

    const secondSection = document.querySelector(".second_section");
    if (!secondSection) {
        console.error('Élément avec la classe "second_section" non rencontré.');
        return;
    }

    for(let i = 9; i < 18; i++) {
        const medicaments = piece[i];

        // Créer une balise pour chaque medicament
        const pieceMedicaments = document.createElement("article");

        // Créer une balise img pour chaque medicament
        const image = document.createElement("img");
        image.src = medicaments.image;

        const name = document.createElement("h4");
        name.textContent = medicaments.nom;
        // Ajouter un bouton voir plus sur chaque medicament
        const voirPlus = document.createElement("button");
        voirPlus.textContent = "Voir plus";
        voirPlus.addEventListener("click", () => {
            const contentInfo = document.querySelector(".content_info");


            // creer une div pour recuperer l'image et les maladies concernés avec des li
            const div = document.createElement("div");
            // ajouter une classe a la div pour pouvoir l'utiliser dans le css
            div.classList.add("entete_info");
            const imageInfo = document.createElement("img");
            imageInfo.src = medicaments.image;
            const ul = document.createElement("ul");
            //ecrire le code pour recuperer les elements qui se trouve dans le tableau maladies dans le json
            const titleMaladies = document.createElement("h3");
            titleMaladies.textContent = "Maladies";
            ul.appendChild(titleMaladies);
            for (let j = 0; j < medicaments.maladies.length; j++) {
                const li = document.createElement("li");
                li.textContent = medicaments.maladies[j];
                ul.appendChild(li);
            }

            // mettre en place une div pour la description du produit
            const divDescription = document.createElement("div");
            divDescription.classList.add("description");
            const p = document.createElement("p");
            p.textContent = medicaments.description;
            divDescription.appendChild(p);
            // mettre en place une div pour l'utilisations et la posologie
            const div2 = document.createElement("div");
            div2.classList.add("utili_poso");
            

            const divUtili = document.createElement("div");
            divUtili.classList.add("utilisations");
            const divPoso = document.createElement("div");
            divPoso.classList.add("posologie");
            const ulUtili = document.createElement("ul");
            const ulPoso = document.createElement("ul");
            //ecrire le code pour recuperer les elements qui se trouve dans le tableau utilisations dans le json
            const titleUtil = document.createElement("h3");
                titleUtil.textContent = "Utilisations";
                divUtili.appendChild(titleUtil);
            for (let j = 0; j < medicaments.utilisations.length; j++) {
                const li = document.createElement("li");
                li.textContent = medicaments.utilisations[j];
                ulUtili.appendChild(li);
            }
            //ecrire le code pour recuperer les elements qui se trouve dans le tableau posologie dans le json

            const titlePoso = document.createElement("h3");
                titlePoso.textContent = "Posologie";
                divPoso.appendChild(titlePoso);
            for (let j = 0; j < medicaments.posologie.length; j++) {
                const li = document.createElement("li");
                li.textContent = medicaments.posologie[j];
                ulPoso.appendChild(li);
            }

            // mettre en place une div pour les precautions
            const div3 = document.createElement("div");
            div3.classList.add("precautions");
            const ulPreco = document.createElement("ul");
            //ecrire le code pour recuperer les elements qui se trouve dans le tableau precautions dans le json
            const titlePreca = document.createElement("h3");
                titlePreca.textContent = "Precautions";
                div3.appendChild(titlePreca);
            for (let j = 0; j < medicaments.precautions.length; j++) {
                const li = document.createElement("li");
                li.textContent = medicaments.precautions[j];
                ulPreco.appendChild(li);
            }


            // mettre en place une div pour prix et le nombre de medocs achetable
            const div4 = document.createElement("div");
            div4.classList.add("prix_achat");
            const divPrix = document.createElement("div");

            const titlePrix = document.createElement("h3");
            titlePrix.textContent = "Prix";
            divPrix.appendChild(titlePrix);

            const prix = document.createElement("button");
            prix.textContent = `${medicaments.prix} fcfa`;
            divPrix.appendChild(prix);

            // creer un input da saisie pour le nombre de medocs a payer 

            const divInput = document.createElement("div");
            const titleInput = document.createElement("h3");
            titleInput.textContent = "Quantité";
            divInput.appendChild(titleInput);

            const input = document.createElement("input");
            input.type = "number";
            input.min = "0";
            input.max = "25";
            input.value = "1";
            divInput.appendChild(input);
            // ecouter un evenement sur l'inut quantite pour mettre a jour le prix
            input.addEventListener("input", () => {
                const quantite = input.value;
                const total = medicaments.prix * quantite;
                prix.textContent = `${total} fcfa`;
            })

            // mettre en place un bouton pour acheter le medicament
            const divAchat = document.createElement("div");
            divAchat.classList.add("achat");
            const acheter = document.createElement("button");
            acheter.textContent = "Ajouter au panier";
            divAchat.appendChild(acheter);

            
            acheter.addEventListener("click", () => {
                sectionCommande.style.display = "block";
                const quantite = input.value;
                if(quantite > 0){
                    
                    nbreAjoutPanier++;
                    nbre = nbreAjoutPanier
                    number.innerHTML = nbre;

                    const articleCommande = document.createElement("article");
                    const imageCommande = document.createElement("img");
                    imageCommande.src = medicaments.image;
                    const titleCommande = document.createElement("h3");
                    titleCommande.textContent = medicaments.nom;
                    const quantiteCommande = document.createElement("p");
                    quantiteCommande.textContent = `Quantité : ${quantite}`;
                    const prixCommande = document.createElement("p");
                    prixCommande.textContent = `Prix total : ${medicaments.prix * quantite} fcfa`;
                    const supprimerCommande = document.createElement("button");
                    supprimerCommande.textContent = "Supprimer";

                    articleCommande.appendChild(imageCommande);
                    articleCommande.appendChild(titleCommande);
                    articleCommande.appendChild(quantiteCommande);
                    articleCommande.appendChild(prixCommande);
                    articleCommande.appendChild(supprimerCommande);
                    
                    boxCommande.appendChild(articleCommande);
                    
                    // supprimer un produit du panier 
                    supprimerCommande.addEventListener("click", () => {
                        boxCommande.removeChild(articleCommande);
                        nbreAjoutPanier--;
                        nbre = nbreAjoutPanier
                        number.innerHTML = nbre;
                        if(nbre == 0){
                            sectionCommande.style.display = "none";
                        }
                    })
                }
                contentInfo.innerHTML = "" ;
            });
            
            
            div.appendChild(imageInfo);
            div.appendChild(ul);
            divUtili.appendChild(ulUtili);
            divPoso.appendChild(ulPoso);
            div2.appendChild(divUtili);
            div2.appendChild(divPoso);
            div3.appendChild(ulPreco);
            div4.appendChild(divPrix);
            div4.appendChild(divInput);

            contentInfo.innerHTML = '';

            contentInfo.appendChild(div);
            contentInfo.appendChild(divDescription);
            contentInfo.appendChild(div2);
            contentInfo.appendChild(div3);
            contentInfo.appendChild(div4);
            contentInfo.appendChild(divAchat);
        })
        // Ajouter les éléments au DOM
        pieceMedicaments.appendChild(image);
        pieceMedicaments.appendChild(name);
        pieceMedicaments.appendChild(voirPlus);
        secondSection.appendChild(pieceMedicaments);
    }

    const thirdSection = document.querySelector(".third_section");
    if (!thirdSection) {
        console.error('Élément avec la classe "third_section" non trouvé.');
        return;
    }

    for(let i = 18; i < 27; i++) {
        const medicaments = piece[i];

        // Créer une balise pour chaque medicament
        const pieceMedicaments = document.createElement("article"); 

        // Créer une balise img pour chaque medicament        
        const image = document.createElement("img");
        image.src = medicaments.image;              

        const name = document.createElement("h4");
        name.textContent = medicaments.nom;
        // Ajouter un bouton voir plus sur chaque medicament
        const voirPlus = document.createElement("button");
        voirPlus.textContent = "Voir plus";
        voirPlus.addEventListener("click", () => {
            const contentInfo = document.querySelector(".content_info");


            // creer une div pour recuperer l'image et les maladies concernés avec des li
            const div = document.createElement("div");
            // ajouter une classe a la div pour pouvoir l'utiliser dans le css
            div.classList.add("entete_info");
            const imageInfo = document.createElement("img");
            imageInfo.src = medicaments.image;
            const ul = document.createElement("ul");
            //ecrire le code pour recuperer les elements qui se trouve dans le tableau maladies dans le json
            const titleMaladies = document.createElement("h3");
            titleMaladies.textContent = "Maladies";
            ul.appendChild(titleMaladies);
            for (let j = 0; j < medicaments.maladies.length; j++) {
                const li = document.createElement("li");
                li.textContent = medicaments.maladies[j];
                ul.appendChild(li);
            }

            // mettre en place une div pour la description du produit
            const divDescription = document.createElement("div");
            divDescription.classList.add("description");
            const p = document.createElement("p");
            p.textContent = medicaments.description;
            divDescription.appendChild(p);
            // mettre en place une div pour l'utilisations et la posologie
            const div2 = document.createElement("div");
            div2.classList.add("utili_poso");
            

            const divUtili = document.createElement("div");
            divUtili.classList.add("utilisations");
            const divPoso = document.createElement("div");
            divPoso.classList.add("posologie");
            const ulUtili = document.createElement("ul");
            const ulPoso = document.createElement("ul");
            //ecrire le code pour recuperer les elements qui se trouve dans le tableau utilisations dans le json
            const titleUtil = document.createElement("h3");
                titleUtil.textContent = "Utilisations";
                divUtili.appendChild(titleUtil);
            for (let j = 0; j < medicaments.utilisations.length; j++) {
                const li = document.createElement("li");
                li.textContent = medicaments.utilisations[j];
                ulUtili.appendChild(li);
            }
            //ecrire le code pour recuperer les elements qui se trouve dans le tableau posologie dans le json

            const titlePoso = document.createElement("h3");
                titlePoso.textContent = "Posologie";
                divPoso.appendChild(titlePoso);
            for (let j = 0; j < medicaments.posologie.length; j++) {
                const li = document.createElement("li");
                li.textContent = medicaments.posologie[j];
                ulPoso.appendChild(li);
            }

            // mettre en place une div pour les precautions
            const div3 = document.createElement("div");
            div3.classList.add("precautions");
            const ulPreco = document.createElement("ul");
            //ecrire le code pour recuperer les elements qui se trouve dans le tableau precautions dans le json
            const titlePreca = document.createElement("h3");
                titlePreca.textContent = "Precautions";
                div3.appendChild(titlePreca);
            for (let j = 0; j < medicaments.precautions.length; j++) {
                const li = document.createElement("li");
                li.textContent = medicaments.precautions[j];
                ulPreco.appendChild(li);
            }


            // mettre en place une div pour prix et le nombre de medocs achetable
            const div4 = document.createElement("div");
            div4.classList.add("prix_achat");
            const divPrix = document.createElement("div");

            const titlePrix = document.createElement("h3");
            titlePrix.textContent = "Prix";
            divPrix.appendChild(titlePrix);

            const prix = document.createElement("button");
            prix.textContent = `${medicaments.prix} fcfa`;
            divPrix.appendChild(prix);

            // creer un input da saisie pour le nombre de medocs a payer 

            const divInput = document.createElement("div");
            const titleInput = document.createElement("h3");
            titleInput.textContent = "Quantité";
            divInput.appendChild(titleInput);

            const input = document.createElement("input");
            input.type = "number";
            input.min = "0";
            input.max = "25";
            input.value = "1";
            divInput.appendChild(input);
            // ecouter un evenement sur l'inut quantite pour mettre a jour le prix
            input.addEventListener("input", () => {
                const quantite = input.value;
                const total = medicaments.prix * quantite;
                prix.textContent = `${total} fcfa`;
            })

            // mettre en place un bouton pour acheter le medicament
            const divAchat = document.createElement("div");
            divAchat.classList.add("achat");
            const acheter = document.createElement("button");
            acheter.textContent = "Ajouter au panier";
            divAchat.appendChild(acheter);

            
            acheter.addEventListener("click", () => {
                sectionCommande.style.display = "block";
                const quantite = input.value;
                if(quantite > 0){
                    
                    nbreAjoutPanier++;
                    nbre = nbreAjoutPanier
                    number.innerHTML = nbre;

                    const articleCommande = document.createElement("article");
                    const imageCommande = document.createElement("img");
                    imageCommande.src = medicaments.image;
                    const titleCommande = document.createElement("h3");
                    titleCommande.textContent = medicaments.nom;
                    const quantiteCommande = document.createElement("p");
                    quantiteCommande.textContent = `Quantité : ${quantite}`;
                    const prixCommande = document.createElement("p");
                    prixCommande.textContent = `Prix total : ${medicaments.prix * quantite} fcfa`;
                    const supprimerCommande = document.createElement("button");
                    supprimerCommande.textContent = "Supprimer";

                    articleCommande.appendChild(imageCommande);
                    articleCommande.appendChild(titleCommande);
                    articleCommande.appendChild(quantiteCommande);
                    articleCommande.appendChild(prixCommande);
                    articleCommande.appendChild(supprimerCommande);
                    
                    boxCommande.appendChild(articleCommande);
                    
                    // supprimer un produit du panier 
                    supprimerCommande.addEventListener("click", () => {
                        boxCommande.removeChild(articleCommande);
                        nbreAjoutPanier--;
                        nbre = nbreAjoutPanier
                        number.innerHTML = nbre;
                        if(nbre == 0){
                            sectionCommande.style.display = "none";
                        }
                    })
                }
                contentInfo.innerHTML = "" ;
            });
            
            div.appendChild(imageInfo);
            div.appendChild(ul);
            divUtili.appendChild(ulUtili);
            divPoso.appendChild(ulPoso);
            div2.appendChild(divUtili);
            div2.appendChild(divPoso);
            div3.appendChild(ulPreco);
            div4.appendChild(divPrix);
            div4.appendChild(divInput);

            contentInfo.innerHTML = '';

            contentInfo.appendChild(div);
            contentInfo.appendChild(divDescription);
            contentInfo.appendChild(div2);
            contentInfo.appendChild(div3);
            contentInfo.appendChild(div4);
            contentInfo.appendChild(divAchat);
        });

        // Ajouter les éléments au DOM
        pieceMedicaments.appendChild(image);
        pieceMedicaments.appendChild(name);
        pieceMedicaments.appendChild(voirPlus);
        thirdSection.appendChild(pieceMedicaments);
    }
}

// Appel de la fonction principale pour le chargement des medicaments sur la page
loadProducts();


// recuperer l'input de recherche 

const searchInput = document.getElementById("search");


// ecouter sur ce input un evenement pou pouvoir touver un produit et l'afficher
searchInput.addEventListener("input", () => {
    const recherche = searchInput.value

    console.log(recherche) ;
})