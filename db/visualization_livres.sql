-- =============================================
-- Procédure : AfficherLivre
-- Description : Affiche les détails d'un livre spécifique à partir de son identifiant
-- Paramètres : @IdLivre - Identifiant unique du livre à afficher
-- =============================================
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

-- =============================================
-- Procédure : AfficherTousLivres
-- Description : Affiche tous les livres de la bibliothèque avec leurs détails
-- Paramètres : Aucun
-- =============================================
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
        AVG(TREVIEWS.Notation) AS NotationMoyenne,
        COUNT(TREVIEWS.IdReview) AS NombreAvis
    FROM TLIVRES
    LEFT JOIN TLANGUES ON TLIVRES.IdLangue = TLANGUES.IdLangue
    LEFT JOIN TREVIEWS ON TLIVRES.IdLivre = TREVIEWS.IdLivre
    GROUP BY TLIVRES.IdLivre, TLIVRES.Titre, TLIVRES.ISBN, TLANGUES.NomLangue
    ORDER BY TLIVRES.Titre 
END
GO

-- =============================================
-- Procédure : AfficherLivresParAuteur
-- Description : Affiche tous les livres écrits par un auteur spécifique
-- Paramètres : 
--   @IdAuteur - Identifiant de l'auteur (optionnel si nom/prénom fourni)
--   @NomAuteur - Nom de l'auteur (optionnel si ID fourni)
--   @PrenomAuteur - Prénom de l'auteur (optionnel si ID fourni)
-- =============================================
CREATE PROCEDURE AfficherLivresParAuteur
    @IdAuteur INT = NULL,
    @NomAuteur VARCHAR(50) = NULL,
    @PrenomAuteur VARCHAR(50) = NULL
AS
BEGIN
    -- Vérification que soit l'ID, soit le nom et prénom sont fournis
    IF @IdAuteur IS NULL AND (@NomAuteur IS NULL OR @PrenomAuteur IS NULL)
    BEGIN
        PRINT 'Erreur : Veuillez fournir soit l identifiant de l auteur, soit son nom et prenom.'
        RETURN
    END

    -- Si l'ID n'est pas fourni mais que le nom et prénom le sont, recherche de l'ID correspondant
    IF @IdAuteur IS NULL AND @NomAuteur IS NOT NULL AND @PrenomAuteur IS NOT NULL
    BEGIN
        SELECT @IdAuteur = IdAuteur 
        FROM TAUTEURS 
        WHERE NomAuteur = LOWER(dbo.Trim(@NomAuteur)) 
          AND PrenomAuteur = LOWER(dbo.Trim(@PrenomAuteur)) 
        
         -- Vérification que l'auteur existe
        IF @IdAuteur IS NULL
        BEGIN
            PRINT 'Erreur : Auteur non trouve.' 
            RETURN 
        END 
    END 

    -- Sélection des livres écrits par l'auteur spécifié
    SELECT 
        TLIVRES.IdLivre,
        TLIVRES.Titre,
        TLIVRES.ISBN,
        TLANGUES.NomLangue AS Langue,
        -- Concaténation des catégories du livre
        STUFF((
            SELECT DISTINCT ', ' + TCATEGORIES.NomCategorie
            FROM TCATEGORIES_LIVRES
            JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
            WHERE TCATEGORIES_LIVRES.IdLivre = TLIVRES.IdLivre
            FOR XML PATH('')
        ), 1, 2, '') AS Categories,
        -- Concaténation des éditeurs du livre
        STUFF((
            SELECT DISTINCT ', ' + TEDITEURS.NomEditeur
            FROM TEDITEURS_LIVRES
            JOIN TEDITEURS ON TEDITEURS_LIVRES.IdEditeur = TEDITEURS.IdEditeur
            WHERE TEDITEURS_LIVRES.IdLivre = TLIVRES.IdLivre
            FOR XML PATH('')
        ), 1, 2, '') AS Editeurs
    FROM TLIVRES
    JOIN TAUTEURS_LIVRES ON TLIVRES.IdLivre = TAUTEURS_LIVRES.IdLivre
    JOIN TAUTEURS ON TAUTEURS_LIVRES.IdAuteur = TAUTEURS.IdAuteur
    LEFT JOIN TLANGUES ON TLIVRES.IdLangue = TLANGUES.IdLangue
    WHERE TAUTEURS.IdAuteur = @IdAuteur
    GROUP BY TLIVRES.IdLivre, TLIVRES.Titre, TLIVRES.ISBN, TLANGUES.NomLangue
    ORDER BY TLIVRES.Titre 
    
    -- Affichage des informations sur l'auteur, notamment le nombre total de livres
    SELECT 
        TAUTEURS.IdAuteur,
        TAUTEURS.NomAuteur,
        TAUTEURS.PrenomAuteur,
        COUNT(DISTINCT TAUTEURS_LIVRES.IdLivre) AS NombreDeLivres
    FROM TAUTEURS
    LEFT JOIN TAUTEURS_LIVRES ON TAUTEURS.IdAuteur = TAUTEURS_LIVRES.IdAuteur
    WHERE TAUTEURS.IdAuteur = @IdAuteur
    GROUP BY TAUTEURS.IdAuteur, TAUTEURS.NomAuteur, TAUTEURS.PrenomAuteur 
END 
GO

-- =============================================
-- Procédure : AfficherLivresParCategorie
-- Description : Affiche tous les livres d'une catégorie spécifique
-- Paramètres : 
--   @IdCategorie - Identifiant de la catégorie (optionnel si nom fourni)
--   @NomCategorie - Nom de la catégorie (optionnel si ID fourni)
-- =============================================
CREATE PROCEDURE AfficherLivresParCategorie
    @IdCategorie INT = NULL,
    @NomCategorie VARCHAR(50) = NULL
