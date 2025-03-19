-- Table TCLIENTS
CREATE TABLE TCLIENTS (
  IdClient INT IDENTITY(1,1) PRIMARY KEY,
  Nom VARCHAR(50) NOT NULL,
  Prenom VARCHAR(50) NOT NULL,
  CIN VARCHAR(20) UNIQUE NOT NULL,
  Email VARCHAR(100),
  PhoneNumber VARCHAR(20),
  Ville VARCHAR(50)
) 
 
-- Table TNOTIFICATIONS
CREATE TABLE TNOTIFICATIONS (
  IdNotification INT IDENTITY(1,1) PRIMARY KEY,
  IdClient INT NOT NULL,
  NotificationType VARCHAR(20) NOT NULL,
  NotificationText NVARCHAR(MAX),
  NotificationDate DATETIME DEFAULT GETDATE(), 
  CONSTRAINT FK_NOTIFICATIONS_CLIENT FOREIGN KEY (IdClient)
      REFERENCES TCLIENTS(IdClient) ON DELETE CASCADE
) 

-- Table TABONNEMENTS_TYPE
CREATE TABLE TABONNEMENTS_TYPE (
  IdAbonnementType INT IDENTITY(1,1) PRIMARY KEY,
  AbonnementType VARCHAR(20) NOT NULL, -- here you might want to set a default value depending on the abonnement type
  NbEmpruntMax INT,
  Duree INT,
  Prix DECIMAL(10,2)
) 

-- Table TABONNEMENTS
CREATE TABLE TABONNEMENTS (
  IdAbonnement INT IDENTITY(1,1) PRIMARY KEY,
  IdClient INT NOT NULL,
  IdAbonnementType INT NOT NULL,
  DateDebut DATETIME DEFAULT GETDATE(),
  EtatAbonnement VARCHAR(20) NOT NULL DEFAULT 'actif' 
        CHECK (EtatAbonnement IN ('actif', 'expire', 'suspendu', 'annule', 'banni')),
  CONSTRAINT FK_ABONNEMENTS_CLIENT FOREIGN KEY (IdClient)
      REFERENCES TCLIENTS(IdClient) ON DELETE CASCADE, 
  CONSTRAINT FK_ABONNEMENTS_TYPE FOREIGN KEY (IdAbonnementType)
      REFERENCES TABONNEMENTS_TYPE(IdAbonnementType) -- here we can't just Cascading Deletes we need to be sure there is no active sub with this type 
) 

-- Table TLANGUES
CREATE TABLE TLANGUES (
  IdLangue INT IDENTITY(1,1) PRIMARY KEY,
  NomLangue VARCHAR(50) NOT NULL
) 

-- Table TLIVRES
CREATE TABLE TLIVRES (
  IdLivre INT IDENTITY(1,1) PRIMARY KEY,
  Titre VARCHAR(100) NOT NULL,
  ISBN VARCHAR(20) UNIQUE NOT NULL,
  IdLangue INT NOT NULL,
  CONSTRAINT FK_LIVRES_LANGUE FOREIGN KEY (IdLangue)
  REFERENCES TLANGUES(IdLangue) ON DELETE CASCADE -- Here Deleting a language will delete all books in that language
);


-- Table TEXEMPLAIRES
CREATE TABLE TEXEMPLAIRES (
  IdExemplaire INT IDENTITY(1,1) PRIMARY KEY,
  IdLivre INT NOT NULL,
  Disponibilite VARCHAR(30) DEFAULT 'disponible'
    CHECK (Disponibilite IN ('disponible', 'perdu', 'emprunte' , 'reserve')),
  Localisation VARCHAR(100),
  CONSTRAINT FK_EXEMPLAIRES_LIVRES FOREIGN KEY (IdLivre)
      REFERENCES TLIVRES(IdLivre) ON DELETE CASCADE
) 

-- Table TEMPRUNTS
CREATE TABLE TEMPRUNTS (
  IdEmprunt INT IDENTITY(1,1) PRIMARY KEY,
  IdAbonnement INT NOT NULL,
  IdExemplaire INT NOT NULL,
  DateEmprunt DATETIME DEFAULT GETDATE(),
  DateRetour DATETIME,
  CONSTRAINT FK_EMPRUNTS_ABONNEMENT FOREIGN KEY (IdAbonnement) -- you can't delete the client without deleting the loans related to hem
      REFERENCES TABONNEMENTS(IdAbonnement) ON DELETE NO ACTION,  -- to prevent deleting a client that still have a loan
  CONSTRAINT FK_EMPRUNTS_EXEMPLAIRE FOREIGN KEY (IdExemplaire) -- if we want to keep borrowing history we need to set
      REFERENCES TEXEMPLAIRES(IdExemplaire) ON DELETE CASCADE -- DELETE CASCADE OFF in both these CONSTRAINT
) 

-- Table TPENALITE
CREATE TABLE TPENALITE (
  IdPenalite INT IDENTITY(1,1) PRIMARY KEY,
  IdAbonnement INT NOT NULL,
  IdEmprunt INT,
  Motif VARCHAR(20),
  Montant DECIMAL(10,2),
  EtatPenalite VARCHAR(20) NOT NULL DEFAULT 'en cours' 
        CHECK (EtatPenalite IN ('en cours', 'payee', 'annulee')), 
  DatePenalite DATETIME DEFAULT GETDATE(),
  CONSTRAINT FK_PENALITE_ABONNEMENTS FOREIGN KEY (IdAbonnement) -- Also here if we want to keep a record
      REFERENCES TABONNEMENTS(IdAbonnement) ON DELETE CASCADE, -- we need to remove the DELETE CASCADE
  CONSTRAINT FK_PENALITE_TEMPRUNTS FOREIGN KEY (IdEmprunt)
      REFERENCES TEMPRUNTS(IdEmprunt)
) 

-- Table TRESERVATIONS
CREATE TABLE TRESERVATIONS (
  IdReservation INT IDENTITY(1,1) PRIMARY KEY,
  IdAbonnement INT NOT NULL,
  IdLivre INT NOT NULL,
  DateReservation DATETIME DEFAULT GETDATE(),
  CONSTRAINT FK_RESERVATIONS_ABONNEMENT FOREIGN KEY (IdAbonnement)
      REFERENCES TABONNEMENTS(IdAbonnement) ON DELETE CASCADE,
  CONSTRAINT FK_RESERVATIONS_LIVRE FOREIGN KEY (IdLivre)
      REFERENCES TLIVRES(IdLivre) ON DELETE CASCADE
) 

-- Table TREVIEWS
CREATE TABLE TREVIEWS (
  IdReview INT IDENTITY(1,1) PRIMARY KEY,
  IdClient INT NOT NULL ,
  IdLivre INT NOT NULL,
  Review INT CHECK (Review BETWEEN 1 AND 10),
  CONSTRAINT FK_REVIEWS_CLIENT FOREIGN KEY (IdClient)
      REFERENCES TCLIENTS(IdClient), -- it's ok to have a reviews even if the client is gone
  CONSTRAINT FK_REVIEWS_LIVRE FOREIGN KEY (IdLivre)
      REFERENCES TLIVRES(IdLivre) ON DELETE CASCADE
) 

-- Table TAUTEURS
CREATE TABLE TAUTEURS (
  IdAuteur INT IDENTITY(1,1) PRIMARY KEY,
  NomAuteur VARCHAR(50) NOT NULL,
  PrenomAuteur VARCHAR(50) NOT NULL
) 

-- Table TAUTEURS_LIVRES
CREATE TABLE TAUTEURS_LIVRES (
  IdAuteur INT,
  IdLivre INT,
  CONSTRAINT PK_TAUTEURS_LIVRES PRIMARY KEY (IdAuteur, IdLivre),
  CONSTRAINT FK_AUTEURS_LIVRES_AUTEUR FOREIGN KEY (IdAuteur)
      REFERENCES TAUTEURS(IdAuteur) ON DELETE CASCADE,
  CONSTRAINT FK_AUTEURS_LIVRES_LIVRES FOREIGN KEY (IdLivre)
      REFERENCES TLIVRES(IdLivre) ON DELETE CASCADE
) 

-- Table TCATEGORIES
CREATE TABLE TCATEGORIES (
  IdCategorie INT IDENTITY(1,1) PRIMARY KEY,
  NomCategorie VARCHAR(50) NOT NULL
) 

-- Table TCATEGORIES_LIVRES
CREATE TABLE TCATEGORIES_LIVRES (
  IdCategorie INT,
  IdLivre INT,
  CONSTRAINT PK_TCATEGORIES_LIVRES PRIMARY KEY (IdCategorie, IdLivre),
  CONSTRAINT FK_CATEGORIES_LIVRES_CATEGORIES FOREIGN KEY (IdCategorie)
      REFERENCES TCATEGORIES(IdCategorie) ON DELETE CASCADE,
  CONSTRAINT FK_CATERIES_LIVRES_LIVRE FOREIGN KEY (IdLivre)
      REFERENCES TLIVRES(IdLivre) ON DELETE CASCADE
) 

-- Table TEDITEURS
CREATE TABLE TEDITEURS (
  IdEditeur INT IDENTITY(1,1) PRIMARY KEY,
  NomEditeur VARCHAR(50) NOT NULL
) 

-- Table TEDITEURS_LIVRES
CREATE TABLE TEDITEURS_LIVRES (
  IdEditeur INT,
  IdLivre INT,
  CONSTRAINT PK_TEDITEURS_LIVRES PRIMARY KEY (IdEditeur, IdLivre),
  CONSTRAINT FK_DITEURS_LIVRES_EDITEUR FOREIGN KEY (IdEditeur)
      REFERENCES TEDITEURS(IdEditeur) ON DELETE CASCADE,
  CONSTRAINT FK_DITEURS_LIVRES_LIVRE FOREIGN KEY (IdLivre)
      REFERENCES TLIVRES(IdLivre) ON DELETE CASCADE
) 
GO

-- LES FONCTIONS
CREATE FUNCTION dbo.Trim (@input NVARCHAR(MAX))  
RETURNS NVARCHAR(MAX)  
AS  
BEGIN  
    RETURN LTRIM(RTRIM(@input))  
END  
GO  


CREATE FUNCTION dbo.Validate_empty (@input NVARCHAR(MAX))  
RETURNS INT 
AS  
BEGIN  
    DECLARE @Result as INT
    
    if dbo.Trim(@input) = '' OR @input IS NULL
    BEGIN
        SET @Result = 0
    END
    ELSE
    BEGIN
        SET @Result = 1
    END

    RETURN @Result
END  
GO  


CREATE FUNCTION dbo.Validate_phonenumber (@input NVARCHAR(MAX))
RETURNS INT
AS  
BEGIN  
    DECLARE @Result as INT
    
    if dbo.Validate_empty(@input) = 1 AND LEN(@input) = 10 AND @input LIKE '[0-9]%' AND @input NOT LIKE '%[^0-9]%'
    BEGIN
        SET @Result = 1
    END
    ELSE
    BEGIN
        SET @Result = 0
    END

    RETURN @Result
