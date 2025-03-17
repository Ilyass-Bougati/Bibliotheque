-- Test Script for Library Management Procedures

-- Clear database data (uncomment if needed)
/*
EXEC sp_MSforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"

DELETE FROM TEDITEURS_LIVRES
DELETE FROM TCATEGORIES_LIVRES
DELETE FROM TAUTEURS_LIVRES

DELETE FROM TPENALITE
DELETE FROM TEMPRUNTS
DELETE FROM TRESERVATIONS
DELETE FROM TREVIEWS
DELETE FROM TEXEMPLAIRES
DELETE FROM TNOTIFICATIONS
DELETE FROM TABONNEMENTS

DELETE FROM TLIVRES
DELETE FROM TABONNEMENTS_TYPE
DELETE FROM TCLIENTS
DELETE FROM TLANGUES
DELETE FROM TAUTEURS
DELETE FROM TCATEGORIES
DELETE FROM TEDITEURS

EXEC sp_MSforeachtable "ALTER TABLE ? CHECK CONSTRAINT all"
*/

-- Test AjouterLangue
PRINT '-------- Testing AjouterLangue --------' 
EXEC AjouterLangue 'français' 
-- Expected: La langue français a ete ajoutee avec succes.
PRINT '---'

EXEC AjouterLangue 'anglais' 
-- Expected: La langue anglais a ete ajoutee avec succes.
PRINT '---'

EXEC AjouterLangue 'français' 
-- Expected: La langue français existe deja.
PRINT '---'

EXEC AjouterLangue '' 
-- Expected: L entree est vide. Veuillez fournir un nom de langue valide.
PRINT ' '

-- Test ModifierLangue
PRINT '-------- Testing ModifierLangue --------' 
DECLARE @IdLangue1 INT 
SELECT @IdLangue1 = IdLangue FROM TLANGUES WHERE NomLangue = 'français' 

EXEC ModifierLangue @IdLangue1, 'french' 
-- Expected: La langue a ete modifiee avec succes.
PRINT '---'

EXEC ModifierLangue 9999, 'invalid' 
-- Expected: Erreur : La langue specifiee n existe pas.
PRINT ' '

-- Test AjouterAuteur
PRINT '-------- Testing AjouterAuteur --------' 
EXEC AjouterAuteur 'Hugo', 'Victor' 
-- Expected: L auteurs victor hugo a ete ajoute avec succes
PRINT '---'

EXEC AjouterAuteur 'Dumas', 'Alexandre' 
-- Expected: L auteurs alexandre dumas a ete ajoute avec succes
PRINT '---'

EXEC AjouterAuteur 'Hugo', 'Victor' 
-- Expected: L auteurs victor hugo existe deja
PRINT '---'

EXEC AjouterAuteur '', 'Victor' 
-- Expected: L entree est vide. Veuillez fournir un nom et prenom valide.
PRINT ' '

-- Test ModifierAuteur
PRINT '-------- Testing ModifierAuteur --------' 
DECLARE @IdAuteur1 INT 
SELECT @IdAuteur1 = IdAuteur FROM TAUTEURS WHERE NomAuteur = 'hugo' AND PrenomAuteur = 'victor' 

EXEC ModifierAuteur @IdAuteur1, 'Hugo', 'Victor M.' 
-- Expected: L auteurs victor m. hugo a ete modifie avec succes
PRINT ' '

-- Test AjouterCategorie
PRINT '-------- Testing AjouterCategorie --------' 
EXEC AjouterCategorie 'roman' 
-- Expected: La Categorie roman a ete ajoute avec succes
PRINT '---'

EXEC AjouterCategorie 'science-fiction' 
-- Expected: La Categorie science-fiction a ete ajoute avec succes
PRINT '---'

EXEC AjouterCategorie 'roman' 
-- Expected: La Categorie roman existe deja
PRINT ' '

-- Test ModifierCategorie
PRINT '-------- Testing ModifierCategorie --------' 
DECLARE @IdCategorie1 INT 
SELECT @IdCategorie1 = IdCategorie FROM TCATEGORIES WHERE NomCategorie = 'roman' 

EXEC ModifierCategorie @IdCategorie1, 'roman classique' 
-- Expected: La Categorie roman classique a ete modifiee avec succes
PRINT ' '

-- Test AjouterEditeur
PRINT '-------- Testing AjouterEditeur --------' 
EXEC AjouterEditeur 'gallimard' 
-- Expected: L editeur gallimard a ete ajoute avec succes
PRINT '---'

EXEC AjouterEditeur 'hachette' 
-- Expected: L editeur hachette a ete ajoute avec succes
PRINT '---'

EXEC AjouterEditeur 'gallimard' 
-- Expected: L editeur gallimard existe deja
PRINT ' '

-- Test ModifierEditeur
PRINT '-------- Testing ModifierEditeur --------' 
DECLARE @IdEditeur1 INT 
SELECT @IdEditeur1 = IdEditeur FROM TEDITEURS WHERE NomEditeur = 'gallimard' 

EXEC ModifierEditeur @IdEditeur1, 'gallimard classique' 
-- No expected output message specified in the procedure
PRINT ' '

