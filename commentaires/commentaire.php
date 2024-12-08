<?php
// -- COMMENTAIRE EXPLICATIF : LIAISON DU FORMULAIRE D'ARTICLEPHARMACIE À POSTGRESQL
// --
// -- Dans le cadre de notre projet "ArticlePharmacie", nous avons conçu un formulaire pour permettre aux utilisateurs
// -- d'ajouter, modifier ou supprimer des articles pharmaceutiques. Ce formulaire sera lié à la base de données PostgreSQL
// -- pour stocker et gérer les données des articles (nom, prix, description, etc.).
// --
// -- 1. Connexion à la base de données PostgreSQL :
// --    - Nous utiliserons une bibliothèque appropriée (comme 'pg' pour Node.js ou 'psycopg2' pour Python) pour connecter
// --      notre application web à la base de données PostgreSQL.
// --
// -- 2. Structure de la base de données (Table "articles") :
// --    - Une table dédiée sera créée dans PostgreSQL pour stocker les informations des articles.
// --    Exemple de structure de la table "articles" :
// --    CREATE TABLE articles (
// --        id SERIAL PRIMARY KEY,       -- Identifiant unique pour chaque article
// --        name VARCHAR(255) NOT NULL,   -- Nom de l'article
// --        description TEXT,            -- Description détaillée de l'article
// --        price DECIMAL(10, 2) NOT NULL, -- Prix de l'article
// --        quantity INT NOT NULL        -- Quantité disponible en stock
// --    );
// --
// -- 3. Ajout de données via le formulaire :
// --    - Lorsqu'un utilisateur soumet le formulaire, nous récupérerons les données (nom, description, prix, quantité)
// --      et les insérerons dans la base de données PostgreSQL via une requête INSERT.
// --    Exemple de requête d'insertion :
// --    INSERT INTO articles (name, description, price, quantity)
// --    VALUES ($1, $2, $3, $4);
// --    -- Ici, les paramètres $1, $2, $3 et $4 sont les valeurs envoyées par le formulaire.
// --
// -- 4. Récupération des données pour affichage :
// --    - Nous pouvons récupérer les articles à partir de PostgreSQL avec une requête SELECT pour les afficher sur le site.
// --    Exemple de requête de sélection pour afficher tous les articles :
// --    SELECT * FROM articles;
// --    -- Cette requête renverra tous les articles stockés dans la base de données pour les afficher dans une liste.
// --
// -- 5. Mise à jour des données via le formulaire :
// --    - Si un utilisateur souhaite modifier un article existant, nous utiliserons une requête UPDATE pour mettre à jour
// --      les informations de l'article dans PostgreSQL.
// --    Exemple de requête de mise à jour :
// --    UPDATE articles
// --    SET name = $1, description = $2, price = $3, quantity = $4
// --    WHERE id = $5;
// --    -- Ici, $1, $2, $3, et $4 sont les nouvelles valeurs soumises, et $5 est l'ID de l'article à mettre à jour.
// --
// -- 6. Suppression d'un article :
// --    - Pour supprimer un article, nous utiliserons une requête DELETE avec l'ID de l'article à supprimer.
// --    Exemple de requête de suppression :
// --    DELETE FROM articles WHERE id = $1;
// --    -- Ici, $1 est l'ID de l'article à supprimer.
// --
// -- 7. Sécurisation des requêtes :
// --    - Toutes les requêtes SQL liées à la gestion des articles doivent être sécurisées contre les injections SQL.
// --      Nous utiliserons des requêtes préparées ou des ORM pour éviter ce risque et garantir la sécurité des données.
// --
// -- Ces opérations permettront de lier efficacement le formulaire de notre site "ArticlePharmacie" à PostgreSQL,
// -- assurant une gestion fluide et sécurisée des articles pharmaceutiques.
