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
@IdClient AS INT

AS
BEGIN
    --Check if the client is returning the book in the agreed upon return date
    DECLARE @DateRetourEffective AS DATETIME
    DECLARE @DateRetourInitiale AS DATETIME

    SELECT @DateRetourEffective = GETDATE()
    SELECT @DateRetourInitiale = DateRetourIn
    FROM
        (
            SELECT
                DateRetour AS DateRetourIn
            FROM
                TEMPRUNTS
            WHERE
                IdExemplaire = @IdExemplaire
        ) AS TEMP1

    IF DATEDIFF(day , @DateRetourEffective ,@DateRetourInitiale) < 0
    BEGIN
        --Insert penalty procedure here :
        --Proposed arguments : 
            -- + Retard DATETIME
            -- + IdAbonnement INT
    END

    --String type argument needed to describe the state of the returned book :
    --However :
        -- + How much should that string hold ?
        -- + What are its possible values ?

    -- Once we settle down on these , then this procedure can be finished

    DELETE FROM TEMPRUNTS
    WHERE IdExemplaire = @IdExemplaire

    --If the "Disponible" attribute is affected by a book being rented then this
    --block is changing it , however , be it not necessary , I shall remove it.

    UPDATE
        TEXEMPLAIRES
    SET
        Disponible = 'disponible'
    WHERE
        IdExemplaire = @IdExemplaire
END
