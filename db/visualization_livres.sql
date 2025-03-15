-- Afficher specifique livre
CREATE PROCEDURE AfficherLivre
    @IdLivre INT
AS
BEGIN
    IF @IdLivre IS NULL OR @IdLivre <= 0
    BEGIN
        PRINT 'Erreur : L identifiant du livre doit etre un nombre positif valide.' 
        RETURN 
    END 

    IF NOT EXISTS (SELECT 1 FROM TLIVRES WHERE IdLivre = @IdLivre)
    BEGIN
        PRINT 'Erreur : Le livre specifie n existe pas.' 
        RETURN 
    END 

    SELECT 
        TLIVRES.IdLivre,
        TLIVRES.Titre,
        TLIVRES.ISBN,
        TLANGUES.NomLangue AS Langue,
        STRING_AGG(TAUTEURS.PrenomAuteur + ' ' + TAUTEURS.NomAuteur, ', ') AS Auteurs,
        STRING_AGG(TCATEGORIES.NomCategorie, ', ') AS Categories,
        STRING_AGG(TEDITEURS.NomEditeur, ', ') AS Editeurs,
        AVG(TREVIEWS.Notation) AS NotationMoyenne,
        COUNT(TREVIEWS.IdReview) AS NombreAvis
    FROM TLIVRES
    LEFT JOIN TLANGUES ON  TLIVRES.IdLangue = TLANGUES.IdLangue
    LEFT JOIN TAUTEURS_LIVRES ON  TLIVRES.IdLivre = TAUTEURS_LIVRES.IdLivre
    LEFT JOIN TAUTEURS TAUTEURS ON TAUTEURS_LIVRES.IdAuteur = TAUTEURS.IdAuteur
    LEFT JOIN TCATEGORIES_LIVRES ON  TLIVRES.IdLivre = TCATEGORIES_LIVRES.IdLivre
    LEFT JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
    LEFT JOIN TEDITEURS_LIVRES ON  TLIVRES.IdLivre = TEDITEURS_LIVRES.IdLivre
    LEFT JOIN TEDITEURS ON TEDITEURS_LIVRES.IdEditeur = TEDITEURS.IdEditeur
    LEFT JOIN TREVIEWS ON TLIVRES.IdLivre = TREVIEWS.IdLivre
    WHERE  TLIVRES.IdLivre = @IdLivre
    GROUP BY  TLIVRES.IdLivre,  TLIVRES.Titre,  TLIVRES.ISBN, TLANGUES.NomLangue 
END
GO

-- Afficher tous les livres
CREATE PROCEDURE AfficherTousLivres
AS
BEGIN
    SELECT 
        TLIVRES.IdLivre,
        TLIVRES.Titre,
        TLIVRES.ISBN,
        TLANGUES.NomLangue AS Langue,
        STRING_AGG(TAUTEURS.PrenomAuteur + ' ' + TAUTEURS.NomAuteur, ', ') AS Auteurs,
        STRING_AGG(TCATEGORIES.NomCategorie, ', ') AS Categories,
        STRING_AGG(TEDITEURS.NomEditeur, ', ') AS Editeurs,
        AVG(TREVIEWS.Notation) AS NotationMoyenne,
        COUNT(TREVIEWS.IdReview) AS NombreAvis
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
    ORDER BY TLIVRES.Titre 
END
GO

-- Afficher les livres pour un auteur spécifique
CREATE PROCEDURE AfficherLivresParAuteur
    @IdAuteur INT = NULL,
    @NomAuteur VARCHAR(50) = NULL,
    @PrenomAuteur VARCHAR(50) = NULL
