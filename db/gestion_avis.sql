--PROC 2
CREATE PROCEDURE AjouterAvis
@IdClient AS INT,
@IdLivre AS INT,
@Commentaire AS NVARCHAR(MAX),
@Note AS INT

AS
BEGIN
    -- Checking if the Comment is empy or null
    IF dbo.Validate_empty(@Commentaire) = 0
    BEGIN
        PRINT('l avis est vide')
        RETURN
    END

    INSERT INTO TREVIEWS(IdClient , IdLivre , Commentaire , Notation)
    VALUES (@IdClient , @IdLivre , @Commentaire , @Note)
END
GO

--PROC 3 
CREATE PROCEDURE ModifierAvis
@IdReview AS INT,
@Commentaire AS NVARCHAR(MAX),
@Note AS INT

AS
BEGIN
    -- Checking if the Comment is empy or null
    IF dbo.Validate_empty(@Commentaire) = 0
    BEGIN
        PRINT('l avis est vide')
        RETURN
    END

    UPDATE 
        TREVIEWS 
    SET
        Commentaire = @Commentaire ,
        Notation = @Note
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
