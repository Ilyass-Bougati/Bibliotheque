-- Populate TCLIENTS
INSERT INTO TCLIENTS (Nom, Prenom, CIN, Email, PhoneNumber, Ville)
VALUES 
    ('Dupont', 'Marie', 'AB123456', 'marie.dupont@email.com', '0611223344', 'Paris'),
    ('Martin', 'Jean', 'CD789012', 'jean.martin@email.com', '0622334455', 'Lyon'),
    ('Bernard', 'Sophie', 'EF345678', 'sophie.bernard@email.com', '0633445566', 'Marseille'),
    ('Thomas', 'Pierre', 'GH901234', 'pierre.thomas@email.com', '0644556677', 'Bordeaux'),
    ('Robert', 'Julie', 'IJ567890', 'julie.robert@email.com', '0655667788', 'Lille'),
    ('Petit', 'David', 'KL123789', 'david.petit@email.com', '0666778899', 'Toulouse'),
    ('Richard', 'Claire', 'MN456012', 'claire.richard@email.com', '0677889900', 'Nantes'),
    ('Moreau', 'Antoine', 'OP789345', 'antoine.moreau@email.com', '0688990011', 'Strasbourg'),
    ('Simon', 'Emma', 'QR012678', 'emma.simon@email.com', '0699001122', 'Nice'),
    ('Michel', 'Lucas', 'ST345901', 'lucas.michel@email.com', '0600112233', 'Rennes');

-- Populate TABONNEMENTS_TYPE
INSERT INTO TABONNEMENTS_TYPE (AbonnementType, NbEmpruntMax, Dure, Prix)
VALUES 
    ('Type 1', 3, 30, 100.00),  -- Basic subscription: 3 books max, 30 days, 100DH
    ('Type 2', 5, 60, 200.00);  -- Premium subscription: 5 books max, 60 days, 200DH

-- Populate TABONNEMENTS
INSERT INTO TABONNEMENTS (IdClient, IdAbonnementType, DateDebut, EtatAbonnement)
VALUES 
    (1, 2, DATEADD(month, -2, GETDATE()), 'actif'),
    (2, 1, DATEADD(month, -3, GETDATE()), 'actif'),
    (3, 2, DATEADD(month, -1, GETDATE()), 'actif'),
    (4, 1, DATEADD(month, -5, GETDATE()), 'expire'),
    (5, 2, DATEADD(month, -4, GETDATE()), 'suspendu'),
    (6, 1, DATEADD(day, -10, GETDATE()), 'actif'),
    (7, 2, DATEADD(day, -15, GETDATE()), 'actif'),
    (8, 1, DATEADD(month, -6, GETDATE()), 'annule'),
    (9, 2, DATEADD(day, -5, GETDATE()), 'actif'),
    (10, 1, DATEADD(month, -1, GETDATE()), 'actif');

-- Populate TNOTIFICATIONS
INSERT INTO TNOTIFICATIONS (IdClient, NotificationType, NotificationText, NotificationDate)
VALUES 
    (1, 'Type 1', 'Votre abonnement sera bientôt expiré.', DATEADD(day, -5, GETDATE())),
    (2, 'Type 2', 'Un livre que vous avez réservé est maintenant disponible.', DATEADD(day, -3, GETDATE())),
    (3, 'Type 1', 'Rappel: Vous avez un livre à retourner dans 3 jours.', DATEADD(day, -2, GETDATE())),
    (4, 'Type 2', 'Votre abonnement a expiré.', DATEADD(day, -30, GETDATE())),
    (5, 'Type 1', 'Votre compte a été suspendu en raison d''un livre non retourné.', DATEADD(day, -15, GETDATE()));

-- Populate TLANGUES
INSERT INTO TLANGUES (NomLangue)
VALUES 
    ('Français'),
    ('Anglais'),
    ('Espagnol'),
    ('Allemand'),
    ('Italien'),
    ('Arabe'),
    ('Chinois');

