
-- AjouterLivre
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

    DECLARE @IdAuteur INT;
    DECLARE @IdLivre INT;
    DECLARE @IdCategorie INT;
    DECLARE @IdEditeur INT;
    DECLARE @IdLangue INT;

    IF dbo.Validate_empty(@Titre) = 0
    BEGIN
        PRINT 'Erreur : Le titre du livre ne peut pas etre vide.';
        RETURN;
    END;

    IF dbo.Validate_empty(@ISBN) = 0
    BEGIN
        PRINT 'Erreur : L ISBN ne peut pas etre vide.';
        RETURN;
    END;

    IF dbo.Validate_empty(@NomAuteur) = 0
    BEGIN
        PRINT 'Erreur : Le nom de l auteur ne peut pas etre vide.';
        RETURN;
    END;

    IF dbo.Validate_empty(@PrenomAuteur) = 0
    BEGIN
        PRINT 'Erreur : Le prenom de l auteur ne peut pas etre vide.';
        RETURN;
    END;

    IF dbo.Validate_empty(@Categorie) = 0
    BEGIN
        PRINT 'Erreur : La categorie ne peut pas etre vide.';
        RETURN;
    END;

    IF dbo.Validate_empty(@NomEditeur) = 0
    BEGIN
        PRINT 'Erreur : Le nom de l editeur ne peut pas etre vide.';
        RETURN;
    END;

    IF dbo.Validate_ISBN(dbo.Trim(@ISBN)) = 0
    BEGIN
    PRINT 'Erreur : Format ISBN invalide.';
    RETURN;
    END;

    IF dbo.Validate_empty(@NomLangue) = 1
    BEGIN
        
        SELECT @IdLangue = IdLangue
        FROM TLANGUES
        WHERE NomLangue = LOWER(dbo.Trim(@NomLangue));
        
        IF @IdLangue IS NULL
        BEGIN
            EXEC AjouterLangue @NomLangue;
            
            SELECT @IdLangue = IdLangue
            FROM TLANGUES
            WHERE NomLangue = LOWER(dbo.Trim(@NomLangue));
        END;
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
        DELETE FROM TCATEGORIES_LIVRES WHERE IdLivre = @IdLivre;
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
        DELETE FROM TEDITEURS_LIVRES WHERE IdLivre = @IdLivre;
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

    IF @NomEditeur IS NOT NULL
    BEGIN
        EXEC AjouterEditeur @NomEditeur;
        DECLARE @IdEditeur INT;
        SELECT @IdEditeur = IdEditeur
        FROM TEDITEURS
        WHERE NomEditeur = LOWER(dbo.Trim(@NomEditeur));

        DELETE FROM TEDITEURS_LIVRES WHERE IdLivre = @IdLivre;
        EXEC AssocierEditeurLivre @IdLivre, @IdEditeur;
    END
END;
GO

-- SupprimerLivre
CREATE PROCEDURE SupprimerLivre
    @IdLivre INT
AS
BEGIN
    IF @IdLivre IS NULL OR @IdLivre <= 0
    BEGIN
        PRINT 'Erreur : L identifiant de la livre doit etre un nombre positif valide.';
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;
        
        IF NOT EXISTS (SELECT 1 FROM TLIVRES WHERE IdLivre = @IdLivre)
        BEGIN
            PRINT 'Erreur : Le livre specifie n existe pas.';
            ROLLBACK;
            RETURN;
        END;
        
        DECLARE @Titre VARCHAR(100);
        SELECT @Titre = Titre FROM TLIVRES WHERE IdLivre = @IdLivre;
        
        DELETE FROM TAUTEURS_LIVRES WHERE IdLivre = @IdLivre;
        DELETE FROM TCATEGORIES_LIVRES WHERE IdLivre = @IdLivre;
        DELETE FROM TEDITEURS_LIVRES WHERE IdLivre = @IdLivre;
        
        DELETE FROM TLIVRES WHERE IdLivre = @IdLivre;
        
        COMMIT;
        PRINT 'Le livre "' + @Titre + '" a ete supprime avec succes.';
    END TRY
    BEGIN CATCH
        ROLLBACK;
        PRINT 'Erreur lors de la suppression du livre : ' + ERROR_MESSAGE();
    END CATCH
END;
GO

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
    IF dbo.Validate_empty(@NomAuteur) = 0
    BEGIN
        PRINT 'Erreur : Le non de l auteur du livre ne peut pas etre vide.';
        RETURN;
    END
    IF dbo.Validate_empty(@PrenomAuteur) = 0
    BEGIN
        PRINT 'Erreur : Le prenon de l auteur du livre ne peut pas etre vide.';
        RETURN;
    END
    UPDATE TAUTEURS
    SET NomAuteur = LOWER(dbo.Trim(@NomAuteur)),
        PrenomAuteur = LOWER(dbo.Trim(@PrenomAuteur))
    WHERE IdAuteur = @IdAuteur;
