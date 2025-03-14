CREATE PROCEDURE AjouterTypeAbonnement
	@AbonnementType VARCHAR(50),
    @EmpruntMax INT,
    @Duree INT,
    @Prix INT
AS
BEGIN
    -- checking that the type isn't empty
    if dbo.Validate_empty(@AbonnementType) = 0
    BEGIN
        print('Le type abonnement est vide')
        RETURN
    END

    INSERT INTO TABONNEMENTS_TYPE (AbonnementType, EmpruntMax, Duree, Prix)
    VALUES (LOWER(@AbonnementType), @EmpruntMax, @Duree, @Prix)
END
GO


CREATE PROCEDURE AjouterAbonnement
    @IdClient INT,
    @AbonnementType VARCHAR(50)
AS 
BEGIN
    -- getting the type of subscription
    SET @AbonnementType = dbo.Trim(LOWER(@AbonnementType))
    DECLARE @IdAbonnementType INT
    SET @IdAbonnementType = (
        SELECT
            IdAbonnementType
        FROM
            TABONNEMENTS_TYPE
        WHERE
            AbonnementType LIKE @AbonnementType
    )

    if @IdAbonnementType IS NULL
    BEGIN
        print('Ce type n existe pas')
        RETURN
    END

    -- inserting
    INSERT INTO TABONNEMENTS (IdAbonnementType, IdClient)
    VALUES (@IdAbonnementType, @IdClient)
END
GO


CREATE PROCEDURE ModifierAbonnement
    @IdAbonnement INT,
    @AbonnementType VARCHAR(50),
    @Etat VARCHAR(50)
AS
BEGIN
    -- getting the type of subscription
    SET @AbonnementType = dbo.Trim(LOWER(@AbonnementType))
    DECLARE @IdAbonnementType INT
    SET @IdAbonnementType = (
        SELECT
            IdAbonnementType
        FROM
            TABONNEMENTS_TYPE
        WHERE
            AbonnementType LIKE @AbonnementType
    )

    if @IdAbonnementType IS NULL
    BEGIN
        print('Ce type n existe pas')
        RETURN
    END

    UPDATE
        TABONNEMENTS
    SET
        IdAbonnementType = @IdAbonnementType,
        Etat = dbo.Trim(LOWER(@Etat))
    WHERE
        IdAbonnement = @IdAbonnement
        
END