-- Populate TAUTEURS
INSERT INTO TAUTEURS (NomAuteur, PrenomAuteur)
VALUES 
    ('Hugo', 'Victor'),
    ('Rowling', 'J.K.'),
    ('Camus', 'Albert'),
    ('Christie', 'Agatha'),
    ('Garcia Marquez', 'Gabriel'),
    ('Dostoïevski', 'Fiodor'),
    ('Austen', 'Jane'),
    ('Orwell', 'George'),
    ('Flaubert', 'Gustave'),
    ('Tolkien', 'J.R.R.');

-- Populate TCATEGORIES
INSERT INTO TCATEGORIES (NomCategorie)
VALUES 
    ('Roman'),
    ('Science-Fiction'),
    ('Fantastique'),
    ('Policier'),
    ('Philosophie'),
    ('Biographie'),
    ('Histoire'),
    ('Poésie'),
    ('Jeunesse'),
    ('Théâtre');

-- Populate TEDITEURS
INSERT INTO TEDITEURS (NomEditeur)
VALUES 
    ('Gallimard'),
    ('Hachette'),
    ('Flammarion'),
    ('Albin Michel'),
    ('Le Seuil'),
    ('Bloomsbury'),
    ('Penguin Books'),
    ('Harper Collins'),
    ('Fayard'),
    ('Actes Sud');

-- Populate TLIVRES
INSERT INTO TLIVRES (Titre, ISBN, IdLangue)
VALUES 
    ('Les Misérables', '9782070409228', 1),
    ('Harry Potter à l''école des sorciers', '9782070643028', 2),
    ('L''Étranger', '9782070360024', 1),
    ('Dix petits nègres', '9782253067061', 2),
    ('Cent ans de solitude', '9782020238113', 3),
    ('Crime et Châtiment', '9782253082996', 2),
    ('Orgueil et Préjugés', '9782070412587', 2),
    ('1984', '9782070368228', 2),
    ('Madame Bovary', '9782070413119', 1),
    ('Le Seigneur des Anneaux', '9782266254069', 2),
    ('Notre-Dame de Paris', '9782253096344', 1),
    ('Le Hobbit', '9782267027037', 2),
    ('La Peste', '9782070371082', 1),
    ('Mort sur le Nil', '9782253020998', 2),
    ('L''Amour aux temps du choléra', '9782253051205', 3);

-- Populate TAUTEURS_LIVRES
INSERT INTO TAUTEURS_LIVRES (IdAuteur, IdLivre)
VALUES 
    (1, 1),   -- Victor Hugo - Les Misérables
    (1, 11),  -- Victor Hugo - Notre-Dame de Paris
    (2, 2),   -- J.K. Rowling - Harry Potter
    (3, 3),   -- Albert Camus - L'Étranger
    (3, 13),  -- Albert Camus - La Peste
    (4, 4),   -- Agatha Christie - Dix petits nègres
    (4, 14),  -- Agatha Christie - Mort sur le Nil
    (5, 5),   -- Gabriel Garcia Marquez - Cent ans de solitude
    (5, 15),  -- Gabriel Garcia Marquez - L'Amour aux temps du choléra
    (6, 6),   -- Fiodor Dostoïevski - Crime et Châtiment
    (7, 7),   -- Jane Austen - Orgueil et Préjugés
    (8, 8),   -- George Orwell - 1984
    (9, 9),   -- Gustave Flaubert - Madame Bovary
    (10, 10), -- J.R.R. Tolkien - Le Seigneur des Anneaux
    (10, 12); -- J.R.R. Tolkien - Le Hobbit

-- Populate TCATEGORIES_LIVRES
INSERT INTO TCATEGORIES_LIVRES (IdCategorie, IdLivre)
VALUES 
    (1, 1),   -- Roman - Les Misérables
    (3, 2),   -- Fantastique - Harry Potter
    (1, 3),   -- Roman - L'Étranger
    (4, 4),   -- Policier - Dix petits nègres
    (1, 5),   -- Roman - Cent ans de solitude
    (1, 6),   -- Roman - Crime et Châtiment
    (1, 7),   -- Roman - Orgueil et Préjugés
    (2, 8),   -- Science-Fiction - 1984
    (1, 9),   -- Roman - Madame Bovary
    (3, 10),  -- Fantastique - Le Seigneur des Anneaux
    (1, 11),  -- Roman - Notre-Dame de Paris
    (3, 12),  -- Fantastique - Le Hobbit
    (1, 13),  -- Roman - La Peste
    (4, 14),  -- Policier - Mort sur le Nil
    (1, 15),  -- Roman - L'Amour aux temps du choléra
    (9, 2),   -- Jeunesse - Harry Potter
    (5, 3),   -- Philosophie - L'Étranger
    (5, 13),  -- Philosophie - La Peste
    (7, 1),   -- Histoire - Les Misérables
    (7, 11);  -- Histoire - Notre-Dame de Paris