AS
BEGIN
    -- Vérification qu'au moins un des deux paramètres est fourni
    IF @IdCategorie IS NULL AND @NomCategorie IS NULL
    BEGIN
        PRINT 'Erreur : Veuillez fournir soit l identifiant de la categorie, soit son nom.' 
        RETURN 
    END 

    -- Si l'ID n'est pas fourni mais que le nom l'est, recherche de l'ID correspondant
    IF @IdCategorie IS NULL AND @NomCategorie IS NOT NULL
    BEGIN
        SELECT @IdCategorie = IdCategorie 
        FROM TCATEGORIES 
        WHERE NomCategorie = LOWER(dbo.Trim(@NomCategorie)) 
        
        -- Vérification que la catégorie existe
        IF @IdCategorie IS NULL
        BEGIN
            PRINT 'Erreur : Categorie non trouvee.' 
            RETURN 
        END 
    END 

    -- Sélection des livres appartenant à la catégorie spécifiée
    SELECT 
        TLIVRES.IdLivre,
        TLIVRES.Titre,
        TLIVRES.ISBN,
        TLANGUES.NomLangue AS Langue,
        -- Concaténation des auteurs du livre
        STUFF((
            SELECT DISTINCT ', ' + TAUTEURS.PrenomAuteur + ' ' + TAUTEURS.NomAuteur
            FROM TAUTEURS_LIVRES
            JOIN TAUTEURS ON TAUTEURS_LIVRES.IdAuteur = TAUTEURS.IdAuteur
            WHERE TAUTEURS_LIVRES.IdLivre = TLIVRES.IdLivre
            FOR XML PATH('')
        ), 1, 2, '') AS Auteurs,
        -- Concaténation des éditeurs du livre
        STUFF((
            SELECT DISTINCT ', ' + TEDITEURS.NomEditeur
            FROM TEDITEURS_LIVRES
            JOIN TEDITEURS ON TEDITEURS_LIVRES.IdEditeur = TEDITEURS.IdEditeur
            WHERE TEDITEURS_LIVRES.IdLivre = TLIVRES.IdLivre
            FOR XML PATH('')
        ), 1, 2, '') AS Editeurs
    FROM TLIVRES
    JOIN TCATEGORIES_LIVRES ON TLIVRES.IdLivre = TCATEGORIES_LIVRES.IdLivre
    JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
    LEFT JOIN TLANGUES ON TLIVRES.IdLangue = TLANGUES.IdLangue
    WHERE TCATEGORIES.IdCategorie = @IdCategorie 
    GROUP BY TLIVRES.IdLivre, TLIVRES.Titre, TLIVRES.ISBN, TLANGUES.NomLangue
    ORDER BY TLIVRES.Titre 
    
    -- Affichage des informations sur la catégorie, notamment le nombre total de livres
    SELECT 
        TCATEGORIES.IdCategorie,
        TCATEGORIES.NomCategorie,
        COUNT(DISTINCT TCATEGORIES_LIVRES.IdLivre) AS NombreDeLivres
    FROM TCATEGORIES
    LEFT JOIN TCATEGORIES_LIVRES ON TCATEGORIES.IdCategorie = TCATEGORIES_LIVRES.IdCategorie
    WHERE TCATEGORIES.IdCategorie = @IdCategorie 
    GROUP BY TCATEGORIES.IdCategorie, TCATEGORIES.NomCategorie 
END 
GO

-- =============================================
-- Procédure : AfficherLivresParEditeur
-- Description : Affiche tous les livres publiés par un éditeur spécifique
-- Paramètres : 
--   @IdEditeur - Identifiant de l'éditeur (optionnel si nom fourni)
--   @NomEditeur - Nom de l'éditeur (optionnel si ID fourni)
-- =============================================
CREATE PROCEDURE AfficherLivresParEditeur
    @IdEditeur INT = NULL,
    @NomEditeur VARCHAR(50) = NULL
AS
BEGIN
    -- Vérification qu'au moins un des deux paramètres est fourni
    IF @IdEditeur IS NULL AND @NomEditeur IS NULL
    BEGIN
        PRINT 'Erreur : Veuillez fournir soit l identifiant de l editeur, soit son nom.' 
        RETURN 
    END 

    -- Si l'ID n'est pas fourni mais que le nom l'est, recherche de l'ID correspondant
    IF @IdEditeur IS NULL AND @NomEditeur IS NOT NULL
    BEGIN
        SELECT @IdEditeur = IdEditeur 
        FROM TEDITEURS 
        WHERE NomEditeur = LOWER(dbo.Trim(@NomEditeur)) 
        
        -- Vérification que l'éditeur existe
        IF @IdEditeur IS NULL
        BEGIN
            PRINT 'Erreur : Editeur non trouve.' 
            RETURN 
        END 
    END 

    -- Sélection des livres publiés par l'éditeur spécifié
     SELECT 
        TLIVRES.IdLivre,
        TLIVRES.Titre,
        TLIVRES.ISBN,
        TLANGUES.NomLangue AS Langue,
        -- Concaténation des auteurs du livre
        STUFF((
            SELECT DISTINCT ', ' + TAUTEURS.PrenomAuteur + ' ' + TAUTEURS.NomAuteur
            FROM TAUTEURS_LIVRES
            JOIN TAUTEURS ON TAUTEURS_LIVRES.IdAuteur = TAUTEURS.IdAuteur
            WHERE TAUTEURS_LIVRES.IdLivre = TLIVRES.IdLivre
            FOR XML PATH('')
        ), 1, 2, '') AS Auteurs,
        -- Concaténation des catégories du livre
        STUFF((
            SELECT DISTINCT ', ' + TCATEGORIES.NomCategorie
            FROM TCATEGORIES_LIVRES
            JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
            WHERE TCATEGORIES_LIVRES.IdLivre = TLIVRES.IdLivre
            FOR XML PATH('')
        ), 1, 2, '') AS Categories
    FROM TLIVRES
    JOIN TEDITEURS_LIVRES ON TLIVRES.IdLivre = TEDITEURS_LIVRES.IdLivre
    JOIN TEDITEURS ON TEDITEURS_LIVRES.IdEditeur = TEDITEURS.IdEditeur
    LEFT JOIN TLANGUES ON TLIVRES.IdLangue = TLANGUES.IdLangue
    WHERE TEDITEURS.IdEditeur = @IdEditeur
    GROUP BY TLIVRES.IdLivre, TLIVRES.Titre, TLIVRES.ISBN, TLANGUES.NomLangue
    ORDER BY TLIVRES.Titre 
    
    -- Affichage des informations sur l'éditeur, notamment le nombre total de livres
    SELECT 
        TEDITEURS.IdEditeur,
        TEDITEURS.NomEditeur,
        COUNT(DISTINCT TEDITEURS_LIVRES.IdLivre) AS NombreDeLivres
    FROM TEDITEURS
    LEFT JOIN TEDITEURS_LIVRES ON TEDITEURS.IdEditeur = TEDITEURS_LIVRES.IdEditeur
    WHERE TEDITEURS.IdEditeur = @IdEditeur
    GROUP BY TEDITEURS.IdEditeur, TEDITEURS.NomEditeur 
