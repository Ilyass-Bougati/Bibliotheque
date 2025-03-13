CREATE FUNCTION dbo.TRIMME (@input_text NVARCHAR(MAX))  
RETURNS NVARCHAR(MAX)  
AS  
BEGIN  
    -- Supprimer les espaces en début et fin  
    DECLARE @trimmed_text NVARCHAR(MAX) = LTRIM(RTRIM(@input_text));  

    -- Remplacer plusieurs espaces internes par un seul  
    WHILE CHARINDEX('  ', @trimmed_text) > 0  
    BEGIN  
        SET @trimmed_text = REPLACE(@trimmed_text, '  ', ' ');  
    END  

    RETURN @trimmed_text;  
END