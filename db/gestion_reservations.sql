CREATE PROCEDURE ReserverLivre
	@IdAbonnement INT,
	@IdLivre INT
AS
BEGIN
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