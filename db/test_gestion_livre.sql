-- ============================================
-- Script de Test pour le Système de Gestion de Bibliothèque
-- ============================================

-- Activer les messages de sortie
SET NOCOUNT OFF 

PRINT '======================================================' 
PRINT 'DÉMARRAGE DU SCRIPT DE TEST COMPLET' 
PRINT '======================================================' 
PRINT '' 

-- =============================================
-- Test des fonctions utilitaires
-- =============================================
PRINT '*** Test des fonctions utilitaires ***' 



DECLARE @result INT 

-- Test de la fonction Validate_ISBN
PRINT '# Test de la fonction Validate_ISBN:' 
SET @result = dbo.Validate_ISBN('9780306406157') 
PRINT 'Validate_ISBN avec ISBN valide: ' + CAST(@result AS VARCHAR(10)) + ' (Attendu: 1)' 
SET @result = dbo.Validate_ISBN('isbn-invalide') 
PRINT 'Validate_ISBN avec ISBN invalide: ' + CAST(@result AS VARCHAR(10)) + ' (Attendu: 0)' 
SET @result = dbo.Validate_ISBN('9780306876157') 
PRINT 'Validate_ISBN avec ISBN invalide: ' + CAST(@result AS VARCHAR(10)) + ' (Attendu: 0)' 


PRINT '' 

-- =============================================
-- Test des procédures de gestion des langues
-- =============================================
PRINT '*** Test des procédures de gestion des langues ***' 

-- Test AjouterLangue
PRINT '# Test de AjouterLangue:' 
EXEC AjouterLangue 'LangueTest' 
EXEC AjouterLangue 'LangueTest'  -- Essai d'ajout en double
EXEC AjouterLangue ''  -- Essai avec un nom vide
EXEC AjouterLangue NULL  -- Essai avec un nom NULL

-- Test ModifierLangue
PRINT '# Test de ModifierLangue:' 
DECLARE @testLangueId INT 
SELECT @testLangueId = IdLangue FROM TLANGUES WHERE NomLangue = 'languetest' 
IF @testLangueId IS NOT NULL
BEGIN
    EXEC ModifierLangue @testLangueId, 'LangueMiseAJour' 
    EXEC ModifierLangue @testLangueId, ''  -- Essai avec un nom vide
    EXEC ModifierLangue 9999, 'LangueInexistante'  -- Essai avec un ID inexistant
END
ELSE
    PRINT 'Enregistrement de test de langue non trouvé pour le test de modification' 

-- Vérifier que la langue existe après modification
IF EXISTS (SELECT 1 FROM TLANGUES WHERE NomLangue = 'languemiseajour')
    PRINT 'La langue a été mise à jour avec succès' 
ELSE
    PRINT 'La mise à jour de la langue a échoué' 

-- Test SupprimerLangue
PRINT '# Test de SupprimerLangue:' 
DECLARE @langIdToDelete INT 
SELECT @langIdToDelete = IdLangue FROM TLANGUES WHERE NomLangue = 'languemiseajour' 
IF @langIdToDelete IS NOT NULL
BEGIN
    EXEC SupprimerLangue @langIdToDelete 
    IF NOT EXISTS (SELECT 1 FROM TLANGUES WHERE IdLangue = @langIdToDelete)
        PRINT 'La langue a été supprimée avec succès' 
    ELSE
        PRINT 'La suppression de la langue a échoué' 
END
ELSE
    PRINT 'Enregistrement de test de langue non trouvé pour le test de suppression' 

-- Essayer de supprimer une langue inexistante
EXEC SupprimerLangue 9999 

PRINT '' 

-- =============================================
-- Test des procédures de gestion des auteurs
-- =============================================
PRINT '*** Test des procédures de gestion des auteurs ***' 

-- Test AjouterAuteur
PRINT '# Test de AjouterAuteur:' 
EXEC AjouterAuteur 'AuteurTest', 'PrénomTest' 
EXEC AjouterAuteur 'AuteurTest', 'PrénomTest'  -- Essai d'ajout en double
EXEC AjouterAuteur '', 'PrénomTest'  -- Essai avec un nom vide
EXEC AjouterAuteur 'AuteurTest', ''  -- Essai avec un prénom vide
EXEC AjouterAuteur NULL, NULL  -- Essai avec des valeurs NULL