AS
BEGIN
    IF @IdAuteur IS NULL AND (@NomAuteur IS NULL OR @PrenomAuteur IS NULL)
    BEGIN
        PRINT 'Erreur : Veuillez fournir soit l identifiant de l auteur, soit son nom et prenom.'
        RETURN
    END


    IF @IdAuteur IS NULL AND @NomAuteur IS NOT NULL AND @PrenomAuteur IS NOT NULL
    BEGIN
        SELECT @IdAuteur = IdAuteur 
        FROM TAUTEURS 
        WHERE NomAuteur = LOWER(dbo.Trim(@NomAuteur)) 
          AND PrenomAuteur = LOWER(dbo.Trim(@PrenomAuteur)) 
        
        IF @IdAuteur IS NULL
        BEGIN
            PRINT 'Erreur : Auteur non trouve.' 
            RETURN 
        END 
    END 

    SELECT 
        TLIVRES.IdLivre,
        TLIVRES.Titre,
        TLIVRES.ISBN,
        TLANGUES.NomLangue AS Langue,
        STRING_AGG(TCATEGORIES.NomCategorie, ', ') AS Categories,
        STRING_AGG(TEDITEURS.NomEditeur, ', ') AS Editeurs
    FROM TLIVRES
    JOIN TAUTEURS_LIVRES ON TLIVRES.IdLivre = TAUTEURS_LIVRES.IdLivre
    JOIN TAUTEURS ON TAUTEURS_LIVRES.IdAuteur = TAUTEURS.IdAuteur
    LEFT JOIN TLANGUES ON TLIVRES.IdLangue = TLANGUES.IdLangue
    LEFT JOIN TCATEGORIES_LIVRES ON TLIVRES.IdLivre = TCATEGORIES_LIVRES.IdLivre
    LEFT JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
    LEFT JOIN TEDITEURS_LIVRES ON TLIVRES.IdLivre = TEDITEURS_LIVRES.IdLivre
    LEFT JOIN TEDITEURS ON TEDITEURS_LIVRES.IdEditeur = TEDITEURS.IdEditeur
    WHERE TAUTEURS.IdAuteur = @IdAuteur
    GROUP BY TLIVRES.IdLivre, TLIVRES.Titre, TLIVRES.ISBN, TLANGUES.NomLangue
    ORDER BY TLIVRES.Titre 
    
    SELECT 
        TAUTEURS.IdAuteur,
        TAUTEURS.NomAuteur,
        TAUTEURS.PrenomAuteur,
        COUNT(DISTINCT TAUTEURS_LIVRES.IdLivre) AS NombreDeLivres
    FROM TAUTEURS
    LEFT JOIN TAUTEURS_LIVRES TAUTEURS_LIVRES ON TAUTEURS.IdAuteur = TAUTEURS_LIVRES.IdAuteur
    WHERE TAUTEURS.IdAuteur = @IdAuteur
    GROUP BY TAUTEURS.IdAuteur, TAUTEURS.NomAuteur, TAUTEURS.PrenomAuteur 
END 
GO

-- Afficher les livres pour une categorie spécifique
CREATE PROCEDURE AfficherLivresParCategorie
    @IdCategorie INT = NULL,
    @NomCategorie VARCHAR(50) = NULL
