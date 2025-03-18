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
    VerifierDateAbonnement(@IdAbonnement)
    FETCH NEXT FROM Abonnement_curseur INTO @IdAbonnement
  END
END

CREATE PROCEDURE VerifierReservationsDepassees
AS
BEGIN
    -- Mise � jour de la disponibilit� des exemplaires r�serv�s mais non emprunt�s
    UPDATE 
		TEXEMPLAIRES
    SET 
		EtatExemplaire = 'disponible'
    WHERE 
		IdExemplaire IN 
		(
			SELECT TEXEMPLAIRES.IdExemplaire
			FROM TRESERVATIONS 
			JOIN TEXEMPLAIRES  ON TRESERVATIONS.IdExemplaire = TEXEMPLAIRES.IdExemplaire
			WHERE DATEDIFF(DAY, TRESERVATIONS.DateReservation, GETDATE()) > 7
			  AND TEXEMPLAIRES.EtatExemplaire = 'reserve'
			  AND NOT EXISTS (
				  SELECT 1
				  FROM TEMPRUNTS 
				  JOIN TABONNEMENTS ON TEMPRUNTS.IdAbonnement = TABONNEMENTS.IdAbonnement
				  WHERE TEMPRUNTS.IdExemplaire = TRESERVATIONS.IdExemplaire
					AND TABONNEMENTS.IdClient = TRESERVATIONS.IdClient 
			  )
    )

    -- Suppression des r�servations non r�cup�r�es apr�s 7 jours
    DELETE 
	FROM 
		TRESERVATIONS
    WHERE
		DATEDIFF(DAY, DateReservation, GETDATE()) > 7
		AND NOT EXISTS (
          SELECT 1
          FROM TEMPRUNTS 
          JOIN TABONNEMENTS ON TEMPRUNTS.IdAbonnement = TABONNEMENTS.IdAbonnement
          WHERE TEMPRUNTS.IdExemplaire = TRESERVATIONS.IdExemplaire AND 
		  TABONNEMENTS.IdClient = TRESERVATIONS.IdClient
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

    -- Curseur pour parcourir tous les emprunts et v�rifier les p�nalit�s pour retard
    DECLARE penalite_cursor CURSOR FOR
    SELECT 
        TEMPRUNTS.IdAbonnement, TEMPRUNTS.IdEmprunt, TEMPRUNTS.DateRetour
    FROM 
        TEMPRUNTS 
    WHERE 
        TEMPRUNTS.DateRetour < GETDATE()  -- Emprunts en retard
        AND TEMPRUNTS.IdEmprunt NOT IN (SELECT IdEmprunt FROM TPENALITE WHERE Motif = 'retard') -- �viter les doublons

    OPEN penalite_cursor
    FETCH NEXT FROM penalite_cursor INTO @IdAbonnement, @IdEmprunt, @DateRetour

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Calcul du retard
        SET @NbJoursRetard = DATEDIFF(DAY, @DateRetour, GETDATE())

        -- Si le retard est confirm�, ajouter la p�nalit�
        IF @NbJoursRetard > 0
        BEGIN
            EXEC AjouterPenalite @IdAbonnement, @IdEmprunt, 'retard'
        END

        FETCH NEXT FROM penalite_cursor INTO @IdAbonnement, @IdEmprunt, @DateRetour
    END

    CLOSE penalite_cursor
    DEALLOCATE penalite_cursor

END
GO