-- Populate TEDITEURS_LIVRES
INSERT INTO TEDITEURS_LIVRES (IdEditeur, IdLivre)
VALUES 
    (1, 1),   -- Gallimard - Les Misérables
    (6, 2),   -- Bloomsbury - Harry Potter
    (1, 3),   -- Gallimard - L'Étranger
    (2, 4),   -- Hachette - Dix petits nègres
    (5, 5),   -- Le Seuil - Cent ans de solitude
    (2, 6),   -- Hachette - Crime et Châtiment
    (1, 7),   -- Gallimard - Orgueil et Préjugés
    (1, 8),   -- Gallimard - 1984
    (1, 9),   -- Gallimard - Madame Bovary
    (8, 10),  -- Harper Collins - Le Seigneur des Anneaux
    (3, 11),  -- Flammarion - Notre-Dame de Paris
    (8, 12),  -- Harper Collins - Le Hobbit
    (1, 13),  -- Gallimard - La Peste
    (2, 14),  -- Hachette - Mort sur le Nil
    (5, 15);  -- Le Seuil - L'Amour aux temps du choléra

-- Populate TEXEMPLAIRES (multiple copies of each book)
-- For each book, add multiple copies with different availability status
DECLARE @IdLivre INT = 1;
WHILE @IdLivre <= 15
BEGIN
    -- Add 3 copies of each book
    INSERT INTO TEXEMPLAIRES (IdLivre, Disponible, Localisation)
    VALUES 
        (@IdLivre, 1, 'Étage 1 - Rayon ' + CAST(@IdLivre as VARCHAR)),
        (@IdLivre, 1, 'Étage 2 - Rayon ' + CAST(@IdLivre as VARCHAR)),
        (@IdLivre, 0, 'Étage 1 - Rayon ' + CAST(@IdLivre as VARCHAR));
    
    SET @IdLivre = @IdLivre + 1;
END

-- Populate TEMPRUNTS
INSERT INTO TEMPRUNTS (IdClient, IdExemplaire, DateEmprunt, DateRetour)
VALUES 
    (1, 3, DATEADD(day, -20, GETDATE()), NULL),  -- Currently borrowed
    (2, 6, DATEADD(day, -15, GETDATE()), NULL),  -- Currently borrowed
    (3, 9, DATEADD(day, -10, GETDATE()), NULL),  -- Currently borrowed
    (4, 12, DATEADD(day, -30, GETDATE()), DATEADD(day, -5, GETDATE())),  -- Returned
    (5, 15, DATEADD(day, -25, GETDATE()), NULL),  -- Currently borrowed, overdue
    (1, 18, DATEADD(day, -40, GETDATE()), DATEADD(day, -30, GETDATE())),  -- Returned
    (2, 21, DATEADD(day, -35, GETDATE()), DATEADD(day, -20, GETDATE())),  -- Returned
    (6, 24, DATEADD(day, -5, GETDATE()), NULL),  -- Currently borrowed
    (7, 27, DATEADD(day, -8, GETDATE()), NULL),  -- Currently borrowed
    (9, 30, DATEADD(day, -3, GETDATE()), NULL),  -- Currently borrowed
    (10, 33, DATEADD(day, -12, GETDATE()), NULL),  -- Currently borrowed
    (3, 36, DATEADD(day, -50, GETDATE()), DATEADD(day, -40, GETDATE())),  -- Returned
    (4, 39, DATEADD(day, -45, GETDATE()), DATEADD(day, -35, GETDATE())),  -- Returned
    (5, 42, DATEADD(day, -60, GETDATE()), DATEADD(day, -45, GETDATE())),  -- Returned
    (7, 45, DATEADD(day, -7, GETDATE()), NULL);  -- Currently borrowed

