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
DELIMITER $$
CREATE FUNCTION CalculerTotalCommande(p_id_commande INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10, 2);
    SELECT SUM(p.prix * c.quantite) 
    INTO total
    FROM contient c
    JOIN produit p ON c.id_produit = p.id_produit
    WHERE c.id_commande = p_id_commande;
    RETURN total;
END$$
DELIMITER ;

-- Procédure pour ajouter un produit
DELIMITER $$
CREATE PROCEDURE AjouterProduit(
    IN p_nom VARCHAR(255),
    IN p_image VARCHAR(255),
    IN p_description TEXT,
    IN p_prix DECIMAL(10, 2),
    IN p_maladies TEXT,
    IN p_utilisations TEXT,
    IN p_posologie TEXT,
    IN p_precautions TEXT,
    IN p_liens_de_reference VARCHAR(255),
    IN p_id_categorie INT
)
BEGIN
    INSERT INTO produit (nom, image, description, prix, maladies, utilisations, posologie, precautions, liens_de_reference, id_categorie)
    VALUES (p_nom, p_image, p_description, p_prix, p_maladies, p_utilisations, p_posologie, p_precautions, p_liens_de_reference, p_id_categorie);
END$$
DELIMITER ;

-- Procédure pour ajouter un client
DELIMITER $$
CREATE PROCEDURE AjouterClient(
    IN p_nom VARCHAR(50),
    IN p_prenom VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_mot_de_passe VARCHAR(255),
    IN p_adresse VARCHAR(255),
    IN p_telephone VARCHAR(15)
)
BEGIN
    INSERT INTO client (nom, prenom, email, mot_de_passe, adresse, telephone)
    VALUES (p_nom, p_prenom, p_email, p_mot_de_passe, p_adresse, p_telephone);
END$$
DELIMITER ;

-- Trigger pour mettre à jour le total de la commande après une insertion dans "contient"
CREATE TRIGGER update_total AFTER INSERT ON contient
FOR EACH ROW
BEGIN
    DECLARE v_total DECIMAL(10, 2);
    SELECT SUM(p.prix * c.quantite) INTO v_total
    FROM contient c
    JOIN produit p ON c.id_produit = p.id_produit
    WHERE c.id_commande = NEW.id_commande;
    UPDATE commande
    SET total = v_total
    WHERE id_commande = NEW.id_commande;
END;

-- Trigger pour vérifier la disponibilité du produit avant insertion dans "contient"
CREATE TRIGGER validate_stock BEFORE INSERT ON contient
FOR EACH ROW
BEGIN
    DECLARE v_stock INT;
    SELECT stock INTO v_stock
    FROM produit
    WHERE id_produit = NEW.id_produit;
    IF v_stock < NEW.quantite THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuffisant';
    END IF;
END;

-- Trigger pour mettre à jour le stock du produit après insertion dans "contient"
CREATE TRIGGER update_stock AFTER INSERT ON contient
FOR EACH ROW
BEGIN
    DECLARE v_stock INT;
    
    -- Récupérer le stock actuel du produit
    SELECT stock INTO v_stock
    FROM produit
    WHERE id_produit = NEW.id_produit;

    -- Vérifier qu'il y a suffisamment de stock pour cette quantité
    IF v_stock < NEW.quantite THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuffisant';
    ELSE
        -- Réduire le stock en fonction de la quantité commandée
        UPDATE produit
        SET stock = stock - NEW.quantite
        WHERE id_produit = NEW.id_produit;
    END IF;
END;

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

--Fonction de recuperation des rôles--
DELIMITER $$

