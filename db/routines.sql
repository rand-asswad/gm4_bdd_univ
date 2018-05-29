USE univ;

DROP PROCEDURE IF EXISTS matieresPourEtudiant;
CREATE PROCEDURE matieresPourEtudiant(idEtudiant INT)
  BEGIN
    SELECT Matiere.code, Matiere.nom, Matiere.credits
    FROM Matiere
    INNER JOIN PreRequisition ON Matiere.code = PreRequisition.matiere
    WHERE Matiere.code NOT IN (SELECT matiere FROM Valide WHERE Valide.etudiant=idEtudiant)
    AND PreRequisition.matiereRequise = ANY (SELECT matiere FROM Valide WHERE Valide.etudiant=idEtudiant);
  END;

DROP PROCEDURE IF EXISTS coursPourEtudiant;
CREATE PROCEDURE coursPourEtudiant(idEtudiant INT)
  BEGIN
    SELECT Cours.code, Cours.matiere, Matiere.nom, Matiere.credits, Cours.trimestre, Cours.enseignant
    FROM Cours
    INNER JOIN Matiere ON Cours.matiere = Matiere.code
    INNER JOIN PreRequisition ON Cours.matiere = PreRequisition.matiere
    WHERE Matiere.code NOT IN (SELECT matiere FROM Valide WHERE Valide.etudiant=idEtudiant)
    AND PreRequisition.matiereRequise = ANY (SELECT matiere FROM Valide WHERE Valide.etudiant=idEtudiant)
    AND Cours.annee = Year(curdate());
  END;

DROP PROCEDURE IF EXISTS etudiantDiplomes;
CREATE PROCEDURE etudiantDiplomes(idEtudiant INT)
  BEGIN
    SELECT Diplome.titre, Diplome.niveau, COUNT(1) as nbValide, matieresDiplome.nbMatieres as nbTotal
    FROM Contenir
    INNER JOIN Diplome ON Contenir.diplome = Diplome.id
    INNER JOIN Matiere ON Contenir.matiere = Matiere.code
    INNER JOIN Valide ON Matiere.code = Valide.matiere
    INNER JOIN matieresDiplome ON Diplome.id = matieresDiplome.id
    WHERE Valide.etudiant = idEtudiant
    GROUP BY Contenir.diplome
    ORDER BY nbValide DESC;
  END;

DROP PROCEDURE IF EXISTS matieresRestantesDiplome;
CREATE PROCEDURE matieresRestantesDiplome(idEtudiant INT, idDiplome INT)
  BEGIN
    SELECT Matiere.code, Matiere.nom, Matiere.credits
    FROM Contenir
    INNER JOIN Matiere ON Contenir.matiere = Matiere.code
    INNER JOIN Valide ON Matiere.code = Valide.matiere
    WHERE Matiere.code NOT IN (SELECT matiere FROM Valide WHERE Valide.etudiant=idEtudiant)
    AND Contenir.id = idDiplome;
  end;

DROP PROCEDURE IF EXISTS listeInscriptions;
CREATE PROCEDURE listeInscriptions(codeCours LINESTRING)
  BEGIN
    SELECT Etudiant.id, Etudiant.prenom, Etudiant.nom, InscriptionCours.noteConseiller, InscriptionCours.suivreCours
    FROM InscriptionCours
    INNER JOIN Etudiant ON InscriptionCours.etudiant = Etudiant.id
    WHERE InscriptionCours.cours = codeCours
    ORDER BY InscriptionCours.noteConseiller DESC;
  END;

DROP PROCEDURE IF EXISTS professeursDomaine;
CREATE PROCEDURE professeursDomaine(domaine LINESTRING)
  BEGIN
    SELECT DISTINCT Professeur.id, Professeur.nom, Professeur.prenom
    FROM Cours
    INNER JOIN Professeur ON Cours.enseignant = Professeur.id
    INNER JOIN Matiere ON Cours.matiere = Matiere.code
    WHERE Matiere.nomDomaine = domaine;
  END;
