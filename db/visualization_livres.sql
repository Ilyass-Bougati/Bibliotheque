-- Afficher specifique livre
CREATE PROCEDURE AfficherLivre
    @IdLivre INT
AS
BEGIN
    IF @IdLivre IS NULL OR @IdLivre <= 0
    BEGIN
        PRINT 'Erreur : L identifiant du livre doit etre un nombre positif valide.';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM TLIVRES WHERE IdLivre = @IdLivre)
    BEGIN
        PRINT 'Erreur : Le livre specifie n existe pas.';
        RETURN;
    END;

    SELECT 
        TLIVRES.IdLivre,
        TLIVRES.Titre,
        TLIVRES.ISBN,
        TLANGUES.NomLangue AS Langue,
        STRING_AGG(TAUTEURS.PrenomAuteur + ' ' + TAUTEURS.NomAuteur, ', ') AS Auteurs,
        STRING_AGG(TCATEGORIES.NomCategorie, ', ') AS Categories,
        STRING_AGG(TEDITEURS.NomEditeur, ', ') AS Editeurs
    FROM TLIVRES
    LEFT JOIN TLANGUES ON  TLIVRES.IdLangue = TLANGUES.IdLangue
    LEFT JOIN TAUTEURS_LIVRES ON  TLIVRES.IdLivre = TAUTEURS_LIVRES.IdLivre
    LEFT JOIN TAUTEURS TAUTEURS ON TAUTEURS_LIVRES.IdAuteur = TAUTEURS.IdAuteur
    LEFT JOIN TCATEGORIES_LIVRES ON  TLIVRES.IdLivre = TCATEGORIES_LIVRES.IdLivre
    LEFT JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
    LEFT JOIN TEDITEURS_LIVRES ON  TLIVRES.IdLivre = TEDITEURS_LIVRES.IdLivre
    LEFT JOIN TEDITEURS ON TEDITEURS_LIVRES.IdEditeur = TEDITEURS.IdEditeur
    WHERE  TLIVRES.IdLivre = @IdLivre
    GROUP BY  TLIVRES.IdLivre,  TLIVRES.Titre,  TLIVRES.ISBN, TLANGUES.NomLangue;
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
        STRING_AGG(TEDITEURS.NomEditeur, ', ') AS Editeurs
    FROM TLIVRES
    LEFT JOIN TLANGUES ON TLIVRES.IdLangue = TLANGUES.IdLangue
    LEFT JOIN TAUTEURS_LIVRES ON TLIVRES.IdLivre = TAUTEURS_LIVRES.IdLivre
    LEFT JOIN TAUTEURS ON TAUTEURS_LIVRES.IdAuteur = TAUTEURS.IdAuteur
    LEFT JOIN TCATEGORIES_LIVRES ON TLIVRES.IdLivre = TCATEGORIES_LIVRES.IdLivre
    LEFT JOIN TCATEGORIES ON TCATEGORIES_LIVRES.IdCategorie = TCATEGORIES.IdCategorie
    LEFT JOIN TEDITEURS_LIVRES ON TLIVRES.IdLivre = TEDITEURS_LIVRES.IdLivre
    LEFT JOIN TEDITEURS ON TEDITEURS_LIVRES.IdEditeur = TEDITEURS.IdEditeur
    GROUP BY TLIVRES.IdLivre, TLIVRES.Titre, TLIVRES.ISBN, TLANGUES.NomLangue
    ORDER BY TLIVRES.Titre;
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

    DECLARE @AuthorId INT = @IdAuteur

    IF @AuthorId IS NULL AND @NomAuteur IS NOT NULL AND @PrenomAuteur IS NOT NULL
    BEGIN
        SELECT @AuthorId = IdAuteur 
        FROM TAUTEURS 
        WHERE NomAuteur = LOWER(dbo.Trim(@NomAuteur)) 
          AND PrenomAuteur = LOWER(dbo.Trim(@PrenomAuteur));
        
        IF @AuthorId IS NULL
        BEGIN
            PRINT 'Erreur : Auteur non trouve.';
            RETURN;
        END;
    END;

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
    WHERE TAUTEURS.IdAuteur = @AuthorId
    GROUP BY TLIVRES.IdLivre, TLIVRES.Titre, TLIVRES.ISBN, TLANGUES.NomLangue
    ORDER BY TLIVRES.Titre;
    
    SELECT 
        TAUTEURS.IdAuteur,
        TAUTEURS.NomAuteur,
        TAUTEURS.PrenomAuteur,
        COUNT(DISTINCT TAUTEURS_LIVRES.IdLivre) AS NombreDeLivres
    FROM TAUTEURS
    LEFT JOIN TAUTEURS_LIVRES TAUTEURS_LIVRES ON TAUTEURS.IdAuteur = TAUTEURS_LIVRES.IdAuteur
    WHERE TAUTEURS.IdAuteur = @AuthorId
    GROUP BY TAUTEURS.IdAuteur, TAUTEURS.NomAuteur, TAUTEURS.PrenomAuteur;
END;
GO