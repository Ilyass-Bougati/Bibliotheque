CREATE PROCEDURE AjouterPenalite     
    @IdAbonnement INT,     
    @IdEmprunt INT = NULL,     
    @Motif VARCHAR(20) 
AS 
BEGIN     
    DECLARE @NbPerteAbime INT     
    DECLARE @DateRetour DATETIME     
    DECLARE @NbJoursRetard INT     
    DECLARE @Montant DECIMAL(10,2)      

    -- Traitement pour le retard
    IF @Motif = 'retard'     
    BEGIN         
        SELECT @DateRetour = DateRetour         
        FROM TEMPRUNTS         
        WHERE IdEmprunt = @IdEmprunt          

        IF @DateRetour IS NULL
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
    ELSE IF @Motif = 'abîmé'     
    BEGIN         
        SET @Montant = 300.00  -- Montant fixe en dirhams pour une détérioration     
    END      

    -- Vérification du nombre de pénalités pour perte ou abîmé
    IF @Motif IN ('perte', 'abîmé')
    BEGIN
        SELECT @NbPerteAbime = COUNT(*)         
        FROM TPENALITE         
        WHERE IdAbonnement = @IdAbonnement AND Motif IN ('perte', 'abîmé') 

        IF @NbPerteAbime = 4
        BEGIN
            UPDATE TABONNEMENTS             
            SET EtatAbonnement = 'annule'             
            WHERE IdAbonnement = @IdAbonnement
            PRINT 'L abonnement a été annulé en raison de 5 pénalités pour perte ou abîmé.'
            RETURN
        END
    END

    -- Insertion de la pénalité si l'abonnement n'est pas annulé
    INSERT INTO TPENALITE (IdAbonnement, IdEmprunt, Motif, Montant, EtatPenalite, DatePenalite)     
    VALUES (@IdAbonnement, @IdEmprunt, @Motif, @Montant, 'en cours', GETDATE())

    -- suspendu l'abonnement s'il n'est pas annulé
    UPDATE TABONNEMENTS        
    SET EtatAbonnement = 'suspendu'
    WHERE IdAbonnement = @IdAbonnement 
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

CREATE PROCEDURE SuspendreAbonnementSiPenalitesRetards
    @IdAbonnement INT,
    @Seuil INT = 3  
AS
BEGIN
    DECLARE @NbPenalites INT

    SELECT @NbPenalites = COUNT(*)
    FROM TPENALITE
    WHERE IdAbonnement = @IdAbonnement 
          AND EtatPenalite = 'en cours' 
          AND Motif = 'retard'

    IF @NbPenalites >= @Seuil
    BEGIN
        -- Vérifier si l'abonnement est déjà suspendu ou annulé
        IF NOT EXISTS (SELECT 1 FROM TABONNEMENTS 
                       WHERE IdAbonnement = @IdAbonnement 
                       AND EtatAbonnement IN ('suspendu', 'annule'))
        BEGIN
            UPDATE TABONNEMENTS
            SET EtatAbonnement = 'suspendu'
            WHERE IdAbonnement = @IdAbonnement

            PRINT 'L abonnement a été suspendu en raison de pénalités de retard impayées.'
            
            -- Insérer une notification pour le client
            --INSERT INTO TNOTIFICATIONS (IdClient, NotificationType, NotificationText)
            -- SELECT IdClient, 'Penalite', 'Votre abonnement a été suspendu en raison de plusieurs retards.'
            -- FROM TABONNEMENTS WHERE IdAbonnement = @IdAbonnement
        END
    END
END

GO

-- Procédure pour lister les pénalités
CREATE PROCEDURE ListerPenalitesEnCours
    @IdAbonnement INT
AS
BEGIN
    SELECT * FROM TPENALITE
    WHERE IdAbonnement = @IdAbonnement AND EtatPenalite = 'en cours'
END
GO