AS
BEGIN
    IF @IdCategorie IS NULL AND @NomCategorie IS NULL
    BEGIN
        PRINT 'Erreur : Veuillez fournir soit l identifiant de la categorie, soit son nom.' 
        RETURN 
    END 

    
    IF @IdCategorie  IS NULL AND @NomCategorie IS NOT NULL
    BEGIN
        SELECT @IdCategorie  = IdCategorie 
        FROM TCATEGORIES 
        WHERE NomCategorie = LOWER(dbo.Trim(@NomCategorie)) 
        
        IF @IdCategorie  IS NULL
        BEGIN
            PRINT 'Erreur : Categorie non trouvee.' 
            RETURN 
        END 
    END 

    SELECT 
         TLIVRES.IdLivre,
         TLIVRES.Titre,
         TLIVRES.ISBN,
        TLANGUES.NomLangue AS Langue,
        STRING_AGG(TAUTEURS.PrenomAuteur + ' ' + TAUTEURS.NomAuteur, ', ') AS Auteurs,
        STRING_AGG(DISTINCT TEDITEURS.NomEditeur, ', ') AS Editeurs
    FROM TLIVRES
    JOIN TCATEGORIES_LIVRES ON  TLIVRES.IdLivre = TCATEGORIES_LIVRES.IdLivre
    JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
    LEFT JOIN TLANGUES ON  TLIVRES.IdLangue = TLANGUES.IdLangue
    LEFT JOIN TAUTEURS_LIVRES ON  TLIVRES.IdLivre = TAUTEURS_LIVRES.IdLivre
    LEFT JOIN TAUTEURS ON TAUTEURS_LIVRES.IdAuteur = TAUTEURS.IdAuteur
    LEFT JOIN TEDITEURS_LIVRES ON  TLIVRES.IdLivre = TEDITEURS_LIVRES.IdLivre
    LEFT JOIN TEDITEURS ON TEDITEURS_LIVRES.IdEditeur = TEDITEURS.IdEditeur
    WHERE TCATEGORIES.IdCategorie = @IdCategorie 
    GROUP BY  TLIVRES.IdLivre,  TLIVRES.Titre,  TLIVRES.ISBN, TLANGUES.NomLangue
    ORDER BY  TLIVRES.Titre 
    
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

-- Afficher les livres pour une Editeur spécifique
CREATE PROCEDURE AfficherLivresParEditeur
    @IdEditeur INT = NULL,
    @NomEditeur VARCHAR(50) = NULL
AS
BEGIN
    IF @IdEditeur IS NULL AND @NomEditeur IS NULL
    BEGIN
        PRINT 'Erreur : Veuillez fournir soit l identifiant de l editeur, soit son nom.' 
        RETURN 
    END 

    
    IF @IdEditeur IS NULL AND @NomEditeur IS NOT NULL
    BEGIN
        SELECT @IdEditeur = IdEditeur 
        FROM TEDITEURS 
        WHERE NomEditeur = LOWER(dbo.Trim(@NomEditeur)) 
        
        IF @IdEditeur IS NULL
        BEGIN
            PRINT 'Erreur : Editeur non trouve.' 
            RETURN 
        END 
    END 

    SELECT 
         TLIVRES.IdLivre,
         TLIVRES.Titre,
         TLIVRES.ISBN,
        TLANGUES.NomLangue AS Langue,
        STRING_AGG(TAUTEURS.PrenomAuteur + ' ' + TAUTEURS.NomAuteur, ', ') AS Auteurs,
        STRING_AGG(TCATEGORIES.NomCategorie, ', ') AS Categories
    FROM TLIVRES
    JOIN TEDITEURS_LIVRES ON  TLIVRES.IdLivre = TEDITEURS_LIVRES.IdLivre
    JOIN TEDITEURS ON TEDITEURS_LIVRES.IdEditeur = TEDITEURS.IdEditeur
    LEFT JOIN TLANGUES ON  TLIVRES.IdLangue = TLANGUES.IdLangue
    LEFT JOIN TAUTEURS_LIVRES ON  TLIVRES.IdLivre = TAUTEURS_LIVRES.IdLivre
    LEFT JOIN TAUTEURS ON TAUTEURS_LIVRES.IdAuteur = TAUTEURS.IdAuteur
    LEFT JOIN TCATEGORIES_LIVRES ON  TLIVRES.IdLivre = TCATEGORIES_LIVRES.IdLivre
    LEFT JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
    WHERE TEDITEURS.IdEditeur = @IdEditeur
    GROUP BY  TLIVRES.IdLivre,  TLIVRES.Titre,  TLIVRES.ISBN, TLANGUES.NomLangue
    ORDER BY  TLIVRES.Titre 
    

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

-- Afficher les livres pour une Langue spécifique
CREATE PROCEDURE AfficherLivresParLangue
    @IdLangue INT = NULL,
    @NomLangue VARCHAR(50) = NULL
