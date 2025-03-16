CREATE PROCEDURE ModifierExemplaire
	@IdExemplaire AS INT,
	@Localisation AS VARCHAR(100)
AS
BEGIN
    -- Checking if the localisation is empy or null
    IF dbo.Validate_empty(@Localisation) = 0
    BEGIN
        PRINT('le localisation est vide')
        RETURN
    END

	UPDATE
		TEXEMPLAIRES
	SET
		localisation = LOWER(dbo.Trim(@Localisation))
	WHERE
		IdExemplaire = @IdExemplaire
END
GO


CREATE PROCEDURE AjouterExemplaire 
	@Idlivre AS iNT,
	@Localisation AS VARCHAR(100),
	@Disponible AS bit
AS
BEGIN
	INSERT INTO	
		TEXEMPLAIRES (IdLivre,localisation,disponible)
		VALUES (@Idlivre, @Localisation, @Disponible)
END
GO


CREATE PROCEDURE SupprimerExemplaire
	@IdExemplaire AS INT
AS
BEGIN
	DELETE
		TEXEMPLAIRES
	WHERE
		IdExemplaire = @IdExemplaire
END