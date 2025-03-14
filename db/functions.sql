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