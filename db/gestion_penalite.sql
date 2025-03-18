--Procedure pour Ajouter une Penalite
CREATE PROCEDURE AjouterPenalite     
    @IdAbonnement INT,     
    @IdEmprunt INT = NULL,     
    @Motif VARCHAR(20) 
AS 
BEGIN     
    DECLARE @NbPerteAbime INT = 0    
    DECLARE @DateRetour DATETIME     
    DECLARE @NbJoursRetard INT     
    DECLARE @Montant DECIMAL(10,2)      
    DECLARE @IdClient INT
    DECLARE @NotificationText NVARCHAR(MAX)

    -- Récupérer l'IdClient à partir de l'IdAbonnement
    SELECT @IdClient = IdClient FROM TABONNEMENTS WHERE IdAbonnement = @IdAbonnement

    -- Traitement pour le retard
    IF @Motif = 'retard'
    BEGIN
        -- Vérifier si @IdEmprunt est NULL
        IF @IdEmprunt IS NULL
        BEGIN
            PRINT 'Erreur : L''ID d''emprunt est requis pour calculer la pénalité de retard.'
            RETURN
        END      
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
            SET @Montant = 100.00     -- Montant pour un retard de 8 à 14 jours      
        ELSE IF @NbJoursRetard <= 21             
            SET @Montant = 200.00     -- Montant pour un retard de 15 à 21 jours     
        ELSE             
            SET @Montant = 300.00  -- Montant maximal pour un retard supérieur à 21 jours 

        -- Si le retard est de 3 mois (90 jours) ou plus on marque l'exemplaire comme perdu
        IF @NbJoursRetard >= 90
        BEGIN
            UPDATE TEXEMPLAIRES
            SET Disponibilite = 'perdu'
            WHERE IdExemplaire = (SELECT IdExemplaire FROM TEMPRUNTS WHERE IdEmprunt = @IdEmprunt)

            PRINT 'L exemplaire a été marqué comme perdu en raison d un retard de 3 mois ou plus.'
        END

        SELECT @NotificationText =  'Vous avez une pénalité pour retard de '+ CAST(@NbJoursRetard AS NVARCHAR(20))+ ' jours. Montant: ' + CAST(@Montant AS NVARCHAR(20))+ ' Dhs.'
        -- Envoi de notification pour retard
        EXEC EnvoyerNotification @IdClient,@NotificationText ,'retard'
    END     
    ELSE IF @Motif = 'perte'     
    BEGIN         
        SET @Montant = 500.00  

        SELECT @NotificationText = 'Un livre a été déclaré perdu. Une pénalité de ' +CAST(@Montant AS NVARCHAR(20))+ ' Dhs a été appliquée.'
        -- Envoi de notification pour perte
        EXEC EnvoyerNotification @IdClient, @NotificationText,'perte'
    END     
    ELSE IF @Motif = 'abime'     
    BEGIN         
        SET @Montant = 300.00  

        SELECT @NotificationText = 'Un livre a été déclaré abîmé. Une pénalité de ' +CAST(@Montant AS NVARCHAR(20))+ ' Dhs a été appliquée.'
        -- Envoi de notification pour abîmé
        EXEC EnvoyerNotification @IdClient, @NotificationText, 'abime'
    END      

    -- Vérification du nombre de pénalités pour perte ou abîmé
    IF @Motif IN ('perte', 'abime')
    BEGIN
        SET @NbPerteAbime = 0
        SELECT @NbPerteAbime = COUNT(*)         
        FROM TPENALITE         
        WHERE IdAbonnement = @IdAbonnement AND Motif IN ('perte', 'abime') 

        IF @NbPerteAbime = 4
        BEGIN
            UPDATE TABONNEMENTS             
            SET EtatAbonnement = 'annule'             
            WHERE IdAbonnement = @IdAbonnement

            PRINT 'L abonnement a été annulé en raison de 5 pénalités pour perte ou abîmé.'

            -- Envoi de notification pour annulation
            EXEC EnvoyerNotification @IdClient, 'Votre abonnement a été annulé en raison de 5 pénalités pour perte ou détérioration.','annulation'

            RETURN
        END
    END

    -- Insertion de la pénalité si l'abonnement n'est pas annulé
    INSERT INTO TPENALITE (IdAbonnement, IdEmprunt, Motif, Montant, EtatPenalite, DatePenalite)     
    VALUES (@IdAbonnement, @IdEmprunt, @Motif, @Montant, 'en cours', GETDATE())

    -- Suspendre l'abonnement s'il n'est pas annulé
    UPDATE TABONNEMENTS        
    SET EtatAbonnement = 'suspendu'
    WHERE IdAbonnement = @IdAbonnement 

    -- Envoi de notification pour suspension
    EXEC EnvoyerNotification @IdClient,'Votre abonnement a été suspendu en raison d''une pénalité.', 'suspension'