END;
GO

-- SupprimerAuteur
CREATE PROCEDURE SupprimerCategorie
    @IdCategorie INT
AS
BEGIN
    
    IF @IdCategorie IS NULL OR @IdCategorie <= 0
    BEGIN
        PRINT 'Erreur : L identifiant de la categorie doit etre un nombre positif valide.';
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;
        
        IF NOT EXISTS (SELECT 1 FROM TCATEGORIES WHERE IdCategorie = @IdCategorie)
        BEGIN
            PRINT 'Erreur : La categorie specifiee n existe pas.';
            ROLLBACK;
            RETURN;
        END;
        
        DECLARE @NomCategorie VARCHAR(50);
        SELECT @NomCategorie = NomCategorie FROM TCATEGORIES WHERE IdCategorie = @IdCategorie;
        
        IF EXISTS (SELECT 1 FROM TCATEGORIES_LIVRES WHERE IdCategorie = @IdCategorie)
        BEGIN
            PRINT 'Erreur : Impossible de supprimer cette categorie car elle est utilisee par des livres.';
            PRINT 'Nombre de livres concernés : ' + CAST((SELECT COUNT(*) FROM TCATEGORIES_LIVRES WHERE IdCategorie = @IdCategorie) AS VARCHAR);
            ROLLBACK;
            RETURN;
        END;
        
        DELETE FROM TCATEGORIES WHERE IdCategorie = @IdCategorie;
        
        COMMIT;
        PRINT 'La categorie "' + @NomCategorie + '" a ete supprimee avec succes.';
    END TRY
    BEGIN CATCH
        ROLLBACK;
        PRINT 'Erreur lors de la suppression de la categorie : ' + ERROR_MESSAGE();
    END CATCH
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
    INSERT INTO TTEDITEURS_LIVRES (IdEditeur, IdLivre)
    VALUES (@IdEditeur, @IdLivre);
END;
GO

-- ModifierEditeur
CREATE PROCEDURE ModifierEditeur
    @IdEditeur INT,
    @NomEditeur VARCHAR(50)
AS
BEGIN
    IF dbo.Validate_empty(@NomEditeur) = 0
    BEGIN
        PRINT 'Erreur : Le titre Editeur du livre ne peut pas etre vide.';
        RETURN;
    END

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
    IF @IdEditeur IS NULL OR @IdEditeur <= 0
    BEGIN
        PRINT 'Erreur : L identifiant de la livre doit etre un nombre positif valide.';
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;
        
        IF NOT EXISTS (SELECT 1 FROM TEDITEURS WHERE IdEditeur = @IdEditeur)
        BEGIN
            PRINT 'Erreur : L editeur specifie n existe pas.';
            ROLLBACK;
            RETURN;
        END;
        

        DECLARE @NomEditeur VARCHAR(50);
        SELECT @NomEditeur = NomEditeur FROM TEDITEURS WHERE IdEditeur = @IdEditeur;
        
        IF EXISTS (SELECT 1 FROM TEDITEURS_LIVRES WHERE IdEditeur = @IdEditeur)
        BEGIN
            PRINT 'Erreur : Impossible de supprimer cet diteur car il est utilise par des livres.';
            PRINT 'Nombre de livres concernes : ' + CAST((SELECT COUNT(*) FROM TEDITEURS_LIVRES WHERE IdEditeur = @IdEditeur) AS VARCHAR);
            ROLLBACK;
            RETURN;
        END;
        
        DELETE FROM TEDITEURS WHERE IdEditeur = @IdEditeur;
        
        COMMIT;
        PRINT 'L editeur "' + @NomEditeur + '" a ete supprime avec succes.';
    END TRY
    BEGIN CATCH
        ROLLBACK;
        PRINT 'Erreur lors de la suppression de l editeur : ' + ERROR_MESSAGE();
    END CATCH
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
    IF dbo.Validate_empty(@NomCategorie) = 0
    BEGIN
        PRINT 'Erreur : La Categorie du livre ne peut pas etre vide.';
        RETURN;
    END
    UPDATE TCATEGORIES
    SET NomCategorie = LOWER(dbo.Trim(@NomCategorie))
    WHERE IdCategorie = @IdCategorie;
END;
GO


-- SupprimerCategorie
CREATE PROCEDURE SupprimerAuteur
    @IdAuteur INT