-- Test AjouterLivre
PRINT '-------- Testing AjouterLivre --------' 
EXEC AjouterLivre 'Les Misérables', '9782070409228', 'french', 'Hugo', 'Victor M.', 'roman classique', 'gallimard classique' 
-- Expected: Le livre a ete ajoute avec succes.
PRINT '---'

EXEC AjouterLivre 'Le Comte de Monte-Cristo', '9782070406999', 'french', 'Dumas', 'Alexandre', 'roman classique', 'hachette' 
-- Expected: Le livre a ete ajoute avec succes.
PRINT '---'

EXEC AjouterLivre '', '9782070406999', 'french', 'Dumas', 'Alexandre', 'roman classique', 'hachette' 
-- Expected: Erreur : Le titre du livre ne peut pas etre vide.
PRINT '---'

EXEC AjouterLivre 'Duplicate ISBN Test', '9782070409228', 'french', 'Test', 'Author', 'test', 'test' 
-- Expected: Erreur : Un livre avec cet ISBN existe deja.
PRINT '---'

EXEC AjouterLivre 'Titre Test', '123456', 'french', 'Dumas', 'Alexandre', 'roman classique', 'hachette' 
-- Expected: Erreur : Format ISBN invalide.
PRINT ' '

-- Test ModifierLivre
PRINT '-------- Testing ModifierLivre --------' 
DECLARE @IdLivre1 INT 
SELECT @IdLivre1 = IdLivre FROM TLIVRES WHERE Titre = 'Les Misérables' 

EXEC ModifierLivre @IdLivre1, 'Les Misérables (Tome 1)', NULL, NULL, NULL, NULL, 'roman', NULL 
-- Expected: Le livre a ete modifiee avec succes.
PRINT ' '

-- Test SupprimerLivre, SupprimerAuteur, SupprimerCategorie, SupprimerEditeur, SupprimerLangue
-- These tests are commented out as they are destructive and may cause issues with foreign key constraints
-- Uncomment and run separately if needed

/*
PRINT '-------- Testing Delete Operations --------' 

-- First, let's create a test book that we'll delete
EXEC AjouterLivre 'Test Book for Deletion', '978-3-16-148410-0', 'english', 'Test', 'Author', 'test category', 'test publisher' 

DECLARE @IdLivreTest INT 
SELECT @IdLivreTest = IdLivre FROM TLIVRES WHERE Titre = 'Test Book for Deletion' 

-- Now delete the test book
EXEC SupprimerLivre @IdLivreTest 
-- Expected: Le livre "Test Book for Deletion" a ete supprime avec succes.

-- Then try to delete authors, categories, etc. that are still linked to other books
DECLARE @IdAuteurTest INT 
SELECT @IdAuteurTest = IdAuteur FROM TAUTEURS WHERE NomAuteur = 'hugo' 

EXEC SupprimerAuteur @IdAuteurTest 
-- Expected: Erreur : Impossible de supprimer cet auteur car il est associe a des livres.

DECLARE @IdCategorieTest INT 
SELECT @IdCategorieTest = IdCategorie FROM TCATEGORIES WHERE NomCategorie = 'roman classique' 

EXEC SupprimerCategorie @IdCategorieTest 
-- Expected: Erreur : Impossible de supprimer cette categorie car elle est utilisee par des livres.

DECLARE @IdEditeurTest INT 
SELECT @IdEditeurTest = IdEditeur FROM TEDITEURS WHERE NomEditeur = 'gallimard classique' 

EXEC SupprimerEditeur @IdEditeurTest 
-- Expected: Erreur : Impossible de supprimer cet diteur car il est utilise par des livres.

DECLARE @IdLangueTest INT 
SELECT @IdLangueTest = IdLangue FROM TLANGUES WHERE NomLangue = 'french' 

EXEC SupprimerLangue @IdLangueTest 
-- Expected: Erreur : Impossible de supprimer cette langue car elle est utilisee par des livres.
*/

-- Test listing results
PRINT '-------- Verify Database Contents --------' 
SELECT * FROM TLANGUES 
SELECT * FROM TAUTEURS 
SELECT * FROM TCATEGORIES 
SELECT * FROM TEDITEURS 
SELECT * FROM TLIVRES 
SELECT * FROM TAUTEURS_LIVRES 
SELECT * FROM TCATEGORIES_LIVRES 
SELECT * FROM TEDITEURS_LIVRES 

-- Test associations between tables
PRINT '-------- Testing Associations --------' 
SELECT l.Titre, a.NomAuteur, a.PrenomAuteur, c.NomCategorie, e.NomEditeur, lang.NomLangue
FROM TLIVRES l
JOIN TAUTEURS_LIVRES al ON l.IdLivre = al.IdLivre
JOIN TAUTEURS a ON al.IdAuteur = a.IdAuteur
JOIN TCATEGORIES_LIVRES cl ON l.IdLivre = cl.IdLivre
JOIN TCATEGORIES c ON cl.IdCategorie = c.IdCategorie
JOIN TEDITEURS_LIVRES el ON l.IdLivre = el.IdLivre
JOIN TEDITEURS e ON el.IdEditeur = e.IdEditeur
JOIN TLANGUES lang ON l.IdLangue = lang.IdLangue 
-- Expected: Results showing all associations between books, authors, categories, publishers, and languages