END
GO


-- Procédure pour réactiver un abonnement
CREATE PROCEDURE ReactiverAbonnement
    @IdAbonnement INT
AS
BEGIN
     DECLARE @IdClient INT 
      -- Récupérer l'IdClient à partir de l'IdAbonnement
    SELECT @IdClient = IdClient FROM TABONNEMENTS WHERE IdAbonnement = @IdAbonnement
    -- Vérifier s'il reste des pénalités non payées
    DECLARE @PenalitesEnCours INT 
    SELECT @PenalitesEnCours = COUNT(*) 
    FROM TPENALITE 
    WHERE IdAbonnement = @IdAbonnement AND EtatPenalite = 'en cours' 

    -- Si aucune pénalité en cours, on réactive l'abonnement
    IF @PenalitesEnCours = 0
    BEGIN
        UPDATE TABONNEMENTS
        SET EtatAbonnement = 'actif'
        WHERE IdAbonnement = @IdAbonnement AND EtatAbonnement = 'suspendu'
         -- Ajouter une notification dans la table de notifications
        EXEC EnvoyerNotification @IdClient,  'Votre abonnement a été réactivé avec succès.','Confirmation'

    END
END
GO


--Procedure pour payer une Penalite
CREATE PROCEDURE PayerPenalite
    @IdPenalite INT
AS
BEGIN
    -- Mettre à jour la pénalité comme "payée"
    UPDATE TPENALITE
    SET EtatPenalite = 'payee'
    WHERE IdPenalite = @IdPenalite

    -- Récupérer l'ID de l'abonnement et l'ID du client en une seule requête avec jointure
    DECLARE @IdAbonnement INT, @IdClient INT 
    
    SELECT @IdAbonnement = P.IdAbonnement, 
           @IdClient = A.IdClient
    FROM TPENALITE P
    JOIN TABONNEMENTS A ON P.IdAbonnement = A.IdAbonnement
    WHERE P.IdPenalite = @IdPenalite 

    -- Ajouter une notification dans la table de notifications
    EXEC EnvoyerNotification @IdClient, 'Votre pénalité a été payée avec succès.', 'information' 
   
    -- Vérifier s'il reste des pénalités non payées et réactiver si nécessaire
    EXEC ReactiverAbonnement @IdAbonnement 
END
GO

--Procédure pour suspendre l'abonnement d'un client ayant des pénalités de retard impayées
CREATE PROCEDURE SuspendreAbonnementSiPenalitesRetards
    @IdAbonnement INT,
    @Seuil INT = 3  
AS
BEGIN
    DECLARE @NbPenalites INT , @IdClient INT

    -- Récupérer l'IdClient et le nombre de pénalités en une seule requête avec une jointure
    SELECT @IdClient = A.IdClient, 
           @NbPenalites = COUNT(P.IdPenalite)
    FROM TABONNEMENTS A
    LEFT JOIN TPENALITE P ON A.IdAbonnement = P.IdAbonnement 
                          AND P.EtatPenalite = 'en cours' 
                          AND P.Motif = 'retard'
    WHERE A.IdAbonnement = @IdAbonnement
    GROUP BY A.IdClient 

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
            
            -- Ajouter une notification dans la table de notifications
            EXEC EnvoyerNotification @IdClient,  
                'Votre abonnement a été suspendu en raison de pénalités de retard impayées.',
                'suspension' 
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