-- Populate TRESERVATIONS
INSERT INTO TRESERVATIONS (IdClient, IdLivre, DateReservation)
VALUES 
    (1, 5, DATEADD(day, -3, GETDATE())),
    (2, 8, DATEADD(day, -5, GETDATE())),
    (3, 10, DATEADD(day, -2, GETDATE())),
    (4, 12, DATEADD(day, -7, GETDATE())),
    (6, 15, DATEADD(day, -1, GETDATE())),
    (7, 2, DATEADD(day, -4, GETDATE())),
    (9, 7, DATEADD(day, -3, GETDATE())),
    (10, 11, DATEADD(day, -2, GETDATE()));

-- Populate TREVIEWS
INSERT INTO TREVIEWS (IdClient, IdLivre,Notation , Review)
VALUES 
    (1, 1, 5, 'Un classique incontournable. L''histoire de Jean Valjean est bouleversante et toujours pertinente.'),
    (2, 2, 6, 'Excellent premier tome qui introduit parfaitement le monde magique de Harry Potter.'),
    (3, 3, 2, 'Un roman existentialiste captivant. Le personnage de Meursault est fascinant par son détachement.'),
    (4, 10, 4 'Une épopée fantastique monumentale. Tolkien a créé un monde d''une richesse incroyable.'),
    (5, 7, 7, 'Un classique de la littérature anglaise plein d''esprit et d''humour.'),
    (6, 8, 3, 'Visionnaire et terrifiant. Cette dystopie reste malheureusement d''actualité.'),
    (7, 5, 9, 'Un chef-d''œuvre du réalisme magique. L''histoire de la famille Buendia est inoubliable.'),
    (1, 13,1, 'Une allégorie puissante sur la condition humaine face à l''absurde.'),
    (2, 4,6, 'Un des meilleurs romans policiers d''Agatha Christie. Les rebondissements sont surprenants.'),
    (3, 6,5, 'Une plongée fascinante dans la psychologie criminelle. Dostoïevski est un maître.'),
    (4, 9,8, 'Un portrait saisissant de la bourgeoisie provinciale. Le style de Flaubert est remarquable.'),
    (5, 14,8, 'Une enquête palpitante dans le cadre exotique de l''Égypte. Hercule Poirot est à son meilleur.'),
    (6, 12,10, 'Une aventure magique qui se lit à tout âge. Parfait comme introduction à l''univers de Tolkien.'),
    (7, 15,10, 'Une histoire d''amour magnifique qui transcende le temps. La prose est somptueuse.'),
    (8, 2,4, 'Une lecture divertissante qui m''a transporté dans un monde magique.'),
    (9, 10,5, 'Une œuvre majeure de la fantasy, je la relis chaque année.'),
    (10, 3,6, 'Un roman qui pousse à la réflexion sur l''absurdité de l''existence.'),
    (1, 5,8, 'Magnifiquement écrit, mais j''ai trouvé l''histoire parfois difficile à suivre.'),
    (2, 8,1, 'Prophétique et glaçant. Un livre qui reste d''actualité.');

-- Populate TPENALITE
INSERT INTO TPENALITE (IdAbonnement, IdEmprunt, Motif, Montant, EtatPenalite, DatePenalite)
VALUES 
    (5, 5, 'Retard', 15.00, 'en cours', DATEADD(day, -10, GETDATE())),  -- Client 5, overdue book
    (4, 4, 'Livre endommagé', 25.00, 'payee', DATEADD(day, -20, GETDATE())),  -- Client 4, damaged book
    (8, NULL, 'Comportement', 50.00, 'payee', DATEADD(day, -45, GETDATE())),  -- Client 8, behavior penalty
    (2, 7, 'Retard', 10.00, 'annulee', DATEADD(day, -30, GETDATE())),  -- Client 2, late return but cancelled
    (3, 12, 'Livre perdu', 35.00, 'en cours', DATEADD(day, -25, GETDATE()));  -- Client 3, lost book