-- Populate TCLIENTS
INSERT INTO TCLIENTS (Nom, Prenom, CIN, Email, PhoneNumber, Ville)
VALUES 
  ('Dupont', 'Jean', 'AB123456', 'jean.dupont@email.com', '0612345678', 'Paris'),
  ('Martin', 'Sophie', 'CD789012', 'sophie.martin@email.com', '0687654321', 'Lyon'),
  ('Bernard', 'Michel', 'EF345678', 'michel.bernard@email.com', '0623456789', 'Marseille'),
  ('Petit', 'Marie', 'GH901234', 'marie.petit@email.com', '0634567890', 'Bordeaux'),
  ('Durand', 'Thomas', 'IJ567890', 'thomas.durand@email.com', '0645678901', 'Toulouse');

-- Populate TLANGUES
INSERT INTO TLANGUES (NomLangue)
VALUES 
  ('Français'),
  ('Anglais'),
  ('Espagnol'),
  ('Arabe'),
  ('Allemand');

-- Populate TAUTEURS
INSERT INTO TAUTEURS (NomAuteur, PrenomAuteur)
VALUES 
  ('Hugo', 'Victor'),
  ('Flaubert', 'Gustave'),
  ('Camus', 'Albert'),
  ('Rowling', 'J.K.'),
  ('King', 'Stephen'),
  ('Orwell', 'George'),
  ('Garcia Marquez', 'Gabriel'),
  ('Tolkien', 'J.R.R.');

-- Populate TCATEGORIES
INSERT INTO TCATEGORIES (NomCategorie)
VALUES 
  ('Roman'),
  ('Poésie'),
  ('Science-Fiction'),
  ('Policier'),
  ('Philosophie'),
  ('Histoire'),
  ('Biographie'),
  ('Fantastique');

-- Populate TEDITEURS
INSERT INTO TEDITEURS (NomEditeur)
VALUES 
  ('Gallimard'),
  ('Hachette'),
  ('Flammarion'),
  ('Pocket'),
  ('Albin Michel');

-- Populate TABONNEMENTS_TYPE
INSERT INTO TABONNEMENTS_TYPE (AbonnementType, NbEmpruntMax, Duree, Prix)
VALUES 
  ('Standard', 3, 30, 150.00),
  ('Premium', 5, 60, 250.00),
  ('Étudiant', 2, 30, 100.00),
  ('Famille', 10, 45, 400.00),
  ('Senior', 4, 45, 120.00);

-- Populate TLIVRES
INSERT INTO TLIVRES (Titre, ISBN, IdLangue)
VALUES 
  ('Les Misérables', '9782253096344', 1),
  ('Madame Bovary', '9782070413119', 1),
  ('L''Étranger', '9782070360024', 1),
  ('Harry Potter à l''école des sorciers', '9782070643028', 2),
  ('The Shining', '9780307743657', 2),
  ('1984', '9780451524935', 2),
  ('Cent Ans de Solitude', '9782020238113', 3),
  ('Le Seigneur des Anneaux', '9782266154116', 2),
  ('Don Quichotte', '9782070397174', 3),
  ('Le Petit Prince', '9782070612758', 1);

-- Populate TEXEMPLAIRES
INSERT INTO TEXEMPLAIRES (IdLivre, Disponibilite, Localisation)
VALUES 
  (1, 'disponible', 'Étagère A1'),
  (1, 'disponible', 'Étagère A2'),
  (2, 'disponible', 'Étagère B1'),
  (3, 'disponible', 'Étagère C1'),
  (4, 'disponible', 'Étagère D1'),
  (5, 'disponible', 'Étagère E1'),
  (6, 'disponible', 'Étagère F1'),
  (7, 'disponible', 'Étagère G1'),
  (8, 'disponible', 'Étagère H1'),
  (9, 'disponible', 'Étagère I1'),
  (10, 'disponible', 'Étagère J1'),
  (4, 'disponible', 'Étagère D2'),
  (5, 'disponible', 'Étagère E2'),
  (6, 'disponible', 'Étagère F2');

-- Populate TABONNEMENTS
INSERT INTO TABONNEMENTS (IdClient, IdAbonnementType, DateDebut, EtatAbonnement)
VALUES 
  (1, 1, DATEADD(day, -30, GETDATE()), 'actif'),
  (2, 2, DATEADD(day, -45, GETDATE()), 'actif'),
  (3, 3, DATEADD(day, -15, GETDATE()), 'actif'),
  (4, 4, DATEADD(day, -60, GETDATE()), 'actif'),
  (5, 5, DATEADD(day, -5, GETDATE()), 'actif');

-- Populate TAUTEURS_LIVRES
INSERT INTO TAUTEURS_LIVRES (IdAuteur, IdLivre)
VALUES 
  (1, 1),  -- Victor Hugo - Les Misérables
  (2, 2),  -- Gustave Flaubert - Madame Bovary
  (3, 3),  -- Albert Camus - L'Étranger
  (4, 4),  -- J.K. Rowling - Harry Potter
  (5, 5),  -- Stephen King - The Shining
  (6, 6),  -- George Orwell - 1984
  (7, 7),  -- Gabriel Garcia Marquez - Cent Ans de Solitude
  (8, 8);  -- J.R.R. Tolkien - Le Seigneur des Anneaux

