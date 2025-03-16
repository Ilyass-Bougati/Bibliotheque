--PROC 1
CREATE PROCEDURE EnvoyerNotification
@IdClient AS INT,
@NotificationText AS NVARCHAR(MAX),
@IdType AS INT

AS
BEGIN
    -- Checking if the notification text is empy or null
    IF dbo.Validate_empty(@NotificationText) = 0
    BEGIN
        PRINT('le notification est vide')
        RETURN
    END

    INSERT INTO TNOTIFICATIONS(IdClient , IdNotificationType , NotificationText)
    VALUES (@IdClient , @IdType , @NotificationText)

END