AS
BEGIN
    IF @IdLangue IS NULL AND @NomLangue IS NULL
    BEGIN
        PRINT 'Erreur : Veuillez fournir soit l identifiant de la langue, soit son nom.' 
        RETURN 
    END 

    
    IF @IdLangue IS NULL AND @NomLangue IS NOT NULL
    BEGIN
        SELECT @IdLangue = IdLangue 
        FROM TLANGUES 
        WHERE NomLangue = LOWER(dbo.Trim(@NomLangue)) 
        
        IF @IdLangue IS NULL
        BEGIN
            PRINT 'Erreur : Langue non trouvee.' 
            RETURN 
        END 
    END 

    SELECT 
         TLIVRES.IdLivre,
         TLIVRES.Titre,
         TLIVRES.ISBN,
        STRING_AGG(TAUTEURS.PrenomAuteur + ' ' + TAUTEURS.NomAuteur, ', ') AS Auteurs,
        STRING_AGG(TCATEGORIES.NomCategorie, ', ') AS Categories,
        STRING_AGG(TEDITEURS.NomEditeur, ', ') AS Editeurs
    FROM TLIVRES
    JOIN TLANGUES ON  TLIVRES.IdLangue = TLANGUES.IdLangue
    LEFT JOIN TAUTEURS_LIVRES ON  TLIVRES.IdLivre = TAUTEURS_LIVRES.IdLivre
    LEFT JOIN TAUTEURS ON TAUTEURS_LIVRES.IdAuteur = TAUTEURS.IdAuteur
    LEFT JOIN TCATEGORIES_LIVRES ON  TLIVRES.IdLivre = TCATEGORIES_LIVRES.IdLivre
    LEFT JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
    LEFT JOIN TEDITEURS_LIVRES ON  TLIVRES.IdLivre = TEDITEURS_LIVRES.IdLivre
    LEFT JOIN TEDITEURS ON TEDITEURS_LIVRES.IdEditeur = TEDITEURS.IdEditeur
    WHERE TLANGUES.IdLangue = @IdLangue
    GROUP BY  TLIVRES.IdLivre,  TLIVRES.Titre,  TLIVRES.ISBN
    ORDER BY  TLIVRES.Titre 
    

    SELECT 
        TLANGUES.IdLangue,
        TLANGUES.NomLangue,
        COUNT(DISTINCT  TLIVRES.IdLivre) AS NombreDeLivres
    FROM TLANGUES
    LEFT JOIN TLIVRES  TLIVRES ON TLANGUES.IdLangue =  TLIVRES.IdLangue
    WHERE TLANGUES.IdLangue = @IdLangue
    GROUP BY TLANGUES.IdLangue, TLANGUES.NomLangue 
END 
GO

-- Afficher tous les auteurs
CREATE PROCEDURE AfficherTousAuteurs
AS
BEGIN
    SELECT 
        TAUTEURS.IdAuteur,
        TAUTEURS.NomAuteur,
        TAUTEURS.PrenomAuteur,
        COUNT(DISTINCT TAUTEURS_LIVRES.IdLivre) AS NombreDeLivres,
        STRING_AGG(TCATEGORIES.NomCategorie, ', ') AS Categories
    FROM TAUTEURS
    LEFT JOIN TAUTEURS_LIVRES ON TAUTEURS.IdAuteur = TAUTEURS_LIVRES.IdAuteur
    LEFT JOIN TLIVRES  TLIVRES ON TAUTEURS_LIVRES.IdLivre =  TLIVRES.IdLivre
    LEFT JOIN TCATEGORIES_LIVRES ON  TLIVRES.IdLivre = TCATEGORIES_LIVRES.IdLivre
    LEFT JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
    GROUP BY TAUTEURS.IdAuteur, TAUTEURS.NomAuteur, TAUTEURS.PrenomAuteur
    ORDER BY TAUTEURS.NomAuteur, TAUTEURS.PrenomAuteur 
