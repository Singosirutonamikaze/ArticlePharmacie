-- Création de la Base de données
CREATE DATABASE IF NOT EXISTS Pharmacie_Gestion;
USE Pharmacie_Gestion;

-- Table des clients
CREATE TABLE client (
    id_client SERIAL PRIMARY KEY,
    nom VARCHAR(50),
    prenom VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    mot_de_passe VARCHAR(255),
    adresse VARCHAR(255),
    telephone VARCHAR(15)
);
CREATE INDEX idx_client_email ON client(email);

-- Table des employés
CREATE TABLE employe (
    id_employe SERIAL PRIMARY KEY,
    nom VARCHAR(50),
    prenom VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    roles VARCHAR(50)
);
CREATE INDEX idx_employe_email ON employe(email);

-- Table des livreurs
CREATE TABLE livreur (
    id_livreur SERIAL PRIMARY KEY,
    nom VARCHAR(50),
    prenom VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    vehicule VARCHAR(50)
);
CREATE INDEX idx_livreur_email ON livreur(email);

-- Table des fournisseurs
CREATE TABLE fournisseur (
    id_fournisseur SERIAL PRIMARY KEY,
    nom VARCHAR(100),
    adresse VARCHAR(255),
    telephone VARCHAR(15),
    email VARCHAR(100)
);
CREATE INDEX idx_fournisseur_email ON fournisseur(email);

-- Table des catégories de produits
CREATE TABLE categorie (
    id_categorie SERIAL PRIMARY KEY,
    nom VARCHAR(100)
);

-- Table des produits
CREATE TABLE produit (
    id_produit SERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    image VARCHAR(255),
    description TEXT,
    prix DECIMAL(10, 2) NOT NULL,
    maladies TEXT,
    stock INT CHECK (stock >= 0),
    utilisations TEXT,
    posologie TEXT,
    precautions TEXT,
    liens_de_reference VARCHAR(255),
    id_categorie INT,
    FOREIGN KEY (id_categorie) REFERENCES categorie(id_categorie)
);
CREATE INDEX idx_produit_categorie ON produit(id_categorie);
CREATE INDEX idx_produit_nom ON produit(nom);

-- Table des produits fournis par les fournisseurs
CREATE TABLE fournit (
    id_produit INT,
    id_fournisseur INT,
    PRIMARY KEY (id_produit, id_fournisseur),
    FOREIGN KEY (id_produit) REFERENCES produit(id_produit),
    FOREIGN KEY (id_fournisseur) REFERENCES fournisseur(id_fournisseur)
);

-- Table des commandes
CREATE TABLE commande (
    id_commande SERIAL PRIMARY KEY,
    date_commande DATE,
    statut VARCHAR(50),
    total DECIMAL(10,2),
    id_client INT,
    id_employe INT,
    id_livreur INT,
    FOREIGN KEY (id_client) REFERENCES client(id_client),
    FOREIGN KEY (id_employe) REFERENCES employe(id_employe),
    FOREIGN KEY (id_livreur) REFERENCES livreur(id_livreur)
);
CREATE INDEX idx_commande_client ON commande(id_client);
CREATE INDEX idx_commande_employe ON commande(id_employe);
CREATE INDEX idx_commande_livreur ON commande(id_livreur);

-- Table des produits dans les commandes
CREATE TABLE contient (
    id_commande INT,
    id_produit INT,
    quantite INT,
    PRIMARY KEY (id_commande, id_produit),
    FOREIGN KEY (id_commande) REFERENCES commande(id_commande),
    FOREIGN KEY (id_produit) REFERENCES produit(id_produit)
);

-- Fonction pour calculer le total d'une commande
CREATE OR REPLACE FUNCTION CalculerTotalCommande(p_id_commande INT)
RETURNS NUMERIC(10, 2) AS $$
BEGIN
    RETURN (
        SELECT COALESCE(SUM(p.prix * c.quantite), 0)
        FROM contient c
        JOIN produit p ON c.id_produit = p.id_produit
        WHERE c.id_commande = p_id_commande
    );
END;
$$ LANGUAGE plpgsql;

