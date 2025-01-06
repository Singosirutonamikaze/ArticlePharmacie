--Création de la Base de donnée--
CREATE DATABASE Pharmacie_Gestion

--Ou créer la base de données enn vérifiant qu'une autre base de données du même nom existe-
CREATE DATABASE IF NOT EXISTS Pharmacie_Gestion

-- Table des clients
CREATE TABLE client (
    id_client INT PRIMARY KEY,
    nom VARCHAR(50),
    prenom VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    mot_de_passe VARCHAR(255),
    adresse VARCHAR(255),
    telephone VARCHAR(15)
);

-- Table des commandes
CREATE TABLE commande (
    id_commande INT PRIMARY KEY,
    date_commande DATE,
    statut VARCHAR(50),
    total DECIMAL(10,2),
    id_client INT,
    FOREIGN KEY (id_client) REFERENCES client(id_client)
);

-- Table des catégories
CREATE TABLE categorie (
    id_categorie INT PRIMARY KEY,
    nom VARCHAR(50)
);

-- Table des produits
CREATE TABLE Produits (
    id_produit INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    image VARCHAR(255),
    description TEXT,
    prix DECIMAL(10, 2),
    maladies TEXT,
    utilisations TEXT,
    posologie TEXT,
    precautions TEXT,
    liens_de_reference VARCHAR(255)
);

-- Table des employés
CREATE TABLE employe (
    id_employe INT PRIMARY KEY,
    nom VARCHAR(50),
    prenom VARCHAR(50),
    email VARCHAR(100),
    role VARCHAR(50)
);

-- Table des livreurs
CREATE TABLE livreur (
    id_livreur INT PRIMARY KEY,
    nom VARCHAR(50),
    prenom VARCHAR(50),
    email VARCHAR(100),
    vehicule VARCHAR(50)
);

-- Table des fournisseurs
CREATE TABLE fournisseur (
    id_fournisseur INT PRIMARY KEY,
    nom VARCHAR(100),
    adresse VARCHAR(255),
    telephone VARCHAR(15),
    email VARCHAR(100)
);

-- Table des produits fournis par les fournisseurs
CREATE TABLE fournit (
    id_produit INT,
    id_fournisseur INT,
    PRIMARY KEY (id_produit, id_fournisseur),
    FOREIGN KEY (id_produit) REFERENCES produits(id_produit),
    FOREIGN KEY (id_fournisseur) REFERENCES fournisseur(id_fournisseur)
);

-- Table des produits dans les commandes
CREATE TABLE contient ( 
    id_commande INT, 
    id_produit INT,
    quantite INT, 
    PRIMARY KEY (id_commande, id_produit), 
    FOREIGN KEY (id_commande) REFERENCES commande(id_commande),
    FOREIGN KEY (id_produit) REFERENCES produit(id_produit)
);
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

('Paracetamol (500 mg)', '../Admin/assets/images/Paracetamol (500 mg).jpg.webp', 'Médicament anti-inflammatoire non stéroïdien, utilisé pour soulager la douleur et la fièvre.', 2500, 
'Douleurs légères à modérées, Fièvre', 
'Traitement des douleurs légères à modérées : Soulagement des maux de tête, douleurs dentaires et douleurs musculaires; Réduction de la fièvre', 
'Adultes : 500 mg toutes les 4 à 6 heures, ne pas dépasser 3 grammes par jour; Enfants : Posologie adaptée en fonction du poids et de l\'âge, selon la prescription médicale', 
'Ne pas dépasser la dose recommandée; Consulter un médecin en cas d\'effets indésirables; Ne pas utiliser en cas d\'allergie connue au paracétamol',
'https://www.exemple.com/paracetamol'),

('Ibuprofène (400 mg)', '../Admin/assets/images/Ibuprofène (400 mg).jpg.webp', 'AINS utilisé pour réduire la douleur, l\'inflammation et la fièvre.', 2500, 
'Douleurs musculaires, Douleurs articulaires, Migraines, Douleurs menstruelles', 
'Traitement des douleurs musculaires et articulaires; Soulagement des migraines', 
'Adultes et enfants de plus de 12 ans : 200 à 400 mg toutes les 4 à 6 heures, ne pas dépasser 1200 mg par jour; Enfants de 6 à 12 ans : 200 mg toutes les 6 à 8 heures, ne pas dépasser 800 mg par jour', 
'Ne pas dépasser la dose recommandée pour éviter les surdosages; Prendre avec de la nourriture pour éviter les troubles digestifs; Consulter un médecin en cas d\'effets indésirables',
'https://www.exemple.com/ibuprofène'),

