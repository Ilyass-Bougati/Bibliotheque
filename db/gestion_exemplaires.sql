CREATE PROCEDURE ModifierExemplaire
	@IdExemplaire AS INT,
	@Localisation AS VARCHAR(100),
	@Disponible AS bit
AS
BEGIN
	UPDATE
		TEXEMPLAIRES
	SET
		localisation = @Localisation,
		disponible = @Disponible
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