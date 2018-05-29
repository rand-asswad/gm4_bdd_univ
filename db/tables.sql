DROP DATABASE IF EXISTS univ;
CREATE DATABASE univ;
USE univ;

# MAIN TABLES

CREATE TABLE Professeur (
  id int(6) NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
  nom varchar(70) NOT NULL,
 prenom varchar(35) NOT NULL,
  adresse varchar(100),
  email varchar(320),
  dateNaissance DATE NOT NULL
) ENGINE = InnoDB;

CREATE TABLE Conseiller (
  id int(6) NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
  nom varchar(70) NOT NULL,
  prenom varchar(35) NOT NULL,
  adresse varchar(100),
  email varchar(320),
  dateNaissance DATE NOT NULL
) ENGINE = InnoDB;

CREATE TABLE Etudiant (
  id int(6) NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
  nom varchar(70) NOT NULL,
  prenom varchar(35) NOT NULL,
  adresse varchar(100),
  email varchar(320),
  dateNaissance DATE NOT NULL,
  conseiller int(6),
  CONSTRAINT donnerConseille
    FOREIGN KEY (conseiller) REFERENCES Conseiller(id)
) ENGINE = InnoDB;

CREATE TABLE Diplome (
  id int(3) NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
  titre varchar(100) NOT NULL,
  niveau varchar(5),
  creditsEssentiels int(4),
  creditsEnrichissement int(4)
) ENGINE = InnoDB;


CREATE TABLE Matiere (
  code varchar(10) NOT NULL UNIQUE PRIMARY KEY,
  nom varchar(100),
  credits int(2) default 0,
  nomDomaine varchar(50),
  respoDomaine int(6),
  CONSTRAINT reponsableDomaine
    FOREIGN KEY (respoDomaine) REFERENCES Professeur(id)
) ENGINE = InnoDB;

CREATE TABLE Cours (
  code varchar(15) NOT NULL UNIQUE PRIMARY KEY,
  matiere varchar(10) NOT NULL,
  quota int(3),
  quotaExamen int(3),
  dateDebut DATE,
  horaire1 varchar(7),
  horaire2 varchar(7),
  dateExamen DATETIME,
  enseignant int(6),
  annee YEAR NOT NULL,
  trimestre varchar(3) NOT NULL,
  CONSTRAINT instantiate
  FOREIGN KEY (matiere) REFERENCES Matiere(code)
    ON DELETE CASCADE
    ON UPDATE RESTRICT,
  CONSTRAINT enseigner
  FOREIGN KEY (enseignant) REFERENCES Professeur(id)
    ON DELETE CASCADE
    ON UPDATE RESTRICT
) ENGINE = InnoDB;

# JUNCTION TABLES (many to many)

CREATE TABLE PreRequisition (
  id int NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
  matiere varchar(10) NOT NULL,
  matiereRequise varchar(10) NOT NULL,
  CONSTRAINT requires
    FOREIGN KEY (matiere) REFERENCES Matiere(code)
    ON DELETE CASCADE
    ON UPDATE RESTRICT,
  CONSTRAINT required
  FOREIGN KEY (matiereRequise) REFERENCES Matiere(code)
    ON DELETE CASCADE
    ON UPDATE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE InscriptionCours (
  id int NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
  cours varchar(15) NOT NULL,
  etudiant int(6) NOT NULL,
  suivreCours BOOLEAN DEFAULT 1,
  inscrit BOOLEAN DEFAULT 0,
  noteConseiller int(1) NOT NULL,
  noteObtenue int(2) NULL,
  CONSTRAINT inscrit
  FOREIGN KEY (cours) REFERENCES Cours(code)
    ON DELETE CASCADE
    ON UPDATE RESTRICT,
  CONSTRAINT sinscrit
  FOREIGN KEY (etudiant) REFERENCES Etudiant(id)
    ON DELETE CASCADE
    ON UPDATE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE Preparer (
  id int NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
  etudiant int(6) NOT NULL,
  diplome int(3) NOT NULL,
  CONSTRAINT prepared
  FOREIGN KEY (diplome) REFERENCES Diplome(id)
    ON DELETE CASCADE
    ON UPDATE RESTRICT,
  CONSTRAINT prepares
  FOREIGN KEY (etudiant) REFERENCES Etudiant(id)
    ON DELETE CASCADE
    ON UPDATE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE Contenir (
  id int NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
  diplome int(3) NOT NULL,
  matiere varchar(10) NOT NULL,
  CONSTRAINT contient
  FOREIGN KEY (diplome) REFERENCES Diplome(id)
    ON DELETE CASCADE
    ON UPDATE RESTRICT,
  CONSTRAINT appartient
  FOREIGN KEY (matiere) REFERENCES Matiere(code)
    ON DELETE CASCADE
    ON UPDATE RESTRICT
) ENGINE = InnoDB;
