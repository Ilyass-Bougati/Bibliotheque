CREATE PROCEDURE ReserverLivre
	@IdAbonnement INT,
	@IdLivre INT
AS
BEGIN
	-- checking if the books is available
	DECLARE @IdExemplaire INT
	SET @IdExemplaire = IdExemplaire FROM (
		SELECT 
			IdExemplaire
		FROM 
			TEXEMPLAIRES
		WHERE 
			IdLivre = @IdLivre
			AND Disponibilite = 'disponible'
	) 

	IF @IdLivre IS NULL
	BEGIN
		PRINT('vous ne pouvez pas réserver un livre qui est disponible')
		RETURN
	END


	INSERT INTO TRESERVATIONS (IdAbonnement, IdLivre)
	VALUES (@IdAbonnement, @IdLivre)
END
GO

CREATE PROCEDURE SupprimerReservation
	@IdReservation INT
AS
BEGIN
	DELETE FROM 
		TRESERVATIONS
	WHERE
		IdReservation = @IdReservation
END
GO