-- Procédure pour ajouter un produit
CREATE OR REPLACE PROCEDURE AjouterProduit(
    p_nom VARCHAR(255),
    p_image VARCHAR(255),
    p_description TEXT,
    p_prix NUMERIC(10, 2),
    p_maladies TEXT,
    p_utilisations TEXT,
    p_posologie TEXT,
    p_precautions TEXT,
    p_liens_de_reference VARCHAR(255),
    p_id_categorie INT
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO produit (
        nom, image, description, prix, maladies, utilisations, posologie, precautions, liens_de_reference, id_categorie
    )
    VALUES (
        p_nom, p_image, p_description, p_prix, p_maladies, p_utilisations, p_posologie, p_precautions, p_liens_de_reference, p_id_categorie
    );
END;
$$;

-- Procédure pour ajouter un client
CREATE OR REPLACE PROCEDURE AjouterClient(
    p_nom VARCHAR(50),
    p_prenom VARCHAR(50),
    p_email VARCHAR(100),
    p_mot_de_passe VARCHAR(255),
    p_adresse VARCHAR(255),
    p_telephone VARCHAR(15)
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO client (
        nom, prenom, email, mot_de_passe, adresse, telephone
    )
    VALUES (
        p_nom, p_prenom, p_email, p_mot_de_passe, p_adresse, p_telephone
    );
END;
$$;

--Trigger pour mettre à jour le total de la commande après une insertion dans `contient`
CREATE OR REPLACE FUNCTION update_total_func()
RETURNS TRIGGER AS $$
BEGIN
    -- Calculer le nouveau total de la commande
    UPDATE commande
    SET total = (
        SELECT SUM(p.prix * c.quantite)
        FROM contient c
        JOIN produit p ON c.id_produit = p.id_produit
        WHERE c.id_commande = NEW.id_commande
    )
    WHERE id_commande = NEW.id_commande;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_total
AFTER INSERT ON contient
FOR EACH ROW
EXECUTE FUNCTION update_total_func();

--Trigger pour vérifier la disponibilité du produit avant insertion dans `contient`
CREATE OR REPLACE FUNCTION validate_stock_func()
RETURNS TRIGGER AS $$
DECLARE
    v_stock INT;
BEGIN
    -- Vérifier le stock disponible
    SELECT stock INTO v_stock
    FROM produit
    WHERE id_produit = NEW.id_produit;

    IF v_stock < NEW.quantite THEN
        RAISE EXCEPTION 'Stock insuffisant pour le produit %', NEW.id_produit;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER validate_stock
BEFORE INSERT ON contient
FOR EACH ROW
EXECUTE FUNCTION validate_stock_func();

--Trigger pour mettre à jour le stock du produit après insertion dans `contient`
CREATE OR REPLACE FUNCTION update_stock_func()
RETURNS TRIGGER AS $$
BEGIN
    -- Réduire le stock en fonction de la quantité commandée
    UPDATE produit
    SET stock = stock - NEW.quantite
    WHERE id_produit = NEW.id_produit;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_stock
AFTER INSERT ON contient
FOR EACH ROW
EXECUTE FUNCTION update_stock_func();

-- Vue des commandes des clients
CREATE VIEW vue_commandes_clients AS
SELECT
    c.id_commande,
    c.date_commande,
    c.statut,
    c.total,
    cl.nom AS client_nom,
    cl.prenom AS client_prenom,
    cl.email AS client_email,
    cl.telephone AS client_telephone
FROM
    commande c
JOIN
    client cl ON c.id_client = cl.id_client;

-- Vue des produits dans une commande
CREATE VIEW vue_produits_commandes AS
SELECT
    co.id_commande,
    p.nom AS produit_nom,
    co.quantite,
    p.prix,
    (co.quantite * p.prix) AS total_produit
FROM
    contient co
JOIN
    produit p ON co.id_produit = p.id_produit;

-- Vue des employés et leurs rôles
CREATE VIEW vue_employes_roles AS
SELECT
    e.id_employe,
    e.nom,
    e.prenom,
    e.email,
    e.roles -- Correction pour correspondre à la structure
FROM
    employe e;

-- Vue des produits et leurs fournisseurs
CREATE VIEW vue_produits_fournisseurs AS
SELECT
    p.nom AS produit_nom,
    p.prix,
    f.nom AS fournisseur_nom,
    f.telephone AS fournisseur_telephone
FROM
    produit p
JOIN
    fournit fnt ON p.id_produit = fnt.id_produit
JOIN
    fournisseur f ON fnt.id_fournisseur = f.id_fournisseur;


--Les rôles--
-- Table des rôles
CREATE TABLE role (
    id_role SERIAL PRIMARY KEY,
    nom_role VARCHAR(50) UNIQUE
);

-- Insertion des rôles de base
INSERT INTO role (nom_role) VALUES
('admin'),
('employé'),
('client'),
('livreur');

-- Ajout du champ 'id_role' dans la table client
ALTER TABLE client
ADD COLUMN id_role INT,
ADD CONSTRAINT fk_client_role FOREIGN KEY (id_role) REFERENCES role(id_role);

-- Ajout du champ 'id_role' dans la table employe
ALTER TABLE employe
ADD COLUMN id_role INT,
ADD CONSTRAINT fk_employe_role FOREIGN KEY (id_role) REFERENCES role(id_role);

-- Ajout du champ 'id_role' dans la table livreur
ALTER TABLE livreur
ADD COLUMN id_role INT,
ADD CONSTRAINT fk_livreur_role FOREIGN KEY (id_role) REFERENCES role(id_role);

-- Fonction pour calculer le total d'une commande
CREATE OR REPLACE FUNCTION CalculerTotalCommande(p_id_commande INT)
RETURNS NUMERIC(10, 2) AS $$
BEGIN
    RETURN (
        SELECT COALESCE(SUM(p.prix * c.quantite), 0)
        FROM contient c
        JOIN produit p ON c.id_produit = p.id_produit
        WHERE c.id_commande = p_id_commande
    );
END;
$$ LANGUAGE plpgsql;

-- Procédure pour ajouter un produit
CREATE OR REPLACE PROCEDURE AjouterProduit(
    p_nom VARCHAR(255),
    p_image VARCHAR(255),
    p_description TEXT,
    p_prix NUMERIC(10, 2),
    p_maladies TEXT,
    p_utilisations TEXT,
    p_posologie TEXT,
    p_precautions TEXT,
    p_liens_de_reference VARCHAR(255),
    p_id_categorie INT
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO produit (
        nom, image, description, prix, maladies, utilisations, posologie, precautions, liens_de_reference, id_categorie
    )
    VALUES (
        p_nom, p_image, p_description, p_prix, p_maladies, p_utilisations, p_posologie, p_precautions, p_liens_de_reference, p_id_categorie
    );
END;
$$;

-- Procédure pour ajouter un client
CREATE OR REPLACE PROCEDURE AjouterClient(
    p_nom VARCHAR(50),
    p_prenom VARCHAR(50),
    p_email VARCHAR(100),
    p_mot_de_passe VARCHAR(255),
    p_adresse VARCHAR(255),
    p_telephone VARCHAR(15)
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO client (
        nom, prenom, email, mot_de_passe, adresse, telephone
    )
    VALUES (
        p_nom, p_prenom, p_email, p_mot_de_passe, p_adresse, p_telephone
    );
END;
$$;

-- Fonction pour récupérer les rôles
CREATE OR REPLACE FUNCTION GetRoleId(p_nom_role VARCHAR(50))
RETURNS INT AS $$
DECLARE
    v_id_role INT;
BEGIN
    SELECT id_role INTO v_id_role
    FROM role
    WHERE nom_role = p_nom_role;
    RETURN v_id_role;
END;
$$ LANGUAGE plpgsql;

-- Procédure pour ajouter un client avec un rôle
CREATE OR REPLACE PROCEDURE AjouterClientAvecRole(
    p_nom VARCHAR(50),
    p_prenom VARCHAR(50),
    p_email VARCHAR(100),
    p_mot_de_passe VARCHAR(255),
    p_adresse VARCHAR(255),
    p_telephone VARCHAR(15),
    p_nom_role VARCHAR(50)
)
LANGUAGE plpgsql AS $$
DECLARE
    v_id_role INT;
BEGIN
    v_id_role := GetRoleId(p_nom_role);
    INSERT INTO client (
        nom, prenom, email, mot_de_passe, adresse, telephone, id_role
    )
    VALUES (
        p_nom, p_prenom, p_email, p_mot_de_passe, p_adresse, p_telephone, v_id_role
    );
END;
$$;

-- Procédure pour ajouter un livreur avec un rôle
CREATE OR REPLACE PROCEDURE AjouterLivreurAvecRole(
    p_nom VARCHAR(50),
    p_prenom VARCHAR(50),
    p_email VARCHAR(100),
    p_vehicule VARCHAR(50),
    p_nom_role VARCHAR(50)
)
LANGUAGE plpgsql AS $$
DECLARE
    v_id_role INT;
BEGIN
    v_id_role := GetRoleId(p_nom_role);
    INSERT INTO livreur (
        nom, prenom, email, vehicule, id_role
    )
    VALUES (
        p_nom, p_prenom, p_email, p_vehicule, v_id_role
    );
END;
$$;

-- Procédure pour modifier le rôle d'un utilisateur
CREATE OR REPLACE PROCEDURE ModifierRoleUtilisateur(
    p_id_utilisateur INT,
    p_nom_role VARCHAR(50),
    p_type_utilisateur VARCHAR(50)
)
LANGUAGE plpgsql AS $$
DECLARE
    v_id_role INT;
BEGIN
    v_id_role := GetRoleId(p_nom_role);
    IF p_type_utilisateur = 'client' THEN
        UPDATE client
        SET id_role = v_id_role
        WHERE id_client = p_id_utilisateur;
    ELSIF p_type_utilisateur = 'employe' THEN
        UPDATE employe
        SET id_role = v_id_role
        WHERE id_employe = p_id_utilisateur;
    ELSIF p_type_utilisateur = 'livreur' THEN
        UPDATE livreur
        SET id_role = v_id_role
        WHERE id_livreur = p_id_utilisateur;
    END IF;
END;
$$;

-- Procédure pour afficher les clients avec leurs rôles
CREATE OR REPLACE PROCEDURE AfficherClientsAvecRole()
LANGUAGE plpgsql AS $$
BEGIN
    SELECT 
        c.id_client,
        c.nom,
        c.prenom,
        c.email,
        c.telephone,
        r.nom_role AS role
    FROM
        client c
    JOIN
        role r ON c.id_role = r.id_role;
END;
$$;

-- Procédure pour afficher les employés avec leurs rôles
CREATE OR REPLACE PROCEDURE AfficherEmployesAvecRole()
LANGUAGE plpgsql AS $$
BEGIN
    SELECT 
        e.id_employe,
        e.nom,
        e.prenom,
        e.email,
        e.roles,
        r.nom_role AS role
    FROM
        employe e
    JOIN
        role r ON e.id_role = r.id_role;
END;
$$;

-- Procédure pour afficher les livreurs avec leurs rôles
CREATE OR REPLACE PROCEDURE AfficherLivreursAvecRole()
LANGUAGE plpgsql AS $$
BEGIN
    SELECT 
        l.id_livreur,
        l.nom,
        l.prenom,
        l.email,
        l.vehicule,
        r.nom_role AS role
    FROM
        livreur l
    JOIN
        role r ON l.id_role = r.id_role;
END;
$$;

--Test des Ajouts
-- Ajouter 5 clients avec le rôle 'client'
CALL AjouterClientAvecRole('Dupont', 'Jean', 'jean.dupont@example.com', 'password123', '123 Rue de Paris', '0123456789', 'client');
CALL AjouterClientAvecRole('Durand', 'Paul', 'paul.durand@example.com', 'password456', '456 Rue de Lyon', '0123456780', 'client');
CALL AjouterClientAvecRole('Lemoine', 'Sophie', 'sophie.lemoine@example.com', 'password789', '789 Rue des Alpes', '0123456781', 'client');
CALL AjouterClientAvecRole('Bernard', 'Pierre', 'pierre.bernard@example.com', 'password321', '321 Rue de Bordeaux', '0123456782', 'client');
CALL AjouterClientAvecRole('Martin', 'Claire', 'claire.martin@example.com', 'password654', '654 Rue de Toulouse', '0123456783', 'client');

-- Ajouter 5 employés avec le rôle 'employé'
CALL AjouterEmployeAvecRole('Martin', 'Claire', 'claire.martin@example.com', 'Vente', 'employé');
CALL AjouterEmployeAvecRole('Lemoine', 'Marc', 'marc.lemoine@example.com', 'Marketing', 'employé');
CALL AjouterEmployeAvecRole('Dupont', 'Sylvie', 'sylvie.dupont@example.com', 'Gestion', 'employé');
CALL AjouterEmployeAvecRole('Leclerc', 'Paul', 'paul.leclerc@example.com', 'Finances', 'employé');
CALL AjouterEmployeAvecRole('Tremblay', 'Lucie', 'lucie.tremblay@example.com', 'Vente', 'employé');

-- Ajouter 5 livreurs avec le rôle 'livreur'
CALL AjouterLivreurAvecRole('Tremblay', 'Michel', 'michel.tremblay@example.com', 'Vélo', 'livreur');
CALL AjouterLivreurAvecRole('Leclerc', 'Sophie', 'sophie.leclerc@example.com', 'Moto', 'livreur');
CALL AjouterLivreurAvecRole('Dufresne', 'David', 'david.dufresne@example.com', 'Voiture', 'livreur');
CALL AjouterLivreurAvecRole('Benoit', 'Paul', 'paul.benoit@example.com', 'Vélo', 'livreur');
CALL AjouterLivreurAvecRole('Lemoine', 'Lucie', 'lucie.lemoine@example.com', 'Moto', 'livreur');

-- Appel pour ajouter 5 produits
CALL AjouterProduit('Aspirine', 'aspirine.jpg', 'Médicament pour soulager les douleurs', 5.99, 'Douleurs', 'Douleur de tête', '1 à 2 comprimés par jour', 'Ne pas dépasser la dose recommandée', 'https://exemple.com/aspirine', 1);
CALL AjouterProduit('Paracétamol', 'paracetamol.jpg', 'Antidouleur et antipyrétique', 3.49, 'Fièvre, Douleurs', 'Fièvre, Maux de tête', '1 à 2 comprimés toutes les 4 heures', 'Ne pas dépasser 8 comprimés par jour', 'https://exemple.com/paracetamol', 2);
CALL AjouterProduit('Ibuprofène', 'ibuprofene.jpg', 'Anti-inflammatoire pour douleurs musculaires', 8.99, 'Douleurs musculaires', 'Douleurs inflammatoires', '1 comprimé toutes les 6 heures', 'Ne pas prendre avec certains médicaments', 'https://exemple.com/ibuprofene', 1);
CALL AjouterProduit('Vitamine C', 'vitamineC.jpg', 'Complément alimentaire pour renforcer le système immunitaire', 12.99, 'Système immunitaire', 'Prévention de la grippe', '1 comprimé par jour', 'Aucun effet secondaire connu', 'https://exemple.com/vitamineC', 3);
CALL AjouterProduit('Antibiotique Amoxicilline', 'amoxicilline.jpg', 'Antibiotique pour traiter les infections bactériennes', 15.99, 'Infections bactériennes', 'Infections respiratoires', '1 capsule toutes les 8 heures', 'Ne pas prendre si allergique à la pénicilline', 'https://exemple.com/amoxicilline', 2);


--Les requêtes d'insertion
-- Insertion dans la table des clients
INSERT INTO client (nom, prenom, email, mot_de_passe, adresse, telephone)
VALUES
    ('Dupont', 'Jean', 'jean.dupont@example.com', 'password123', '123 Rue de Paris', '0123456789'),
    ('Martin', 'Claire', 'claire.martin@example.com', 'password456', '456 Rue des Champs', '0123456780'),
    ('Tremblay', 'Michel', 'michel.tremblay@example.com', 'password789', '789 Rue du Moulin', '0123456781'),
    ('Bernard', 'Luc', 'luc.bernard@example.com', 'password321', '321 Rue du Lac', '0123456782'),
    ('Lemoine', 'Sophie', 'sophie.lemoine@example.com', 'password654', '654 Rue des Fleurs', '0123456783');

-- Insertion dans la table des employés
INSERT INTO employe (nom, prenom, email, roles)
VALUES
    ('Robert', 'Paul', 'paul.robert@example.com', 'Vente'),
    ('Durand', 'Julie', 'julie.durand@example.com', 'Vente'),
    ('Leclerc', 'Eric', 'eric.leclerc@example.com', 'Gestion des stocks'),
    ('Garcia', 'Isabelle', 'isabelle.garcia@example.com', 'Administration'),
    ('Pires', 'Nathalie', 'nathalie.pires@example.com', 'Direction');

-- Insertion dans la table des livreurs
INSERT INTO livreur (nom, prenom, email, vehicule)
VALUES
    ('Benoit', 'Luc', 'luc.benoit@example.com', 'Vélo'),
    ('Meyer', 'Thierry', 'thierry.meyer@example.com', 'Voiture'),
    ('Cohen', 'David', 'david.cohen@example.com', 'Moto'),
    ('Petit', 'Jean-Pierre', 'jean-pierre.petit@example.com', 'Camion'),
    ('Joubert', 'Claire', 'claire.joubert@example.com', 'Vélo');

-- Insertion dans la table des fournisseurs
INSERT INTO fournisseur (nom, adresse, telephone, email)
VALUES
    ('PharmaCorp', '1 Rue des Médicaments', '0123456789', 'contact@pharmacorp.com'),
    ('MediSupply', '2 Rue des Fournisseurs', '0123456790', 'support@medisupply.com'),
    ('HealthPlus', '3 Rue du Bien-être', '0123456791', 'sales@healthplus.com'),
    ('MedWorld', '4 Avenue des Soins', '0123456792', 'info@medworld.com'),
    ('CarePharma', '5 Boulevard des Pharmacies', '0123456793', 'contact@carepharma.com');

-- Insertion dans la table des catégories de produits
INSERT INTO categorie (nom)
VALUES
    ('Médicaments'),
    ('Compléments alimentaires'),
    ('Soins et hygiène'),
    ('Accessoires médicaux'),
    ('Produits vétérinaires');

-- Insertion dans la table des produits
INSERT INTO produit (nom, image, description, prix, maladies, stock, utilisations, posologie, precautions, liens_de_reference, id_categorie)
VALUES
    ('Aspirine', 'aspirine.jpg', 'Médicament pour soulager les douleurs', 5.99, 'Douleurs', 100, 'Douleur de tête', '1 à 2 comprimés par jour', 'Ne pas dépasser la dose recommandée', 'https://exemple.com/aspirine', 1),
    ('Paracétamol', 'paracetamol.jpg', 'Antidouleur et antipyrétique', 3.49, 'Fièvre, Douleurs', 50, 'Fièvre, Maux de tête', '1 à 2 comprimés toutes les 4 heures', 'Ne pas dépasser 8 comprimés par jour', 'https://exemple.com/paracetamol', 1),
    ('Ibuprofène', 'ibuprofene.jpg', 'Anti-inflammatoire pour douleurs musculaires', 8.99, 'Douleurs musculaires', 75, 'Douleurs inflammatoires', '1 comprimé toutes les 6 heures', 'Ne pas prendre avec certains médicaments', 'https://exemple.com/ibuprofene', 1),
    ('Vitamine C', 'vitamineC.jpg', 'Complément alimentaire pour renforcer le système immunitaire', 12.99, 'Système immunitaire', 200, 'Prévention de la grippe', '1 comprimé par jour', 'Aucun effet secondaire connu', 'https://exemple.com/vitamineC', 2),
    ('Antibiotique Amoxicilline', 'amoxicilline.jpg', 'Antibiotique pour traiter les infections bactériennes', 15.99, 'Infections bactériennes', 30, 'Infections respiratoires', '1 capsule toutes les 8 heures', 'Ne pas prendre si allergique à la pénicilline', 'https://exemple.com/amoxicilline', 1);

-- Insertion dans la table des produits fournis par les fournisseurs
INSERT INTO fournit (id_produit, id_fournisseur)
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);

-- Insertion dans la table des commandes
INSERT INTO commande (date_commande, statut, total, id_client, id_employe, id_livreur)
VALUES
    ('2025-01-09', 'En cours', 35.95, 1, 1, 1),
    ('2025-01-10', 'Livrée', 23.98, 2, 2, 2),
    ('2025-01-11', 'Annulée', 0.00, 3, 3, 3),
    ('2025-01-12', 'En attente', 50.99, 4, 4, 4),
    ('2025-01-13', 'Livrée', 12.99, 5, 5, 5);

-- Insertion dans la table des produits dans les commandes
INSERT INTO contient (id_commande, id_produit, quantite)
VALUES
    (1, 1, 2),
    (1, 2, 1),
    (2, 3, 2),
    (2, 4, 1),
    (3, 5, 1);

-- Sélectionner tous les clients
SELECT * FROM client;

-- Sélectionner les employés avec leurs rôles
SELECT id_employe, nom, prenom, email, roles FROM employe;

-- Sélectionner les livreurs avec leurs informations de véhicule
SELECT id_livreur, nom, prenom, email, vehicule FROM livreur;

-- Sélectionner tous les produits disponibles en stock
SELECT nom, prix, stock FROM produit WHERE stock > 0;

-- Sélectionner les fournisseurs et leurs produits associés
SELECT f.nom AS fournisseur, p.nom AS produit
FROM fournisseur f
JOIN fournit ft ON f.id_fournisseur = ft.id_fournisseur
JOIN produit p ON ft.id_produit = p.id_produit;

-- Sélectionner les commandes avec leurs produits et quantités
SELECT c.id_commande, c.date_commande, c.statut, p.nom AS produit, co.quantite
FROM commande c
JOIN contient co ON c.id_commande = co.id_commande
JOIN produit p ON co.id_produit = p.id_produit;

-- Sélectionner le total des commandes des clients
SELECT c.id_commande, c.total, cl.nom AS client_nom, cl.prenom AS client_prenom
FROM commande c
JOIN client cl ON c.id_client = cl.id_client;

--Ajouter la colonne 'role' dans la table des employés** :

ALTER TABLE employe ADD COLUMN role VARCHAR(50) DEFAULT 'Utilisateur';

--Créer une fonction pour supprimer un client
CREATE OR REPLACE FUNCTION SupprimerClient(
    p_id_client INT,
    p_user_email VARCHAR(100)  -- email de l'utilisateur appelant
)
RETURNS VOID AS $$
DECLARE
    v_role VARCHAR(50);
BEGIN
    -- Récupérer le rôle de l'utilisateur appelant
    SELECT role INTO v_role
    FROM employe
    WHERE email = p_user_email;

    -- Vérifier si l'utilisateur a le rôle d'administrateur
    IF v_role = 'Administrateur' THEN
        -- Si l'utilisateur est un administrateur, on supprime le client
        DELETE FROM client WHERE id_client = p_id_client;
    ELSE
        -- Si l'utilisateur n'est pas administrateur, afficher un message d'erreur
        RAISE EXCEPTION 'Erreur : seul un administrateur peut supprimer des clients.';
    END IF;
END;
$$ LANGUAGE plpgsql;

--Créer une fonction pour supprimer un produit
CREATE OR REPLACE FUNCTION SupprimerProduit(
    p_id_produit INT,
    p_user_email VARCHAR(100)  -- email de l'utilisateur appelant
)
RETURNS VOID AS $$
DECLARE
    v_role VARCHAR(50);
BEGIN
    -- Récupérer le rôle de l'utilisateur appelant
    SELECT role INTO v_role
    FROM employe
    WHERE email = p_user_email;

    -- Vérifier si l'utilisateur a le rôle d'administrateur
    IF v_role = 'Administrateur' THEN
        -- Si l'utilisateur est un administrateur, on supprime le produit
        DELETE FROM produit WHERE id_produit = p_id_produit;
    ELSE
        -- Si l'utilisateur n'est pas administrateur, afficher un message d'erreur
        RAISE EXCEPTION 'Erreur : seul un administrateur peut supprimer des produits.';
    END IF;
END;
$$ LANGUAGE plpgsql;


--Créer une fonction pour supprimer une commande
CREATE OR REPLACE FUNCTION SupprimerCommande(
    p_id_commande INT,
    p_user_email VARCHAR(100)  -- email de l'utilisateur appelant
)
RETURNS VOID AS $$
DECLARE
    v_role VARCHAR(50);
BEGIN
    -- Récupérer le rôle de l'utilisateur appelant
    SELECT role INTO v_role
    FROM employe
    WHERE email = p_user_email;

    -- Vérifier si l'utilisateur a le rôle d'administrateur
    IF v_role = 'Administrateur' THEN
        -- Si l'utilisateur est un administrateur, on supprime la commande
        DELETE FROM commande WHERE id_commande = p_id_commande;
    ELSE
        -- Si l'utilisateur n'est pas administrateur, afficher un message d'erreur
        RAISE EXCEPTION 'Erreur : seul un administrateur peut supprimer des commandes.';
    END IF;
END;
$$ LANGUAGE plpgsql;

--Appeler les fonctions
SELECT SupprimerClient(1, 'admin@example.com');  -- Supprimer le client avec l'ID 1 si l'email de l'utilisateur est admin@example.com
SELECT SupprimerProduit(5, 'admin@example.com');  -- Supprimer le produit avec l'ID 5 si l'email de l'utilisateur est admin@example.com
SELECT SupprimerCommande(10, 'admin@example.com');  -- Supprimer la commande avec l'ID 10 si l'email de l'utilisateur est admin@example.com