END 
GO

-- =============================================
-- Procédure : AfficherLivresParLangue
-- Description : Affiche tous les livres écrits dans une langue spécifique
-- Paramètres : 
--   @IdLangue - Identifiant de la langue (optionnel si nom fourni)
--   @NomLangue - Nom de la langue (optionnel si ID fourni)
-- =============================================
CREATE PROCEDURE AfficherLivresParLangue
    @IdLangue INT = NULL,
    @NomLangue VARCHAR(50) = NULL
AS
BEGIN
    -- Vérification qu'au moins un des deux paramètres est fourni
    IF @IdLangue IS NULL AND @NomLangue IS NULL
    BEGIN
        PRINT 'Erreur : Veuillez fournir soit l identifiant de la langue, soit son nom.' 
        RETURN 
    END 

    -- Si l'ID n'est pas fourni mais que le nom l'est, recherche de l'ID correspondant
    IF @IdLangue IS NULL AND @NomLangue IS NOT NULL
    BEGIN
        SELECT @IdLangue = IdLangue 
        FROM TLANGUES 
        WHERE NomLangue = LOWER(dbo.Trim(@NomLangue)) 
        
        -- Vérification que la langue existe
        IF @IdLangue IS NULL
        BEGIN
            PRINT 'Erreur : Langue non trouvee.' 
            RETURN 
        END 
    END 

    -- Sélection des livres écrits dans la langue spécifiée
    SELECT 
        TLIVRES.IdLivre,
        TLIVRES.Titre,
        TLIVRES.ISBN,
        -- Concaténation des auteurs du livre
        STUFF((
            SELECT DISTINCT ', ' + TAUTEURS.PrenomAuteur + ' ' + TAUTEURS.NomAuteur
            FROM TAUTEURS_LIVRES
            JOIN TAUTEURS ON TAUTEURS_LIVRES.IdAuteur = TAUTEURS.IdAuteur
            WHERE TAUTEURS_LIVRES.IdLivre = TLIVRES.IdLivre
            FOR XML PATH('')
        ), 1, 2, '') AS Auteurs,
        -- Concaténation des catégories du livre
        STUFF((
            SELECT DISTINCT ', ' + TCATEGORIES.NomCategorie
            FROM TCATEGORIES_LIVRES
            JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
            WHERE TCATEGORIES_LIVRES.IdLivre = TLIVRES.IdLivre
            FOR XML PATH('')
        ), 1, 2, '') AS Categories,
        -- Concaténation des éditeurs du livre
        STUFF((
            SELECT DISTINCT ', ' + TEDITEURS.NomEditeur
            FROM TEDITEURS_LIVRES
            JOIN TEDITEURS ON TEDITEURS_LIVRES.IdEditeur = TEDITEURS.IdEditeur
            WHERE TEDITEURS_LIVRES.IdLivre = TLIVRES.IdLivre
            FOR XML PATH('')
        ), 1, 2, '') AS Editeurs
    FROM TLIVRES
    JOIN TLANGUES ON TLIVRES.IdLangue = TLANGUES.IdLangue
    WHERE TLANGUES.IdLangue = @IdLangue
    GROUP BY TLIVRES.IdLivre, TLIVRES.Titre, TLIVRES.ISBN
    ORDER BY TLIVRES.Titre 
    
    -- Affichage des informations sur la langue, notamment le nombre total de livres
    SELECT 
        TLANGUES.IdLangue,
        TLANGUES.NomLangue,
        COUNT(DISTINCT TLIVRES.IdLivre) AS NombreDeLivres
    FROM TLANGUES
    LEFT JOIN TLIVRES ON TLANGUES.IdLangue = TLIVRES.IdLangue
    WHERE TLANGUES.IdLangue = @IdLangue
    GROUP BY TLANGUES.IdLangue, TLANGUES.NomLangue 
END 
GO

-- =============================================
-- Procédure : AfficherTousAuteurs
-- Description : Affiche tous les auteurs avec le nombre de livres et les catégories
-- Paramètres : Aucun
-- =============================================
CREATE PROCEDURE AfficherTousAuteurs
AS
BEGIN
    -- Sélection de tous les auteurs avec le nombre de livres et les catégories associées
    SELECT 
        TAUTEURS.IdAuteur,
        TAUTEURS.NomAuteur,
        TAUTEURS.PrenomAuteur,
        COUNT(DISTINCT TAUTEURS_LIVRES.IdLivre) AS NombreDeLivres,
        -- Concaténation des catégories associées à l'auteur
        STUFF((
            SELECT DISTINCT ', ' + TCATEGORIES.NomCategorie
            FROM TAUTEURS_LIVRES
            JOIN TLIVRES ON TAUTEURS_LIVRES.IdLivre = TLIVRES.IdLivre
            JOIN TCATEGORIES_LIVRES ON TLIVRES.IdLivre = TCATEGORIES_LIVRES.IdLivre
            JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
            WHERE TAUTEURS_LIVRES.IdAuteur = TAUTEURS.IdAuteur
            FOR XML PATH('')
        ), 1, 2, '') AS Categories
    FROM TAUTEURS
    LEFT JOIN TAUTEURS_LIVRES ON TAUTEURS.IdAuteur = TAUTEURS_LIVRES.IdAuteur
    GROUP BY TAUTEURS.IdAuteur, TAUTEURS.NomAuteur, TAUTEURS.PrenomAuteur
    ORDER BY TAUTEURS.NomAuteur, TAUTEURS.PrenomAuteur 
