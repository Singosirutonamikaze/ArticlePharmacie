--Création de la Base de donnée--
CREATE DATABASE Pharmacie_Gestion;

-- Création de la base de données si elle n'existe pas
CREATE DATABASE IF NOT EXISTS Pharmacie_Gestion USE Pharmacie_Gestion;

-- Table des clients
CREATE TABLE client (
    id_client SERIAL  PRIMARY KEY,
    nom VARCHAR(50),
    prenom VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    mot_de_passe VARCHAR(255),
    adresse VARCHAR(255),
    telephone VARCHAR(15)
);

-- Table des commandes
CREATE TABLE commande (
    id_commande SERIAL  PRIMARY KEY,
    date_commande DATE,
    statut VARCHAR(50),
    total DECIMAL(10,2),
    id_client SERIAL,
	id_employe SERIAL,
	id_livreur SERIAL,
    FOREIGN KEY (id_client) REFERENCES client(id_client),
    FOREIGN KEY (id_employe) REFERENCES employe(id_employe),
    FOREIGN KEY (id_livreur) REFERENCES livreur(id_livreur)
);

-- Table des catégories
CREATE TABLE categorie (
    id_categorie SERIAL  PRIMARY KEY,
    nom VARCHAR(50)
);

-- Table des produits
CREATE TABLE produit (
    id_produit SERIAL  PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    image VARCHAR(255),
    description TEXT,
    prix DECIMAL(10, 2) NOT NULL,
    maladies TEXT,
    stock INT,
    utilisations TEXT,
    posologie TEXT,
    precautions TEXT,
    liens_de_reference VARCHAR(255),
    id_categorie SERIAL ,
    FOREIGN KEY (id_categorie) REFERENCES categorie(id_categorie)
);

-- Table des employés
CREATE TABLE employe (
    id_employe SERIAL PRIMARY KEY,
    nom VARCHAR(50),
    prenom VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    roles VARCHAR(50)
);

-- Table des livreurs
CREATE TABLE livreur (
    id_livreur SERIAL  PRIMARY KEY,
    nom VARCHAR(50),
    prenom VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    vehicule VARCHAR(50)
);

-- Table des fournisseurs
CREATE TABLE fournisseur (
    id_fournisseur SERIAL  PRIMARY KEY,
    nom VARCHAR(100),
    adresse VARCHAR(255),
    telephone VARCHAR(15),
    email VARCHAR(100)
);

-- Table des produits fournis par les fournisseurs
CREATE TABLE fournit (
    id_produit SERIAL ,
    id_fournisseur SERIAL ,
    PRIMARY KEY (id_produit, id_fournisseur),
    FOREIGN KEY (id_produit) REFERENCES produit(id_produit),
    FOREIGN KEY (id_fournisseur) REFERENCES fournisseur(id_fournisseur)
);

-- Table des produits dans les commandes
CREATE TABLE contient (
    id_commande SERIAL ,
    id_produit SERIAL ,
    quantite INT,
    PRIMARY KEY (id_commande, id_produit),
    FOREIGN KEY (id_commande) REFERENCES commande(id_commande),
    FOREIGN KEY (id_produit) REFERENCES produit(id_produit)
);

--Fonction et procéduires--

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


