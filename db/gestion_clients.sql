CREATE PROCEDURE AjouterClient
	@Nom VARCHAR(50),
	@Prenom VARCHAR(50),
	@CIN VARCHAR(20),
	@Email VARCHAR(100),
	@PhoneNumber VARCHAR(20),
	@Ville VARCHAR(50)
AS
BEGIN
    INSERT INTO TCLIENTS(Nom, Prenom, CIN, Email, PhoneNumber, Ville)
	VALUES (@Nom, @Prenom, @CIN, @Email, @PhoneNumber, @Ville)
END
GO


CREATE PROCEDURE ModifierClient
	@IdClient INT,
	@Nom VARCHAR(50),
	@Prenom VARCHAR(50),
	@CIN VARCHAR(20),
	@Email VARCHAR(100),
	@PhoneNumber VARCHAR(20),
	@Ville VARCHAR(50)
AS
BEGIN
    UPDATE
		TCLIENTS
	SET
		Nom = @Nom,
		Prenom = @Prenom,
		CIN = @CIN,
		Email = @Email,
		PhoneNumber = @PhoneNumber,
		Ville = @Ville
	WHERE
		idClient = @IdClient
END
GO


CREATE PROCEDURE SuprimerClient
	@IdClient INT
AS
BEGIN
    DELETE FROM 
		TCLIENTS
	WHERE
		idClient = @IdClient
END
GO


CREATE PROCEDURE InterditClient
	@IdClient INT
AS
BEGIN
	UPDATE
		TCLIENTS
	SET
		interdit = 1
	WHERE
		idClient = @IdClient
END