--Liste des commandes Sql--
CREATE For customer table

--Commande de creation de la table Client--

CREATE TABLE Client (
    ID_Client INT PRIMARY KEY,
    Nom VARCHAR(50),
    Prenom VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    Mot_de_passe VARCHAR(255),
    Adresse VARCHAR(255),
    Telephone VARCHAR(15)
);

--Commande de creation de la table Commande--

CREATE TABLE Commande (
    ID_Commande INT PRIMARY KEY,
    Date_Commande DATE,
    Statut VARCHAR(50),
    Total DECIMAL(10, 2),
    ID_Client INT,
    FOREIGN KEY (ID_Client) REFERENCES Client(ID_Client)
);

--Commande de creation de la table Produit--

CREATE TABLE Produit (
    ID_Produit INT PRIMARY KEY,
    Nom VARCHAR(100),
    Description TEXT,
    Prix DECIMAL(10, 2),
    Stock INT,
    ID_Catégorie INT,
    FOREIGN KEY (ID_Catégorie) REFERENCES Catégorie(ID_Catégorie)
);

--Commande de creation de la table categorie--

CREATE TABLE Categorie (
    ID_Categorie INT PRIMARY KEY,
    Nom VARCHAR(50)
);


--Commande de creation de la table Employe--

CREATE TABLE Employe (
    ID_Employé INT PRIMARY KEY,
    Nom VARCHAR(50),
    Prenom VARCHAR(50),
    Email VARCHAR(100),
    Role VARCHAR(50)
);

--Commande de creation de la table Livreur--

CREATE TABLE Livreur (
    ID_Livreur INT PRIMARY KEY,
    Nom VARCHAR(50),
    Prenom VARCHAR(50),
    Email VARCHAR(100),
    Véhicule VARCHAR(50)
);

--Commande de creation de la table Fournisseur--

CREATE TABLE Fournisseur (
    ID_Fournisseur INT PRIMARY KEY,
    Nom VARCHAR(100),
    Adresse VARCHAR(255),
    Téléphone VARCHAR(15),
    Email VARCHAR(100)
);

--Commande de creation de la table Fournit(Fournit est une relation)--

CREATE TABLE Fournit (
    ID_Produit INT,
    ID_Fournisseur INT,
    PRIMARY KEY (ID_Produit, ID_Fournisseur),
    FOREIGN KEY (ID_Produit) REFERENCES Produit(ID_Produit),
    FOREIGN KEY (ID_Fournisseur) REFERENCES Fournisseur(ID_Fournisseur)
);

--Commande de creation de la table Contient qui est une relation entre les tables commande et Produit--

CREATE TABLE Contient (
    ID_Commande INT,
    ID_Produit INT,
    Quantité INT,
    PRIMARY KEY (ID_Commande, ID_Produit),
    FOREIGN KEY (ID_Commande) REFERENCES Commande(ID_Commande),
    FOREIGN KEY (ID_Produit) REFERENCES Produit(ID_Produit)
);