-- Test ModifierAuteur
PRINT '# Test de ModifierAuteur:' 
DECLARE @testAuteurId INT 
SELECT @testAuteurId = IdAuteur FROM TAUTEURS WHERE NomAuteur = 'auteurtest' AND PrenomAuteur = 'prénomtest' 
IF @testAuteurId IS NOT NULL
BEGIN
    EXEC ModifierAuteur @testAuteurId, 'AuteurMiseAJour', 'PrénomMiseAJour' 
    EXEC ModifierAuteur @testAuteurId, '', 'PrénomMiseAJour'  -- Essai avec un nom vide
    EXEC ModifierAuteur @testAuteurId, 'AuteurMiseAJour', ''  -- Essai avec un prénom vide
    EXEC ModifierAuteur 9999, 'AuteurInexistant', 'PrénomInexistant'  -- Essai avec un ID inexistant
END
ELSE
    PRINT 'Enregistrement de test d auteur non trouvé pour le test de modification' 

-- Vérifier que l'auteur existe après modification
IF EXISTS (SELECT 1 FROM TAUTEURS WHERE NomAuteur = 'auteurmiseajour' AND PrenomAuteur = 'prénommiseajour')
    PRINT 'L auteur a été mis à jour avec succès' 
ELSE
    PRINT 'La mise à jour de l auteur a échoué' 

-- Test SupprimerAuteur
PRINT '# Test de SupprimerAuteur:' 
DECLARE @autIdToDelete INT 
SELECT @autIdToDelete = IdAuteur FROM TAUTEURS WHERE NomAuteur = 'auteurmiseajour' 
IF @autIdToDelete IS NOT NULL
BEGIN
    EXEC SupprimerAuteur @autIdToDelete 
    IF NOT EXISTS (SELECT 1 FROM TAUTEURS WHERE IdAuteur = @autIdToDelete)
        PRINT 'L auteur a été supprimé avec succès' 
    ELSE
        PRINT 'La suppression de l auteur a échoué' 
END
ELSE
    PRINT 'Enregistrement de test d auteur non trouvé pour le test de suppression' 

-- Essayer de supprimer un auteur inexistant
EXEC SupprimerAuteur 9999 

PRINT '' 

-- =============================================
-- Test des procédures de gestion des catégories
-- =============================================
PRINT '*** Test des procédures de gestion des catégories ***' 

-- Test AjouterCategorie
PRINT '# Test de AjouterCategorie:' 
EXEC AjouterCategorie 'CatégorieTest' 
EXEC AjouterCategorie 'CatégorieTest'  -- Essai d'ajout en double
EXEC AjouterCategorie ''  -- Essai avec un nom vide
EXEC AjouterCategorie NULL  -- Essai avec un nom NULL

-- Test ModifierCategorie
PRINT '# Test de ModifierCategorie:' 
DECLARE @testCategorieId INT 
SELECT @testCategorieId = IdCategorie FROM TCATEGORIES WHERE NomCategorie = 'catégorietest' 
IF @testCategorieId IS NOT NULL
BEGIN
    EXEC ModifierCategorie @testCategorieId, 'CatégorieMiseAJour' 
    EXEC ModifierCategorie @testCategorieId, ''  -- Essai avec un nom vide
    EXEC ModifierCategorie 9999, 'CatégorieInexistante'  -- Essai avec un ID inexistant
END
ELSE
    PRINT 'Enregistrement de test de catégorie non trouvé pour le test de modification' 

-- Vérifier que la catégorie existe après modification
IF EXISTS (SELECT 1 FROM TCATEGORIES WHERE NomCategorie = 'catégoriemiseajour')
    PRINT 'La catégorie a été mise à jour avec succès' 
ELSE
    PRINT 'La mise à jour de la catégorie a échoué' 

-- Test SupprimerCategorie
PRINT '# Test de SupprimerCategorie:' 
DECLARE @catIdToDelete INT 
SELECT @catIdToDelete = IdCategorie FROM TCATEGORIES WHERE NomCategorie = 'catégoriemiseajour' 
IF @catIdToDelete IS NOT NULL
BEGIN
    EXEC SupprimerCategorie @catIdToDelete 
    IF NOT EXISTS (SELECT 1 FROM TCATEGORIES WHERE IdCategorie = @catIdToDelete)
        PRINT 'La catégorie a été supprimée avec succès' 
    ELSE
        PRINT 'La suppression de la catégorie a échoué' 
