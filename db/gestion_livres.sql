
-- AjouterLivre
CREATE PROCEDURE AjouterLivre
    @Titre VARCHAR(100),
    @ISBN VARCHAR(20),
    @IdLangue INT,
    @NomAuteur VARCHAR(50),
    @PrenomAuteur VARCHAR(50),
    @Categorie NVARCHAR(50),
    @NomEditeur NVARCHAR(50)
AS
BEGIN

    DECLARE @IdAuteur INT;
    DECLARE @IdLivre INT;
    DECLARE @IdCategorie INT;
    DECLARE @IdEditeur INT;

    IF @IdLangue IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM TLANGUES WHERE IdLangue = @IdLangue
    )
    BEGIN
        PRINT 'Erreur : La langue specifiee n existe pas.';
        RETURN;
    END;

    EXEC AjouterAuteur @NomAuteur, @PrenomAuteur;
    SELECT @IdAuteur = IdAuteur
    FROM TAUTEURS
    WHERE NomAuteur = LOWER(dbo.Trim(@NomAuteur))
      AND PrenomAuteur = LOWER(dbo.Trim(@PrenomAuteur));

    EXEC AjouterCategorie @Categorie;
    SELECT @IdCategorie = IdCategorie
    FROM TCATEGORIES
    WHERE NomCategorie = LOWER(dbo.Trim(@Categorie));

    EXEC AjouterEditeur @NomEditeur;
    SELECT @IdEditeur = IdEditeur
    FROM TEDITEURS
    WHERE NomEditeur = LOWER(dbo.Trim(@NomEditeur));

    INSERT INTO TLIVRES (Titre, ISBN, IdLangue)
    VALUES (@Titre, @ISBN, @IdLangue);
    SET @IdLivre = SCOPE_IDENTITY();

    EXEC AssocierAuteurLivre @IdLivre, @IdAuteur;
    EXEC AssocierCategorieLivre @IdLivre, @IdCategorie;
    EXEC AssocierEditeurLivre @IdLivre, @IdEditeur;
END;
GO

-- ModifierLivre 
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

    IF @ISBN IS NOT NULL AND EXISTS (
        SELECT 1 FROM TLIVRES WHERE ISBN = @ISBN AND IdLivre <> @IdLivre
    )
    BEGIN
        PRINT 'Erreur : L ISBN existe deja pour un autre livre.';
        RETURN;
    END;

    UPDATE TLIVRES
    SET Titre = COALESCE(@Titre, Titre),
        ISBN = COALESCE(@ISBN, ISBN),
        IdLangue = COALESCE(@IdLangue, IdLangue)
    WHERE IdLivre = @IdLivre;

    -- update l auteur
    IF @NomAuteur IS NOT NULL AND @PrenomAuteur IS NOT NULL
    BEGIN
        DECLARE @IdAuteur INT;
        
        -- verifier si l auteur existe
        SELECT @IdAuteur = IdAuteur
        FROM TAUTEURS
        WHERE NomAuteur = LOWER(dbo.Trim(@NomAuteur))
          AND PrenomAuteur = LOWER(dbo.Trim(@PrenomAuteur));

        IF @IdAuteur IS NULL
        BEGIN
            EXEC AjouterAuteur @NomAuteur, @PrenomAuteur;
            SELECT @IdAuteur = IdAuteur
            FROM TAUTEURS
            WHERE NomAuteur = LOWER(dbo.Trim(@NomAuteur))
              AND PrenomAuteur = LOWER(dbo.Trim(@PrenomAuteur));
        END;

        -- supprimer old auteur associe
        DELETE FROM TAUTEURS_LIVRES WHERE IdLivre = @IdLivre;
        EXEC AssocierAuteurLivre @IdLivre, @IdAuteur;
    END;

    -- uupdate categorie
    IF @Categorie IS NOT NULL
    BEGIN
        DECLARE @IdCategorie INT;

        -- verifier si la catgorie existe
        SELECT @IdCategorie = IdCategorie
        FROM TCATEGORIES
        WHERE NomCategorie = LOWER(dbo.Trim(@Categorie));

        -- si elle existe pas l ajouter
        IF @IdCategorie IS NULL
        BEGIN
            EXEC AjouterCategorie @Categorie;
            SELECT @IdCategorie = IdCategorie
            FROM TCATEGORIES
            WHERE NomCategorie = LOWER(dbo.Trim(@Categorie));
        END;

        -- supprimer old categorie associee
        DELETE FROM TLIVRES_CATEGORIES WHERE IdLivre = @IdLivre;
        EXEC AssocierCategorieLivre @IdLivre, @IdCategorie;
    END;

    -- update editeur
    IF @NomEditeur IS NOT NULL
    BEGIN
        DECLARE @IdEditeur INT;

        -- virifier si editeur existe
        SELECT @IdEditeur = IdEditeur
        FROM TEDITEURS
        WHERE NomEditeur = LOWER(dbo.Trim(@NomEditeur));

        -- si editeur n existe pas l ajouter
        IF @IdEditeur IS NULL
        BEGIN
            EXEC AjouterEditeur @NomEditeur;
            SELECT @IdEditeur = IdEditeur
            FROM TEDITEURS
            WHERE NomEditeur = LOWER(dbo.Trim(@NomEditeur));
        END;

        -- supprimer ancien editeur associe
        DELETE FROM EDITEURS_LIVRES WHERE IdLivre = @IdLivre;
        EXEC AssocierEditeurLivre @IdLivre, @IdEditeur;
    END;

    -- update la langue
    IF @IdLangue IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM TLANGUES WHERE IdLangue = @IdLangue
    )
    BEGIN
        PRINT 'Erreur : La langue specifiee n existe pas.';
        RETURN;
    END;