END 
GO

-- =============================================
-- Procédure : AfficherAuteur
-- Description : Affiche les détails d'un auteur spécifique avec ses statistiques
-- Paramètres : 
--   @IdAuteur - Identifiant de l'auteur (optionnel si nom/prénom fourni)
--   @NomAuteur - Nom de l'auteur (optionnel si ID fourni)
--   @PrenomAuteur - Prénom de l'auteur (optionnel si ID fourni)
-- =============================================
CREATE PROCEDURE AfficherAuteur
    @IdAuteur INT = NULL,
    @NomAuteur VARCHAR(50) = NULL,
    @PrenomAuteur VARCHAR(50) = NULL
AS
BEGIN
    -- Vérification que soit l'ID, soit le nom et prénom sont fournis
    IF @IdAuteur IS NULL AND (@NomAuteur IS NULL OR @PrenomAuteur IS NULL)
    BEGIN
        PRINT 'Erreur : Veuillez fournir soit l identifiant de l auteur, soit son nom et prenom.' 
        RETURN 
    END 

    -- Si l'ID n'est pas fourni mais que le nom et prénom le sont, recherche de l'ID correspondant
    IF @IdAuteur IS NULL AND @NomAuteur IS NOT NULL AND @PrenomAuteur IS NOT NULL
    BEGIN
        SELECT @IdAuteur = IdAuteur 
        FROM TAUTEURS 
        WHERE NomAuteur = LOWER(dbo.Trim(@NomAuteur)) 
          AND PrenomAuteur = LOWER(dbo.Trim(@PrenomAuteur)) 
        
        -- Vérification que l'auteur existe
        IF @IdAuteur IS NULL
        BEGIN
            PRINT 'Erreur : Auteur non trouve.' 
            RETURN 
        END 
    END 

    -- Sélection des informations de base sur l'auteur
    SELECT 
        TAUTEURS.IdAuteur,
        TAUTEURS.NomAuteur,
        TAUTEURS.PrenomAuteur,
        COUNT(DISTINCT TAUTEURS_LIVRES.IdLivre) AS NombreDeLivres
    FROM TAUTEURS
    LEFT JOIN TAUTEURS_LIVRES ON TAUTEURS.IdAuteur = TAUTEURS_LIVRES.IdAuteur
    WHERE TAUTEURS.IdAuteur = @IdAuteur
    GROUP BY TAUTEURS.IdAuteur, TAUTEURS.NomAuteur, TAUTEURS.PrenomAuteur 
    
    -- Sélection des catégories associées à l'auteur avec le nombre de livres par catégorie
    SELECT 
        TCATEGORIES.NomCategorie,
        COUNT(DISTINCT TCATEGORIES_LIVRES.IdLivre) AS NombreDeLivres
    FROM TCATEGORIES
    JOIN TCATEGORIES_LIVRES ON TCATEGORIES.IdCategorie = TCATEGORIES_LIVRES.IdCategorie
    JOIN TLIVRES ON TCATEGORIES_LIVRES.IdLivre = TLIVRES.IdLivre
    JOIN TAUTEURS_LIVRES ON TLIVRES.IdLivre = TAUTEURS_LIVRES.IdLivre
    WHERE TAUTEURS_LIVRES.IdAuteur = @IdAuteur
    GROUP BY TCATEGORIES.NomCategorie
    ORDER BY COUNT(DISTINCT TCATEGORIES_LIVRES.IdLivre) DESC 
    
    -- Sélection des éditeurs associés à l'auteur avec le nombre de livres par éditeur
    SELECT 
        TEDITEURS.NomEditeur,
        COUNT(DISTINCT TEDITEURS_LIVRES.IdLivre) AS NombreDeLivres
    FROM TEDITEURS
    JOIN TEDITEURS_LIVRES ON TEDITEURS.IdEditeur = TEDITEURS_LIVRES.IdEditeur
    JOIN TLIVRES ON TEDITEURS_LIVRES.IdLivre = TLIVRES.IdLivre
    JOIN TAUTEURS_LIVRES ON TLIVRES.IdLivre = TAUTEURS_LIVRES.IdLivre
    WHERE TAUTEURS_LIVRES.IdAuteur = @IdAuteur
    GROUP BY TEDITEURS.NomEditeur
    ORDER BY COUNT(DISTINCT TEDITEURS_LIVRES.IdLivre) DESC 
END 
GO

-- =============================================
-- Procédure : AfficherToutesCategories
-- Description : Affiche toutes les catégories avec le nombre de livres associés
-- Paramètres : Aucun
-- =============================================
CREATE PROCEDURE AfficherToutesCategories
AS
BEGIN
    -- Sélection de toutes les catégories avec le nombre de livres associés
    SELECT 
        TCATEGORIES.IdCategorie,
        TCATEGORIES.NomCategorie,
        COUNT(DISTINCT TCATEGORIES_LIVRES.IdLivre) AS NombreDeLivres
    FROM TCATEGORIES
    LEFT JOIN TCATEGORIES_LIVRES ON TCATEGORIES.IdCategorie = TCATEGORIES_LIVRES.IdCategorie
    GROUP BY TCATEGORIES.IdCategorie, TCATEGORIES.NomCategorie
    ORDER BY TCATEGORIES.NomCategorie 
