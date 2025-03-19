--PROC 2
CREATE PROCEDURE AjouterAvis
@IdClient AS INT,
@IdLivre AS INT,
@Review AS INT

AS
BEGIN
    DECLARE @ExistingReview AS INT
    SELECT @ExistingReview = @Review
    FROM
        TREVIEWS
    WHERE
        IdClient = @IdClient
    AND
        IdLivre = @IdLivre

    IF @ExistingReview IS NOT NULL
    BEGIN
        PRINT 'Il existe deja une notation du livre sur votre compte .'
        RETURN
    END 

    INSERT INTO TREVIEWS(IdClient , IdLivre , Review)
    VALUES (@IdClient , @IdLivre , @Review)
END
GO

--PROC 3 
CREATE PROCEDURE ModifierAvis
@IdClient AS INT,
@IdLivre AS INT,
@Review AS INT

AS
BEGIN
    UPDATE 
        TREVIEWS 
    SET
        Review = @Review
    WHERE 
        IdClient = @IdClient
    AND
        IdLivre = @IdLivre
END
GO

--PROC 4
CREATE PROCEDURE SupprimerAvis
@IdClient AS INT,
@IdLivre AS INT,
AS
BEGIN
    DELETE 
    FROM 
        TREVIEWS
     WHERE 
        IdClient = @IdClient
    AND
        IdLivre = @IdLivre
END
GO