END 
GO

-- Afficher specifique Auteur
CREATE PROCEDURE AfficherAuteur
    @IdAuteur INT = NULL,
    @NomAuteur VARCHAR(50) = NULL,
    @PrenomAuteur VARCHAR(50) = NULL
AS
BEGIN
    IF @IdAuteur IS NULL AND (@NomAuteur IS NULL OR @PrenomAuteur IS NULL)
    BEGIN
        PRINT 'Erreur : Veuillez fournir soit l identifiant de l auteur, soit son nom et prenom.' 
        RETURN 
    END 

    
    IF @IdAuteur IS NULL AND @NomAuteur IS NOT NULL AND @PrenomAuteur IS NOT NULL
    BEGIN
        SELECT @IdAuteur = IdAuteur 
        FROM TAUTEURS 
        WHERE NomAuteur = LOWER(dbo.Trim(@NomAuteur)) 
          AND PrenomAuteur = LOWER(dbo.Trim(@PrenomAuteur)) 
        
        IF @IdAuteur IS NULL
        BEGIN
            PRINT 'Erreur : Auteur non trouve.' 
            RETURN 
        END 
    END 


    SELECT 
        TAUTEURS.IdAuteur,
        TAUTEURS.NomAuteur,
        TAUTEURS.PrenomAuteur,
        COUNT(DISTINCT TAUTEURS_LIVRES.IdLivre) AS NombreDeLivres
    FROM TAUTEURS
    LEFT JOIN TAUTEURS_LIVRES ON TAUTEURS.IdAuteur = TAUTEURS_LIVRES.IdAuteur
    WHERE TAUTEURS.IdAuteur = @IdAuteur
    GROUP BY TAUTEURS.IdAuteur, TAUTEURS.NomAuteur, TAUTEURS.PrenomAuteur 
    

    SELECT 
        TCATEGORIES.NomCategorie,
        COUNT(DISTINCT TCATEGORIES_LIVRES.IdLivre) AS NombreDeLivres
    FROM TCATEGORIES
    JOIN TCATEGORIES_LIVRES ON TCATEGORIES.IdCategorie = TCATEGORIES_LIVRES.IdCategorie
    JOIN TLIVRES ON TCATEGORIES_LIVRES.IdLivre =  TLIVRES.IdLivre
    JOIN TAUTEURS_LIVRES ON  TLIVRES.IdLivre = TAUTEURS_LIVRES.IdLivre
    WHERE TAUTEURS_LIVRES.IdAuteur = @IdAuteur
    GROUP BY TCATEGORIES.NomCategorie
    ORDER BY COUNT(DISTINCT TCATEGORIES_LIVRES.IdLivre) DESC 
    

    SELECT 
        TEDITEURS.NomEditeur,
        COUNT(DISTINCT TEDITEURS_LIVRES.IdLivre) AS NombreDeLivres
    FROM TEDITEURS
    JOIN TEDITEURS_LIVRES ON TEDITEURS.IdEditeur = TEDITEURS_LIVRES.IdEditeur
    JOIN TLIVRES ON TEDITEURS_LIVRES.IdLivre =  TLIVRES.IdLivre
    JOIN TAUTEURS_LIVRES ON  TLIVRES.IdLivre = TAUTEURS_LIVRES.IdLivre
    WHERE TAUTEURS_LIVRES.IdAuteur = @IdAuteur
    GROUP BY TEDITEURS.NomEditeur
    ORDER BY COUNT(DISTINCT TEDITEURS_LIVRES.IdLivre) DESC 
END 
GO

-- Afficher toutes les categories
CREATE PROCEDURE AfficherToutesCategories
AS
BEGIN
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

-- Afficher tous les editeurs
CREATE PROCEDURE AfficherTousEditeurs
AS
BEGIN
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