END  
GO  


CREATE FUNCTION dbo.Validate_email (@input NVARCHAR(MAX))
RETURNS INT
AS  
BEGIN  
    DECLARE @Result as INT
    
    if dbo.Validate_empty(@input) = 1 AND @input LIKE '_%@_%._%'
    BEGIN
        SET @Result = 1
    END
    ELSE
    BEGIN
        SET @Result = 0
    END

    RETURN @Result
END  
GO 

-- Validate_ISBN
CREATE FUNCTION dbo.Validate_ISBN (@ISBN VARCHAR(20)) 
RETURNS BIT
AS
BEGIN
    DECLARE @EstValide BIT = 0;
    DECLARE @CleanISBN VARCHAR(20);
    DECLARE @Longueur INT;
    
    SET @CleanISBN = REPLACE(REPLACE(@ISBN, '-', ''), ' ', '');
    SET @Longueur = LEN(@CleanISBN);
    
    IF @Longueur = 10 -- ISBN-10
    BEGIN
        
        IF @CleanISBN LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9X]'
        BEGIN
            DECLARE @somme INT = 0;
            DECLARE @i INT = 1;
            DECLARE @Nb CHAR(1);
            DECLARE @Weight INT;
            DECLARE @CheckNb INT;
            
            -- Calculer la somme pondérée pour l'ISBN-10
            WHILE @i <= 9
            BEGIN
                SET @Nb = SUBSTRING(@CleanISBN, @i, 1);
                SET @Weight = 11 - @i;
                SET @somme = @somme + (CAST(@Nb AS INT) * @Weight);
                SET @i = @i + 1;
            END;
            
            SET @CheckNb = (11 - (@somme % 11)) % 11;
            
            IF (@CheckNb = 10 AND SUBSTRING(@CleanISBN, 10, 1) = 'X')
               OR (@CheckNb = CAST(SUBSTRING(@CleanISBN, 10, 1) AS INT))
            BEGIN
                SET @EstValide = 1;
            END;
        END;
    END;
    ELSE IF @Longueur = 13 -- ISBN-13
    BEGIN

        IF @CleanISBN LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
        BEGIN
            DECLARE @somme13 INT = 0;
            DECLARE @j INT = 1;
            DECLARE @Nb13 CHAR(1);
            DECLARE @Weight13 INT;
            DECLARE @CheckNb13 INT;
            
            WHILE @j <= 12
            BEGIN
                SET @Nb13 = SUBSTRING(@CleanISBN, @j, 1);
                SET @Weight13 = IIF(@j % 2 = 1, 1, 3);
                SET @somme13 = @somme13 + (CAST(@Nb13 AS INT) * @Weight13);
                SET @j = @j + 1;
            END;
            
            SET @CheckNb13 = (10 - (@somme13 % 10)) % 10;
            
            IF @CheckNb13 = CAST(SUBSTRING(@CleanISBN, 13, 1) AS INT)
            BEGIN
                SET @EstValide = 1;
            END
        END
    END
    
    RETURN @EstValide;
END
GO

-- GESTION DES CLIENTS

CREATE PROCEDURE AjouterClient
	@Nom VARCHAR(50),
	@Prenom VARCHAR(50),
	@CIN VARCHAR(20),
	@Email VARCHAR(100),
	@PhoneNumber VARCHAR(20),
	@Ville VARCHAR(50),
	@AbonnementType VARCHAR(50)
AS
BEGIN
	-- trimming and lowercasing the variables
	SET @Nom = LOWER(dbo.Trim(@Nom))
	SET @Prenom = LOWER(dbo.Trim(@Prenom))
	SET @Email = LOWER(dbo.Trim(@Email))
	SET @CIN = LOWER(dbo.Trim(@CIN))
	SET @PhoneNumber = LOWER(dbo.Trim(@PhoneNumber))
	SET @Ville = LOWER(dbo.Trim(@Ville))


	-- checking of the inputs are correct
	-- checking if the nom or prenom or or ville CIN are empty
	IF dbo.Validate_empty(@Nom) = 0
	BEGIN
		PRINT 'Le nom est vide'
		RETURN
	END
	IF dbo.Validate_empty(@Prenom) = 0
	BEGIN
		PRINT 'Le Prenom est vide'
		RETURN
	END
	IF dbo.Validate_empty(@CIN) = 0
	BEGIN
		PRINT 'Le CIN est vide'
		RETURN
	END
	IF dbo.Validate_empty(@Ville) = 0
	BEGIN
		PRINT 'Le Ville est vide'
		RETURN
	END

	-- checking that the phone number is valide
	IF dbo.Validate_phonenumber(@PhoneNumber) = 0
	BEGIN
		PRINT 'Le numero de telephone est non valide'
		RETURN
	END

	-- checking if the email is invalide
	IF dbo.Validate_email(@email) = 0
	BEGIN
		PRINT 'Le email est non valide'
		RETURN
	END

	-- inserting the client
    INSERT INTO TCLIENTS(Nom, Prenom, CIN, Email, PhoneNumber, Ville)
	VALUES (
		@Nom, 
		@Prenom, 
		@CIN, 
		@Email, 
		@PhoneNumber, 
		@Ville
	)

	PRINT('Client ' + @Nom + ' a été créé avec succès')

	DECLARE @IdClient  INT
	SET @IdClient = SCOPE_IDENTITY()
	EXEC AjouterAbonnement @IdClient, @AbonnementType -- @AbonnementType doesn't need to be stripped

END
GO


CREATE PROCEDURE ModifierClient
	@IdClient INT,
	@Nom VARCHAR(50),
	@Prenom VARCHAR(50),
	@CIN VARCHAR(20),
	@Email VARCHAR(100),
	@PhoneNumber VARCHAR(20),
	@Ville VARCHAR(50)
AS
BEGIN
		-- trimming and lowercasing the variables
	SET @Nom = LOWER(dbo.Trim(@Nom))
	SET @Prenom = LOWER(dbo.Trim(@Prenom))
	SET @Email = LOWER(dbo.Trim(@Email))
	SET @CIN = LOWER(dbo.Trim(@CIN))
	SET @PhoneNumber = LOWER(dbo.Trim(@PhoneNumber))
	SET @Ville = LOWER(dbo.Trim(@Ville))


	-- checking of the inputs are correct
	-- checking if the nom or prenom or or ville CIN are empty
	IF dbo.Validate_empty(@Nom) = 0
	BEGIN
		PRINT 'Le nom est vide'
		RETURN
	END
	IF dbo.Validate_empty(@Prenom) = 0
	BEGIN
		PRINT 'Le Prenom est vide'
		RETURN
	END
	IF dbo.Validate_empty(@CIN) = 0
	BEGIN
		PRINT 'Le CIN est vide'
		RETURN
	END
	IF dbo.Validate_empty(@Ville) = 0
	BEGIN
		PRINT 'Le Ville est vide'
		RETURN
	END

	-- checking that the phone number is valide
	IF dbo.Validate_phonenumber(@PhoneNumber) = 0
	BEGIN
		PRINT 'Le numero de telephone est non valide'
		RETURN
	END

	-- checking if the email is invalide
	IF dbo.Validate_email(@email) = 0
	BEGIN
		PRINT 'Le email est non valide'
		RETURN
	END

    UPDATE
		TCLIENTS
	SET
		Nom = @Nom,
		Prenom = @Prenom,
		CIN = @CIN,
		Email = @Email,
		PhoneNumber = @PhoneNumber,
		Ville = @Ville
	WHERE
		idClient = @IdClient
END
GO


CREATE PROCEDURE SuprimerClient
	@IdClient INT
AS
BEGIN
    DELETE FROM 
		TCLIENTS
	WHERE
		idClient = @IdClient
END
GO


-- GESTION DES ABONNEMENTS

CREATE PROCEDURE AjouterTypeAbonnement
	@AbonnementType VARCHAR(50),
    @EmpruntMax INT,
    @Duree INT,
    @Prix INT
AS
BEGIN
    -- checking that the type isn't empty
    if dbo.Validate_empty(@AbonnementType) = 0
    BEGIN
        print('Le type abonnement est vide')
        RETURN
    END

    INSERT INTO TABONNEMENTS_TYPE (AbonnementType, NbEmpruntMax, Duree, Prix)
    VALUES (LOWER(dbo.Trim(@AbonnementType)), @EmpruntMax, @Duree, @Prix)
END
GO


CREATE PROCEDURE AjouterAbonnement
    @IdClient INT,
    @AbonnementType VARCHAR(50)
AS 
BEGIN

    -- Checking if the type is empy or null
    IF dbo.Validate_empty(@AbonnementType) = 0
    BEGIN
        PRINT('le type est vide')
        RETURN
    END

    -- getting the type of subscription
    SET @AbonnementType = dbo.Trim(LOWER(@AbonnementType))
    DECLARE @IdAbonnementType INT
    SET @IdAbonnementType = (
        SELECT
            IdAbonnementType
        FROM
            TABONNEMENTS_TYPE
        WHERE
            AbonnementType LIKE @AbonnementType
    )

    if @IdAbonnementType IS NULL
    BEGIN
        print('Ce type n existe pas')
        RETURN
    END

    -- inserting
    INSERT INTO TABONNEMENTS (IdAbonnementType, IdClient)
    VALUES (@IdAbonnementType, @IdClient)

    PRINT('Créer un nouvel abonnement')
END
GO


CREATE PROCEDURE ModifierAbonnement
    @IdAbonnement INT,
    @AbonnementType VARCHAR(50),
    @Etat VARCHAR(50)
AS
BEGIN

    -- Checking if the type is empy or null
    IF dbo.Validate_empty(@AbonnementType) = 0
    BEGIN
        PRINT('le type est vide')
        RETURN
    END

        -- Checking if the etat is empy or null
    IF dbo.Validate_empty(@Etat) = 0
    BEGIN
        PRINT('l etat est vide')
        RETURN
    END

    -- getting the type of subscription
    SET @AbonnementType = dbo.Trim(LOWER(@AbonnementType))
    DECLARE @IdAbonnementType INT
    SET @IdAbonnementType = (
        SELECT
            IdAbonnementType
        FROM
            TABONNEMENTS_TYPE
        WHERE
            AbonnementType LIKE @AbonnementType
    )

    if @IdAbonnementType IS NULL
    BEGIN
        print('Ce type n existe pas')
        RETURN
    END

    UPDATE
        TABONNEMENTS
    SET
        IdAbonnementType = @IdAbonnementType,
        EtatAbonnement = dbo.Trim(LOWER(@Etat))
    WHERE
        IdAbonnement = @IdAbonnement
        
END
GO

