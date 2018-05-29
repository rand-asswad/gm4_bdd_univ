use univ;

DROP View IF EXISTS matieresDiplome;
CREATE VIEW matieresDiplome AS
  SELECT Diplome.id, Diplome.titre, Diplome.niveau, Diplome.creditsEssentiels, Diplome.creditsEnrichissement, COUNT(1) AS nbMatieres
  FROM Contenir
  INNER JOIN Diplome on Contenir.diplome = Diplome.id
  GROUP BY Contenir.diplome;


DROP VIEW IF EXISTS Valide;
CREATE VIEW Valide AS
  SELECT Etudiant.id as etudiant, Cours.matiere
  FROM InscriptionCours
  JOIN Cours ON InscriptionCours.cours = Cours.code
  JOIN Etudiant ON InscriptionCours.etudiant = Etudiant.id
  WHERE noteObtenue>=10;