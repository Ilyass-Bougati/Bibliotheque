-- INSETION DES LIVRES

EXEC AjouterLivre 'meditations', '9780812968255', 'Anglais', 'Marcus', 'Aurelius', 'philosophie', 'penguin classics';
EXEC AjouterLivre 'the stranger', '9780679720201', 'Anglais', 'Albert', 'Camus', 'philosophie', 'Vintage';
EXEC AjouterLivre 'L''étranger', '9782070360024', 'Francais', 'Albert', 'Camus', 'philosophie', 'Gallimard';
EXEC AjouterLivre 'hamlet', '9781451669411', 'Francais', 'William', 'Shakespeare', 'tragédie', 'Simon & Schuster';
EXEC AjouterLivre 'The alchemist', '9789779922614', 'Arabe', 'paulo', 'coelho', 'fantaisie', 'Ilyass publishing house';

-- CREATION DES EXEMPLAIRES
EXEC AjouterExemplaire 1, 'A';
EXEC AjouterExemplaire 1, 'B';
EXEC AjouterExemplaire 2, 'C';
EXEC AjouterExemplaire 2, 'D';
EXEC AjouterExemplaire 3, 'E';
EXEC AjouterExemplaire 3, 'F';
EXEC AjouterExemplaire 4, 'G';
EXEC AjouterExemplaire 4, 'H';
EXEC AjouterExemplaire 5, 'I';


-- ADDING CLIENTS
EXEC AjouterTypeAbonnement 'personnel', 5, 12, 100;
EXEC AjouterTypeAbonnement 'éducation', 5, 12, 75;
EXEC AjouterTypeAbonnement 'famille', 10, 12, 125;


EXEC AjouterClient 'Ilyass', 'Bougati', 'MA*', 'ilyass@gmail.com', '0601000000', 'Marrakech', 'personnel';
EXEC AjouterClient 'Amine', 'Sidki', 'MB*', 'amine@gmail.com', '0602000000', 'Casablanca', 'personnel';
EXEC AjouterClient 'Abdelah', 'Darni', 'MC*', 'abdelah@gmail.com', '0603000000', 'Berchid','éducation';
EXEC AjouterClient 'Hajar', 'El Hilali', 'MD*', 'Hajar@gmail.com', '0604000000', 'Settat','famille';
EXEC AjouterClient 'Yasmine', 'Koulam', 'ME*', 'yasmine@gmail.com', '0605000000', 'Casablanca','famille';


-- EMPRUNTER
EXEC EmprunterLivre 1, 1;
EXEC EmprunterLivre 2, 1; -- pas disponible
EXEC EmprunterLivre 2, 5;
EXEC EmprunterLivre 3, 2;
EXEC EmprunterLivre 4, 3;
EXEC EmprunterLivre 5, 4;


-- RESERVATIONS
EXEC ReserverLivre 1, 1;
EXEC ReserverLivre 1, 5;
EXEC RetournerLivre 1;

-- AVIS
EXEC AjouterAvis 1, 1, 8;
EXEC AjouterAvis 2, 1, 5;
EXEC AjouterAvis 3, 1, 8;
EXEC AjouterAvis 4, 1, 9;

EXEC AfficherLivre 1;