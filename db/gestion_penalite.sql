

-- Procédure pour ajouter une pénalité
CREATE PROCEDURE AjouterPenalite
    @IdAbonnement INT,
    @IdEmprunt INT,
    @Motif VARCHAR(20)
AS
BEGIN
    DECLARE @NbPerteAbime INT
    DECLARE @DateRetour DATETIME
    DECLARE @NbJoursRetard INT
    DECLARE @Montant DECIMAL(10,2)

    IF @Motif = 'retard'
    BEGIN
        SELECT @DateRetour = DateRetour
        FROM TEMPRUNTS
        WHERE IdEmprunt = @IdEmprunt

        IF @DateRetour IS NULL -- this is an unreacheable case
        BEGIN
            PRINT 'Erreur : La date de retour est introuvable.'
            RETURN
        END

        -- Calcul du nombre de jours de retard
        SET @NbJoursRetard = DATEDIFF(DAY, @DateRetour, GETDATE())

        -- Calcul du montant basé sur les jours de retard
        IF @NbJoursRetard <= 7
            SET @Montant = 50.00  -- Montant pour un retard de 7 jours ou moins
        ELSE IF @NbJoursRetard <= 14
            SET @Montant = 100.00  -- Montant pour un retard de 8 à 14 jours
        ELSE IF @NbJoursRetard <= 21
            SET @Montant = 200.00  -- Montant pour un retard de 15 à 21 jours
        ELSE
            SET @Montant = 300.00  -- Montant maximal pour un retard supérieur à 21 jours
    END
    ELSE IF @Motif = 'perte'
    BEGIN
        SET @Montant = 500.00  -- Montant fixe en dirhams pour une perte
    END
    ELSE IF @Motif = 'abîme'
    BEGIN
        SET @Montant = 300.00  -- Montant fixe en dirhams pour une détérioration
    END

    -- Insertion de la pénalité
    INSERT INTO TPENALITE (IdAbonnement, IdEmprunt, Motif, Montant, EtatPenalite, DatePenalite)
    VALUES (@IdAbonnement, @IdEmprunt, @Motif, @Montant, 'en cours', GETDATE())

    -- Traitement en fonction du motif
    IF @Motif IN ('perte', 'abîme')
    BEGIN
        SELECT @NbPerteAbime = COUNT(*)
        FROM TPENALITE
        WHERE IdAbonnement = @IdAbonnement AND Motif IN ('perte', 'abîme')

        IF @NbPerteAbime >= 5
        BEGIN
            UPDATE TABONNEMENTS
            SET EtatAbonnement = 'annule'
            WHERE IdAbonnement = @IdAbonnement
        END
        ELSE 
        BEGIN
            UPDATE TABONNEMENTS
            SET EtatAbonnement = 'suspendu'
            WHERE IdAbonnement = @IdAbonnement
        END
    END
    ELSE IF @Motif = 'retard'
    BEGIN
        UPDATE TABONNEMENTS
        SET EtatAbonnement = 'suspendu'
        WHERE IdAbonnement = @IdAbonnement
    END
END
GO

-- Procédure pour payer une pénalité
CREATE PROCEDURE PayerPenalite
    @IdPenalite INT
AS
BEGIN
    -- Mettre à jour la pénalité comme "payée"
    UPDATE TPENALITE
    SET EtatPenalite = 'payee'
    WHERE IdPenalite = @IdPenalite;

    -- Récupérer l'ID de l'abonnement associé à la pénalité
    DECLARE @IdAbonnement INT;
    SELECT @IdAbonnement = IdAbonnement FROM TPENALITE WHERE IdPenalite = @IdPenalite;

    -- Vérifier s'il reste des pénalités non payées et réactiver si nécessaire
    EXEC ReactiverAbonnement @IdAbonnement;
END
GO

-- Procédure pour réactiver un abonnement
CREATE PROCEDURE ReactiverAbonnement
    @IdAbonnement INT
AS
BEGIN
    -- Vérifier s'il reste des pénalités non payées
    DECLARE @PenalitesEnCours INT;
    SELECT @PenalitesEnCours = COUNT(*) 
    FROM TPENALITE 
    WHERE IdAbonnement = @IdAbonnement AND EtatPenalite = 'en cours';

    -- Si aucune pénalité en cours, on réactive l'abonnement
    IF @PenalitesEnCours = 0
    BEGIN
        UPDATE TABONNEMENTS
        SET EtatAbonnement = 'actif'
        WHERE IdAbonnement = @IdAbonnement AND EtatAbonnement = 'suspendu';
    END
END
GO