('Cetrizine (10 mg)', '../Admin/assets/images/Cetrizine (10 mg).webp', 'Antihistaminique utilisé pour soulager les symptômes d\'allergies.', 2500, 
'Rhinites allergiques, Urticaires, Allergies cutanées', 
'Soulagement des symptômes de rhinites allergiques, telles que le nez qui coule et les éternuements; Réduction des démangeaisons et de l\'urticaire', 
'Adultes et enfants de plus de 12 ans : 10 mg une fois par jour; Enfants de 6 à 12 ans : 5 mg deux fois par jour ou 10 mg une fois par jour, selon la prescription médicale', 
'Ne pas dépasser la dose recommandée; Consulter un médecin en cas de réaction allergique sévère; Éviter de prendre en cas d\'allergie connue au médicament',
'https://www.exemple.com/cetrizine'),

('Omeprazole (20 mg)', '../Admin/assets/images/Omeprazole (20 mg).jpg.webp', 'Inhibiteur de la pompe à protons, utilisé pour réduire la production d\'acide gastrique.', 2500, 
'Ulcères gastroduodénaux, Reflux gastro-œsophagien', 
'Traitement des ulcères gastroduodénaux en réduisant la production d\'acide gastrique; Réduction des symptômes du reflux gastro-œsophagien tels que les brûlures d\'estomac', 
'Adultes : 20 mg une fois par jour avant un repas, selon la prescription médicale; Enfants : Posologie adaptée en fonction de l\'âge, selon la prescription médicale', 
'Ne pas dépasser la dose recommandée; Prendre avant les repas pour une meilleure efficacité; Consulter un médecin en cas de persistance des symptômes',
'https://www.exemple.com/omeprazole'),

('Metformine (500 mg)', '../assets/images/metformine2.jpg', 'Médicament antidiabétique utilisé pour traiter le diabète de type 2.', 2500, 'Diabète de type 2, Résistance à l'insuline', 'Traitement du diabète de type 2, Amélioration de la sensibilité à l'insuline', 'Adultes : 500 mg deux à trois fois par jour, au début des repas, selon la prescription médicale, Enfants : Posologie adaptée en fonction de l'âge, selon la prescription médicale', 'Ne pas dépasser la dose recommandée, Consulter un médecin en cas de troubles gastro-intestinaux, Ne pas utiliser en cas d'allergie connue au médicament', 'https://www.exemple.com/metformine'),

('Lorazépam (1 mg)', '../Admin/assets/images/Lorazepam.jpeg', 'Benzodiazépine utilisée pour l'anxiété et les troubles du sommeil.', 2500, 'Anxiété, Insomnie', 'Traitement de l'anxiété, Amélioration du sommeil', 'Adultes : 1 à 3 mg par jour en doses divisées, selon la prescription médicale, Enfants : Posologie adaptée en fonction de l'âge, selon la prescription médicale', 'Ne pas dépasser la dose recommandée, Ne pas utiliser en cas d'allergie connue aux benzodiazépines, Consulter un médecin en cas de troubles respiratoires', 'https://www.exemple.com/lorazepam'),

('Clopidogrel (75 mg)', '../Admin/assets/images/clopidrogel.jpg', 'Médicament antiplaquettaire utilisé pour prévenir les caillots sanguins.', 2500, 'Prévention des accidents vasculaires cérébraux, Infarctus du myocarde', 'Prévention des accidents vasculaires cérébraux, Prévention des infarctus du myocarde', 'Adultes : 75 mg une fois par jour, selon la prescription médicale, Enfants : Posologie adaptée en fonction de l'âge, selon la prescription médicale', 'Ne pas dépasser la dose recommandée, Consulter un médecin en cas de troubles hémorragiques, Ne pas utiliser en cas d'allergie connue au médicament', 'https://www.exemple.com/clopidogrel'),

('Lansoprazole (30 mg)', '../Admin/assets/images/lansoprazole.jpeg', 'Inhibiteur de la pompe à protons pour réduire la production d'acide gastrique.', 2500, 'Ulcères, Reflux gastro-œsophagien', 'Traitement des ulcères gastroduodénaux, Réduction des symptômes de reflux gastro-œsophagien', 'Adultes : 30 mg une fois par jour avant un repas, selon la prescription médicale, Enfants : Posologie adaptée en fonction de l'âge, selon la prescription médicale', 'Ne pas dépasser la dose recommandée, Prendre avant les repas pour une meilleure efficacité, Consulter un médecin en cas de persistance des symptômes', 'https://www.exemple.com/lansoprazole'),

('Furosemide (40 mg)', '../Admin/assets/images/furosemide.jpeg', 'Diurétique utilisé pour réduire la rétention d'eau.', 2500, 'Hypertension, Œdème', 'Traitement de l\'hypertension, Réduction de l\'œdème', 'Adultes : 20 à 40 mg par jour, selon la prescription médicale, Enfants : Posologie adaptée en fonction du poids et de l\'âge, selon la prescription médicale', 'Ne pas dépasser la dose recommandée, Consulter un médecin en cas de déshydratation, Surveiller les niveaux de potassium', 'https://www.exemple.com/furosemide'),

