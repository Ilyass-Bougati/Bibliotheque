-- AjouterLivre
CREATE PROCEDURE AjouterLivre
    @Titre NVARCHAR(100),
    @ISBN NVARCHAR(20),
    @IdLangue INT,
    @IdAutheur INT
AS
BEGIN
    INSERT INTO TLIVRES (Titre, ISBN, IdLangue, IdAutheur) 
    VALUES (@Titre, @ISBN, @IdLangue, @IdAutheur);
END;
GO;

-- ModifierLivre 
CREATE PROCEDURE ModifierLivre
    @IdLivre INT,
    @Titre VARCHAR(100) = NULL,
    @ISBN VARCHAR(20) = NULL,
    @IdLangue INT = NULL,
    @IdAutheur INT = NULL
AS
BEGIN
    UPDATE TLIVRES
    SET 
        Titre = COALESCE(@Titre, Titre), -- La fonction COALESCE() renvoie la première valeur non NULL parmi ses arguments.
        ISBN = COALESCE(@ISBN, ISBN),   -- Dans notre procédure, elle permet de conserver la valeur actuelle de la colonne 
        IdLangue = COALESCE(@IdLangue, IdLangue),-- si le paramètre correspondant est NULL. Ainsi, seules les colonnes dont une nouvelle 
        IdAutheur= COALESCE(@IdAutheur, IdAutheur)-- valeur est fournie seront mises à jour.
    WHERE IdLivre = @IdLivre;
END;
GO

-- SupprimerLivre
CREATE PROCEDURE SupprimerLivre
    @IdLivre INT
AS
BEGIN
    DELETE FROM TLIVRES WHERE IdLivre = @IdLivre;
END;
Go;

-- AssocierCategorieLivre
CREATE PROCEDURE AssocierCategorieLivre
    @IdLivre INT,
    @idCategorie INT
AS
BEGIN
    INSERT INTO TCATEGORIES_LIVRES (idCategorie, IdLivre)
    VALUES (@idCategorie, @IdLivre);
END;
GO


-- AssocierAuteurLivre
CREATE PROCEDURE AssocierAuteurLivre
    @IdLivre INT,
    @IdAutheur INT
AS
BEGIN
    INSERT INTO TAUTHEURS_LIVRES (IdAutheur, IdLivre)
    VALUES (@IdAutheur, @IdLivre);
END;
GO