-- Affichier toutes les langues
CREATE PROCEDURE AfficherToutesLangues
AS
BEGIN
    SELECT 
         TLIVRES.IdLangue,
         TLIVRES.NomLangue,
        COUNT(DISTINCT liv.IdLivre) AS NombreDeLivres
    FROM TLANGUES
    LEFT JOIN TLIVRES liv ON  TLIVRES.IdLangue = liv.IdLangue
    GROUP BY  TLIVRES.IdLangue,  TLIVRES.NomLangue
    ORDER BY  TLIVRES.NomLangue 
END 
GO

-- Rechercher les Livres
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
        Authors.Auteurs,
        Categories.Categories,
        Editors.Editeurs
    FROM TLIVRES
    LEFT JOIN TLANGUES ON  TLIVRES.IdLangue = TLANGUES.IdLangue
    LEFT JOIN (
        SELECT TAUTEURS_LIVRES.IdLivre,
               STRING_AGG(TAUTEURS.PrenomAuteur + ' ' + TAUTEURS.NomAuteur, ', ') 
                   WITHIN GROUP (ORDER BY TAUTEURS.NomAuteur, TAUTEURS.PrenomAuteur) AS Auteurs
        FROM TAUTEURS_LIVRES
        JOIN TAUTEURS ON TAUTEURS_LIVRES.IdAuteur = TAUTEURS.IdAuteur
        GROUP BY TAUTEURS_LIVRES.IdLivre
    ) Authors ON  TLIVRES.IdLivre = Authors.IdLivre
    LEFT JOIN (
        SELECT TCATEGORIES_LIVRES.IdLivre,
               STRING_AGG(TCATEGORIES.NomCategorie, ', ') 
                   WITHIN GROUP (ORDER BY TCATEGORIES.NomCategorie) AS Categories
        FROM TCATEGORIES_LIVRES
        JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
        GROUP BY TCATEGORIES_LIVRES.IdLivre
    ) Categories ON  TLIVRES.IdLivre = Categories.IdLivre
    LEFT JOIN (
        SELECT TEDITEURS_LIVRES.IdLivre,
               STRING_AGG(TEDITEURS.NomEditeur, ', ') 
                   WITHIN GROUP (ORDER BY TEDITEURS.NomEditeur) AS Editeurs
        FROM TEDITEURS_LIVRES
        JOIN TEDITEURS ON TEDITEURS_LIVRES.IdEditeur = TEDITEURS.IdEditeur
        GROUP BY TEDITEURS_LIVRES.IdLivre
    ) Editors ON  TLIVRES.IdLivre = Editors.IdLivre
    WHERE (@Titre IS NULL OR  TLIVRES.Titre LIKE '%' + @Titre + '%')
      AND (@ISBN IS NULL OR  TLIVRES.ISBN = @ISBN)
      AND (@Langue IS NULL OR TLANGUES.NomLangue LIKE '%' + LOWER(dbo.Trim(@Langue)) + '%')
      AND (@NomAuteur IS NULL OR Authors.Auteurs LIKE '%' + LOWER(dbo.Trim(@NomAuteur)) + '%')
      AND (@PrenomAuteur IS NULL OR Authors.Auteurs LIKE '%' + LOWER(dbo.Trim(@PrenomAuteur)) + '%')
      AND (@Categorie IS NULL OR Categories.Categories LIKE '%' + LOWER(dbo.Trim(@Categorie)) + '%')
      AND (@Editeur IS NULL OR Editors.Editeurs LIKE '%' + LOWER(dbo.Trim(@Editeur)) + '%')
    ORDER BY  TLIVRES.Titre 
END 
GO