CREATE PROCEDURE VerifierDateAbonnement
@IdAbonnement AS INT
AS
BEGIN
    DECLARE @DateDebut AS DATETIME
    SELECT @DateDebut = DateDebut
    FROM
        TABONNEMENTS
    WHERE
        IdAbonnement = @IdAbonnement

    DECLARE @Duree AS INT
    SELECT @Duree = Duree
    FROM
        TABONNEMENTS_TYPE JOIN TABONNEMENTS 
        ON TABONNEMENTS_TYPE.IdAbonnementType = TABONNEMENTS.IdAbonnementType
    WHERE
        IdAbonnement = @IdAbonnement

    DECLARE @DateFin AS DATETIME
    DECLARE @DateCourante AS DATETIME

    SELECT @DateFin = DATEADD(DAY , @Duree , @DateDebut)
    SELECT @DateCourante = GETDATE()

    IF DATEDIFF(DAY , @DateFin , @DateCourante) > 0
    BEGIN
        UPDATE 
            TABONNEMENTS
        SET
            EtatAbonnement = 'expire'
        WHERE
            IdAbonnement = @IdAbonnement
        
        DECLARE @IdClient INT
        SELECT 
			@IdClient = IdClient 
		FROM
			TABONNEMENTS
		WHERE
			IdAbonnement = @IdAbonnement
            

        EXEC EnvoyerNotification @IdClient , 'Votre abonnement est arrive a echeance , veuillez le renouveler le plus tot possible.' , 'Fin Abonnement'
    END
    
END
GO

-- GESTION CLIENT
--PROC 2
CREATE PROCEDURE AjouterAvis
@IdClient AS INT,
@IdLivre AS INT,
@Review AS INT

AS
BEGIN
    DECLARE @ExistingReview AS INT
    SELECT @ExistingReview = @Review
    FROM
        TREVIEWS
    WHERE
        IdClient = @IdClient
    AND
        IdLivre = @IdLivre

    IF @ExistingReview IS NOT NULL
    BEGIN
        PRINT 'Il existe deja une notation du livre sur votre compte .'
        RETURN
    END 

    INSERT INTO TREVIEWS(IdClient , IdLivre , Review)
    VALUES (@IdClient , @IdLivre , @Review)
END
GO

--PROC 3 
CREATE PROCEDURE ModifierAvis
@IdClient AS INT,
@IdLivre AS INT,
@Review AS INT

AS
BEGIN
    UPDATE 
        TREVIEWS 
    SET
        Review = @Review
    WHERE 
        IdClient = @IdClient
    AND
        IdLivre = @IdLivre
END
GO

--PROC 4
CREATE PROCEDURE SupprimerAvis
@IdClient AS INT,
@IdLivre AS INT
AS
BEGIN
    DELETE 
    FROM 
        TREVIEWS
     WHERE 
        IdClient = @IdClient
    AND
        IdLivre = @IdLivre
END
GO

-- GESTION EMPRUNT
CREATE PROCEDURE EmprunterLivre
@IdAbonnement AS INT,
@IdExemplaire AS INT

AS
BEGIN
    DECLARE @DateEmprunt AS DATETIME
    SELECT @DateEmprunt = GETDATE()
    --verifier que le livre n'est pas deja emprunte
    DECLARE @Disponibilite AS VARCHAR(30)
    SELECT @Disponibilite = Disponibilite
    FROM
        TEXEMPLAIRES
    WHERE
        IdExemplaire = @IdExemplaire

    IF @Disponibilite != 'disponible'
    BEGIN
        PRINT 'L''exemplaire desire n''est pas disponible'
        RETURN
    END
    -- Verifier que le client n'est pas penalise
    DECLARE @EtatClient AS VARCHAR(20)
    SELECT @EtatClient = LOWER(EtatAbonnement) -- etat should be lowercase by default
    FROM(
        SELECT
            EtatAbonnement
        FROM
            TABONNEMENTS
        WHERE
            @IdAbonnement = IdAbonnement
        ) AS TEMP1

    IF @EtatClient != 'actif'
    BEGIN
        PRINT 'L''abonnement n''est pas eligible a un emprunt'
        RETURN
    END

    --Verify that the client didn't go over the maximum amount of loans
    DECLARE @NbEmpruntMax AS INT
    DECLARE @NbEmprunt AS INT

    SELECT @NbEmpruntMax = NbEmpMax
    FROM
        (
            SELECT
                NbEmpruntMax AS NbEmpMax
            FROM 
                TABONNEMENTS_TYPE JOIN TABONNEMENTS 
                ON 
                TABONNEMENTS_TYPE.IdAbonnementType  = TABONNEMENTS.IdAbonnementType
            WHERE
                IdAbonnement = @IdAbonnement
        )AS TEMP3

    SELECT @NbEmprunt = NbEmp
    FROM
        (
            SELECT
                COUNT(IdEmprunt) AS NbEmp
            FROM 
                TEMPRUNTS
            WHERE
                IdAbonnement = @IdAbonnement
        )AS TEMP4

    IF @NbEmpruntMax = @NbEmprunt
    BEGIN
        PRINT 'Le client a atteint le nombre maximal de livres empruntes'
        RETURN
    END

    DECLARE @DateRetour AS DATETIME
    SELECT @DateRetour = DATEADD(day , 15 , @DateEmprunt)

    INSERT INTO TEMPRUNTS(IdAbonnement , IdExemplaire , DateEmprunt , DateRetour)
    VALUES(@IdAbonnement , @IdExemplaire , @DateEmprunt , @DateRetour)

    UPDATE 
        TEXEMPLAIRES
    SET
        Disponibilite = 'emprunte'
    WHERE
        IdExemplaire = @IdExemplaire

END

GO


--Retourner livre
CREATE PROCEDURE RetournerLivre
@IdExemplaire AS INT

AS
BEGIN
    --Gets the exemplary's book id
    DECLARE @IdLivre AS INT
    SELECT @IdLivre = IdLivre
    FROM
        TEXEMPLAIRES
    WHERE
        IdExemplaire = @IdExemplaire

    --Checks if the book is reserved :
    DECLARE @IdAbonnement AS INT
    SELECT @IdAbonnement = TABONNEMENTS.IdAbonnement
    FROM
        TRESERVATIONS JOIN TABONNEMENTS
        ON TRESERVATIONS.IdAbonnement = TABONNEMENTS.IdAbonnement
    WHERE
        IdLivre = @IdLivre

    DELETE FROM TEMPRUNTS
    WHERE IdExemplaire = @IdExemplaire

    DECLARE @Disponibilite AS VARCHAR(20)
    SELECT @Disponibilite = 'disponible'
    
    IF @IdAbonnement IS NOT NULL
    BEGIN
        SELECT @Disponibilite = 'reserve'

        DECLARE @IdClient AS INT
        SELECT @IdClient = IdClient
        FROM
            TABONNEMENTS
        WHERE
            IdAbonnement = @IdAbonnement

        EXEC EnvoyerNotification @IdClient ,'Le livre que vous avez reserve est maintenant disponible .', 'Reservation'
    END


    UPDATE
        TEXEMPLAIRES
    SET
        Disponibilite = @Disponibilite
    WHERE
        IdExemplaire = @IdExemplaire
END
GO

-- GESTION EXEMPLAIRES
CREATE PROCEDURE ModifierExemplaire
	@IdExemplaire AS INT,
	@Localisation AS VARCHAR(100)
AS
BEGIN
    -- Checking if the localisation is empy or null
    IF dbo.Validate_empty(@Localisation) = 0
    BEGIN
        PRINT('le localisation est vide')
        RETURN
    END

	UPDATE
		TEXEMPLAIRES
	SET
		localisation = LOWER(dbo.Trim(@Localisation))
	WHERE
		IdExemplaire = @IdExemplaire
END
GO


CREATE PROCEDURE AjouterExemplaire 
	@Idlivre AS iNT,
	@Localisation AS VARCHAR(100)
AS
BEGIN
    -- Checking if the localisation is empy or null
    IF dbo.Validate_empty(@Localisation) = 0
    BEGIN
        PRINT('le localisation est vide')
        RETURN
    END


	INSERT INTO	
		TEXEMPLAIRES (IdLivre, localisation)
		VALUES (@Idlivre, LOWER(dbo.Trim(@Localisation)))
END
GO


CREATE PROCEDURE SupprimerExemplaire
	@IdExemplaire AS INT
AS
BEGIN
	DELETE
		TEXEMPLAIRES
	WHERE
		IdExemplaire = @IdExemplaire
END
GO

-- GESTOPM LIVRES
-- AjouterLivre
-- Cette procédure stockée permet d'ajouter un nouveau livre dans la base de données
-- Elle gère également les relations avec les auteurs, catégories, éditeurs et langues
CREATE PROCEDURE AjouterLivre
    @Titre VARCHAR(100),
    @ISBN VARCHAR(20),
    @NomLangue VARCHAR(50),
    @NomAuteur VARCHAR(50),
    @PrenomAuteur VARCHAR(50),
    @Categorie NVARCHAR(50),
    @NomEditeur NVARCHAR(50)
