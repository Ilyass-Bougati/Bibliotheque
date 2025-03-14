--PROC 6
CREATE PROCEDURE EmprunterLivre
@IdClient AS INT,
@IdExemplaire AS INT,
@DateEmprunt AS DATETIME,
@DateRetour AS DATETIME

AS
BEGIN

--Verifie si le client est sanctionne
--DEPRECATED ! : is to change once the new schema is decided.
DECLARE @Etat_Client AS INT

SELECT
    @Etat_Client = INTERDICTION
FROM
    (
        SELECT
            interdit as INTERDICTION
        FROM
            TCLIENTS
        WHERE
            IdClient = @IdClient
    ) AS TEMP1


IF @Etat_Client = 1
BEGIN
    PRINT 'Le client est sanctionne .'
    RETURN
END

-- Verifie si l'exemplaire en question est libre :
DECLARE @Etat_Livre AS INT
SELECT 
    @Etat_Livre = DISPONIBLE
FROM
    (
        SELECT
            disponible as DISPONIBLE
        FROM
            TCLIENTS
        WHERE
            IdExemplaire = @IdExemplaire
    )AS TEMP2

IF @Etat_Livre = 0
BEGIN
    PRINT 'l''exemplaire n''est pas disponible.'
    RETURN
END

INSERT INTO TEMPRUNTS(IdClient , IdExemplaire , DateEmprunt , DateRetour)
VALUES(@IdClient , @IdExemplaire , @DateEmprunt , @DateRetour)

UPDATE 
    TEXEMPLAIRES
SET
    disponible = 0
WHERE
    IdExemplaire = IdExemplaire

END

--PROC 7
CREATE PROCEDURE RetournerLivre
@IdLivre AS INT
@IdEmprunt AS INT

AS
BEGIN

DECLARE @DateRetourEffectif AS DATETIME
SELECT @DateRetourEffectif = GETDATE()

DECLARE @Difference AS INT
SELECT @Difference = DATEDIFF(day , @DateRetourEffectif , DateRetourPevue)

FROM
    (
        SELECT 
            TOP 1 DateRetour AS DateRetourPevue
        FROM
            TEMPRUNTS
        WHERE
            IdEmprunt = @IdEmprunt
    )AS TDATE

DECLARE @IdClient AS INT
SELECT @IdClient = CLIENT

FROM
    (
        SELECT 
            TOP 1 IdClient AS CLIENT
        FROM 
            TCLIENTS
        WHERE 
            IdClient = @IdClient
    )AS TCLIENT

DECLARE @IdExemplaire AS INT
SELECT @IdExemplaire = IDex

FROM
    (
        SELECT 
            TOP 1 IdExemplaire AS IDex
        FROM
            TEMPRUNTS
        WHERE
            IdEmprunt = @IdEmprunt
    )AS TEXEMPLAIRE

IF @Difference < 0
BEGIN
    UPDATE 
        TCLIENTS
    SET 
        interdit = 1
    WHERE
        IdClient = @IdClient
END

UPDATE
    TEXEMPLAIRES
SET
    disponible = 1
WHERE
    IdExemplaire = @IdExemplaire

DELETE FROM
    TEMPRUNTS
WHERE
    IdEmprunt = @IdEmprunt

END
