# Implémentation

## Environnement
Pour des raisons de portabilité, j'ai sauvegardé les scripts SQL permettant de créer la base de donnée,
et la populer par les tableau, des données aléatoires pour tester
et les requêtes dans ce rapport (*repertoire:* db).

Pour faciliter la connection, j'ai créé des scripts shell qui lancent les requêtes SQL
à partir du terminal (*repertoire:* bin).

Les tableaux dans ce rapport sont compilé en directe à l'aide des libraries R **knitr** et **DBI**.

Le code source du projet y compris ce rapport est disponible sur:
[github.com/rand-asswad/gm4_bdd_univ](https://github.com/rand-asswad/gm4_bdd_univ)

Cette section est plus visible en format HTML:
[rand-asswad.github.io/gm4_bdd_univ/rapport/index.html](https://rand-asswad.github.io/gm4_bdd_univ/rapport/index.html)

Connection à la base de données:
```{r}
library(DBI)
univ <- dbConnect(RMariaDB::MariaDB(), dbname="univ", username="root")
```

## Les requêtes
### Les vues
Les tableaux de la base de données permettent d'obtenir toutes les informations
nécessaires par des requêtes, il n'y a donc aucun besoin de d'avoir d'autres tableaux.
En revanche, il est certainement pratique d'avoir des **vues** qu'on utilisera souvent
dans nos requêtes, par exemple une liste des matières validés (par étudiant).


```{sql, connection=univ}
DROP VIEW IF EXISTS Valide;
```
```{sql, connection=univ}
CREATE VIEW Valide AS
  SELECT Etudiant.id as etudiant, Cours.matiere
  FROM InscriptionCours
  INNER JOIN Cours ON InscriptionCours.cours = Cours.code
  INNER JOIN Etudiant ON InscriptionCours.etudiant = Etudiant.id
  WHERE noteObtenue >= 10;
```
En rajoutant quelques colonnes à cette vue, on obtient:
```{sql, connection=univ}
SELECT Etudiant.nom, Etudiant.prenom, Matiere.code, Matiere.nom, Matiere.credits
FROM Valide
INNER JOIN Etudiant ON Valide.etudiant = Etudiant.id
INNER JOIN Matiere ON Valide.matiere = Matiere.code
```

Voici une vue de diplômes et le nombre de matières qu'elles contiennent.
```{sql, connection=univ}
DROP View IF EXISTS matieresDiplome;
```
```{sql, connection=univ}
CREATE VIEW matieresDiplome AS
  SELECT Diplome.id, COUNT(*) AS nbMatieres 
  FROM Contenir
  INNER JOIN Diplome on Contenir.diplome = Diplome.id
  GROUP BY Contenir.diplome;
```
Afin de mieux visualiser cette vue, on rajoutes quelques colonnes du tableau *Diplome*.
```{sql, connection=univ}
SELECT Diplome.titre, Diplome.niveau, matieresDiplome.nbMatieres, Diplome.creditsEssentiels
FROM matieresDiplome
INNER JOIN Diplome ON matieresDiplome.id = Diplome.id;
```

### Les séléctions
Les séléctions sont spécifiques à une ligne d'un tableau, donc dans le code source j'ai
créé des *procédures* qui prennent la clé primaire en entrée pour effectuer ces requêtes.

Dans ce rapport, j'ai testé avec les valeurs suivantes:
```{r}
idEtudiant <- 1
idDiplome <- 5
domaine <- "Combinatoires"
codeCours <- "AUT18Ana01"
```

On séléctionnent les matières qu'un étudiant pourra prendre.
C'est-à-dire, les matières que l'étudiant n'a pas encore validées
**_et_** il/elle a déjà validé ses matières requises.
```{sql, connection=univ}
SELECT Matiere.code, Matiere.nom, Matiere.credits
FROM Matiere
INNER JOIN PreRequisition ON Matiere.code = PreRequisition.matiere
WHERE Matiere.code NOT IN (SELECT matiere
                           FROM Valide
                           WHERE Valide.etudiant = ?idEtudiant)
AND PreRequisition.matiereRequise = ANY (SELECT matiere
                                         FROM Valide
                                         WHERE Valide.etudiant = ?idEtudiant);
```

On séléctionnent les cours qu'un étudiant peut prendre pendant l'année courante.
```{sql, connection=univ}
SELECT Cours.code, Matiere.nom, Matiere.credits, Cours.enseignant
FROM Cours
INNER JOIN Matiere ON Cours.matiere = Matiere.code
INNER JOIN PreRequisition ON Cours.matiere = PreRequisition.matiere
WHERE Matiere.code NOT IN (SELECT matiere
                           FROM Valide
                           WHERE Valide.etudiant = ?idEtudiant)
AND PreRequisition.matiereRequise = ANY (SELECT matiere
                                         FROM Valide
                                         WHERE Valide.etudiant = ?idEtudiant)
AND Cours.annee = Year(curdate());
```

Compter le nombre de matières validées par diplômes pour un étudiant,
et les afficher dans l'ordre décroissant.
```{sql, connection=univ}
SELECT Diplome.titre, Diplome.niveau, COUNT(1) as nbValide,
    matieresDiplome.nbMatieres as nbTotal
FROM Contenir
INNER JOIN Diplome ON Contenir.diplome = Diplome.id
INNER JOIN Matiere ON Contenir.matiere = Matiere.code
INNER JOIN Valide ON Matiere.code = Valide.matiere
INNER JOIN matieresDiplome ON Diplome.id = matieresDiplome.id
WHERE Valide.etudiant = ?idEtudiant
GROUP BY Contenir.diplome
ORDER BY nbValide DESC;
```

Compter le nombre matières restant pour un étudiant afin de valider un diplôme.
```{sql, connection=univ}
SELECT Matiere.code, Matiere.nom, Matiere.credits
FROM Contenir
INNER JOIN Matiere ON Contenir.matiere = Matiere.code
WHERE Matiere.code NOT IN (SELECT Valide.matiere
                           FROM Valide
                           WHERE Valide.etudiant = ?idEtudiant)
AND Contenir.diplome = ?idDiplome;
```

Donner la liste d'inscrits dans un cours, et les ordonner par la note donnée par le conseiller.q
On test pour cours="`r codeCours`".
```{sql, connection=univ}
SELECT Etudiant.id, Etudiant.prenom, Etudiant.nom,
    InscriptionCours.noteConseiller, InscriptionCours.suivreCours
FROM InscriptionCours
INNER JOIN Etudiant ON InscriptionCours.etudiant = Etudiant.id
WHERE InscriptionCours.cours = ?codeCours
ORDER BY InscriptionCours.noteConseiller DESC;
```

Donner la liste de enseignant dans un domain (domain="`r domaine`").
```{sql, connection=univ}
SELECT DISTINCT Professeur.id, Professeur.nom, Professeur.prenom
FROM Cours
INNER JOIN Professeur ON Cours.enseignant = Professeur.id
INNER JOIN Matiere ON Cours.matiere = Matiere.code
WHERE Matiere.nomDomaine = ?domaine;
```
