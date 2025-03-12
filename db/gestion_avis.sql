--PROC 2
CREATE PROCEDURE AjouterAvis
@IdClient AS INT,
@IdLivre AS INT,
@Review AS NVARCHAR(MAX)

AS
BEGIN
    INSERT INTO TREVIEWS(IdClient , IdLivre , review)
    VALUES (@IdClient , @IdLivre , @Review)
END

--PROC 3 
CREATE PROCEDURE ModifierAvis
@IdReview AS INT,
@Review AS NVARCHAR(MAX)

AS
BEGIN
    UPDATE 
        TREVIEWS 
    SET
        review = @Review
    WHERE 
        IdReview = @IdReview
END

--PROC 4
CREATE PROCEDURE SupprimerAvis
@IdReview AS INT,
@Review AS NVARCHAR(MAX)

AS
BEGIN
    DELETE 
    FROM 
        TREVIEWS
    WHERE 
        IdReview = @IdReview
END