END
ELSE
    PRINT 'Enregistrement de test de catégorie non trouvé pour le test de suppression' 

-- Essayer de supprimer une catégorie inexistante
EXEC SupprimerCategorie 9999 

PRINT '' 

-- =============================================
-- Test des procédures de gestion des éditeurs
-- =============================================
PRINT '*** Test des procédures de gestion des éditeurs ***' 

-- Test AjouterEditeur
PRINT '# Test de AjouterEditeur:' 
EXEC AjouterEditeur 'EditeurTest' 
EXEC AjouterEditeur 'EditeurTest'  -- Essai d'ajout en double
EXEC AjouterEditeur ''  -- Essai avec un nom vide
EXEC AjouterEditeur NULL  -- Essai avec un nom NULL

-- Test ModifierEditeur
PRINT '# Test de ModifierEditeur:' 
DECLARE @testEditeurId INT 
SELECT @testEditeurId = IdEditeur FROM TEDITEURS WHERE NomEditeur = 'editeurtest' 
IF @testEditeurId IS NOT NULL
BEGIN
    EXEC ModifierEditeur @testEditeurId, 'EditeurMiseAJour' 
    EXEC ModifierEditeur @testEditeurId, ''  -- Essai avec un nom vide
    EXEC ModifierEditeur 9999, 'EditeurInexistant'  -- Essai avec un ID inexistant
END
ELSE
    PRINT 'Enregistrement de test d editeur non trouvé pour le test de modification' 

-- Vérifier que l'éditeur existe après modification
IF EXISTS (SELECT 1 FROM TEDITEURS WHERE NomEditeur = 'editeurmiseajour')
    PRINT 'L editeur a été mis à jour avec succès' 
ELSE
    PRINT 'La mise à jour de l editeur a échoué' 

-- Test SupprimerEditeur
PRINT '# Test de SupprimerEditeur:' 
DECLARE @editIdToDelete INT 
SELECT @editIdToDelete = IdEditeur FROM TEDITEURS WHERE NomEditeur = 'editeurmiseajour' 
IF @editIdToDelete IS NOT NULL
BEGIN
    EXEC SupprimerEditeur @editIdToDelete 
    IF NOT EXISTS (SELECT 1 FROM TEDITEURS WHERE IdEditeur = @editIdToDelete)
        PRINT 'L éditeur a été supprimé avec succès' 
    ELSE
        PRINT 'La suppression de l editeur a échoué' 
END
ELSE
    PRINT 'Enregistrement de test d editeur non trouvé pour le test de suppression' 

-- Essayer de supprimer un éditeur inexistant
EXEC SupprimerEditeur 9999 

PRINT '' 

-- =============================================
-- Test des procédures de gestion des livres
-- =============================================
PRINT '*** Test des procédures de gestion des livres ***' 

-- Test AjouterLivre
PRINT '# Test de AjouterLivre:' 
EXEC AjouterLivre 'LivreTest', '9780306406157', 'LangueTest', 'AuteurTest', 'PrénomTest', 'CatégorieTest', 'EditeurTest' 
EXEC AjouterLivre '', '9780471958697', 'LangueTest', 'AuteurTest', 'PrénomTest', 'CatégorieTest', 'EditeurTest'  -- Titre vide
EXEC AjouterLivre 'LivreTest2', '', 'LangueTest', 'AuteurTest', 'PrénomTest', 'CatégorieTest', 'EditeurTest'  -- ISBN vide
EXEC AjouterLivre 'LivreTest3', '9780131103627', '', 'AuteurTest', 'PrénomTest', 'CatégorieTest', 'EditeurTest'  -- Langue vide
EXEC AjouterLivre 'LivreTest4', '9780262033848', 'LangueTest', '', 'PrénomTest', 'CatégorieTest', 'EditeurTest'  -- Nom auteur vide
EXEC AjouterLivre 'LivreTest5', '9780201896831', 'LangueTest', 'AuteurTest', '', 'CatégorieTest', 'EditeurTest'  -- Prénom auteur vide
EXEC AjouterLivre 'LivreTest6', '9780596516178', 'LangueTest', 'AuteurTest', 'PrénomTest', '', 'EditeurTest'  -- Catégorie vide
EXEC AjouterLivre 'LivreTest7', '9780134685991', 'LangueTest', 'AuteurTest', 'PrénomTest', 'CatégorieTest', ''  -- Éditeur vide
EXEC AjouterLivre 'LivreTest8', 'isbn-invalide', 'LangueTest', 'AuteurTest', 'PrénomTest', 'CatégorieTest', 'EditeurTest'  -- ISBN invalide

