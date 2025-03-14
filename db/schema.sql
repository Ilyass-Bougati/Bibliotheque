
-- Table TCLIENTS
CREATE TABLE TCLIENTS (
  IdClient INT IDENTITY(1,1) PRIMARY KEY,
  Nom VARCHAR(50),
  Prenom VARCHAR(50),
  CIN VARCHAR(20),
  Email VARCHAR(100),
  PhoneNumber VARCHAR(20),
  Ville VARCHAR(50),
  interdit BIT DEFAULT 0
);


-- Table TABONNEMENTS_TYPE
CREATE TABLE TABONNEMENTS_TYPE (
  IdAbonnementType INT IDENTITY(1,1) PRIMARY KEY,
  AbonnementType VARCHAR(50),
  EmpruntMax INT,
  Duree INT, -- this variable is in months
  Prix INT
);


-- Table TABONNEMENTS
CREATE TABLE TABONNEMENTS (
  IdAbonnement INT IDENTITY(1,1) PRIMARY KEY,
  IdAbonnementType INT,
  IdClient INT,
  DateDebut DATE DEFAULT GETDATE(),
  Etat VARCHAR(50) DEFAULT 'activated',
  CONSTRAINT FK_ABONNEMENTS_CLIENT FOREIGN KEY (IdClient)
      REFERENCES TCLIENTS(IdClient) ON DELETE CASCADE,
  CONSTRAINT FK_ABONNEMENTS_ABONNEMENTS_TYPE FOREIGN KEY (IdAbonnementType)
      REFERENCES TABONNEMENTS_TYPE(IdAbonnementType) -- should this be cascade?
);


-- Table TNOTIFFICATION_TYPE
CREATE TABLE TNOTIFFICATION_TYPE (
  IdType INT IDENTITY(1,1) PRIMARY KEY,
  NomType VARCHAR(50)
);


-- Table TLANGUES
CREATE TABLE TLANGUES (
  IdLangue INT IDENTITY(1,1) PRIMARY KEY,
  NomLangue VARCHAR(50)
);


-- Table TAUTEURS
CREATE TABLE TAUTEURS (
  IdAuteur INT IDENTITY(1,1) PRIMARY KEY,
  NomAuteur VARCHAR(50),
  PrenomAuteur VARCHAR(50)
);


-- Table TCATEGORIES
CREATE TABLE TCATEGORIES (
  IdCategorie INT IDENTITY(1,1) PRIMARY KEY,
  NomCategorie VARCHAR(50)
);


-- Table TEDITEURS
CREATE TABLE TEDITEURS (
  IdEditeur INT IDENTITY(1,1) PRIMARY KEY,
  NomEditeur VARCHAR(50)
);


-- Table TLIVRES
CREATE TABLE TLIVRES (
  IdLivre INT IDENTITY(1,1) PRIMARY KEY,
  Titre VARCHAR(100),
  ISBN VARCHAR(20),
  IdLangue INT,
  CONSTRAINT FK_LIVRES_LANGUE FOREIGN KEY (IdLangue)
      REFERENCES TLANGUES(IdLangue) ON DELETE CASCADE,
);


-- Table TEXEMPLAIRES
CREATE TABLE TEXEMPLAIRES (
  IdExemplaire INT IDENTITY(1,1) PRIMARY KEY,
  IdLivre INT,
  disponible BIT,
  localisation VARCHAR(100),
  CONSTRAINT FK_EXEMPLAIRES_LIVRES FOREIGN KEY (IdLivre)
      REFERENCES TLIVRES(IdLivre) ON DELETE CASCADE
);


-- Table TNOTIFICATIONS
CREATE TABLE TNOTIFICATIONS (
  IdNotification INT IDENTITY(1,1) PRIMARY KEY,
  IdClient INT,
  IdNotificationType INT,
  NotificationText NVARCHAR(MAX),
  NotificationDate DATETIME,
  CONSTRAINT FK_NOTIFICATIONS_CLIENT FOREIGN KEY (IdClient)
      REFERENCES TCLIENTS(IdClient) ON DELETE CASCADE,
  CONSTRAINT FK_NOTIFICATIONS_TYPE FOREIGN KEY (IdNotificationType)
      REFERENCES TNOTIFFICATION_TYPE(IdType) ON DELETE CASCADE
);