END;
GO


    -- Update editor association if a new editor is provided
    IF @NomEditeur IS NOT NULL
    BEGIN
        EXEC AjouterEditeur @NomEditeur;
        DECLARE @IdEditeur INT;
        SELECT @IdEditeur = IdEditeur
        FROM TEDITEURS
        WHERE NomEditeur = LOWER(dbo.Trim(@NomEditeur));

        DELETE FROM EDITEURS_LIVRES WHERE IdLivre = @IdLivre;
        EXEC AssocierEditeurLivre @IdLivre, @IdEditeur;
    END
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


-- AjouterAuteur
CREATE PROCEDURE AjouterAuteur
    @NomAuteur VARCHAR(50),
    @PrenomAuteur VARCHAR(50)

AS
BEGIN
    IF dbo.Validate_empty(@NomAuteur) = 0 OR dbo.Validate_empty(@PrenomAuteur) = 0
    BEGIN
        PRINT 'L entree est vide. Veuillez fournir un nom et prenom valide.';
        RETURN;
    END

    DECLARE @Nom NVARCHAR(50);
    DECLARE @Prenom NVARCHAR(50);

    SET @Nom = LOWER(dbo.Trim(@NomAuteur));
    SET @Prenom = LOWER(dbo.Trim(@PrenomAuteur));

    IF NOT EXISTS (SELECT 1 FROM TAUTEURS WHERE NomAuteur = @Nom AND PrenomAuteur = @Prenom)
    BEGIN
        INSERT INTO TAUTEURS(NomAuteur, PrenomAuteur)
        VALUES (@Nom, @Prenom);
        PRINT 'L auteurs ' + @Editeur + ' a ete ajoute avec succes';
    END
    ELSE
    BEGIN
        PRINT 'L auteurs ' + @Editeur + ' existe deja';
    END

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

-- ModifierAuteur
CREATE PROCEDURE ModifierAuteur
    @IdAuteur INT,
    @NomAuteur VARCHAR(50),
    @PrenomAuteur VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE TAUTEURS
    SET NomAuteur = LOWER(dbo.Trim(@NomAuteur)),
        PrenomAuteur = LOWER(dbo.Trim(@PrenomAuteur))
    WHERE IdAuteur = @IdAuteur;
