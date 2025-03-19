--PROC 2
CREATE PROCEDURE AjouterAvis
@IdClient AS INT,
@IdLivre AS INT,
@Review AS INT

AS
BEGIN
    INSERT INTO TREVIEWS(IdClient , IdLivre , Review)
    VALUES (@IdClient , @IdLivre , @Review)
END
GO

--PROC 3 
CREATE PROCEDURE ModifierAvis
@IdReview AS INT,
@Review AS INT

AS
BEGIN
    UPDATE 
        TREVIEWS 
    SET
        Review = @Review
    WHERE 
        IdReview = @IdReview
END
GO

--PROC 4
CREATE PROCEDURE SupprimerAvis
@IdReview AS INT
AS
BEGIN
    DELETE 
    FROM 
        TREVIEWS
    WHERE 
        IdReview = @IdReview
END
GO