AS
BEGIN
    IF @IdAuteur IS NULL OR @IdAuteur <= 0
    BEGIN
        PRINT 'Erreur : L identifiant de l auteur doit etre un nombre positif valide.';
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;
        
        IF NOT EXISTS (SELECT 1 FROM TAUTEURS WHERE IdAuteur = @IdAuteur)
        BEGIN
            PRINT 'Erreur : L auteur specifie n existe pas.';
            ROLLBACK;
            RETURN;
        END;
        
        DECLARE @NomAuteur VARCHAR(50);
        DECLARE @PrenomAuteur VARCHAR(50);
        SELECT @NomAuteur = NomAuteur, @PrenomAuteur = PrenomAuteur 
        FROM TAUTEURS WHERE IdAuteur = @IdAuteur;
        
        IF EXISTS (SELECT 1 FROM TAUTEURS_LIVRES WHERE IdAuteur = @IdAuteur)
        BEGIN
            PRINT 'Erreur : Impossible de supprimer cet auteur car il est associe a des livres.';
            PRINT 'Nombre de livres concernes : ' + CAST((SELECT COUNT(*) FROM TAUTEURS_LIVRES WHERE IdAuteur = @IdAuteur) AS VARCHAR);
            ROLLBACK;
            RETURN;
        END;
        
        DELETE FROM TAUTEURS WHERE IdAuteur = @IdAuteur;
        
        COMMIT;
        PRINT 'L auteur "' + @PrenomAuteur + ' ' + @NomAuteur + '" a ete supprime avec succes.';
    END TRY
    BEGIN CATCH
        ROLLBACK;
        PRINT 'Erreur lors de la suppression de l auteur : ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- AjouterLangue
CREATE PROCEDURE AjouterLangue
    @NomLangue VARCHAR(50)
AS
BEGIN
    
    IF dbo.Validate_empty(@NomLangue) = 0
    BEGIN
        PRINT 'L entree est vide. Veuillez fournir un nom de langue valide.';
        RETURN;
    END
    
    DECLARE @Langue VARCHAR(50) = LOWER(dbo.Trim(@NomLangue));
    
    IF NOT EXISTS (SELECT 1 FROM TLANGUES WHERE LOWER(NomLangue) = @Langue)
    BEGIN
        INSERT INTO TLANGUES (NomLangue)
        VALUES (@Langue);
        PRINT 'La langue ' + @NomLangue + ' a ete ajoutee avec succes.';
    END
    ELSE
    BEGIN
        PRINT 'La langue ' + @NomLangue + ' existe deja.';
    END
END
GO

-- ModifierLangue
CREATE PROCEDURE ModifierLangue
    @IdLangue INT,
    @NomLangue VARCHAR(50)
AS
BEGIN
    
    IF NOT EXISTS (SELECT 1 FROM TLANGUES WHERE IdLangue = @IdLangue)
    BEGIN
        PRINT 'Erreur : La langue specifiee n existe pas.';
        RETURN;
    END
    
    IF dbo.Validate_empty(@NomLangue) = 0
    BEGIN
        PRINT 'L entree est vide. Veuillez fournir un nom de langue valide.';
        RETURN;
    END
    
    DECLARE @Langue VARCHAR(50) = LOWER(dbo.Trim(@NomLangue));
    
    IF EXISTS (SELECT 1 FROM TLANGUES WHERE LOWER(NomLangue) = @Langue AND IdLangue <> @IdLangue)
    BEGIN
        PRINT 'Erreur : Une langue avec ce nom existe deja.';
        RETURN;
    END
    
    UPDATE TLANGUES
    SET NomLangue = @Langue
    WHERE IdLangue = @IdLangue;
    
    PRINT 'La langue a ete modifiee avec succes.';
END;
GO

-- SupprimerLangue
CREATE PROCEDURE SupprimerLangue
    @IdLangue INT
AS
BEGIN
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        IF NOT EXISTS (SELECT 1 FROM TLANGUES WHERE IdLangue = @IdLangue)
        BEGIN
            PRINT 'Erreur : La langue specifiee n existe pas.';
            ROLLBACK;
            RETURN;
        END
        
        IF EXISTS (SELECT 1 FROM TLIVRES WHERE IdLangue = @IdLangue)
        BEGIN
            PRINT 'Erreur : Impossible de supprimer cette langue car elle est utilisee par des livres.';
            PRINT 'Nombre de livres concernes : ' + CAST((SELECT COUNT(*) FROM TLIVRES WHERE IdLangue = @IdLangue) AS VARCHAR);
            ROLLBACK;
            RETURN;
        END
        
        DELETE FROM TLANGUES WHERE IdLangue = @IdLangue;
        
        COMMIT;
        PRINT 'La langue a ete supprimee avec succes.';
    END TRY
    BEGIN CATCH
        ROLLBACK;
        PRINT 'Erreur lors de la suppression de la langue : ' + ERROR_MESSAGE();
    END CATCH
END;
GO