END 
GO

-- =============================================
-- Procédure : AfficherTousEditeurs
-- Description : Affiche tous les éditeurs avec le nombre de livres publiés
-- Paramètres : Aucun
-- =============================================
CREATE PROCEDURE AfficherTousEditeurs
AS
BEGIN
    -- Sélection de tous les éditeurs avec le nombre de livres publiés
    SELECT 
        TEDITEURS.IdEditeur,
        TEDITEURS.NomEditeur,
        COUNT(DISTINCT TEDITEURS_LIVRES.IdLivre) AS NombreDeLivres
    FROM TEDITEURS
    LEFT JOIN TEDITEURS_LIVRES ON TEDITEURS.IdEditeur = TEDITEURS_LIVRES.IdEditeur
    GROUP BY TEDITEURS.IdEditeur, TEDITEURS.NomEditeur
    ORDER BY TEDITEURS.NomEditeur 
END 
GO

-- =============================================
-- Procédure : AfficherToutesLangues
-- Description : Affiche toutes les langues avec le nombre de livres disponibles
-- Paramètres : Aucun
-- =============================================
CREATE PROCEDURE AfficherToutesLangues
AS
BEGIN
    -- Sélection de toutes les langues avec le nombre de livres disponibles dans chaque langue
    SELECT 
        TLANGUES.IdLangue,
        TLANGUES.NomLangue,
        COUNT(DISTINCT TLIVRES.IdLivre) AS NombreDeLivres
    FROM TLANGUES
    LEFT JOIN TLIVRES ON TLANGUES.IdLangue = TLIVRES.IdLangue
    GROUP BY TLANGUES.IdLangue, TLANGUES.NomLangue
    ORDER BY TLANGUES.NomLangue
END
GO

-- =============================================
-- Procédure: RechercherLivres
-- Description: Permet de rechercher des livres selon différents critères (titre, ISBN, auteur, etc.)
-- Paramètres : 
    -- @Titre : Titre du livre (recherche partielle)
    -- @ISBN : ISBN du livre (recherche exacte)
    -- @NomAuteur : Nom de l'auteur (recherche partielle)
    -- @PrenomAuteur : Prénom de l'auteur (recherche partielle)
    -- @Categorie : Catégorie du livre (recherche partielle)
    -- @Editeur : Éditeur du livre (recherche partielle)
    -- @Langue : Langue du livre (recherche partielle)
-- =============================================
CREATE PROCEDURE RechercherLivres
    @Titre VARCHAR(100) = NULL,
    @ISBN VARCHAR(20) = NULL,
    @NomAuteur VARCHAR(50) = NULL,
    @PrenomAuteur VARCHAR(50) = NULL,
    @Categorie VARCHAR(50) = NULL,
    @Editeur VARCHAR(50) = NULL,
    @Langue VARCHAR(50) = NULL
AS
BEGIN
    SELECT 
        TLIVRES.IdLivre,
        TLIVRES.Titre,
        TLIVRES.ISBN,
        TLANGUES.NomLangue AS Langue,
        Authors.Auteurs,                -- Liste concaténée des auteurs
        Categories.Categories,          -- Liste concaténée des catégories
        Editors.Editeurs                -- Liste concaténée des éditeurs
    FROM TLIVRES
    LEFT JOIN TLANGUES ON TLIVRES.IdLangue = TLANGUES.IdLangue
    -- Sous-requête pour concaténer tous les auteurs d'un livre en une seule chaîne
    LEFT JOIN (
        SELECT TAUTEURS_LIVRES.IdLivre,
               STUFF((
                   SELECT ', ' + TAUTEURS.PrenomAuteur + ' ' + TAUTEURS.NomAuteur
                   FROM TAUTEURS_LIVRES
                   JOIN TAUTEURS ON TAUTEURS_LIVRES.IdAuteur = TAUTEURS.IdAuteur
                   WHERE TAUTEURS_LIVRES.IdLivre = TAUTEURS_LIVRES.IdLivre
                   ORDER BY TAUTEURS.NomAuteur, TAUTEURS.PrenomAuteur
                   FOR XML PATH('')
               ), 1, 2, '') AS Auteurs  -- STUFF retire les deux premiers caractères (', ')
        FROM TAUTEURS_LIVRES
        GROUP BY TAUTEURS_LIVRES.IdLivre
    ) Authors ON TLIVRES.IdLivre = Authors.IdLivre
    -- Sous-requête pour concaténer toutes les catégories d'un livre en une seule chaîne
    LEFT JOIN (
        SELECT TCATEGORIES_LIVRES.IdLivre,
               STUFF((
                   SELECT ', ' + TCATEGORIES.NomCategorie
                   FROM TCATEGORIES_LIVRES
                   JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
                   WHERE TCATEGORIES_LIVRES.IdLivre = TCATEGORIES_LIVRES.IdLivre
                   ORDER BY TCATEGORIES.NomCategorie
                   FOR XML PATH('')
               ), 1, 2, '') AS Categories
        FROM TCATEGORIES_LIVRES
        GROUP BY TCATEGORIES_LIVRES.IdLivre
    ) Categories ON TLIVRES.IdLivre = Categories.IdLivre
     -- Sous-requête pour concaténer tous les éditeurs d'un livre en une seule chaîne
    LEFT JOIN (
        SELECT TEDITEURS_LIVRES.IdLivre,
               STUFF((
                   SELECT ', ' + TEDITEURS.NomEditeur
                   FROM TEDITEURS_LIVRES
                   JOIN TEDITEURS ON TEDITEURS_LIVRES.IdEditeur = TEDITEURS.IdEditeur
                   WHERE TEDITEURS_LIVRES.IdLivre = TEDITEURS_LIVRES.IdLivre
                   ORDER BY TEDITEURS.NomEditeur
                   FOR XML PATH('')
               ), 1, 2, '') AS Editeurs
        FROM TEDITEURS_LIVRES
        GROUP BY TEDITEURS_LIVRES.IdLivre
    ) Editors ON TLIVRES.IdLivre = Editors.IdLivre
    -- Filtres de recherche, tous optionnels (si NULL, le filtre est ignoré)
    WHERE (@Titre IS NULL OR TLIVRES.Titre LIKE '%' + @Titre + '%')
      AND (@ISBN IS NULL OR TLIVRES.ISBN = @ISBN)
      AND (@Langue IS NULL OR TLANGUES.NomLangue LIKE '%' + LOWER(dbo.Trim(@Langue)) + '%')
      AND (@NomAuteur IS NULL OR Authors.Auteurs LIKE '%' + LOWER(dbo.Trim(@NomAuteur)) + '%')
      AND (@PrenomAuteur IS NULL OR Authors.Auteurs LIKE '%' + LOWER(dbo.Trim(@PrenomAuteur)) + '%')
      AND (@Categorie IS NULL OR Categories.Categories LIKE '%' + LOWER(dbo.Trim(@Categorie)) + '%')
      AND (@Editeur IS NULL OR Editors.Editeurs LIKE '%' + LOWER(dbo.Trim(@Editeur)) + '%')
    ORDER BY  TLIVRES.Titre -- Tri des résultats par titre de livre