-- Vérifier si le livre a été ajouté
IF EXISTS (SELECT 1 FROM TLIVRES WHERE Titre = 'LivreTest')
    PRINT 'Le livre a été ajouté avec succès' 
ELSE
    PRINT 'L''ajout du livre a échoué' 

-- Test ModifierLivre
PRINT '# Test de ModifierLivre:' 
DECLARE @testLivreId INT 
SELECT @testLivreId = IdLivre FROM TLIVRES WHERE Titre = 'LivreTest' 
IF @testLivreId IS NOT NULL
BEGIN
    -- Récupérer l'ID de langue pour un test
    DECLARE @testLangId INT 
    SELECT TOP 1 @testLangId = IdLangue FROM TLANGUES 
    
    EXEC ModifierLivre @testLivreId, 'LivreMiseAJour', '9780321356680', @testLangId, 'NouvelAuteur', 'NouveauPrénom', 'NouvelleCatégorie', 'NouvelEditeur' 
    EXEC ModifierLivre @testLivreId, '', NULL, NULL, NULL, NULL, NULL, NULL  -- Essai avec un titre vide
    EXEC ModifierLivre @testLivreId, NULL, 'isbn-invalide', NULL, NULL, NULL, NULL, NULL  -- Essai avec un ISBN invalide
    EXEC ModifierLivre 9999, 'LivreInexistant', NULL, NULL, NULL, NULL, NULL, NULL  -- Essai avec un ID inexistant
END
ELSE
    PRINT 'Enregistrement de test de livre non trouvé pour le test de modification' 

-- Vérifier que le livre existe après modification
IF EXISTS (SELECT 1 FROM TLIVRES WHERE Titre = 'LivreMiseAJour')
    PRINT 'Le livre a été mis à jour avec succès' 
ELSE
    PRINT 'La mise à jour du livre a échoué' 

-- Test SupprimerLivre
PRINT '# Test de SupprimerLivre:' 
DECLARE @livreIdToDelete INT 
SELECT @livreIdToDelete = IdLivre FROM TLIVRES WHERE Titre = 'LivreMiseAJour' 
IF @livreIdToDelete IS NOT NULL
BEGIN
    EXEC SupprimerLivre @livreIdToDelete 
    
    IF NOT EXISTS (SELECT 1 FROM TLIVRES WHERE IdLivre = @livreIdToDelete)
        PRINT 'Le livre a été supprimé avec succès' 
    ELSE
        PRINT 'La suppression du livre a échoué' 
END
ELSE
    PRINT 'Enregistrement de test de livre non trouvé pour le test de suppression' 

-- Essayer de supprimer un livre inexistant
EXEC SupprimerLivre 9999 
EXEC SupprimerLivre NULL  -- Test avec NULL

PRINT '' 

-- =============================================
-- Test des associations entre tables
-- =============================================
PRINT '*** Test des procédures d''association entre tables ***' 

-- Créer des enregistrements de test pour les associations
DECLARE @testLivreId2 INT, @testAuteurId2 INT, @testCategorieId2 INT, @testEditeurId2 INT 

-- Ajouter un nouvel auteur pour le test
EXEC AjouterAuteur 'AuteurAsso', 'PrénomAsso' 
SELECT @testAuteurId2 = IdAuteur FROM TAUTEURS WHERE NomAuteur = 'auteurasso' AND PrenomAuteur = 'prénomasso' 

-- Ajouter une nouvelle catégorie pour le test
EXEC AjouterCategorie 'CatégorieAsso' 
SELECT @testCategorieId2 = IdCategorie FROM TCATEGORIES WHERE NomCategorie = 'catégorieasso' 

-- Ajouter un nouvel éditeur pour le test
EXEC AjouterEditeur 'EditeurAsso' 
SELECT @testEditeurId2 = IdEditeur FROM TEDITEURS WHERE NomEditeur = 'editeurasso' 