AS
BEGIN

    DECLARE @IdAuteur INT 
    DECLARE @IdLivre INT 
    DECLARE @IdCategorie INT 
    DECLARE @IdEditeur INT 
    DECLARE @IdLangue INT 

    -- Vérification que le titre n'est pas vide
    IF dbo.Validate_empty(@Titre) = 0
    BEGIN
        PRINT 'Erreur : Le titre du livre ne peut pas etre vide.' 
        RETURN 
    END 

    -- Vérification que l'ISBN n'est pas vide
    IF dbo.Validate_empty(@ISBN) = 0
    BEGIN
        PRINT 'Erreur : L ISBN ne peut pas etre vide.' 
        RETURN 
    END

    -- Vérification que l'ISBN n'existe pas déjà dans la base de données
    IF EXISTS (SELECT 1 FROM TLIVRES WHERE ISBN = dbo.Trim(@ISBN))
    BEGIN
        PRINT 'Erreur : Un livre avec cet ISBN existe deja.'
        RETURN
    END

    -- Vérification que le nom de l'auteur n'est pas vide
    IF dbo.Validate_empty(@NomAuteur) = 0
    BEGIN
        PRINT 'Erreur : Le nom de l auteur ne peut pas etre vide.' 
        RETURN 
    END 

    -- Vérification que le prénom de l'auteur n'est pas vide
    IF dbo.Validate_empty(@PrenomAuteur) = 0
    BEGIN
        PRINT 'Erreur : Le prenom de l auteur ne peut pas etre vide.' 
        RETURN 
    END 

    -- Vérification que la catégorie n'est pas vide
    IF dbo.Validate_empty(@Categorie) = 0
    BEGIN
        PRINT 'Erreur : La categorie ne peut pas etre vide.' 
        RETURN 
    END 

    -- Vérification que le nom de l'éditeur n'est pas vide
    IF dbo.Validate_empty(@NomEditeur) = 0
    BEGIN
        PRINT 'Erreur : Le nom de l editeur ne peut pas etre vide.' 
        RETURN 
    END 

    -- Vérification que le nom de la langue n'est pas vide
    IF dbo.Validate_empty(@NomLangue) = 0
    BEGIN
        PRINT 'Erreur : Le nom de la langue ne peut pas etre vide.' 
        RETURN 
    END 

    -- Vérification du format de l'ISBN
    IF dbo.Validate_ISBN(dbo.Trim(@ISBN)) = 0
    BEGIN
        PRINT 'Erreur : Format ISBN invalide.' 
        RETURN 
    END 

    BEGIN TRY
        BEGIN TRANSACTION
            -- Recherche de l'ID de la langue
            SELECT @IdLangue = IdLangue
            FROM TLANGUES
            WHERE NomLangue = LOWER(dbo.Trim(@NomLangue)) 
            
            -- Si la langue n'existe pas, on l'ajoute
            IF @IdLangue IS NULL
            BEGIN
                EXEC AjouterLangue @NomLangue 
                
                -- Récupération de l'ID de la langue nouvellement créée
                SELECT @IdLangue = IdLangue
                FROM TLANGUES
                WHERE NomLangue = LOWER(dbo.Trim(@NomLangue)) 
            END 

            -- Ajout de l'auteur s'il n'existe pas et récupération de son ID
            EXEC AjouterAuteur @NomAuteur, @PrenomAuteur 
            SELECT @IdAuteur = IdAuteur
            FROM TAUTEURS
            WHERE NomAuteur = LOWER(dbo.Trim(@NomAuteur))
            AND PrenomAuteur = LOWER(dbo.Trim(@PrenomAuteur)) 

            -- Ajout de la catégorie si elle n'existe pas et récupération de son ID
            EXEC AjouterCategorie @Categorie 
            SELECT @IdCategorie = IdCategorie
            FROM TCATEGORIES
            WHERE NomCategorie = LOWER(dbo.Trim(@Categorie)) 

            -- Ajout de l'éditeur s'il n'existe pas et récupération de son ID
            EXEC AjouterEditeur @NomEditeur 
            SELECT @IdEditeur = IdEditeur
            FROM TEDITEURS
            WHERE NomEditeur = LOWER(dbo.Trim(@NomEditeur)) 

            -- Insertion du livre dans la table TLIVRES
            INSERT INTO TLIVRES (Titre, ISBN, IdLangue)
            VALUES (@Titre, @ISBN, @IdLangue) 
            SET @IdLivre = SCOPE_IDENTITY() -- Récupération de l'ID du livre créé

            -- Création des associations entre le livre et les autres entités
            EXEC AssocierAuteurLivre @IdLivre, @IdAuteur 
            EXEC AssocierCategorieLivre @IdLivre, @IdCategorie 
            EXEC AssocierEditeurLivre @IdLivre, @IdEditeur 

            COMMIT -- Validation de la transaction
            PRINT 'Le livre a ete ajoute avec succes.' 
    END TRY
    BEGIN CATCH
        ROLLBACK -- Annulation de la transaction en cas d'erreur
        PRINT 'Erreur lors de l''ajout du livre : ' + ERROR_MESSAGE()
    END CATCH

END 
GO

-- ModifierLivre 
-- Cette procédure stockée permet de modifier les informations d'un livre existant
-- Les paramètres NULL indiquent que les valeurs correspondantes sont optionnelles
CREATE PROCEDURE ModifierLivre
    @IdLivre INT,
    @Titre VARCHAR(100) = NULL,
    @ISBN VARCHAR(20) = NULL,
    @IdLangue INT = NULL,
    @NomAuteur VARCHAR(50) = NULL,
    @PrenomAuteur VARCHAR(50) = NULL,
    @Categorie NVARCHAR(50) = NULL,
    @NomEditeur VARCHAR(50) = NULL
AS
BEGIN

    -- Vérification que l'ISBN, s'il est fourni, n'existe pas déjà pour un autre livre
    IF @ISBN IS NOT NULL AND EXISTS (
        SELECT 1 FROM TLIVRES WHERE ISBN = @ISBN AND IdLivre != @IdLivre
    )
    BEGIN
        PRINT 'Erreur : L ISBN existe deja pour un autre livre.' 
        RETURN 
    END 

    BEGIN TRY
        BEGIN TRANSACTION

            -- Mise à jour des informations de base du livre
            -- La fonction COALESCE permet de conserver la valeur actuelle si le paramètre est NULL
            UPDATE TLIVRES
            SET Titre = COALESCE(@Titre, Titre),
                ISBN = COALESCE(@ISBN, ISBN),
                IdLangue = COALESCE(@IdLangue, IdLangue)
            WHERE IdLivre = @IdLivre 

            -- -- Mise à jour de l'auteur si des informations sont fournies
            IF @NomAuteur IS NOT NULL AND @PrenomAuteur IS NOT NULL
            BEGIN
                DECLARE @IdAuteur INT 
                
                -- Vérification si l'auteur existe déjà
                SELECT @IdAuteur = IdAuteur
                FROM TAUTEURS
                WHERE NomAuteur = LOWER(dbo.Trim(@NomAuteur))
                AND PrenomAuteur = LOWER(dbo.Trim(@PrenomAuteur)) 

                -- Si l'auteur n'existe pas, on l'ajoute
                IF @IdAuteur IS NULL
                BEGIN
                    EXEC AjouterAuteur @NomAuteur, @PrenomAuteur 
                    SELECT @IdAuteur = IdAuteur
                    FROM TAUTEURS
                    WHERE NomAuteur = LOWER(dbo.Trim(@NomAuteur))
                    AND PrenomAuteur = LOWER(dbo.Trim(@PrenomAuteur)) 
                END 

                -- Suppression de l'association précédente entre le livre et son auteur
                DELETE FROM TAUTEURS_LIVRES WHERE IdLivre = @IdLivre
                -- Création de la nouvelle association
                EXEC AssocierAuteurLivre @IdLivre, @IdAuteur 
            END 

            -- Mise à jour de la catégorie si une information est fournie
            IF @Categorie IS NOT NULL
            BEGIN
                DECLARE @IdCategorie INT 

                -- Vérification si la catégorie existe déjà
                SELECT @IdCategorie = IdCategorie
                FROM TCATEGORIES
                WHERE NomCategorie = LOWER(dbo.Trim(@Categorie)) 

                -- Si la catégorie n'existe pas, on l'ajoute
                IF @IdCategorie IS NULL
                BEGIN
                    EXEC AjouterCategorie @Categorie 
                    SELECT @IdCategorie = IdCategorie
                    FROM TCATEGORIES
                    WHERE NomCategorie = LOWER(dbo.Trim(@Categorie)) 
                END 

                -- Suppression de l'association précédente entre le livre et sa catégorie
                DELETE FROM TCATEGORIES_LIVRES WHERE IdLivre = @IdLivre 
                -- Création de la nouvelle association
                EXEC AssocierCategorieLivre @IdLivre, @IdCategorie 
            END 

            -- Mise à jour de l'éditeur si une information est fournie
            IF @NomEditeur IS NOT NULL
            BEGIN
                DECLARE @IdEditeur INT 

                -- Vérification si l'éditeur existe déjà
                SELECT @IdEditeur = IdEditeur
                FROM TEDITEURS
                WHERE NomEditeur = LOWER(dbo.Trim(@NomEditeur)) 

                -- Si l'éditeur n'existe pas, on l'ajoute
                IF @IdEditeur IS NULL
                BEGIN
                    EXEC AjouterEditeur @NomEditeur 
                    SELECT @IdEditeur = IdEditeur
                    FROM TEDITEURS
                    WHERE NomEditeur = LOWER(dbo.Trim(@NomEditeur)) 
                END 

                -- Suppression de l'association précédente entre le livre et son éditeur
                DELETE FROM TEDITEURS_LIVRES WHERE IdLivre = @IdLivre
                -- Création de la nouvelle association
                EXEC AssocierEditeurLivre @IdLivre, @IdEditeur 
            END 

            -- Vérification si la langue spécifiée existe
            IF @IdLangue IS NOT NULL AND NOT EXISTS (
                SELECT 1 FROM TLANGUES WHERE IdLangue = @IdLangue
            )
            BEGIN
                PRINT 'Erreur : La langue specifiee n existe pas.' 
                RETURN 
            END 

            COMMIT -- Validation de la transaction
            PRINT 'Le livre a ete modifiee avec succes.' 
    END TRY
    BEGIN CATCH
        ROLLBACK -- Annulation de la transaction en cas d'erreur
        PRINT 'Erreur lors de la modification du livre : ' + ERROR_MESSAGE()
    END CATCH
END 
GO

-- SupprimerLivre
-- Cette procédure stockée permet de supprimer un livre de la base de données
-- Elle vérifie d'abord si des exemplaires du livre sont actuellement empruntés
CREATE PROCEDURE SupprimerLivre
    @IdLivre INT
AS
BEGIN
    -- Vérification que l'ID est valide
    IF @IdLivre IS NULL OR @IdLivre <= 0
    BEGIN
        PRINT 'Erreur : L identifiant de la livre doit etre un nombre positif valide.' 
        RETURN 
    END 

    -- Vérification que le livre existe
    IF NOT EXISTS (SELECT 1 FROM TLIVRES WHERE IdLivre = @IdLivre)
    BEGIN
        PRINT 'Erreur : Le livre specifie n existe pas.' 
        RETURN 
    END 
    
    -- Vérification qu'aucun exemplaire du livre n'est actuellement emprunté
    IF EXISTS (
        SELECT 1 
        FROM TEMPRUNTS
        INNER JOIN TEXEMPLAIRES ON TEMPRUNTS.IdExemplaire = TEXEMPLAIRES.IdExemplaire
        WHERE TEXEMPLAIRES.IdLivre = @IdLivre 
        AND TEMPRUNTS.DateRetour IS NULL
    )
    BEGIN
        PRINT 'Erreur : Impossible de supprimer ce livre car des exemplaires sont actuellement empruntes.'
        RETURN
    END

    BEGIN TRY
        BEGIN TRANSACTION

        -- Récupération du titre du livre pour le message de confirmation
        DECLARE @Titre VARCHAR(100) 
        SELECT @Titre = Titre FROM TLIVRES WHERE IdLivre = @IdLivre 
        
        -- Suppression de toutes les associations du livre avec d'autres entités
        DELETE FROM TAUTEURS_LIVRES WHERE IdLivre = @IdLivre 
        DELETE FROM TCATEGORIES_LIVRES WHERE IdLivre = @IdLivre 
        DELETE FROM TEDITEURS_LIVRES WHERE IdLivre = @IdLivre 
        
        -- Suppression du livre lui-même
        DELETE FROM TLIVRES WHERE IdLivre = @IdLivre 
        
        COMMIT -- Validation de la transaction
        PRINT 'Le livre "' + @Titre + '" a ete supprime avec succes.' 
    END TRY
    BEGIN CATCH
        ROLLBACK -- Annulation de la transaction en cas d'erreur
        PRINT 'Erreur lors de la suppression du livre : ' + ERROR_MESSAGE() 
    END CATCH