END 
GO      


-- =============================================
-- Procédure: StatistiquesLivresParCategorie
-- Description: Génère des statistiques sur le nombre de livres, d'auteurs et d'éditeurs par catégorie
-- Paramètres : Aucun
-- =============================================
CREATE PROCEDURE StatistiquesLivresParCategorie
AS
BEGIN
    SELECT 
        TCATEGORIES.NomCategorie,
        COUNT(DISTINCT TCATEGORIES_LIVRES.IdLivre) AS NombreDeLivres,   -- Nombre de livres uniques dans cette catégorie
        COUNT(DISTINCT TAUTEURS_LIVRES.IdAuteur) AS NombreAuteurs,      -- Nombre d'auteurs uniques ayant écrit dans cette catégorie
        COUNT(DISTINCT TEDITEURS_LIVRES.IdEditeur) AS NombreEditeurs    -- Nombre d'éditeurs uniques publiant dans cette catégorie
    FROM TCATEGORIES
    LEFT JOIN TCATEGORIES_LIVRES ON TCATEGORIES.IdCategorie = TCATEGORIES_LIVRES.IdCategorie
    LEFT JOIN TLIVRES ON TCATEGORIES_LIVRES.IdLivre =  TLIVRES.IdLivre
    LEFT JOIN TAUTEURS_LIVRES ON  TLIVRES.IdLivre = TAUTEURS_LIVRES.IdLivre
    LEFT JOIN TEDITEURS_LIVRES ON  TLIVRES.IdLivre = TEDITEURS_LIVRES.IdLivre
    GROUP BY TCATEGORIES.NomCategorie
    ORDER BY COUNT(DISTINCT TCATEGORIES_LIVRES.IdLivre) DESC -- Tri par nombre de livres décroissant
END 
GO

-- =============================================
-- Procédure: StatistiquesLivresParAuteur
-- Description: Génère des statistiques sur le nombre de livres par auteur et leurs catégories
-- Paramètres : Aucun
-- =============================================
CREATE PROCEDURE StatistiquesLivresParAuteur
AS
BEGIN
    SELECT 
        TAUTEURS.PrenomAuteur + ' ' + TAUTEURS.NomAuteur AS NomComplet, -- Nom complet de l'auteur
        COUNT(DISTINCT TAUTEURS_LIVRES.IdLivre) AS NombreDeLivres,      -- Nombre de livres écrits par cet auteur
        STUFF((
                   SELECT ', ' + TCATEGORIES.NomCategorie
                   FROM TCATEGORIES_LIVRES
                   JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
                   WHERE TCATEGORIES_LIVRES.IdLivre = TCATEGORIES_LIVRES.IdLivre
                   ORDER BY TCATEGORIES.NomCategorie
                   FOR XML PATH('')
               ), 1, 2, '') AS Categories       -- Liste concaténée des catégories de l'auteur
    FROM TAUTEURS
    LEFT JOIN TAUTEURS_LIVRES ON TAUTEURS.IdAuteur = TAUTEURS_LIVRES.IdAuteur
    LEFT JOIN TLIVRES ON TAUTEURS_LIVRES.IdLivre =  TLIVRES.IdLivre
    LEFT JOIN TCATEGORIES_LIVRES ON  TLIVRES.IdLivre = TCATEGORIES_LIVRES.IdLivre
    LEFT JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
    GROUP BY TAUTEURS.PrenomAuteur, TAUTEURS.NomAuteur
    ORDER BY COUNT(DISTINCT TAUTEURS_LIVRES.IdLivre) DESC   -- Tri par nombre de livres décroissant
END 
GO

-- =============================================
-- Procédure: StatistiquesLivresParEditeur
-- Description: Génère des statistiques sur le nombre de livres et d'auteurs par éditeur et leurs catégories
-- Paramètres : Aucun
-- =============================================
CREATE PROCEDURE StatistiquesLivresParEditeur
AS
BEGIN
    SELECT 
        TEDITEURS.NomEditeur,
        COUNT(DISTINCT TEDITEURS_LIVRES.IdLivre) AS NombreDeLivres, -- Nombre de livres publiés par cet éditeur
        COUNT(DISTINCT TAUTEURS_LIVRES.IdAuteur) AS NombreAuteurs,  -- Nombre d'auteurs publiés par cet éditeur
        STUFF((
                   SELECT ', ' + TCATEGORIES.NomCategorie
                   FROM TCATEGORIES_LIVRES
                   JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
                   WHERE TCATEGORIES_LIVRES.IdLivre = TCATEGORIES_LIVRES.IdLivre
                   ORDER BY TCATEGORIES.NomCategorie
                   FOR XML PATH('')
               ), 1, 2, '') AS Categories    -- Liste concaténée des catégories de l'éditeur
    FROM TEDITEURS
    LEFT JOIN TEDITEURS_LIVRES ON TEDITEURS.IdEditeur = TEDITEURS_LIVRES.IdEditeur
    LEFT JOIN TLIVRES ON TEDITEURS_LIVRES.IdLivre =  TLIVRES.IdLivre
    LEFT JOIN TAUTEURS_LIVRES ON  TLIVRES.IdLivre = TAUTEURS_LIVRES.IdLivre
    LEFT JOIN TCATEGORIES_LIVRES ON  TLIVRES.IdLivre = TCATEGORIES_LIVRES.IdLivre
    LEFT JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
    GROUP BY TEDITEURS.NomEditeur
    ORDER BY COUNT(DISTINCT TEDITEURS_LIVRES.IdLivre) DESC  -- Tri par nombre de livres décroissant