-- Ajouter un nouveau livre pour le test
DECLARE @testLangueId2 INT 
SELECT TOP 1 @testLangueId2 = IdLangue FROM TLANGUES 
IF @testLangueId2 IS NOT NULL
BEGIN
    INSERT INTO TLIVRES (Titre, ISBN, IdLangue)
    VALUES ('LivreAssociation', '9780596007126', @testLangueId2) 
    SET @testLivreId2 = SCOPE_IDENTITY() 
    
    -- Test AssocierAuteurLivre
    PRINT '# Test de AssocierAuteurLivre:' 
    IF @testLivreId2 IS NOT NULL AND @testAuteurId2 IS NOT NULL
    BEGIN
        EXEC AssocierAuteurLivre @testLivreId2, @testAuteurId2 
        IF EXISTS (SELECT 1 FROM TAUTEURS_LIVRES WHERE IdAuteur = @testAuteurId2 AND IdLivre = @testLivreId2)
            PRINT 'L''association auteur-livre a réussi' 
        ELSE
            PRINT 'L''association auteur-livre a échoué' 
    END
    ELSE
        PRINT 'Les IDs de test pour AssocierAuteurLivre ne sont pas disponibles' 
    
    -- Test AssocierCategorieLivre
    PRINT '# Test de AssocierCategorieLivre:' 
    IF @testLivreId2 IS NOT NULL AND @testCategorieId2 IS NOT NULL
    BEGIN
        EXEC AssocierCategorieLivre @testLivreId2, @testCategorieId2 
        IF EXISTS (SELECT 1 FROM TCATEGORIES_LIVRES WHERE IdCategorie = @testCategorieId2 AND IdLivre = @testLivreId2)
            PRINT 'L''association catégorie-livre a réussi' 
        ELSE
            PRINT 'L''association catégorie-livre a échoué' 
    END
    ELSE
        PRINT 'Les IDs de test pour AssocierCategorieLivre ne sont pas disponibles' 
    
    -- Test AssocierEditeurLivre
    PRINT '# Test de AssocierEditeurLivre:' 
    IF @testLivreId2 IS NOT NULL AND @testEditeurId2 IS NOT NULL
    BEGIN
        -- Note: Correction du nom de la procédure (AssocierEditeurLivre) et correction de la faute d'orthographe dans le nom de la table TEDITEURS_LIVRES
        BEGIN TRY
            EXEC AssocierEditeurLivre @testLivreId2, @testEditeurId2 
            IF EXISTS (SELECT 1 FROM TEDITEURS_LIVRES WHERE IdEditeur = @testEditeurId2 AND IdLivre = @testLivreId2)
                PRINT 'L''association éditeur-livre a réussi' 
            ELSE
                PRINT 'L''association éditeur-livre a échoué - La table ou l''ID ne correspondent pas' 
        END TRY
        BEGIN CATCH
            PRINT 'Erreur lors de l''association éditeur-livre: ' + ERROR_MESSAGE() 
        END CATCH
    END
    ELSE
        PRINT 'Les IDs de test pour AssocierEditeurLivre ne sont pas disponibles' 
END
ELSE
    PRINT 'Aucune langue trouvée pour créer le livre de test d''association' 

PRINT '' 

-- =============================================
-- Nettoyage des données de test
-- =============================================
PRINT '*** Nettoyage des données de test ***' 

-- Si nécessaire, suppression des enregistrements de test créés pour l'occasion
-- (à activer/désactiver selon les besoins)

-- Supprimer les associations
IF @testLivreId2 IS NOT NULL
BEGIN
    DELETE FROM TAUTEURS_LIVRES WHERE IdLivre = @testLivreId2 
    DELETE FROM TCATEGORIES_LIVRES WHERE IdLivre = @testLivreId2 
    DELETE FROM TEDITEURS_LIVRES WHERE IdLivre = @testLivreId2 
    DELETE FROM TLIVRES WHERE IdLivre = @testLivreId2 
END

-- Supprimer les entités de test
IF @testAuteurId2 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM TAUTEURS_LIVRES WHERE IdAuteur = @testAuteurId2)
    DELETE FROM TAUTEURS WHERE IdAuteur = @testAuteurId2 

IF @testCategorieId2 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM TCATEGORIES_LIVRES WHERE IdCategorie = @testCategorieId2)
    DELETE FROM TCATEGORIES WHERE IdCategorie = @testCategorieId2 

IF @testEditeurId2 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM TEDITEURS_LIVRES WHERE IdEditeur = @testEditeurId2)
    DELETE FROM TEDITEURS WHERE IdEditeur = @testEditeurId2 


PRINT '======================================================' 
PRINT 'FIN DU SCRIPT DE TEST' 
PRINT '======================================================' 
