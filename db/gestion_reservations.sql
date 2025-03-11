CREATE PROCEDURE ReserverLivre
	@IdClient INT,
	@IdLivre INT
AS
BEGIN
	INSERT INTO TRESERVATIONS (IdClient, IdLivre)
	VALUES (@IdClient, @IdLivre)
END


CREATE PROCEDURE SuprimerReservation
	@IdReservation INT
AS
BEGIN
	DELETE FROM 
		TRESERVATIONS
	WHERE
		IdReservation = @IdReservation
END