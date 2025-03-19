--Emprunter livre
CREATE PROCEDURE EmprunterLivre
@IdAbonnement AS INT,
@IdExemplaire AS INT,
@DateEmprunt AS DATETIME

AS
BEGIN

    -- Verifier que le client n'est pas penalise
    DECLARE @EtatClient AS VARCHAR(20)
    SELECT @EtatClient = LOWER(EtatAbonnement) -- etat should be lowercase by default
    FROM(
        SELECT
            EtatAbonnement
        FROM
            TABONNEMENTS
        WHERE
            @IdAbonnement = IdAbonnement
        ) AS TEMP1

    IF @EtatClient != 'actif'
    BEGIN
        PRINT 'L''abonnement n''est pas eligible a un emprunt'
        RETURN
    END

    --Verify that the client didn't go over the maximum amount of loans
    DECLARE @NbEmpruntMax AS INT
    DECLARE @NbEmprunt AS INT

    SELECT @NbEmpruntMax = NbEmpMax
    FROM
        (
            SELECT
                NbEmpruntMax AS NbEmpMax
            FROM 
                TABONNEMENTS_TYPE JOIN TABONNEMENTS 
                ON 
                TABONNEMENTS_TYPE.IdAbonnementType  = TABONNEMENTS.IdAbonnementType
            WHERE
                IdAbonnement = @IdAbonnement
        )AS TEMP3

    SELECT @NbEmprunt = NbEmp
    FROM
        (
            SELECT
                COUNT(IdEmprunt) AS NbEmp
            FROM 
                TEMPRUNTS
            WHERE
                IdAbonnement = @IdAbonnement
        )AS TEMP4

    IF @NbEmpruntMax = @NbEmprunt
    BEGIN
        PRINT 'Le client a atteint le nombre maximal de livres empruntes'
        RETURN
    END

    DECLARE @DateRetour AS DATETIME
    SELECT @DateRetour = DATEADD(day , 15 , @DateEmprunt)

    INSERT INTO TEMPRUNTS(IdAbonnement , IdExemplaire , DateEmprunt , DateRetour)
    VALUES(@IdAbonnement , @IdExemplaire , @DateEmprunt , @DateRetour)

    UPDATE 
        TEXEMPLAIRES
    SET
        Disponibilite = 'empruntee'
    WHERE
        IdExemplaire = @IdExemplaire

END
GO


--Retourner livre
CREATE PROCEDURE RetournerLivre
@IdExemplaire AS INT

AS
BEGIN
    --Gets the exemplary's book id
    DECLARE @IdLivre AS INT
    SELECT @IdLivre = IdLivre
    FROM
        TEXEMPLAIRES
    WHERE
        IdExemplaire = @IdExemplaire

    --Checks if the book is reserved :
    DECLARE @IdAbonnement AS INT
    SELECT @IdAbonnement = TRESERVATIONS.IdAbonnement
    FROM
        TRESERVATIONS JOIN TABONNEMENTS
        ON TRESERVATIONS.IdAbonnement = TABONNEMENTS.IdAbonnement
    WHERE
        IdLivre = @IdLivre

    DELETE FROM TEMPRUNTS
    WHERE IdExemplaire = @IdExemplaire

    DECLARE @Disponibilite AS VARCHAR(20)
    SET @Disponibilite = 'disponible'
    
    IF @IdAbonnement IS NOT NULL
    BEGIN
        SELECT @Disponibilite = 'reserve'

        DECLARE @IdClient AS INT
        SELECT @IdClient = IdClient
        FROM
            TABONNEMENTS
        WHERE
            IdAbonnement = @IdAbonnement

        EXEC EnvoyerNotification @IdClient ,'Le livre que vous avez reserve est maintenant disponible .', 'Reservation'
    END


    UPDATE
        TEXEMPLAIRES
    SET
        Disponibilite = @Disponibilite
    WHERE
        IdExemplaire = @IdExemplaire
END
GO