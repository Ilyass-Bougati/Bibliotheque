CREATE PROCEDURE AjouterAuteur
	@NomAuteur NVARCHAR(50),
	@PrenomAuteur NVARCHAR(50)
AS
BEGIN
    INSERT INTO TAUTEURS (NomAuteur, PrenomAuteur)
	VALUES (@NomAuteur, @PrenomAuteur)
END
GO

CREATE PROCEDURE AjouterCategorie
	@NomCategorie NVARCHAR(50)
AS
BEGIN
    INSERT INTO TCATEGORIES (NomCategorie)
	VALUES (@NomCategorie)
END
GO



CREATE PROCEDURE AjouterLangue
	@NomLangue NVARCHAR(50)
AS
BEGIN
    INSERT INTO TLANGUES (NomLangue)
	VALUES (@NomLangue)
END
GO


CREATE PROCEDURE AjouterEditeur
	@NomEditeur NVARCHAR(50),
	@PrenomEditeur NVARCHAR(50)
AS
BEGIN
    INSERT INTO TEDITEURS (NomEditeur, PrenomEditeur)
	VALUES (@NomEditeur, @PrenomEditeur)
END