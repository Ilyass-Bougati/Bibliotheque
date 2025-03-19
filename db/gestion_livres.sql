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

    -- Vérification du format de l'ISBN
    IF dbo.Validate_ISBN(dbo.Trim(@ISBN)) = 0
    BEGIN
        PRINT 'Erreur : Format ISBN invalide.' 
        RETURN 
    END 

    BEGIN TRY
        BEGIN TRANSACTION
            IF dbo.Validate_empty(@NomLangue) = 1 -- Si le nom de la langue n'est pas vide
            BEGIN
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
        SELECT 1 FROM TLIVRES WHERE ISBN = @ISBN AND IdLivre <> @IdLivre
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
    IF EXISTS (SELECT 1 FROM TLANGUES WHERE LOWER(NomLangue) = @Langue AND IdLangue <> @IdLangue)
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

