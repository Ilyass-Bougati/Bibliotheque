CREATE PROCEDURE AjouterClient
	@Nom VARCHAR(50),
	@Prenom VARCHAR(50),
	@CIN VARCHAR(20),
	@Email VARCHAR(100),
	@PhoneNumber VARCHAR(20),
	@Ville VARCHAR(50)
AS
BEGIN
	-- checking of the inputs are correct
	-- checking if the nom or prenom or or ville CIN are empty
	IF dbo.Validate_empty(@Nom) = 0
	BEGIN
		PRINT 'Le nom est vide'
		RETURN
	END
	IF dbo.Validate_empty(@Prenom) = 0
	BEGIN
		PRINT 'Le Prenom est vide'
		RETURN
	END
	IF dbo.Validate_empty(@CIN) = 0
	BEGIN
		PRINT 'Le CIN est vide'
		RETURN
	END
	IF dbo.Validate_empty(@Ville) = 0
	BEGIN
		PRINT 'Le Ville est vide'
		RETURN
	END

	-- checking that the phone number is valide
	IF dbo.Validate_phonenumber(@PhoneNumber) = 0
	BEGIN
		PRINT 'Le numero de telephone est non valide'
		RETURN
	END

	-- checking if the email is invalide
	IF dbo.Validate_email(@email) = 0
	BEGIN
		PRINT 'Le email est non valide'
		RETURN
	END

	-- inserting the client
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
	-- checking of the inputs are correct
	-- checking if the nom or prenom or or ville CIN are empty
	IF dbo.Validate_empty(@Nom) = 0
	BEGIN
		PRINT 'Le nom est vide'
		RETURN
	END
	IF dbo.Validate_empty(@Prenom) = 0
	BEGIN
		PRINT 'Le Prenom est vide'
		RETURN
	END
	IF dbo.Validate_empty(@CIN) = 0
	BEGIN
		PRINT 'Le CIN est vide'
		RETURN
	END
	IF dbo.Validate_empty(@Ville) = 0
	BEGIN
		PRINT 'Le Ville est vide'
		RETURN
	END

	-- checking that the phone number is valide
	IF dbo.Validate_phonenumber(@PhoneNumber) = 0
	BEGIN
		PRINT 'Le numero de telephone est non valide'
		RETURN
	END

	-- checking if the email is invalide
	IF dbo.Validate_email(@email) = 0
	BEGIN
		PRINT 'Le email est non valide'
		RETURN
	END


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