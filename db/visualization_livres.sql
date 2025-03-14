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