END 
GO

-- =============================================
-- Procédure: StatistiquesLivresParLangue
-- Description: Génère des statistiques sur le nombre de livres, d'auteurs et d'éditeurs par langue
-- Paramètres : Aucun
-- =============================================
CREATE PROCEDURE StatistiquesLivresParLangue
AS
BEGIN
    SELECT 
        TLANGUES.NomLangue,
        COUNT(DISTINCT  TLIVRES.IdLivre) AS NombreDeLivres,             -- Nombre de livres dans cette langue
        COUNT(DISTINCT TAUTEURS_LIVRES.IdAuteur) AS NombreAuteurs,      -- Nombre d'auteurs écrivant dans cette langue
        COUNT(DISTINCT TEDITEURS_LIVRES.IdEditeur) AS NombreEditeurs,   -- Nombre d'éditeurs publiant dans cette langue
        STUFF((
                   SELECT ', ' + TCATEGORIES.NomCategorie
                   FROM TCATEGORIES_LIVRES
                   JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
                   WHERE TCATEGORIES_LIVRES.IdLivre = TCATEGORIES_LIVRES.IdLivre
                   ORDER BY TCATEGORIES.NomCategorie
                   FOR XML PATH('')
               ), 1, 2, '') AS Categories   -- Liste concaténée des catégories par langue
    FROM TLANGUES 
    LEFT JOIN TLIVRES ON TLANGUES.IdLangue =  TLIVRES.IdLangue
    LEFT JOIN TAUTEURS_LIVRES ON  TLIVRES.IdLivre = TAUTEURS_LIVRES.IdLivre
    LEFT JOIN TEDITEURS_LIVRES ON  TLIVRES.IdLivre = TEDITEURS_LIVRES.IdLivre
    LEFT JOIN TCATEGORIES_LIVRES ON  TLIVRES.IdLivre = TCATEGORIES_LIVRES.IdLivre
    LEFT JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
    GROUP BY TLANGUES.NomLangue
    ORDER BY COUNT(DISTINCT  TLIVRES.IdLivre) DESC  -- Tri par nombre de livres décroissant
END 
GO

-- =============================================
-- Procédure: AfficherLivresParNotation
-- Description: Affiche les livres dont la notation moyenne est comprise dans une plage spécifiée
-- Paramètres : 
    -- @NotationMinimum : Notation minimale (défaut: 0)
    -- @NotationMaximum : Notation maximale (défaut: 10)
-- =============================================
CREATE PROCEDURE AfficherLivresParNotation
    @NotationMinimum INT = 0,  
    @NotationMaximum INT = 10  
AS
BEGIN
    -- Vérification de la validité des paramètres d'entrée
    IF @NotationMinimum < 0 OR @NotationMinimum > 10 OR @NotationMaximum < 0 OR @NotationMaximum > 10
    BEGIN
        PRINT 'Erreur: La notation doit etre entre 0 et 10.'
        RETURN
    END

    SELECT 
        TLIVRES.IdLivre,
        TLIVRES.Titre,
        TLIVRES.ISBN,
        TLANGUES.NomLangue AS Langue,
        -- Concaténation des auteurs pour chaque livre
        STUFF((
                   SELECT ', ' + TAUTEURS.PrenomAuteur + ' ' + TAUTEURS.NomAuteur
                   FROM TAUTEURS_LIVRES
                   JOIN TAUTEURS ON TAUTEURS_LIVRES.IdAuteur = TAUTEURS.IdAuteur
                   WHERE TAUTEURS_LIVRES.IdLivre = TAUTEURS_LIVRES.IdLivre
                   ORDER BY TAUTEURS.NomAuteur, TAUTEURS.PrenomAuteur
                   FOR XML PATH('')
               ), 1, 2, '') AS Auteurs,
        -- Concaténation des catégories pour chaque livre
        STUFF((
                   SELECT ', ' + TCATEGORIES.NomCategorie
                   FROM TCATEGORIES_LIVRES
                   JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
                   WHERE TCATEGORIES_LIVRES.IdLivre = TCATEGORIES_LIVRES.IdLivre
                   ORDER BY TCATEGORIES.NomCategorie
                   FOR XML PATH('')
               ), 1, 2, '') AS Categories,
        -- Concaténation des éditeurs pour chaque livre
        STUFF((
                   SELECT ', ' + TEDITEURS.NomEditeur
                   FROM TEDITEURS_LIVRES
                   JOIN TEDITEURS ON TEDITEURS_LIVRES.IdEditeur = TEDITEURS.IdEditeur
                   WHERE TEDITEURS_LIVRES.IdLivre = TEDITEURS_LIVRES.IdLivre
                   ORDER BY TEDITEURS.NomEditeur
                   FOR XML PATH('')
               ), 1, 2, '') AS Editeurs,
        AVG(TREVIEWS.Notation) AS NotationMoyenne,      -- Calcul de la notation moyenne
        COUNT(TREVIEWS.IdReview) AS NombreAvis          -- Nombre total d'avis reçus
    FROM TLIVRES
    LEFT JOIN TLANGUES ON TLIVRES.IdLangue = TLANGUES.IdLangue
    LEFT JOIN TAUTEURS_LIVRES ON TLIVRES.IdLivre = TAUTEURS_LIVRES.IdLivre
    LEFT JOIN TAUTEURS ON TAUTEURS_LIVRES.IdAuteur = TAUTEURS.IdAuteur
    LEFT JOIN TCATEGORIES_LIVRES ON TLIVRES.IdLivre = TCATEGORIES_LIVRES.IdLivre
    LEFT JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
    LEFT JOIN TEDITEURS_LIVRES ON TLIVRES.IdLivre = TEDITEURS_LIVRES.IdLivre
    LEFT JOIN TEDITEURS ON TEDITEURS_LIVRES.IdEditeur = TEDITEURS.IdEditeur
    LEFT JOIN TREVIEWS ON TLIVRES.IdLivre = TREVIEWS.IdLivre
    GROUP BY TLIVRES.IdLivre, TLIVRES.Titre, TLIVRES.ISBN, TLANGUES.NomLangue
    -- Filtre sur la notation moyenne dans la plage spécifiée
    HAVING AVG(TREVIEWS.Notation) >= @NotationMinimum AND AVG(TREVIEWS.Notation) <= @NotationMaximum
    ORDER BY NotationMoyenne DESC, TLIVRES.Titre    -- Tri par notation décroissante puis par titre