END 
GO

-- AjouterAuteur
-- Cette procédure stockée permet d'ajouter un nouvel auteur dans la base de données
-- Si l'auteur existe déjà, un message est affiché
CREATE PROCEDURE AjouterAuteur
    @NomAuteur VARCHAR(50),
    @PrenomAuteur VARCHAR(50)

AS
BEGIN
    -- Vérification que le nom et le prénom ne sont pas vides
    IF dbo.Validate_empty(@NomAuteur) = 0 OR dbo.Validate_empty(@PrenomAuteur) = 0
    BEGIN
        PRINT 'L entree est vide. Veuillez fournir un nom et prenom valide.' 
        RETURN 
    END

    DECLARE @Nom NVARCHAR(50) 
    DECLARE @Prenom NVARCHAR(50) 

    SET @Nom = LOWER(dbo.Trim(@NomAuteur)) 
    SET @Prenom = LOWER(dbo.Trim(@PrenomAuteur)) 

    -- Si l'auteur n'existe pas déjà, on l'ajoute
    IF NOT EXISTS (SELECT 1 FROM TAUTEURS WHERE NomAuteur = @Nom AND PrenomAuteur = @Prenom)
    BEGIN
        INSERT INTO TAUTEURS(NomAuteur, PrenomAuteur)
        VALUES (@Nom, @Prenom) 
        PRINT 'L auteurs ' + @Prenom + ' ' + @Nom + ' a ete ajoute avec succes' 
    END
    ELSE
    BEGIN
        PRINT 'L auteurs ' + @Prenom + ' ' + @Nom + ' existe deja' 
    END

END 
GO

-- AssocierAuteurLivre
-- Cette procédure stockée permet d'associer un auteur à un livre
-- Elle crée une relation dans la table TAUTEURS_LIVRES
CREATE PROCEDURE AssocierAuteurLivre
    @IdLivre INT,
    @IdAuteur INT
AS
BEGIN
    -- Vérification que les identifiants ne sont pas nuls
    IF @IdLivre IS NULL
    BEGIN
        PRINT 'Erreur : L identifiant du livre est null.'
        RETURN
    END

    IF @IdAuteur IS NULL
    BEGIN
        PRINT 'Erreur : L identifiant de l auteur est null.'
        RETURN
    END

    -- Création de l'association
    INSERT INTO TAUTEURS_LIVRES (IdAuteur, IdLivre)
    VALUES (@IdAuteur, @IdLivre)

    PRINT 'Association entre l auteur et le livre effectuee avec succes.'
END 
GO

-- ModifierAuteur
-- Cette procédure stockée permet de modifier les informations d'un auteur existant
CREATE PROCEDURE ModifierAuteur
    @IdAuteur INT,
    @NomAuteur VARCHAR(50),
    @PrenomAuteur VARCHAR(50)
AS
BEGIN
    -- Vérification que l'auteur existe
    IF NOT EXISTS (SELECT 1 FROM TAUTEURS WHERE IdAuteur = @IdAuteur)
    BEGIN
        PRINT 'Erreur : L Auteur specifiee n existe pas.' 
        RETURN 
    END

    -- Vérification que le nom n'est pas vide
    IF dbo.Validate_empty(@NomAuteur) = 0
    BEGIN
        PRINT 'Erreur : Le non de l auteur du livre ne peut pas etre vide.' 
        RETURN 
    END

    -- Vérification que le prénom n'est pas vide
    IF dbo.Validate_empty(@PrenomAuteur) = 0
    BEGIN
        PRINT 'Erreur : Le prenon de l auteur du livre ne peut pas etre vide.' 
        RETURN 
    END

    -- Mise à jour des informations de l'auteur
    UPDATE TAUTEURS
    SET NomAuteur = LOWER(dbo.Trim(@NomAuteur)),
        PrenomAuteur = LOWER(dbo.Trim(@PrenomAuteur))
    WHERE IdAuteur = @IdAuteur

    PRINT 'L auteurs ' + LOWER(dbo.Trim(@PrenomAuteur)) + ' ' + LOWER(dbo.Trim(@NomAuteur)) + ' a ete modifie avec succes'
END 
GO

-- SupprimerCategorie
-- Cette procédure stockée permet de supprimer une catégorie de la base de données
-- Elle vérifie d'abord si la catégorie est associée à des livres
CREATE PROCEDURE SupprimerCategorie
    @IdCategorie INT
AS
BEGIN
    -- Vérification que l'ID est valide
    IF @IdCategorie IS NULL OR @IdCategorie <= 0
    BEGIN
        PRINT 'Erreur : L identifiant de la categorie doit etre un nombre positif valide.' 
        RETURN 
    END 

    -- Vérification que la catégorie existe
    IF NOT EXISTS (SELECT 1 FROM TCATEGORIES WHERE IdCategorie = @IdCategorie)
    BEGIN
        PRINT 'Erreur : La categorie specifiee n existe pas.'
        RETURN 
    END 
        
    DECLARE @NomCategorie VARCHAR(50)
    DECLARE @CountLivres INT

    SELECT @NomCategorie = NomCategorie FROM TCATEGORIES WHERE IdCategorie = @IdCategorie

    SELECT @CountLivres = COUNT(*) 
    FROM TCATEGORIES_LIVRES 
    WHERE IdCategorie = @IdCategorie
    
    -- Si la catégorie est associée à des livres, on empêche la suppression
    IF EXISTS (SELECT 1 FROM TCATEGORIES_LIVRES WHERE IdCategorie = @IdCategorie)
    BEGIN
        PRINT 'Erreur : Impossible de supprimer cette categorie car elle est utilisee par des livres.' 
        PRINT 'Nombre de livres concernés : ' + CAST(@CountLivres AS VARCHAR)  
        RETURN 
    END
    BEGIN TRY
        BEGIN TRANSACTION 
        
        -- Suppression de la catégorie
        DELETE FROM TCATEGORIES WHERE IdCategorie = @IdCategorie 
        
        COMMIT -- Validation de la transaction
        PRINT 'La categorie "' + @NomCategorie + '" a ete supprimee avec succes.' 
    END TRY
    BEGIN CATCH
        ROLLBACK -- Annulation de la transaction en cas d'erreur
        PRINT 'Erreur lors de la suppression de la categorie : ' + ERROR_MESSAGE() 
    END CATCH
END 
GO

-- AjouterEditeur
-- Cette procédure stockée permet d'ajouter un nouvel éditeur dans la base de données
-- Si l'éditeur existe déjà, un message est affiché
CREATE PROCEDURE AjouterEditeur
    @NomEditeur VARCHAR(50)

AS
BEGIN
    -- Vérification que le nom de l'éditeur n'est pas vide
    IF dbo.Validate_empty(@NomEditeur) = 0
    BEGIN
        PRINT 'L entree est vide. Veuillez fournir un nom valide.' 
        RETURN 
    END

    DECLARE @Editeur NVARCHAR(50) 

    SET @Editeur = LOWER(dbo.Trim(@NomEditeur)) 

    -- Si l'éditeur n'existe pas déjà, on l'ajoute
    IF NOT EXISTS (SELECT 1 FROM TEDITEURS WHERE NomEditeur = @Editeur)
    BEGIN
        INSERT INTO TEDITEURS(NomEditeur)
        VALUES (@Editeur) 
        PRINT 'L editeur ' + @Editeur + ' a ete ajoute avec succes' 
    END
    ELSE
    BEGIN
        PRINT 'L editeur ' + @Editeur + ' existe deja' 
    END

END 
GO

-- AssocierEditeurLivre
-- Cette procédure stockée permet d'associer un éditeur à un livre
-- Elle crée une relation dans la table TEDITEURS_LIVRES
CREATE PROCEDURE AssocierEditeurLivre
    @IdLivre INT,
    @IdEditeur INT
AS
BEGIN
    -- Vérification que les identifiants ne sont pas nuls
    IF @IdLivre IS NULL
    BEGIN
        PRINT 'Erreur : L identifiant du livre est null.'
        RETURN
    END

    IF @IdEditeur IS NULL
    BEGIN
        PRINT 'Erreur : L identifiant de l Editeur  est null.'
        RETURN
    END

    -- Création de l'association
    INSERT INTO TEDITEURS_LIVRES (IdEditeur, IdLivre)
    VALUES (@IdEditeur, @IdLivre)

    PRINT 'Association entre l éditeur et le livre effectuée avec succès.'
END 
GO

-- ModifierEditeur
-- Cette procédure stockée permet de modifier le nom d'un éditeur existant
CREATE PROCEDURE ModifierEditeur
    @IdEditeur INT,
    @NomEditeur VARCHAR(50)
AS
BEGIN
    -- Vérifie que le nom de l'éditeur n'est pas vide à l'aide d'une fonction personnalisée
    IF dbo.Validate_empty(@NomEditeur) = 0
    BEGIN
        PRINT 'Erreur : Le titre Editeur du livre ne peut pas etre vide.' 
        RETURN 
    END

    -- Vérifie que l'éditeur existe dans la table TEDITEURS
    IF NOT EXISTS (SELECT 1 FROM TEDITEURS WHERE IdEditeur = @IdEditeur)
    BEGIN
        PRINT 'Erreur : L editeur specifie n existe pas.'
        RETURN
    END

    -- Met à jour le nom de l'éditeur en appliquant la fonction Trim et en convertissant en minuscules
    UPDATE TEDITEURS
    SET NomEditeur = LOWER(dbo.Trim(@NomEditeur))
    WHERE IdEditeur = @IdEditeur

    PRINT 'L editeur ' + LOWER(dbo.Trim(@NomEditeur)) + ' a été modifié avec succès.'
END 
GO

-- SupprimerEditeur
-- Cette procédure stockée permet de supprimer un éditeur s'il n'est pas associé à des livres
CREATE PROCEDURE SupprimerEditeur
    @IdEditeur INT