CREATE FUNCTION GetRoleId(p_nom_role VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_id_role INT;
    SELECT id_role INTO v_id_role
    FROM role
    WHERE nom_role = p_nom_role;
    RETURN v_id_role;
END $$

DELIMITER ;

--Fonction pour ajouter le role
DELIMITER $$

CREATE PROCEDURE AjouterClientAvecRole(
    IN p_nom VARCHAR(50),
    IN p_prenom VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_mot_de_passe VARCHAR(255),
    IN p_adresse VARCHAR(255),
    IN p_telephone VARCHAR(15),
    IN p_nom_role VARCHAR(50)
)
BEGIN
    DECLARE v_id_role INT;

    -- Obtenir l'ID du rôle à partir du nom du rôle
    SET v_id_role = GetRoleId(p_nom_role);

    -- Ajouter un client avec son rôle
    INSERT INTO client (nom, prenom, email, mot_de_passe, adresse, telephone, id_role)
    VALUES (p_nom, p_prenom, p_email, p_mot_de_passe, p_adresse, p_telephone, v_id_role);
END $$

DELIMITER ;

--Fonction pour ajouter le role au livreur

DELIMITER $$

CREATE PROCEDURE AjouterLivreurAvecRole(
    IN p_nom VARCHAR(50),
    IN p_prenom VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_vehicule VARCHAR(50),
    IN p_nom_role VARCHAR(50)
)
BEGIN
    DECLARE v_id_role INT;

    -- Obtenir l'ID du rôle à partir du nom du rôle
    SET v_id_role = GetRoleId(p_nom_role);

    -- Ajouter un livreur avec son rôle
    INSERT INTO livreur (nom, prenom, email, vehicule, id_role)
    VALUES (p_nom, p_prenom, p_email, p_vehicule, v_id_role);
END $$

DELIMITER ;

--Fonction pour modifier le role de l'utilisateur
DELIMITER $$

CREATE PROCEDURE ModifierRoleUtilisateur(
    IN p_id_utilisateur INT,
    IN p_nom_role VARCHAR(50),
    IN p_type_utilisateur VARCHAR(50)
)
BEGIN
    DECLARE v_id_role INT;

    -- Obtenir l'ID du rôle à partir du nom du rôle
    SET v_id_role = GetRoleId(p_nom_role);

    -- Mise à jour du rôle de l'utilisateur en fonction du type
    IF p_type_utilisateur = 'client' THEN
        UPDATE client
        SET id_role = v_id_role
        WHERE id_client = p_id_utilisateur;
    ELSEIF p_type_utilisateur = 'employe' THEN
        UPDATE employe
        SET id_role = v_id_role
        WHERE id_employe = p_id_utilisateur;
    ELSEIF p_type_utilisateur = 'livreur' THEN
        UPDATE livreur
        SET id_role = v_id_role
        WHERE id_livreur = p_id_utilisateur;
    END IF;
END $$

DELIMITER ;

--Procédure pour afficher les clients et leur role

DELIMITER $$

CREATE PROCEDURE AfficherClientsAvecRole()
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
END $$

DELIMITER ;

--Procédure pour afficher les employé et leur role

DELIMITER $$

CREATE PROCEDURE AfficherEmployesAvecRole()
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
END $$

DELIMITER ;

--Procédure pour afficher les Livreurs et leur role
DELIMITER $$

CREATE PROCEDURE AfficherLivreursAvecRole()
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
END $$

DELIMITER ;

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

-- Ajouter la colonne 'role' dans la table des employés
ALTER TABLE employe ADD COLUMN role VARCHAR(50) DEFAULT 'Utilisateur';

DELIMITER $$

-- Procédure pour supprimer un client (accessible seulement à un administrateur)
CREATE PROCEDURE SupprimerClient(
    IN p_id_client INT,
    IN p_user_email VARCHAR(100)  -- email de l'utilisateur appelant
)
BEGIN
    DECLARE v_role VARCHAR(50);

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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erreur : seul un administrateur peut supprimer des clients.';
    END IF;
END $$

DELIMITER ;

DELIMITER $$

-- Procédure pour supprimer un produit (accessible seulement à un administrateur)
CREATE PROCEDURE SupprimerProduit(
    IN p_id_produit INT,
    IN p_user_email VARCHAR(100)  -- email de l'utilisateur appelant
)
BEGIN
    DECLARE v_role VARCHAR(50);

    -- Récupérer le rôle de l'utilisateur appelant
    SELECT role INTO v_role
    FROM employe
    WHERE email = p_user_email;

    -- Vérifier si l'utilisateur est un administrateur
    IF v_role = 'Administrateur' THEN
        -- Si l'utilisateur est un administrateur, on supprime le produit
        DELETE FROM produit WHERE id_produit = p_id_produit;
    ELSE
        -- Si l'utilisateur n'est pas administrateur, afficher un message d'erreur
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erreur : seul un administrateur peut supprimer des produits.';
    END IF;
END $$

DELIMITER ;

DELIMITER $$

-- Procédure pour supprimer une commande (accessible seulement à un administrateur)
CREATE PROCEDURE SupprimerCommande(
    IN p_id_commande INT,
    IN p_user_email VARCHAR(100)  -- email de l'utilisateur appelant
)
BEGIN
    DECLARE v_role VARCHAR(50);

    -- Récupérer le rôle de l'utilisateur appelant
    SELECT role INTO v_role
    FROM employe
    WHERE email = p_user_email;

    -- Vérifier si l'utilisateur est un administrateur
    IF v_role = 'Administrateur' THEN
        -- Si l'utilisateur est un administrateur, on supprime la commande
        DELETE FROM commande WHERE id_commande = p_id_commande;
    ELSE
        -- Si l'utilisateur n'est pas administrateur, afficher un message d'erreur
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erreur : seul un administrateur peut supprimer des commandes.';
    END IF;
END $$

DELIMITER ;

CALL SupprimerClient(1, 'admin@example.com');  -- Supprimer le client avec l'ID 1 si l'email de l'utilisateur est admin@example.com
CALL SupprimerProduit(5, 'admin@example.com');  -- Supprimer le produit avec l'ID 5 si l'email de l'utilisateur est admin@example.com
CALL SupprimerCommande(10, 'admin@example.com');  -- Supprimer la commande avec l'ID 10 si l'email de l'utilisateur est admin@example.com