-- Table TEMPRUNTS
CREATE TABLE TEMPRUNTS (
  IdEmprunt INT IDENTITY(1,1) PRIMARY KEY,
  IdClient INT,
  IdExemplaire INT,
  DateEmprunt DATETIME,
  DateRetour DATETIME,
  CONSTRAINT FK_EMPRUNTS_CLIENT FOREIGN KEY (IdClient)
      REFERENCES TCLIENTS(IdClient) ON DELETE CASCADE,
  CONSTRAINT FK_EMPRUNTS_EXEMPLAIRE FOREIGN KEY (IdExemplaire)
      REFERENCES TEXEMPLAIRES(IdExemplaire) ON DELETE CASCADE
);


-- Table TRESERVATIONS
CREATE TABLE TRESERVATIONS (
  IdReservation INT IDENTITY(1,1) PRIMARY KEY,
  IdClient INT,
  IdLivre INT,
  DateReservation DATETIME DEFAULT GETDATE(),
  CONSTRAINT FK_RESERVATIONS_CLIENT FOREIGN KEY (IdClient)
      REFERENCES TCLIENTS(IdClient) ON DELETE CASCADE,
  CONSTRAINT FK_RESERVATIONS_LIVRE FOREIGN KEY (IdLivre)
      REFERENCES TLIVRES(IdLivre) ON DELETE CASCADE
);


-- Table TREVIEWS
CREATE TABLE TREVIEWS (
  IdReview INT IDENTITY(1,1) PRIMARY KEY,
  IdClient INT,
  IdLivre INT,
  review NVARCHAR(MAX),
  CONSTRAINT FK_REVIEWS_CLIENT FOREIGN KEY (IdClient)
      REFERENCES TCLIENTS(IdClient) ON DELETE CASCADE,
  CONSTRAINT FK_REVIEWS_LIVRE FOREIGN KEY (IdLivre)
      REFERENCES TLIVRES(IdLivre) ON DELETE CASCADE
);


-- Table TAUTEURS_LIVRES
CREATE TABLE TAUTEURS_LIVRES (
  IdAuteur INT,
  IdLivre INT,
  CONSTRAINT PK_TAUTEURS_LIVRES PRIMARY KEY (IdAuteur, IdLivre),
  CONSTRAINT FK_AUTEURS_LIVRES_AUTEUR FOREIGN KEY (IdAuteur)
      REFERENCES TAUTEURS(IdAuteur) ON DELETE CASCADE,
  CONSTRAINT FK_AUTEURS_LIVRES_LIVRES FOREIGN KEY (IdLivre)
      REFERENCES TLIVRES(IdLivre)
);


-- Table TCATEGORIES_LIVRES
CREATE TABLE TCATEGORIES_LIVRES (
  IdCategorie INT,
  IdLivre INT,
  CONSTRAINT PK_TCATEGORIES_LIVRES PRIMARY KEY (IdCategorie, IdLivre),
  CONSTRAINT FK_CATEGORIES_LIVRES_CATEGORIES FOREIGN KEY (IdCategorie)
      REFERENCES TCATEGORIES(IdCategorie) ON DELETE CASCADE,
  CONSTRAINT FK_CATERIES_LIVRES_LIVRE FOREIGN KEY (IdLivre)
      REFERENCES TLIVRES(IdLivre)
);


-- Table TEDITEURS_LIVRES
CREATE TABLE TEDITEURS_LIVRES (
  IdEditeur INT,
  IdLivre INT,
  CONSTRAINT PK_TEDITEURS_LIVRES PRIMARY KEY (IdEditeur, IdLivre),
  CONSTRAINT FK_DITEURS_LIVRES_EDITEUR FOREIGN KEY (IdEditeur)
      REFERENCES TEDITEURS(IdEditeur) ON DELETE CASCADE,
  CONSTRAINT FK_DITEURS_LIVRES_LIVRE FOREIGN KEY (IdLivre)
      REFERENCES TLIVRES(IdLivre)
);

-- Table TPENALITES
CREATE TABLE TPENALITES (
  IdPenalite INT IDENTITY(1,1) PRIMARY KEY,
  IdAbonnement INT,
  IdEmprunt INT,
  Montant INT,
  Etat VARCHAR(50),
  Motif VARCHAR(50),
  DatePenalite DATE DEFAULT GETDATE(),
  CONSTRAINT FK_PENALITES_ABONNEMENT FOREIGN KEY (IdAbonnement)
      REFERENCES TABONNEMENTS(IdAbonnement) ON DELETE CASCADE, -- to be revised with abdellah later
  CONSTRAINT FK_PENALITES_EMPRUNT FOREIGN KEY (IdEmprunt)
      REFERENCES TEMPRUNTS(IdEmprunt) ON DELETE CASCADE -- needs to be looked into
);