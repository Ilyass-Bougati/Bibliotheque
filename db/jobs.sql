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
    SET EtatExemplaire = 'disponible'
    WHERE EtatExemplaire = 'reserve'
    AND IdLivre IN (
        SELECT DISTINCT IdLivre
        FROM TRESERVATIONS
        WHERE DATEDIFF(DAY, DateReservation, GETDATE()) > 7
        AND NOT EXISTS (
            SELECT 1
            FROM TEMPRUNTS
            JOIN TABONNEMENTS ON  TEMPRUNTS.IdAbonnement = TABONNEMENTS.IdAbonnement
            JOIN TEXEMPLAIRES ON  TEMPRUNTS.IdExemplaire = TEXEMPLAIRES.IdExemplaire
            WHERE TEXEMPLAIRES.IdLivre = TRESERVATIONS.IdLivre
            AND TABONNEMENTS.IdClient = TRESERVATIONS.IdClient
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
        AND TABONNEMENTS.IdClient = TRESERVATIONS.IdClient
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