-- Populate TCATEGORIES_LIVRES
INSERT INTO TCATEGORIES_LIVRES (IdCategorie, IdLivre)
VALUES 
  (1, 1),  -- Roman - Les Misérables
  (1, 2),  -- Roman - Madame Bovary
  (1, 3),  -- Roman - L'Étranger
  (5, 3),  -- Philosophie - L'Étranger
  (8, 4),  -- Fantastique - Harry Potter
  (4, 5),  -- Policier - The Shining
  (3, 6),  -- Science-Fiction - 1984
  (1, 7),  -- Roman - Cent Ans de Solitude
  (8, 8),  -- Fantastique - Le Seigneur des Anneaux
  (1, 9),  -- Roman - Don Quichotte
  (1, 10); -- Roman - Le Petit Prince

-- Populate TEDITEURS_LIVRES
INSERT INTO TEDITEURS_LIVRES (IdEditeur, IdLivre)
VALUES 
  (1, 1),  -- Gallimard - Les Misérables
  (1, 3),  -- Gallimard - L'Étranger
  (2, 2),  -- Hachette - Madame Bovary
  (2, 4),  -- Hachette - Harry Potter
  (3, 5),  -- Flammarion - The Shining
  (4, 6),  -- Pocket - 1984
  (5, 7),  -- Albin Michel - Cent Ans de Solitude
  (3, 8),  -- Flammarion - Le Seigneur des Anneaux
  (1, 9),  -- Gallimard - Don Quichotte
  (1, 10); -- Gallimard - Le Petit Prince

-- Populate TEMPRUNTS
INSERT INTO TEMPRUNTS (IdAbonnement, IdExemplaire, DateEmprunt, DateRetour)
VALUES 
  (1, 1, DATEADD(day, -20, GETDATE()), NULL),
  (2, 5, DATEADD(day, -15, GETDATE()), NULL),
  (3, 8, DATEADD(day, -10, GETDATE()), NULL),
  (4, 10, DATEADD(day, -5, GETDATE()), NULL),
  (5, 3, DATEADD(day, -25, GETDATE()), DATEADD(day, -10, GETDATE())),
  (1, 7, DATEADD(day, -45, GETDATE()), DATEADD(day, -30, GETDATE())),
  (2, 9, DATEADD(day, -30, GETDATE()), DATEADD(day, -15, GETDATE()));

-- Update exemplaires availability status
UPDATE TEXEMPLAIRES 
SET Disponibilite = 'emprunte' 
WHERE IdExemplaire IN (1, 5, 8, 10);

-- Populate TREVIEWS
INSERT INTO TREVIEWS (IdClient, IdLivre, Review)
VALUES 
  (1, 1, 9),
  (2, 4, 8),
  (3, 6, 10),
  (4, 8, 7),
  (5, 3, 9);

-- Populate TPENALITE
INSERT INTO TPENALITE (IdAbonnement, IdEmprunt, Motif, Montant, EtatPenalite, DatePenalite)
VALUES 
  (1, 6, 'retard', 50.00, 'payee', DATEADD(day, -30, GETDATE())),
  (5, 5, 'abime', 150.00, 'en cours', DATEADD(day, -10, GETDATE()));

-- Populate TRESERVATIONS (modified to use IdLivre instead of IdExemplaire)
INSERT INTO TRESERVATIONS (IdAbonnement, IdLivre, DateReservation)
VALUES 
  (1, 6, DATEADD(day, -2, GETDATE())),  -- Client 1 reserves livre 6 (1984)
  (3, 4, DATEADD(day, -5, GETDATE())),  -- Client 3 reserves livre 4 (Harry Potter)
  (5, 7, DATEADD(day, -1, GETDATE()));  -- Client 5 reserves livre 7 (Cent Ans de Solitude)

-- Update exemplaires availability status for reservations
-- We need to select one exemplaire for each reserved book
UPDATE TEXEMPLAIRES 
SET Disponibilite = 'reserve' 
WHERE IdExemplaire IN (
  -- Select one exemplaire for each reserved book
  SELECT TOP 1 e.IdExemplaire 
  FROM TEXEMPLAIRES e 
  WHERE e.IdLivre = 6 AND e.Disponibilite = 'disponible'
);

UPDATE TEXEMPLAIRES 
SET Disponibilite = 'reserve' 
WHERE IdExemplaire IN (
  SELECT TOP 1 e.IdExemplaire 
  FROM TEXEMPLAIRES e 
  WHERE e.IdLivre = 4 AND e.Disponibilite = 'disponible'
);

UPDATE TEXEMPLAIRES 
SET Disponibilite = 'reserve' 
WHERE IdExemplaire IN (
  SELECT TOP 1 e.IdExemplaire 
  FROM TEXEMPLAIRES e 
  WHERE e.IdLivre = 7 AND e.Disponibilite = 'disponible'
);

-- Populate TNOTIFICATIONS
INSERT INTO TNOTIFICATIONS (IdClient, NotificationType, NotificationText, NotificationDate)
VALUES 
  (1, 'Retard', 'Votre livre "Les Misérables" est en retard de 2 jours.', DATEADD(day, -2, GETDATE())),
  (2, 'Reservation', 'Le livre que vous avez réservé est maintenant disponible.', DATEADD(day, -3, GETDATE())),
  (3, 'Abonnement', 'Votre abonnement expire dans 15 jours.', DATEADD(day, -5, GETDATE())),
  (4, 'Nouveauté', 'De nouveaux livres sont disponibles dans votre catégorie préférée.', DATEADD(day, -1, GETDATE())),
  (5, 'Penalite', 'Une pénalité de 15€ a été appliquée pour un livre abîmé.', DATEADD(day, -10, GETDATE()));