-- Nombre de livre, auteur et editeurs par Categorie
CREATE PROCEDURE StatistiquesLivresParCategorie
AS
BEGIN
    SELECT 
        TCATEGORIES.NomCategorie,
        COUNT(DISTINCT TCATEGORIES_LIVRES.IdLivre) AS NombreDeLivres,
        COUNT(DISTINCT TAUTEURS_LIVRES.IdAuteur) AS NombreAuteurs,
        COUNT(DISTINCT TEDITEURS_LIVRES.IdEditeur) AS NombreEditeurs
    FROM TCATEGORIES
    LEFT JOIN TCATEGORIES_LIVRES ON TCATEGORIES.IdCategorie = TCATEGORIES_LIVRES.IdCategorie
    LEFT JOIN TLIVRES ON TCATEGORIES_LIVRES.IdLivre =  TLIVRES.IdLivre
    LEFT JOIN TAUTEURS_LIVRES ON  TLIVRES.IdLivre = TAUTEURS_LIVRES.IdLivre
    LEFT JOIN TEDITEURS_LIVRES ON  TLIVRES.IdLivre = TEDITEURS_LIVRES.IdLivre
    GROUP BY TCATEGORIES.NomCategorie
    ORDER BY COUNT(DISTINCT TCATEGORIES_LIVRES.IdLivre) DESC 
END 
GO

-- Statistiques des Livres Par Auteur
CREATE PROCEDURE StatistiquesLivresParAuteur
AS
BEGIN
    SELECT 
        TAUTEURS.PrenomAuteur + ' ' + TAUTEURS.NomAuteur AS NomComplet,
        COUNT(DISTINCT TAUTEURS_LIVRES.IdLivre) AS NombreDeLivres,
        STRING_AGG(TCATEGORIES.NomCategorie, ', ') AS Categories
    FROM TAUTEURS
    LEFT JOIN TAUTEURS_LIVRES ON TAUTEURS.IdAuteur = TAUTEURS_LIVRES.IdAuteur
    LEFT JOIN TLIVRES ON TAUTEURS_LIVRES.IdLivre =  TLIVRES.IdLivre
    LEFT JOIN TCATEGORIES_LIVRES ON  TLIVRES.IdLivre = TCATEGORIES_LIVRES.IdLivre
    LEFT JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
    GROUP BY TAUTEURS.PrenomAuteur, TAUTEURS.NomAuteur
    ORDER BY COUNT(DISTINCT TAUTEURS_LIVRES.IdLivre) DESC 
END 
GO

-- Statistiques des Livres Par Editeur
CREATE PROCEDURE StatistiquesLivresParEditeur
AS
BEGIN
    SELECT 
        TEDITEURS.NomEditeur,
        COUNT(DISTINCT TEDITEURS_LIVRES.IdLivre) AS NombreDeLivres,
        COUNT(DISTINCT TAUTEURS_LIVRES.IdAuteur) AS NombreAuteurs,
        STRING_AGG(TCATEGORIES.NomCategorie, ', ') AS Categories
    FROM TEDITEURS
    LEFT JOIN TEDITEURS_LIVRES ON TEDITEURS.IdEditeur = TEDITEURS_LIVRES.IdEditeur
    LEFT JOIN TLIVRES ON TEDITEURS_LIVRES.IdLivre =  TLIVRES.IdLivre
    LEFT JOIN TAUTEURS_LIVRES ON  TLIVRES.IdLivre = TAUTEURS_LIVRES.IdLivre
    LEFT JOIN TCATEGORIES_LIVRES ON  TLIVRES.IdLivre = TCATEGORIES_LIVRES.IdLivre
    LEFT JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
    GROUP BY TEDITEURS.NomEditeur
    ORDER BY COUNT(DISTINCT TEDITEURS_LIVRES.IdLivre) DESC 
END 
GO

