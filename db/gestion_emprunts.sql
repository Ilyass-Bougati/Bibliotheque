--Emprunter livre
CREATE PROCEDURE EmprunterLivre
@IdAbonnement AS INT,
@IdExemplaire AS INT,
@DateEmprunt AS DATETIME,

AS
BEGIN

    -- Verify that the client is not under a penalty
    DECLARE @EtatClient AS VARCHAR(20)
    SELECT @EtatClient = LOWER(Etat) -- etat should be lowercase by default
    FROM(
        SELECT
            Etat
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

    --Verify that the book is not reserved
    DECLARE @EtatLivre AS BIT
    SELECT @EtatLivre = Disponibilite
    FROM
        (
            SELECT
                Disponibilite
            FROM 
                TEXEMPLAIRES
            WHERE
                IdExemplaire = @IdExemplaire
        )AS TEMP2

    IF @EtatLivre != 'disponible'
    BEGIN
        PRINT 'l''exemplaire n''est pas disponible.'
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

    INSERT INTO TEMPRUNTS(IdClient , IdExemplaire , DateEmprunt , DateRetour)
    VALUES(@IdClient , @IdExemplaire , @DateEmprunt , @DateRetour)

    UPDATE 
        TEXEMPLAIRES
    SET
        Disponibilite = 'empruntee'
    WHERE
        IdExemplaire = @IdExemplaire

END





--Retourner livre
CREATE PROCEDURE RetournerLivre
@IdExemplaire AS INT

AS
BEGIN
    --Checks if the book is reserved :
    
    DECLARE @Reservation AS INT
    SELECT @Reservation = IdReservation
    FROM
        (
            SELECT
                IdReservation
            FROM
                TRESERVATIONS
            WHERE
                IdExemplaire = @IdExemplaire
        )AS TEMP2

    DELETE FROM TEMPRUNTS
    WHERE IdExemplaire = @IdExemplaire

    DECLARE @Disponibilite AS VARCHAR(20)
    SELECT @Disponibilite = 'disponible'
    
    IF @Reservation IS NOT NULL
    BEGIN
        SELECT @Disponibilite = 'reserve'
    END

    UPDATE
        TEXEMPLAIRES
    SET
        Disponible = 'disponible'
    WHERE
        IdExemplaire = @IdExemplaire
END
