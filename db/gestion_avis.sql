--PROC 2
CREATE PROCEDURE AjouterAvis
@IdClient AS INT,
@IdLivre AS INT,
@Review AS NVARCHAR(MAX)

AS
BEGIN
    -- Checking if the review is empy or null
    IF dbo.Validate_empty(@Review) = 0
    BEGIN
        PRINT('l avis est vide')
        RETURN
    END

    INSERT INTO TREVIEWS(IdClient , IdLivre , review)
    VALUES (@IdClient , @IdLivre , @Review)
END

--PROC 3 
CREATE PROCEDURE ModifierAvis
@IdReview AS INT,
@Review AS NVARCHAR(MAX)

AS
BEGIN
    -- Checking if the review is empy or null
    IF dbo.Validate_empty(@Review) = 0
    BEGIN
        PRINT('l avis est vide')
        RETURN
    END

    UPDATE 
        TREVIEWS 
    SET
        review = @Review
    WHERE 
        IdReview = @IdReview
END

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