END
GO

-- =============================================
-- Procédure: AfficherLivresTopNotes
-- Description: Affiche les N livres les mieux notés, avec un minimum d'avis requis
-- Paramètres : 
    -- @NombreLivres : Nombre de livres à afficher (défaut: 10)
    -- @MinimumAvis : Nombre minimum d'avis requis (défaut: 3)
-- =============================================
CREATE PROCEDURE AfficherLivresTopNotes
    @NombreLivres INT = 10, 
    @MinimumAvis INT = 3    
AS
BEGIN
     -- Vérification de la validité des paramètres d'entrée
    IF @NombreLivres <= 0
    BEGIN
        PRINT 'Erreur: Le nombre de livres doit etre positif.'
        RETURN
    END

    IF @MinimumAvis <= 0
    BEGIN
        PRINT 'Erreur: Le nombre minimum d avis doit etre positif.'
        RETURN
    END

    SELECT TOP (@NombreLivres)
        TLIVRES.IdLivre,
        TLIVRES.Titre,
        TLIVRES.ISBN,
        TLANGUES.NomLangue AS Langue,
        -- Concaténation des auteurs pour chaque livre
        STUFF((
                   SELECT ', ' + TAUTEURS.PrenomAuteur + ' ' + TAUTEURS.NomAuteur
                   FROM TAUTEURS_LIVRES
                   JOIN TAUTEURS ON TAUTEURS_LIVRES.IdAuteur = TAUTEURS.IdAuteur
                   WHERE TAUTEURS_LIVRES.IdLivre = TAUTEURS_LIVRES.IdLivre
                   ORDER BY TAUTEURS.NomAuteur, TAUTEURS.PrenomAuteur
                   FOR XML PATH('')
               ), 1, 2, '') AS Auteurs,
        -- Concaténation des catégories pour chaque livre
        STUFF((
                   SELECT ', ' + TCATEGORIES.NomCategorie
                   FROM TCATEGORIES_LIVRES
                   JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
                   WHERE TCATEGORIES_LIVRES.IdLivre = TCATEGORIES_LIVRES.IdLivre
                   ORDER BY TCATEGORIES.NomCategorie
                   FOR XML PATH('')
               ), 1, 2, '') AS Categories,
        -- Concaténation des éditeurs pour chaque livre
        STUFF((
                   SELECT ', ' + TEDITEURS.NomEditeur
                   FROM TEDITEURS_LIVRES
                   JOIN TEDITEURS ON TEDITEURS_LIVRES.IdEditeur = TEDITEURS.IdEditeur
                   WHERE TEDITEURS_LIVRES.IdLivre = TEDITEURS_LIVRES.IdLivre
                   ORDER BY TEDITEURS.NomEditeur
                   FOR XML PATH('')
               ), 1, 2, '') AS Editeurs,
        AVG(TREVIEWS.Notation) AS NotationMoyenne,      -- Calcul de la notation moyenne
        COUNT(TREVIEWS.IdReview) AS NombreAvis          -- Nombre total d'avis reçus
    FROM TLIVRES
    LEFT JOIN TLANGUES ON TLIVRES.IdLangue = TLANGUES.IdLangue
    LEFT JOIN TAUTEURS_LIVRES ON TLIVRES.IdLivre = TAUTEURS_LIVRES.IdLivre
    LEFT JOIN TAUTEURS ON TAUTEURS_LIVRES.IdAuteur = TAUTEURS.IdAuteur
    LEFT JOIN TCATEGORIES_LIVRES ON TLIVRES.IdLivre = TCATEGORIES_LIVRES.IdLivre
    LEFT JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
    LEFT JOIN TEDITEURS_LIVRES ON TLIVRES.IdLivre = TEDITEURS_LIVRES.IdLivre
    LEFT JOIN TEDITEURS ON TEDITEURS_LIVRES.IdEditeur = TEDITEURS.IdEditeur
    INNER JOIN TREVIEWS ON TLIVRES.IdLivre = TREVIEWS.IdLivre   -- INNER JOIN car on veut uniquement les livres avec des avis
    GROUP BY TLIVRES.IdLivre, TLIVRES.Titre, TLIVRES.ISBN, TLANGUES.NomLangue
    -- Filtre pour n'inclure que les livres ayant au moins @MinimumAvis avis
    HAVING COUNT(TREVIEWS.IdReview) >= @MinimumAvis
    -- Tri par notation décroissante, puis par nombre d'avis décroissant, puis par titre
    ORDER BY NotationMoyenne DESC, NombreAvis DESC, TLIVRES.Titre
END
GO