DELIMITER $$
CREATE PROCEDURE ModifierStatutCommande(
    IN p_id_commande INT,
    IN p_statut VARCHAR(50)
)
BEGIN
    UPDATE commande
    SET statut = p_statut
    WHERE id_commande = p_id_commande;
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION VerifierDisponibiliteProduit(p_id_produit INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE disponible BOOLEAN;
    SELECT COUNT(*) > 0 INTO disponible
    FROM produit
    WHERE id_produit = p_id_produit;
    RETURN disponible;
END$$
DELIMITER ;


SELECT CalculerTotalCommande(1) AS total_commande;


--Insertion--

-- Insertion des médicaments dans la table produits
INSERT INTO Produits (nom, image, description, prix, maladies, utilisations, posologie, precautions, liens_de_reference)
VALUES
('Apdyl H (1500)', '../Admin/assets/images/Apdyl H (1500).jpg', 'Médicament utilisé pour traiter les symptômes allergiques et inflammatoires.', 2500, 
'Allergies, Rhume des foins', 
'Traitement des allergies : Soulagement des symptômes allergiques; Traitement du rhume des foins : Réduction des symptômes tels que les yeux larmoyants et les éternuements', 
'Adultes : 1 comprimé toutes les 8 heures, selon la prescription médicale; Enfants : Posologie adaptée en fonction de l\'âge, selon la prescription médicale', 
'Ne pas dépasser la dose recommandée; Consulter un médecin en cas de réaction allergique sévère; Éviter de prendre en cas d\'allergie connue au médicament',
'https://www.exemple.com/apdyl_h'),


-- Insertion des employés--
INSERT INTO employe (id_employe, nom, prenom, email, role) VALUES
(1, 'Togbui', 'Kossi', 'kossi.togbui@email.tg', 'Responsable'),
(2, 'Ameh', 'Evelyne', 'evelyne.ameh@email.tg', 'Vendeuse'),
(3, 'Dossou', 'Jean', 'jean.dossou@email.tg', 'Gestionnaire');

-- Insertion des livreurs--
INSERT INTO livreur (id_livreur, nom, prenom, email, vehicule) VALUES
(1, 'Sow', 'Isaac', 'isaac.sow@email.tg', 'Moto'),
(2, 'Kouassi', 'Pierre', 'pierre.kouassi@email.tg', 'Vélo'),
(3, 'Afegan', 'Kofi', 'kofi.afegan@email.tg', 'Camion');

-- Insertion des fournisseurs--
INSERT INTO fournisseur (id_fournisseur, nom, adresse, telephone, email) VALUES
(1, 'PharmaTogo', 'Lomé', '22222222', 'pharmatogo@email.tg'),
(2, 'Fournitures Médicales', 'Agoè, Lomé', '23333333', 'fournituresmed@email.tg'),
(3, 'MedicoTogo', 'Kpalimé, Lomé', '24444444', 'medicotogo@email.tg');

-- Insertion des clients
INSERT INTO client (id_client, nom, prenom, email, mot_de_passe, adresse, telephone) VALUES
(1, 'Kouadio', 'Eric', 'eric.kouadio@email.tg', 'mdp1234', 'Lomé, Togo', '90909090'),
(2, 'Djedje', 'Aminata', 'aminata.djedje@email.tg', 'mdp5678', 'Tsévié, Togo', '91919191'),
(3, 'Yao', 'Clarisse', 'clarisse.yao@email.tg', 'mdp1122', 'Kpalimé, Togo', '92929292'),
(4, 'Mensah', 'Patrick', 'patrick.mensah@email.tg', 'mdp3344', 'Lomé, Togo', '93939393'),
(5, 'Kossi', 'Alice', 'alice.kossi@email.tg', 'mdp5566', 'Atakpamé, Togo', '94949494'),
(6, 'Afouda', 'Kofi', 'kofi.afouda@email.tg', 'mdp7788', 'Sokodé, Togo', '95959595'),
(7, 'Tchoumi', 'Lucie', 'lucie.tchoumi@email.tg', 'mdp9900', 'Tsévié, Togo', '96969696'),
(8, 'Awi', 'Didier', 'didier.awi@email.tg', 'mdp2233', 'Lomé, Togo', '97979797'),
(9, 'Adom', 'Solange', 'solange.adom@email.tg', 'mdp4455', 'Dapaong, Togo', '98989898'),
(10, 'Lohou', 'Jean-Pierre', 'jeanpierre.lohou@email.tg', 'mdp6677', 'Lomé, Togo', '99999999');

-- Ce trigger met à jour le total de la commande le produit est ajouté--
CREATE TRIGGER update_total AFTER INSERT ON contient
FOR EACH ROW
BEGIN
    -- Met à jour le total de la commande en fonction du prix du produit et de la quantité commandée
    UPDATE commande 
    SET total = total + (SELECT prix FROM produits WHERE id_produit = NEW.id_produit) * NEW.quantite
    WHERE id_commande = NEW.id_commande;
END;

-- Ce trigger vérifie si la quantité demandée si le  produit est disponible en stock avant ajouter une commande--
CREATE TRIGGER validate_stock BEFORE INSERT ON contient
FOR EACH ROW
BEGIN
    -- Vérifie si le stock disponible est inférieur à la quantité demandée
    IF (SELECT stock FROM produits WHERE id_produit = NEW.id_produit) < NEW.quantite THEN
        -- Si le stock est insuffisant, lance une erreur et empêche l'insertion
        SIGNAL SQLSTATE '5' SET MESSAGE_TEXT = 'Insufficient stock';
    END IF;
END;

-- Ce trigger enregistre dans un log les modifications des rôles des employés--
CREATE TRIGGER log_employe_changes AFTER UPDATE ON employe
FOR EACH ROW
BEGIN
    -- Insère un enregistrement dans la table de log avec l'ancien et le nouveau rôle de l'employé
    INSERT INTO employe_log (id_employe, old_role, new_role, change_date)
    VALUES (NEW.id_employe, OLD.role, NEW.role, NOW());
END;

-- Ce trigger met à jour le statut de la commande en fonction du total de la commande.
CREATE TRIGGER update_statut AFTER UPDATE ON commande
FOR EACH ROW
BEGIN
    -- Si le total de la commande est supérieur à 10, on classe la commande comme "High Value"
    IF NEW.total > 10 THEN
        UPDATE commande 
        SET statut = 'High Value'
        WHERE id_commande = NEW.id_commande;
    ELSE
        -- Sinon, la commande est classée comme "Standard"
        UPDATE commande 
        SET statut = 'Standard'
        WHERE id_commande = NEW.id_commande;
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
    co.quantite * p.prix AS total_produit
FROM
    contient co
JOIN
    produits p ON co.id_produit = p.id_produit;

-- Vue des employés et leurs rôles
CREATE VIEW vue_employes_roles AS
SELECT
    e.id_employe,
    e.nom,
    e.prenom,
    e.email,
    e.role
FROM
    employe e;

-- Vue des employés et leurs rôles
CREATE VIEW vue_employes_roles AS
SELECT
    e.id_employe,
    e.nom,
    e.prenom,
    e.email,
    e.role
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
    produits p
JOIN
    fournit fnt ON p.id_produit = fnt.id_produit
JOIN
    fournisseur f ON fnt.id_fournisseur = f.id_fournisseur;


-- Vue des commandes avec produits et quantités
CREATE VIEW vue_commandes_produits_quantites AS
SELECT
    c.id_commande,
    c.date_commande,
    cl.nom AS client_nom,
    p.nom AS produit_nom,
    co.quantite,
    p.prix,
    co.quantite * p.prix AS total_produit
FROM
    commande c
JOIN
    client cl ON c.id_client = cl.id_client
JOIN
    contient co ON c.id_commande = co.id_commande
JOIN
    produits p ON co.id_produit = p.id_produit;

--Les Rôles








