--PROC 1
CREATE PROCEDURE EnvoyerNotification
@IdClient AS INT,
@NotificationText AS NVARCHAR(MAX),
@NotificationType AS VARCHAR(20)

AS
BEGIN
    -- Checking if the notification text is empy or null
    IF dbo.Validate_empty(@NotificationText) = 0
    BEGIN
        PRINT('le notification est vide')
        RETURN
    END

    INSERT INTO TNOTIFICATIONS(IdClient , NotificationType , NotificationText)
    VALUES (@IdClient , @NotificationType , @NotificationText)

END
GO