AS
BEGIN
    -- Vérifie que l'identifiant est valide
    IF @IdEditeur IS NULL OR @IdEditeur <= 0
    BEGIN
        PRINT 'Erreur : L identifiant de la livre doit etre un nombre positif valide.' 
        RETURN 
    END 
    
     -- Vérifie que l'éditeur existe dans la base de données
    IF NOT EXISTS (SELECT 1 FROM TEDITEURS WHERE IdEditeur = @IdEditeur)
    BEGIN
        PRINT 'Erreur : L editeur specifie n existe pas.' 
        RETURN 
    END 
        

    DECLARE @NomEditeur VARCHAR(50)
    DECLARE @CountLivres INT

    SELECT @NomEditeur = NomEditeur FROM TEDITEURS WHERE IdEditeur = @IdEditeur

     -- Compte le nombre de livres associés à cet éditeur dans la table de liaison
    SELECT @CountLivres = COUNT(*)
    FROM TEDITEURS_LIVRES 
    WHERE IdEditeur = @IdEditeur
    
    -- Si l'éditeur est associé à des livres, refuse la suppression
    IF @CountLivres > 0
    BEGIN
        PRINT 'Erreur : Impossible de supprimer cet editeur car il est utilise par des livres.' 
        PRINT 'Nombre de livres concernes : ' + CAST(@CountLivres AS VARCHAR) 
        RETURN 
    END 

    -- Utilise un bloc TRY-CATCH pour gérer les erreurs potentielles
    BEGIN TRY
        -- Débute une transaction pour assurer l'intégrité des données
        BEGIN TRANSACTION
        -- Supprime l'éditeur
        DELETE FROM TEDITEURS WHERE IdEditeur = @IdEditeur 
        
        COMMIT  -- Valide la transaction si tout s'est bien passé
        PRINT 'L editeur "' + @NomEditeur + '" a ete supprime avec succes.' 
    END TRY
    BEGIN CATCH
        ROLLBACK  -- Annule la transaction en cas d'erreur
        PRINT 'Erreur lors de la suppression de l editeur : ' + ERROR_MESSAGE() 
    END CATCH
END 
GO

-- AjouterCategorie
-- Cette procédure stockée permet d'ajouter une nouvelle catégorie dans la base de données
-- Si la catégorie existe déjà, un message est affiché
CREATE PROCEDURE AjouterCategorie
    @NomCategorie VARCHAR(50)

AS
BEGIN
    -- Vérification que le nom de la catégorie n'est pas vide
    IF dbo.Validate_empty(@NomCategorie) = 0
    BEGIN
        PRINT 'L entree est vide. Veuillez fournir un categorie valide.' 
        RETURN 
    END

    DECLARE @Categorie NVARCHAR(50) 

    SET @Categorie = LOWER(dbo.Trim(@NomCategorie)) 

    -- Si la catégorie n'existe pas déjà, on l'ajoute
    IF NOT EXISTS (SELECT 1 FROM TCATEGORIES WHERE NomCategorie = @Categorie)
    BEGIN
        INSERT INTO TCATEGORIES(NomCategorie)
        VALUES (@Categorie) 
        PRINT 'La Categorie ' + @Categorie + ' a ete ajoute avec succes' 
    END
    ELSE
    BEGIN
        PRINT 'La Categorie ' + @Categorie + ' existe deja' 
    END
END 
GO

-- AssocierCategorieLivre
-- Cette procédure stockée permet d'associer une catégorie à un livre
-- Elle crée une relation dans la table TCATEGORIES_LIVRES
CREATE PROCEDURE AssocierCategorieLivre
    @IdLivre INT,
    @IdCategorie INT
AS
BEGIN
    -- Vérification que les identifiants ne sont pas nuls
    IF @IdLivre IS NULL
    BEGIN
        PRINT 'Erreur : L identifiant du livre est null.'
        RETURN
    END

    IF @IdCategorie IS NULL
    BEGIN
        PRINT 'Erreur : L identifiant de la Categorie  est null.'
        RETURN
    END

    -- Création de l'association
    INSERT INTO TCATEGORIES_LIVRES (IdCategorie, IdLivre)
    VALUES (@IdCategorie, @IdLivre)

    PRINT 'Association entre la categorie et le livre effectuee avec succes.'
END 
GO

-- ModifierCategorie
-- Cette procédure stockée permet de modifier le nom d'une catégorie existante
CREATE PROCEDURE ModifierCategorie
    @IdCategorie INT,
    @NomCategorie VARCHAR(50)
AS
BEGIN
    -- Vérification que la catégorie existe
    IF NOT EXISTS (SELECT 1 FROM TCATEGORIES WHERE IdCategorie = @IdCategorie)
    BEGIN
        PRINT 'Erreur : La Categorie specifiee n existe pas.' 
        RETURN 
    END

    -- Vérification que le nom de la catégorie n'est pas vide
    IF dbo.Validate_empty(@NomCategorie) = 0
    BEGIN
        PRINT 'Erreur : La Categorie du livre ne peut pas etre vide.' 
        RETURN 
    END

    -- Mise à jour du nom de la catégorie
    UPDATE TCATEGORIES
    SET NomCategorie = LOWER(dbo.Trim(@NomCategorie))
    WHERE IdCategorie = @IdCategorie 

    PRINT 'La Categorie ' + LOWER(dbo.Trim(@NomCategorie)) + ' a ete modifiee avec succes'
END 
GO

-- SupprimerAuteur
-- Cette procédure stockée permet de supprimer un auteur s'il n'est pas associé à des livres
CREATE PROCEDURE SupprimerAuteur
    @IdAuteur INT
AS
BEGIN
    -- Vérification que l'ID est valide
    IF @IdAuteur IS NULL OR @IdAuteur <= 0
    BEGIN
        PRINT 'Erreur : L identifiant de l auteur doit etre un nombre positif valide.' 
        RETURN 
    END 

    -- Vérification que l'auteur existe
    IF NOT EXISTS (SELECT 1 FROM TAUTEURS WHERE IdAuteur = @IdAuteur)
    BEGIN
        PRINT 'Erreur : L auteur specifie n existe pas.'  
        RETURN 
    END 
        
    DECLARE @NomAuteur VARCHAR(50) 
    DECLARE @PrenomAuteur VARCHAR(50)
    DECLARE @CountLivres INT 

    SELECT @NomAuteur = NomAuteur, @PrenomAuteur = PrenomAuteur 
    FROM TAUTEURS WHERE IdAuteur = @IdAuteur 

    -- Compte le nombre de livres associés à cet auteur
    SELECT @CountLivres = COUNT(*) 
    FROM TAUTEURS_LIVRES 
    WHERE IdAuteur = @IdAuteur
    
    -- Si l'auteur est associé à des livres, refuse la suppression
    IF EXISTS (SELECT 1 FROM TAUTEURS_LIVRES WHERE IdAuteur = @IdAuteur)
    BEGIN
        PRINT 'Erreur : Impossible de supprimer cet auteur car il est associe a des livres.' 
        PRINT 'Nombre de livres concernes : ' + CAST(@CountLivres AS VARCHAR) 
        RETURN 
    END

    -- Utilise un bloc TRY-CATCH pour gérer les erreurs potentielles
    BEGIN TRY
        -- Débute une transaction pour assurer l'intégrité des données
        BEGIN TRANSACTION 
        
        -- Suppression de l'auteur
        DELETE FROM TAUTEURS WHERE IdAuteur = @IdAuteur 
        
        COMMIT -- Validation de la transaction
        PRINT 'L auteur "' + @PrenomAuteur + ' ' + @NomAuteur + '" a ete supprime avec succes.' 
    END TRY
    BEGIN CATCH
        ROLLBACK -- Annulation de la transaction en cas d'erreur
        PRINT 'Erreur lors de la suppression de l auteur : ' + ERROR_MESSAGE() 
    END CATCH
END 
GO

-- AjouterLangue
-- Cette procédure stockée permet d'ajouter une nouvelle langue dans la base de données
CREATE PROCEDURE AjouterLangue
    @NomLangue VARCHAR(50)
AS
BEGIN
    -- Vérifie que le nom de la langue n'est pas vide
    IF dbo.Validate_empty(@NomLangue) = 0
    BEGIN
        PRINT 'L entree est vide. Veuillez fournir un nom de langue valide.' 
        RETURN 
    END
    
    DECLARE @Langue VARCHAR(50) = LOWER(dbo.Trim(@NomLangue)) 
    
    -- Vérifie si la langue existe déjà
    IF NOT EXISTS (SELECT 1 FROM TLANGUES WHERE LOWER(NomLangue) = @Langue)
    BEGIN
        -- Ajoute la langue si elle n'existe pas
        INSERT INTO TLANGUES (NomLangue)
        VALUES (@Langue) 
        PRINT 'La langue ' + @NomLangue + ' a ete ajoutee avec succes.' 
    END
    ELSE
    BEGIN
        PRINT 'La langue ' + @NomLangue + ' existe deja.' 
    END
END
GO

-- ModifierLangue
-- Cette procédure stockée permet de modifier le nom d'une langue existante
CREATE PROCEDURE ModifierLangue
    @IdLangue INT,
    @NomLangue VARCHAR(50)
AS
BEGIN
    -- Vérifie que la langue existe
    IF NOT EXISTS (SELECT 1 FROM TLANGUES WHERE IdLangue = @IdLangue)
    BEGIN
        PRINT 'Erreur : La langue specifiee n existe pas.' 
        RETURN 
    END
    
    -- Vérifie que le nom de la langue n'est pas vide
    IF dbo.Validate_empty(@NomLangue) = 0
    BEGIN
        PRINT 'L entree est vide. Veuillez fournir un nom de langue valide.' 
        RETURN 
    END
    
    DECLARE @Langue VARCHAR(50) = LOWER(dbo.Trim(@NomLangue)) 
    
    -- Vérifie qu'il n'existe pas déjà une autre langue avec ce nom
    IF EXISTS (SELECT 1 FROM TLANGUES WHERE LOWER(NomLangue) = @Langue AND IdLangue != @IdLangue)
    BEGIN
        PRINT 'Erreur : Une langue avec ce nom existe deja.' 
        RETURN 
    END
    
    -- Met à jour le nom de la langue
    UPDATE TLANGUES
    SET NomLangue = @Langue
    WHERE IdLangue = @IdLangue 
    
    PRINT 'La langue a ete modifiee avec succes.' 
END 
GO

-- SupprimerLangue
-- Cette procédure stockée permet de supprimer une langue si elle n'est pas utilisée par des livres
CREATE PROCEDURE SupprimerLangue
    @IdLangue INT
AS
BEGIN
    -- Vérifie que la langue existe
    IF NOT EXISTS (SELECT 1 FROM TLANGUES WHERE IdLangue = @IdLangue)
    BEGIN
        PRINT 'Erreur : La langue specifiee n existe pas.' 
        RETURN
    END

    DECLARE @CountLivres INT

    SELECT @CountLivres = COUNT(*) FROM TLIVRES WHERE IdLangue = @IdLangue
    
    -- Si la langue est utilisée par des livres, refuse la suppression
    IF EXISTS (SELECT 1 FROM TLIVRES WHERE IdLangue = @IdLangue)
    BEGIN
        PRINT 'Erreur : Impossible de supprimer cette langue car elle est utilisee par des livres.' 
        PRINT 'Nombre de livres concernes : ' + CAST(@CountLivres AS VARCHAR)  
        RETURN 
    END

    -- Utilise un bloc TRY-CATCH pour gérer les erreurs potentielles
    BEGIN TRY
        -- Débute une transaction pour assurer l'intégrité des données
        BEGIN TRANSACTION 
        -- Supprime la langue
        DELETE FROM TLANGUES WHERE IdLangue = @IdLangue 
        
        COMMIT -- Valide la transaction si tout s'est bien passé
        PRINT 'La langue a ete supprimee avec succes.' 
    END TRY
    BEGIN CATCH
        ROLLBACK -- Annule la transaction en cas d'erreur
        PRINT 'Erreur lors de la suppression de la langue : ' + ERROR_MESSAGE() 
    END CATCH