-- Statistiques des Livres Par Langue
CREATE PROCEDURE StatistiquesLivresParLangue
AS
BEGIN
    SELECT 
        TLANGUES.NomLangue,
        COUNT(DISTINCT  TLIVRES.IdLivre) AS NombreDeLivres,
        COUNT(DISTINCT TAUTEURS_LIVRES.IdAuteur) AS NombreAuteurs,
        COUNT(DISTINCT TEDITEURS_LIVRES.IdEditeur) AS NombreEditeurs,
        STRING_AGG(TCATEGORIES.NomCategorie, ', ') AS Categories
    FROM TLANGUES 
    LEFT JOIN TLIVRES ON TLANGUES.IdLangue =  TLIVRES.IdLangue
    LEFT JOIN TAUTEURS_LIVRES ON  TLIVRES.IdLivre = TAUTEURS_LIVRES.IdLivre
    LEFT JOIN TEDITEURS_LIVRES ON  TLIVRES.IdLivre = TEDITEURS_LIVRES.IdLivre
    LEFT JOIN TCATEGORIES_LIVRES ON  TLIVRES.IdLivre = TCATEGORIES_LIVRES.IdLivre
    LEFT JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
    GROUP BY TLANGUES.NomLangue
    ORDER BY COUNT(DISTINCT  TLIVRES.IdLivre) DESC 
END 
GO

-- Afficher les livres in a spicific raiting range
CREATE PROCEDURE AfficherLivresParNotation
    @NotationMinimum INT = 0,
    @NotationMaximum INT = 10
AS
BEGIN
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
        STRING_AGG(TAUTEURS.PrenomAuteur + ' ' + TAUTEURS.NomAuteur, ', ') AS Auteurs,
        STRING_AGG(TCATEGORIES.NomCategorie, ', ') AS Categories,
        STRING_AGG(TEDITEURS.NomEditeur, ', ') AS Editeurs,
        AVG(TREVIEWS.Notation) AS NotationMoyenne,
        COUNT(TREVIEWS.IdReview) AS NombreAvis
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
    HAVING AVG(TREVIEWS.Notation) >= @NotationMinimum AND AVG(TREVIEWS.Notation) <= @NotationMaximum
    ORDER BY NotationMoyenne DESC, TLIVRES.Titre
END
GO

-- Afficher the top n raited books
CREATE PROCEDURE AfficherLivresTopNotes
    @NombreLivres INT = 10,
    @MinimumAvis INT = 3
AS
BEGIN
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
        STRING_AGG(TAUTEURS.PrenomAuteur + ' ' + TAUTEURS.NomAuteur, ', ') AS Auteurs,
        STRING_AGG(TCATEGORIES.NomCategorie, ', ') AS Categories,
        STRING_AGG(TEDITEURS.NomEditeur, ', ') AS Editeurs,
        AVG(TREVIEWS.Notation) AS NotationMoyenne,
        COUNT(TREVIEWS.IdReview) AS NombreAvis
    FROM TLIVRES
    LEFT JOIN TLANGUES ON TLIVRES.IdLangue = TLANGUES.IdLangue
    LEFT JOIN TAUTEURS_LIVRES ON TLIVRES.IdLivre = TAUTEURS_LIVRES.IdLivre
    LEFT JOIN TAUTEURS ON TAUTEURS_LIVRES.IdAuteur = TAUTEURS.IdAuteur
    LEFT JOIN TCATEGORIES_LIVRES ON TLIVRES.IdLivre = TCATEGORIES_LIVRES.IdLivre
    LEFT JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
    LEFT JOIN TEDITEURS_LIVRES ON TLIVRES.IdLivre = TEDITEURS_LIVRES.IdLivre
    LEFT JOIN TEDITEURS ON TEDITEURS_LIVRES.IdEditeur = TEDITEURS.IdEditeur
    INNER JOIN TREVIEWS ON TLIVRES.IdLivre = TREVIEWS.IdLivre
    GROUP BY TLIVRES.IdLivre, TLIVRES.Titre, TLIVRES.ISBN, TLANGUES.NomLangue
    HAVING COUNT(TREVIEWS.IdReview) >= @MinimumAvis
    ORDER BY NotationMoyenne DESC, NombreAvis DESC, TLIVRES.Titre
END
GO