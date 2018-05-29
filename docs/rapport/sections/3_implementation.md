# Implémentation

## Environnement
Pour des raisons de portabilités, j'ai sauvegardé les scripts SQL permettant de créer la base de donnée,
et la populer par les tableau, des données aléatoires pour tester
et les requêtes dans ce rapport (*repertoire:* db).

Pour faciliter la connection, j'ai créé des scripts shell qui lancent les requêtes SQL
à partir du terminal (*repertoire:* bin).

Les tableaux dans ce rapport sont compilé en directe à l'aide des libraries R **knitr** et **DBI**.

Le code source du projet y compris ce rapport est disponible sur: [github.com/rand-asswad/gm4_bdd_univ](https://github.com/rand-asswad/gm4_bdd_univ)

Le rapport est aussi disponible en format HTML (dynamique) sur:
[rand-asswad.github.io/gm4_bdd_univ/rapport/index.html](https://rand-asswad.github.io/gm4_bdd_univ/rapport/index.html)

Connection à la base de donnée:
```{r}
library(DBI)
univ <- dbConnect(RMariaDB::MariaDB(), dbname="univ", username="root")
```

## Les requêtes

### Les vues
Cette vue contient le nombre de matieres nécessaires pour l'obtention de chaque diplôme:
```{sql, connection=univ}
DROP View IF EXISTS matieresDiplome;
CREATE VIEW matieresDiplome AS
  SELECT Diplome.id, Diplome.titre, Diplome.niveau, Diplome.creditsEssentiels, Diplome.creditsEnrichissement, COUNT(1) AS nbMatieres
  FROM Contenir
  INNER JOIN Diplome on Contenir.diplome = Diplome.id
  GROUP BY Contenir.diplome;
```

Cette vue contient une liste de projet matières validées:
```{sql, connection=univ}
DROP VIEW IF EXISTS Valide;
CREATE VIEW Valide AS
  SELECT Etudiant.id as etudiant, Cours.matiere
  FROM InscriptionCours
  JOIN Cours ON InscriptionCours.cours = Cours.code
  JOIN Etudiant ON InscriptionCours.etudiant = Etudiant.id
  WHERE noteObtenue>=10;
```

### Les séléctions

Séléctionner 
```{sql, connection=univ}
SELECT Matiere.code, Matiere.nom, Matiere.credits
FROM Matiere
INNER JOIN PreRequisition ON Matiere.code = PreRequisition.matiere
WHERE Matiere.code NOT IN (SELECT matiere FROM Valide WHERE Valide.etudiant=idEtudiant)
AND PreRequisition.matiereRequise = ANY (SELECT matiere FROM Valide WHERE Valide.etudiant=idEtudiant);
```

```{sql, connection=univ}
SELECT Cours.code, Cours.matiere, Matiere.nom, Matiere.credits, Cours.trimestre, Cours.enseignant
FROM Cours
INNER JOIN Matiere ON Cours.matiere = Matiere.code
INNER JOIN PreRequisition ON Cours.matiere = PreRequisition.matiere
WHERE Matiere.code NOT IN (SELECT matiere FROM Valide WHERE Valide.etudiant=idEtudiant)
AND PreRequisition.matiereRequise = ANY (SELECT matiere FROM Valide WHERE Valide.etudiant=idEtudiant)
AND Cours.annee = Year(curdate());
```

```{sql, connection=univ}
SELECT Diplome.titre, Diplome.niveau, COUNT(1) as nbValide, matieresDiplome.nbMatieres as nbTotal
FROM Contenir
INNER JOIN Diplome ON Contenir.diplome = Diplome.id
INNER JOIN Matiere ON Contenir.matiere = Matiere.code
INNER JOIN Valide ON Matiere.code = Valide.matiere
INNER JOIN matieresDiplome ON Diplome.id = matieresDiplome.id
WHERE Valide.etudiant = idEtudiant
GROUP BY Contenir.diplome
ORDER BY nbValide DESC;
```

```{sql, connection=univ}
SELECT Matiere.code, Matiere.nom, Matiere.credits
FROM Contenir
INNER JOIN Matiere ON Contenir.matiere = Matiere.code
WHERE Matiere.code NOT IN (SELECT Valide.matiere FROM Valide WHERE Valide.etudiant=idEtudiant)
AND Contenir.diplome = idDiplome;
```

```{sql, connection=univ}
SELECT Etudiant.id, Etudiant.prenom, Etudiant.nom, InscriptionCours.noteConseiller, InscriptionCours.suivreCours
FROM InscriptionCours
INNER JOIN Etudiant ON InscriptionCours.etudiant = Etudiant.id
WHERE InscriptionCours.cours = codeCours
ORDER BY InscriptionCours.noteConseiller DESC;
```

```{sql, connection=univ}
SELECT DISTINCT Professeur.id, Professeur.nom, Professeur.prenom
FROM Cours
INNER JOIN Professeur ON Cours.enseignant = Professeur.id
INNER JOIN Matiere ON Cours.matiere = Matiere.code
WHERE Matiere.nomDomaine = domaine;
```
