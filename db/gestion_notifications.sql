--PROC 1
CREATE PROCEDURE EnvoyerNotification
@IdClient AS INT,
@NotificationText AS NVARCHAR(MAX),
@NotificationDate AS DATETIME,
@IdType AS INT

AS
BEGIN

    INSERT INTO TNOTIFICATIONS(IdClient , IdNotificationType , NotificationText , NotificationDate)
    VALUES (@IdClient , @IdType , @NotificationText , @NotificationText)

END