END 
GO

-- GESTION NOTIFICATION
--PROC 1
CREATE PROCEDURE EnvoyerNotification
@IdClient AS INT,
@NotificationText AS NVARCHAR(MAX),
@NotificationType AS VARCHAR(20)

AS
BEGIN
    -- Checking if the notification text is empy or null
    IF dbo.Validate_empty(@NotificationText) = 0
    BEGIN
        PRINT('le notification est vide')
        RETURN
    END

    INSERT INTO TNOTIFICATIONS(IdClient , NotificationType , NotificationText)
    VALUES (@IdClient , @NotificationType , @NotificationText)

END
GO

-- GESTOPM PENALITES
--Procedure pour Ajouter une Penalite
CREATE PROCEDURE AjouterPenalite     
    @IdAbonnement INT,     
    @IdEmprunt INT = NULL,     
    @Motif VARCHAR(20) 
AS 
BEGIN     
    DECLARE @NbPerteAbime INT = 0    
    DECLARE @DateRetour DATETIME     
    DECLARE @NbJoursRetard INT     
    DECLARE @Montant DECIMAL(10,2)      
    DECLARE @IdClient INT
    DECLARE @NotificationText NVARCHAR(MAX)

    -- Récupérer l'IdClient à partir de l'IdAbonnement
    SELECT @IdClient = IdClient FROM TABONNEMENTS WHERE IdAbonnement = @IdAbonnement

    -- Traitement pour le retard
    IF @Motif = 'retard'
    BEGIN
        -- Vérifier si @IdEmprunt est NULL
        IF @IdEmprunt IS NULL
        BEGIN
            PRINT 'Erreur : L''ID d''emprunt est requis pour calculer la pénalité de retard.'
            RETURN
        END      
        SELECT @DateRetour = DateRetour         
        FROM TEMPRUNTS         
        WHERE IdEmprunt = @IdEmprunt          

        IF @DateRetour IS NULL         
        BEGIN             
            PRINT 'Erreur : La date de retour est introuvable.'             
            RETURN         
        END          

        -- Calcul du nombre de jours de retard         
        SET @NbJoursRetard = DATEDIFF(DAY, @DateRetour, GETDATE())          

        -- Calcul du montant basé sur les jours de retard         
        IF @NbJoursRetard <= 7             
            SET @Montant = 50.00  -- Montant pour un retard de 7 jours ou moins          
        ELSE IF @NbJoursRetard <= 14             
            SET @Montant = 100.00     -- Montant pour un retard de 8 à 14 jours      
        ELSE IF @NbJoursRetard <= 21             
            SET @Montant = 200.00     -- Montant pour un retard de 15 à 21 jours     
        ELSE             
            SET @Montant = 300.00  -- Montant maximal pour un retard supérieur à 21 jours 

        -- Si le retard est de 3 mois (90 jours) ou plus on marque l'exemplaire comme perdu
        IF @NbJoursRetard >= 90
        BEGIN
            UPDATE TEXEMPLAIRES
            SET Disponibilite = 'perdu'
            WHERE IdExemplaire = (SELECT IdExemplaire FROM TEMPRUNTS WHERE IdEmprunt = @IdEmprunt)

            PRINT 'L exemplaire a été marqué comme perdu en raison d un retard de 3 mois ou plus.'
        END

        SELECT @NotificationText =  'Vous avez une pénalité pour retard de '+ CAST(@NbJoursRetard AS NVARCHAR(20))+ ' jours. Montant: ' + CAST(@Montant AS NVARCHAR(20))+ ' Dhs.'
        -- Envoi de notification pour retard
        EXEC EnvoyerNotification @IdClient,@NotificationText ,'retard'
    END     
    ELSE IF @Motif = 'perte'     
    BEGIN         
        SET @Montant = 500.00  

        SELECT @NotificationText = 'Un livre a été déclaré perdu. Une pénalité de ' +CAST(@Montant AS NVARCHAR(20))+ ' Dhs a été appliquée.'
        -- Envoi de notification pour perte
        EXEC EnvoyerNotification @IdClient, @NotificationText,'perte'
    END     
    ELSE IF @Motif = 'abime'     
    BEGIN         
        SET @Montant = 300.00  

        SELECT @NotificationText = 'Un livre a été déclaré abîmé. Une pénalité de ' +CAST(@Montant AS NVARCHAR(20))+ ' Dhs a été appliquée.'
        -- Envoi de notification pour abîmé
        EXEC EnvoyerNotification @IdClient, @NotificationText, 'abime'
    END      

    -- Vérification du nombre de pénalités pour perte ou abîmé
    IF @Motif IN ('perte', 'abime')
    BEGIN
        SET @NbPerteAbime = 0
        SELECT @NbPerteAbime = COUNT(*)         
        FROM TPENALITE         
        WHERE IdAbonnement = @IdAbonnement AND Motif IN ('perte', 'abime') 

        IF @NbPerteAbime = 4
        BEGIN
            UPDATE TABONNEMENTS             
            SET EtatAbonnement = 'annule'             
            WHERE IdAbonnement = @IdAbonnement

            PRINT 'L abonnement a été annulé en raison de 5 pénalités pour perte ou abîmé.'

            -- Envoi de notification pour annulation
            EXEC EnvoyerNotification @IdClient, 'Votre abonnement a été annulé en raison de 5 pénalités pour perte ou détérioration.','annulation'

            RETURN
        END
    END

    -- Insertion de la pénalité si l'abonnement n'est pas annulé
    INSERT INTO TPENALITE (IdAbonnement, IdEmprunt, Motif, Montant, EtatPenalite, DatePenalite)     
    VALUES (@IdAbonnement, @IdEmprunt, @Motif, @Montant, 'en cours', GETDATE())

    -- Suspendre l'abonnement s'il n'est pas annulé
    UPDATE TABONNEMENTS        
    SET EtatAbonnement = 'suspendu'
    WHERE IdAbonnement = @IdAbonnement 

    -- Envoi de notification pour suspension
    EXEC EnvoyerNotification @IdClient,'Votre abonnement a été suspendu en raison d''une pénalité.', 'suspension'
END
GO


-- Procédure pour réactiver un abonnement
CREATE PROCEDURE ReactiverAbonnement
    @IdAbonnement INT
AS
BEGIN
     DECLARE @IdClient INT 
      -- Récupérer l'IdClient à partir de l'IdAbonnement
    SELECT @IdClient = IdClient FROM TABONNEMENTS WHERE IdAbonnement = @IdAbonnement
    -- Vérifier s'il reste des pénalités non payées
    DECLARE @PenalitesEnCours INT 
    SELECT @PenalitesEnCours = COUNT(*) 
    FROM TPENALITE 
    WHERE IdAbonnement = @IdAbonnement AND EtatPenalite = 'en cours' 

    -- Si aucune pénalité en cours, on réactive l'abonnement
    IF @PenalitesEnCours = 0
    BEGIN
        UPDATE TABONNEMENTS
        SET EtatAbonnement = 'actif'
        WHERE IdAbonnement = @IdAbonnement AND EtatAbonnement = 'suspendu'
         -- Ajouter une notification dans la table de notifications
        EXEC EnvoyerNotification @IdClient,  'Votre abonnement a été réactivé avec succès.','Confirmation'

    END
END
GO


--Procedure pour payer une Penalite
CREATE PROCEDURE PayerPenalite
    @IdPenalite INT
AS
BEGIN
    -- Mettre à jour la pénalité comme "payée"
    UPDATE TPENALITE
    SET EtatPenalite = 'payee'
    WHERE IdPenalite = @IdPenalite

    -- Récupérer l'ID de l'abonnement et l'ID du client en une seule requête avec jointure
    DECLARE @IdAbonnement INT, @IdClient INT 
    
    SELECT @IdAbonnement = P.IdAbonnement, 
           @IdClient = A.IdClient
    FROM TPENALITE P
    JOIN TABONNEMENTS A ON P.IdAbonnement = A.IdAbonnement
    WHERE P.IdPenalite = @IdPenalite 

    -- Ajouter une notification dans la table de notifications
    EXEC EnvoyerNotification @IdClient, 'Votre pénalité a été payée avec succès.', 'information' 
   
    -- Vérifier s'il reste des pénalités non payées et réactiver si nécessaire
    EXEC ReactiverAbonnement @IdAbonnement 
END
GO

--Procédure pour suspendre l'abonnement d'un client ayant des pénalités de retard impayées
CREATE PROCEDURE SuspendreAbonnementSiPenalitesRetards
    @IdAbonnement INT,
    @Seuil INT = 3  
AS
BEGIN
    DECLARE @NbPenalites INT , @IdClient INT

    -- Récupérer l'IdClient et le nombre de pénalités en une seule requête avec une jointure
    SELECT @IdClient = A.IdClient, 
           @NbPenalites = COUNT(P.IdPenalite)
    FROM TABONNEMENTS A
    LEFT JOIN TPENALITE P ON A.IdAbonnement = P.IdAbonnement 
                          AND P.EtatPenalite = 'en cours' 
                          AND P.Motif = 'retard'
    WHERE A.IdAbonnement = @IdAbonnement
    GROUP BY A.IdClient 

    IF @NbPenalites >= @Seuil
    BEGIN
        -- Vérifier si l'abonnement est déjà suspendu ou annulé
        IF NOT EXISTS (SELECT 1 FROM TABONNEMENTS 
                       WHERE IdAbonnement = @IdAbonnement 
                       AND EtatAbonnement IN ('suspendu', 'annule'))
        BEGIN
            UPDATE TABONNEMENTS
            SET EtatAbonnement = 'suspendu'
            WHERE IdAbonnement = @IdAbonnement 

            PRINT 'L abonnement a été suspendu en raison de pénalités de retard impayées.'
            
            -- Ajouter une notification dans la table de notifications
            EXEC EnvoyerNotification @IdClient,  
                'Votre abonnement a été suspendu en raison de pénalités de retard impayées.',
                'suspension' 
        END
    END
END
GO

-- Procédure pour lister les pénalités
CREATE PROCEDURE ListerPenalitesEnCours
    @IdAbonnement INT
AS
BEGIN
    SELECT * FROM TPENALITE
    WHERE IdAbonnement = @IdAbonnement AND EtatPenalite = 'en cours'
END
GO

-- GSETION RESERVATIONS
CREATE PROCEDURE ReserverLivre
	@IdAbonnement INT,
	@IdLivre INT