('Amlodipine (5 mg)', '../Admin/assets/images/Amlodipine.webp', 'Antihypertenseur utilisé pour traiter l\'hypertension et l\'angine de poitrine.', 2500, 'Hypertension, Angine', 'Traitement de l\'hypertension, Soulagement de l\'angine', 'Adultes : 5 à 10 mg une fois par jour, selon la prescription médicale, Enfants : Posologie adaptée en fonction de l\'âge, selon la prescription médicale', 'Ne pas dépasser la dose recommandée, Consulter un médecin en cas de douleurs thoraciques, Informer le médecin de toute autre condition médicale', 'https://www.exemple.com/amlodipine'),

('Prednisone (20 mg)', '../Admin/assets/images/prednisone.jpg', 'Corticostéroïde utilisé pour traiter l\'inflammation.', 2500, 'Maladies inflammatoires, Allergies graves', 'Traitement des maladies inflammatoires, Soulagement des allergies graves', 'Adultes : 5 à 60 mg par jour, selon la prescription médicale, Enfants : Posologie adaptée en fonction de l\'âge, selon la prescription médicale', 'Ne pas arrêter brusquement le traitement, Consulter un médecin en cas d\'infections, Surveiller la pression artérielle', 'https://www.exemple.com/prednisone'),

('Dexaméthasone (4 mg)', '../Admin/assets/images/Dexaméthasone.webp', 'Corticostéroïde utilisé pour son effet anti-inflammatoire.', 2500, 'Allergies, Inflammations, Certaines maladies auto-immunes', 'Traitement des allergies, Réduction des inflammations', 'Adultes : 0,5 à 10 mg par jour, selon la prescription médicale, Enfants : Posologie adaptée en fonction de l\'âge, selon la prescription médicale', 'Ne pas arrêter brusquement le traitement, Consulter un médecin en cas d\'infections, Surveiller la glycémie', 'https://www.exemple.com/dexamethasone'),

('Erythromycine (500 mg)', '../Admin/assets/images/Erythromycine.jpg', 'Antibiotique macrolide efficace contre divers types d\'infections bactériennes.', 2500, 'Infections respiratoires, Infections cutanées', 'Traitement des infections respiratoires, Traitement des infections cutanées', 'Adultes : 250 à 500 mg toutes les 6 heures, selon la prescription médicale, Enfants : Posologie adaptée en fonction du poids et de l\'âge, selon la prescription médicale', 'Suivre le traitement complet, Ne pas utiliser en cas d\'allergie connue aux macrolides, Consulter un médecin en cas de troubles hépatiques', 'https://www.exemple.com/erythromycine'),

('Tétracycline (250 mg)', '../Admin/assets/images/Tétracycline.jpg', 'Antibiotique utilisé contre diverses infections bactériennes.', 2500, 'Acné, Infections urinaires, Infections respiratoires', 'Traitement de l\'acné, Traitement des infections urinaires', 'Adultes : 250 à 500 mg toutes les 6 heures, selon la prescription médicale, Enfants : Posologie adaptée en fonction du poids et de l\'âge, selon la prescription médicale', 'Suivre le traitement complet, Ne pas utiliser en cas d\'allergie connue aux tétracyclines, Éviter l\'exposition prolongée au soleil', 'https://www.exemple.com/tetracycline');

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
(1, 'PharmaTogo', 'Cotonou', 'Lomé', '22222222', 'pharmatogo@email.tg'),
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

-- Ce trigger met à jour le total de la commande lorsqu'un produit est ajouté--
CREATE TRIGGER update_total AFTER INSERT ON contient
FOR EACH ROW
BEGIN
    -- Met à jour le total de la commande en fonction du prix du produit et de la quantité commandée
    UPDATE commande 
    SET total = total + (SELECT prix FROM produits WHERE id_produit = NEW.id_produit) * NEW.quantite
    WHERE id_commande = NEW.id_commande;
END;

-- Ce trigger vérifie si la quantité demandée d'un produit est disponible en stock avant d'ajouter une commande--
CREATE TRIGGER validate_stock BEFORE INSERT ON contient
FOR EACH ROW
BEGIN
    -- Vérifie si le stock disponible est inférieur à la quantité demandée
    IF (SELECT stock FROM produits WHERE id_produit = NEW.id_produit) < NEW.quantite THEN
        -- Si le stock est insuffisant, lance une erreur et empêche l'insertion
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient stock';
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
    -- Si le total de la commande est supérieur à 10 000, on classe la commande comme "High Value"
    IF NEW.total > 10000 THEN
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

