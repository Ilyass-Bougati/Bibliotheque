-- AjouterLivre
CREATE PROCEDURE AjouterLivre
    @Titre VARCHAR(100),
    @ISBN VARCHAR(20),
    @IdLangue INT,
    @NomAuteur VARCHAR(50),
    @PrenomAuteur VARCHAR(50),
    @Categorie NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @IdAuteur INT;
    DECLARE @IdLivre INT;
    DECLARE @IdCategorie INT;
    
    -- Vérifie si l'auteur existe déjà
    SELECT @IdAuteur = IdAuteur
    FROM TAUTEURS
    WHERE NomAuteur = @NomAuteur AND PrenomAuteur = @PrenomAuteur;
    
    -- S'il n'existe pas, insère l'auteur dans TAUTEURS
    IF @IdAuteur IS NULL
    BEGIN
        INSERT INTO TAUTEURS (NomAuteur, PrenomAuteur)
        VALUES (@NomAuteur, @PrenomAuteur);
        SET @IdAuteur = SCOPE_IDENTITY(); -- SCOPE_IDENTITY() retourne la dernière valeur IDENTITY insérée.
    END;

    -- Vérifie si la catégorie existe déjà
    SELECT @IdCategorie = IdCategorie
    FROM TCATEGORIES
    WHERE NomCategorie = @Categorie;
    
    -- Si elle n'existe pas, insère la catégorie dans TCATEGORIES
    IF @IdCategorie IS NULL
    BEGIN
        INSERT INTO TCATEGORIES (NomCategorie)
        VALUES (@Categorie);
        SET @IdCategorie = SCOPE_IDENTITY();
    END;

    -- Insère le livre dans TLIVRES
    INSERT INTO TLIVRES (Titre, ISBN, IdLangue)
    VALUES (@Titre, @ISBN, @IdLangue);
    
    SET @IdLivre = SCOPE_IDENTITY();
    
    -- Établit la relation entre le livre et l'auteur dans TAUTEURS_LIVRES
    INSERT INTO TAUTEURS_LIVRES (IdAuteur, IdLivre)
    VALUES (@IdAuteur, @IdLivre);

    -- Établit la relation entre le livre et la catégorie dans TLIVRES_CATEGORIES
    INSERT INTO TLIVRES_CATEGORIES (IdLivre, IdCategorie)
    VALUES (@IdLivre, @IdCategorie);
    
END;
GO

-- ModifierLivre 
CREATE PROCEDURE ModifierLivre
    @IdLivre INT,
    @Titre VARCHAR(100) = NULL,
    @ISBN VARCHAR(20) = NULL,
    @IdLangue INT = NULL
AS
BEGIN
    UPDATE TLIVRES
    SET 
        Titre = COALESCE(@Titre, Titre), -- La fonction COALESCE() renvoie la première valeur non NULL parmi ses arguments.
        ISBN = COALESCE(@ISBN, ISBN),   -- Dans notre procédure, elle permet de conserver la valeur actuelle de la colonne 
        IdLangue = COALESCE(@IdLangue, IdLangue)-- si le paramètre correspondant est NULL. Ainsi, seules les colonnes dont une nouvelle 
                                                -- valeur est fournie seront mises à jour.
    WHERE IdLivre = @IdLivre;
END;
GO

-- SupprimerLivre
CREATE PROCEDURE SupprimerLivre
    @IdLivre INT
AS
BEGIN
    DELETE FROM TLIVRES WHERE IdLivre = @IdLivre;
END;
Go

-- AssocierCategorieLivre
CREATE PROCEDURE AssocierCategorieLivre
    @IdLivre INT,
    @idCategorie INT
AS
BEGIN
    INSERT INTO TCATEGORIES_LIVRES (idCategorie, IdLivre)
    VALUES (@idCategorie, @IdLivre);
END;
GO


-- AssocierAuteurLivre
CREATE PROCEDURE AssocierAuteurLivre
    @IdLivre INT,
    @IdAuteur INT
AS
BEGIN
    INSERT INTO TAUTEURS_LIVRES (IdAuteur, IdLivre)
    VALUES (@IdAuteur, @IdLivre);
END;
GO