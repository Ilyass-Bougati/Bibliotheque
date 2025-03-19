CREATE PROCEDURE ReserverLivre
	@IdAbonnement INT,
	@IdLivre INT
AS
BEGIN
	DECLARE @NbExemplairesDisponibles AS INT
	SELECT @NbExemplairesDisponibles = COUNT(IdExemplaire)
	FROM
		TEXEMPLAIRES
	WHERE
		IdLivre = @IdLivre
	AND	
		Disponibilite = 'disponible'
	
	IF @NbExemplairesDisponibles > 0
	BEGIN
		PRINT 'Reservation refusee : des exemplaires sont disponibles deja .'
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