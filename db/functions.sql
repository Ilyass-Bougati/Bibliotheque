CREATE FUNCTION dbo.Trim (@input NVARCHAR(MAX))  
RETURNS NVARCHAR(MAX)  
AS  
BEGIN  
    RETURN LTRIM(RTRIM(@input))  
END  
GO  


CREATE FUNCTION dbo.Validate_empty (@input NVARCHAR(MAX))  
RETURNS INT 
AS  
BEGIN  
    DECLARE @Result as INT
    
    if dbo.Trim(@input) = '' OR @input IS NULL
    BEGIN
        SET @Result = 0
    END
    ELSE
    BEGIN
        SET @Result = 1
    END

    RETURN @Result
END  
GO  


CREATE FUNCTION dbo.Validate_phonenumber (@input NVARCHAR(MAX))
RETURNS INT
AS  
BEGIN  
    DECLARE @Result as INT
    
    if dbo.Validate_empty(@input) = 1 AND LEN(@input) = 10 AND @input LIKE '[0-9]%' AND @input NOT LIKE '%[^0-9]%'
    BEGIN
        SET @Result = 1
    END
    ELSE
    BEGIN
        SET @Result = 0
    END

    RETURN @Result
END  
GO  


CREATE FUNCTION dbo.Validate_email (@input NVARCHAR(MAX))
RETURNS INT
AS  
BEGIN  
    DECLARE @Result as INT
    
    if dbo.Validate_empty(@input) = 1 AND @input LIKE '_%@_%._%'
    BEGIN
        SET @Result = 1
    END
    ELSE
    BEGIN
        SET @Result = 0
    END

    RETURN @Result
END  
GO 

-- Validate_ISBN
CREATE FUNCTION dbo.Validate_ISBN (@ISBN VARCHAR(20)) 
RETURNS BIT
AS
BEGIN
    DECLARE @EstValide BIT = 0;
    DECLARE @CleanISBN VARCHAR(20);
    DECLARE @Longueur INT;
    
    SET @CleanISBN = REPLACE(REPLACE(@ISBN, '-', ''), ' ', '');
    SET @Longueur = LEN(@CleanISBN);
    
    IF @Longueur = 10 -- ISBN-10
    BEGIN
        
        IF @CleanISBN LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9X]'
        BEGIN
            DECLARE @somme INT = 0;
            DECLARE @i INT = 1;
            DECLARE @Nb CHAR(1);
            DECLARE @Weight INT;
            DECLARE @CheckNb INT;
            
            -- Calculer la somme pondérée pour l'ISBN-10
            WHILE @i <= 9
            BEGIN
                SET @Nb = SUBSTRING(@CleanISBN, @i, 1);
                SET @Weight = 11 - @i;
                SET @somme = @somme + (CAST(@Nb AS INT) * @Weight);
                SET @i = @i + 1;
            END;
            
            SET @CheckNb = (11 - (@somme % 11)) % 11;
            
            IF (@CheckNb = 10 AND SUBSTRING(@CleanISBN, 10, 1) = 'X')
               OR (@CheckNb = CAST(SUBSTRING(@CleanISBN, 10, 1) AS INT))
            BEGIN
                SET @EstValide = 1;
            END;
        END;
    END;
    ELSE IF @Longueur = 13 -- ISBN-13
    BEGIN

        IF @CleanISBN LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
        BEGIN
            DECLARE @somme13 INT = 0;
            DECLARE @j INT = 1;
            DECLARE @Nb13 CHAR(1);
            DECLARE @Weight13 INT;
            DECLARE @CheckNb13 INT;
            
            WHILE @j <= 12
            BEGIN
                SET @Nb13 = SUBSTRING(@CleanISBN, @j, 1);
                SET @Weight13 = IIF(@j % 2 = 1, 1, 3);
                SET @somme13 = @somme13 + (CAST(@Nb13 AS INT) * @Weight13);
                SET @j = @j + 1;
            END;
            
            SET @CheckNb13 = (10 - (@somme13 % 10)) % 10;
            
            IF @CheckNb13 = CAST(SUBSTRING(@CleanISBN, 13, 1) AS INT)
            BEGIN
                SET @EstValide = 1;
            END
        END
    END
    
    RETURN @EstValide;
END
GO