END;
GO

-- SupprimerAuteur
CREATE PROCEDURE SupprimerAuteur
    @IdAuteur INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM TAUTEURS WHERE IdAuteur = @IdAuteur;
END;
GO

-- AjouterEditeur
CREATE PROCEDURE AjouterEditeur
    @NomEditeur VARCHAR(50)

AS
BEGIN
    IF dbo.Validate_empty(@NomEditeur) = 0
    BEGIN
        PRINT 'L entree est vide. Veuillez fournir un nom valide.';
        RETURN;
    END

    DECLARE @Editeur NVARCHAR(50);

    SET @Editeur = LOWER(dbo.Trim(@NomEditeur));

    IF NOT EXISTS (SELECT 1 FROM TEDITEURS WHERE NomEditeur = @Editeur)
    BEGIN
        INSERT INTO TEDITEURS(NomEditeur)
        VALUES (@Editeur);
        PRINT 'L editeur ' + @Editeur + ' a ete ajoute avec succes';
    END
    ELSE
    BEGIN
        PRINT 'L editeur ' + @Editeur + ' existe deja';
    END

END;
GO

-- AssocierEditeurLivre
CREATE PROCEDURE AssocierEditeurLivre
    @IdLivre INT,
    @IdEditeur INT
AS
BEGIN
    INSERT INTO TEDITEURS_LIVRES (IdEditeur, IdLivre)
    VALUES (@IdEditeur, @IdLivre);
END;
GO

-- ModifierEditeur
CREATE PROCEDURE ModifierEditeur
    @IdEditeur INT,
    @NomEditeur VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE TEDITEURS
    SET NomEditeur = LOWER(dbo.Trim(@NomEditeur))
    WHERE IdEditeur = @IdEditeur;
END;
GO

-- SupprimerEditeur
CREATE PROCEDURE SupprimerEditeur
    @IdEditeur INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM TEDITEURS WHERE IdEditeur = @IdEditeur;
END;
GO

-- AjouterCategorie
CREATE PROCEDURE AjouterCategorie
    @NomCategorie VARCHAR(50)

AS
BEGIN
    IF dbo.Validate_empty(@NomCategorie) = 0
    BEGIN
        PRINT 'L entree est vide. Veuillez fournir un categorie valide.';
        RETURN;
    END

    DECLARE @Categorie NVARCHAR(50);

    SET @Categorie = LOWER(dbo.Trim(@NomCategorie));

    IF NOT EXISTS (SELECT 1 FROM TCATEGORIES WHERE NomCategorie = @Categorie)
    BEGIN
        INSERT INTO TCATEGORIES(NomCategorie)
        VALUES (@Categorie);
        PRINT 'La Categorie ' + @Categorie + ' a ete ajoute avec succes';
    END
    ELSE
    BEGIN
        PRINT 'La Categorie ' + @Categorie + ' existe deja';
    END

END;
GO

-- AssocierCategorieLivre
CREATE PROCEDURE AssocierCategorieLivre
    @IdLivre INT,
    @IdCategorie INT
AS
BEGIN
    INSERT INTO TCATEGORIES_LIVRES (IdCategorie, IdLivre)
    VALUES (@IdCategorie, @IdLivre);
END;
GO

-- ModifierCategorie
CREATE PROCEDURE ModifierCategorie
    @IdCategorie INT,
    @NomCategorie VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE TCATEGORIES
    SET NomCategorie = LOWER(dbo.Trim(@NomCategorie))
    WHERE IdCategorie = @IdCategorie;
END;
GO


-- SupprimerCategorie
CREATE PROCEDURE SupprimerCategorie
    @IdCategorie INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM TCATEGORIES WHERE IdCategorie = @IdCategorie;
END;
GO