AS
BEGIN
	DECLARE @NbExemplairesDisponibles AS INT
	SELECT @NbExemplairesDisponibles = COUNT(IdExemplaire)
	FROM
		TEXEMPLAIRES
	WHERE
		IdLivre = @IdLivre
	AND	
		Disponibilite = 'disponible'
	
	IF @NbExemplairesDisponibles > 0
	BEGIN
		PRINT 'Reservation refusee : des exemplaires sont disponibles deja .'
		RETURN
	END

	INSERT INTO TRESERVATIONS (IdAbonnement, IdLivre)
	VALUES (@IdAbonnement, @IdLivre)
END
GO

CREATE PROCEDURE SupprimerReservation
	@IdReservation INT
AS
BEGIN
	DELETE FROM 
		TRESERVATIONS
	WHERE
		IdReservation = @IdReservation
END
GO

-- affiche livre
CREATE PROCEDURE AfficherLivre
    @IdLivre INT
AS
BEGIN
    -- Vérification que l'identifiant est valide
    IF @IdLivre IS NULL OR @IdLivre <= 0
    BEGIN
        PRINT 'Erreur : L identifiant du livre doit etre un nombre positif valide.' 
        RETURN 
    END 

    -- Vérification que le livre existe dans la base de données
    IF NOT EXISTS (SELECT 1 FROM TLIVRES WHERE IdLivre = @IdLivre)
    BEGIN
        PRINT 'Erreur : Le livre specifie n existe pas.' 
        RETURN 
    END 

    -- Sélection des informations du livre avec les données associées (auteurs, catégories, éditeurs)
    -- STUFF et FOR XML PATH sont utilisés pour concaténer les valeurs multiples en une seule chaîne
    SELECT 
        TLIVRES.IdLivre,
        TLIVRES.Titre,
        TLIVRES.ISBN,
        TLANGUES.NomLangue AS Langue,
        -- Concaténation des noms et prénoms de tous les auteurs du livre
        STUFF((
            SELECT DISTINCT ', ' + TAUTEURS.PrenomAuteur + ' ' + TAUTEURS.NomAuteur
            FROM TAUTEURS_LIVRES
            JOIN TAUTEURS ON TAUTEURS_LIVRES.IdAuteur = TAUTEURS.IdAuteur
            WHERE TAUTEURS_LIVRES.IdLivre = TLIVRES.IdLivre
            FOR XML PATH('')
        ), 1, 2, '') AS Auteurs,
        -- Concaténation de toutes les catégories du livre
        STUFF((
            SELECT DISTINCT ', ' + TCATEGORIES.NomCategorie
            FROM TCATEGORIES_LIVRES
            JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
            WHERE TCATEGORIES_LIVRES.IdLivre = TLIVRES.IdLivre
            FOR XML PATH('')
        ), 1, 2, '') AS Categories,
        -- Concaténation de tous les éditeurs du livre
        STUFF((
            SELECT DISTINCT ', ' + TEDITEURS.NomEditeur
            FROM TEDITEURS_LIVRES
            JOIN TEDITEURS ON TEDITEURS_LIVRES.IdEditeur = TEDITEURS.IdEditeur
            WHERE TEDITEURS_LIVRES.IdLivre = TLIVRES.IdLivre
            FOR XML PATH('')
        ), 1, 2, '') AS Editeurs,
        -- Calcul de la notation moyenne et du nombre d'avis
        AVG(TREVIEWS.Review) AS Reviews,
        COUNT(TREVIEWS.IdReview) AS NombreAvis
    FROM TLIVRES
    LEFT JOIN TLANGUES ON TLIVRES.IdLangue = TLANGUES.IdLangue
    LEFT JOIN TREVIEWS ON TLIVRES.IdLivre = TREVIEWS.IdLivre
    WHERE TLIVRES.IdLivre = @IdLivre
    GROUP BY TLIVRES.IdLivre, TLIVRES.Titre, TLIVRES.ISBN, TLANGUES.NomLangue 
END
GO


--- JOBS ---
CREATE PROCEDURE VerifierValiditeAbonnement
AS
BEGIN
  DECLARE Abonnement_curseur CURSOR FOR
  SELECT 
    IdAbonnement
  FROM
    TABONNEMENTS
  
  DECLARE @IdAbonnement AS INT
  OPEN Abonnement_curseur
  FETCH NEXT FROM Abonnement_curseur INTO @IdAbonnement
  WHILE @@FETCH_STATUS = 0
  BEGIN
    EXEC VerifierDateAbonnement @IdAbonnement
    FETCH NEXT FROM Abonnement_curseur INTO @IdAbonnement
  END
END
GO 

CREATE PROCEDURE VerifierReservationsDepassees
AS
BEGIN
    -- Mettre à jour directement les exemplaires dont les réservations ont expiré
    UPDATE TEXEMPLAIRES
    SET Disponibilite = 'disponible'
    WHERE Disponibilite = 'reserve'
    AND IdLivre IN (
        SELECT DISTINCT IdLivre
        FROM TRESERVATIONS
        WHERE DATEDIFF(DAY, DateReservation, GETDATE()) > 2
        AND NOT EXISTS (
            SELECT 1
            FROM TEMPRUNTS
            JOIN TABONNEMENTS ON  TEMPRUNTS.IdAbonnement = TABONNEMENTS.IdAbonnement
            JOIN TEXEMPLAIRES ON  TEMPRUNTS.IdExemplaire = TEXEMPLAIRES.IdExemplaire
            WHERE TEXEMPLAIRES.IdLivre = TRESERVATIONS.IdLivre
            AND TABONNEMENTS.IdAbonnement = TRESERVATIONS.IdAbonnement
            AND  TEMPRUNTS.DateEmprunt > TRESERVATIONS.DateReservation
        )
    )
    
    -- Supprimer les réservations expirées
    DELETE FROM TRESERVATIONS
    WHERE DATEDIFF(DAY, DateReservation, GETDATE()) > 7
    AND NOT EXISTS (
        SELECT 1
        FROM TEMPRUNTS
        JOIN TABONNEMENTS ON  TEMPRUNTS.IdAbonnement = TABONNEMENTS.IdAbonnement
        JOIN TEXEMPLAIRES ON  TEMPRUNTS.IdExemplaire = TEXEMPLAIRES.IdExemplaire
        WHERE TEXEMPLAIRES.IdLivre = TRESERVATIONS.IdLivre
        AND TABONNEMENTS.IdAbonnement = TRESERVATIONS.IdAbonnement
        AND  TEMPRUNTS.DateEmprunt > TRESERVATIONS.DateReservation
    ) 
END
GO

CREATE PROCEDURE VerifierEtAppliquerPenalites
AS
BEGIN
    DECLARE @IdAbonnement INT
    DECLARE @IdEmprunt INT
    DECLARE @Motif VARCHAR(20)
    DECLARE @DateRetour DATETIME
    DECLARE @NbJoursRetard INT
    
    -- Curseur pour parcourir tous les emprunts et vérifier les pénalités pour retard
    DECLARE penalite_cursor CURSOR FOR
    SELECT
        TEMPRUNTS.IdAbonnement, 
        TEMPRUNTS.IdEmprunt, 
        TEMPRUNTS.DateRetour
    FROM
        TEMPRUNTS
    WHERE
        TEMPRUNTS.DateRetour < GETDATE() -- Emprunts en retard
        AND TEMPRUNTS.DateRetour IS NOT NULL -- S'assurer que la date de retour est définie
        AND TEMPRUNTS.IdEmprunt NOT IN (SELECT IdEmprunt FROM TPENALITE WHERE Motif = 'retard') -- Éviter les doublons
    
    OPEN penalite_cursor
    FETCH NEXT FROM penalite_cursor INTO @IdAbonnement, @IdEmprunt, @DateRetour
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Calcul du retard
        SET @NbJoursRetard = DATEDIFF(DAY, @DateRetour, GETDATE())
        
        -- Si le retard est confirmé, ajouter la pénalité
        IF @NbJoursRetard > 0
        BEGIN
            -- Utiliser une procédure AjouterPenalite supposée existante
            EXEC AjouterPenalite @IdAbonnement, @IdEmprunt, 'retard'
        END
        
        FETCH NEXT FROM penalite_cursor INTO @IdAbonnement, @IdEmprunt, @DateRetour
    END
    
    CLOSE penalite_cursor
    DEALLOCATE penalite_cursor
END
GO


CREATE PROCEDURE AfficherTousLivres
AS
BEGIN
    -- Sélection de tous les livres avec les mêmes détails que la procédure AfficherLivre
    -- mais sans filtre sur l'identifiant
    SELECT 
        TLIVRES.IdLivre,
        TLIVRES.Titre,
        TLIVRES.ISBN,
        TLANGUES.NomLangue AS Langue,
        STUFF((
            SELECT DISTINCT ', ' + TAUTEURS.PrenomAuteur + ' ' + TAUTEURS.NomAuteur
            FROM TAUTEURS_LIVRES
            JOIN TAUTEURS ON TAUTEURS_LIVRES.IdAuteur = TAUTEURS.IdAuteur
            WHERE TAUTEURS_LIVRES.IdLivre = TLIVRES.IdLivre
            FOR XML PATH('')
        ), 1, 2, '') AS Auteurs,
        STUFF((
            SELECT DISTINCT ', ' + TCATEGORIES.NomCategorie
            FROM TCATEGORIES_LIVRES
            JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
            WHERE TCATEGORIES_LIVRES.IdLivre = TLIVRES.IdLivre
            FOR XML PATH('')
        ), 1, 2, '') AS Categories,
        STUFF((
            SELECT DISTINCT ', ' + TEDITEURS.NomEditeur
            FROM TEDITEURS_LIVRES
            JOIN TEDITEURS ON TEDITEURS_LIVRES.IdEditeur = TEDITEURS.IdEditeur
            WHERE TEDITEURS_LIVRES.IdLivre = TLIVRES.IdLivre
            FOR XML PATH('')
        ), 1, 2, '') AS Editeurs,
        AVG(TREVIEWS.Review) AS Reviews,
        COUNT(TREVIEWS.IdReview) AS NombreAvis
    FROM TLIVRES
    LEFT JOIN TLANGUES ON TLIVRES.IdLangue = TLANGUES.IdLangue
    LEFT JOIN TREVIEWS ON TLIVRES.IdLivre = TREVIEWS.IdLivre
    GROUP BY TLIVRES.IdLivre, TLIVRES.Titre, TLIVRES.ISBN, TLANGUES.NomLangue
    ORDER BY TLIVRES.Titre 
END
GO


-- ADDING CLIENTS
EXEC AjouterTypeAbonnement 'personnel', 5, 12, 100;
EXEC AjouterTypeAbonnement 'éducation', 5, 12, 75;
EXEC AjouterTypeAbonnement 'famille', 10, 12, 125;