# Description du projet

## Introduction

Le système d'éducation supérieure dans le monde a beaucoup évolué dans les dernières décennies à cause de plusieurs facteurs, notamment l'ouverture à l'international et les développements en technologie.

Dans le monde d'aujourd'hui, les établissements d'enseignement supérieur s'ouvrent de plus en plus à d'autres pays à travers des programmes d'échanges académiques et des projets en collaboration.

De plus, la technologie est de plus en plus présente dans l'éducation. Grâce à Internet, ils existent aujourd'hui des opportunités d'éducation en ligne, ce qui a donné naissance à des plateformes d'enseignement offrant des programmes diplômant.

Par conséquent, il a fallu développer des systèmes communs d'évaluation de compétences académiques. La solution adoptée par la majorités des établissements d'enseignement supérieur est le **crédit académique** qui est une unité de mesure de compétences obtenues liée au nombres d'heures passées pour acquérir ces compétences.

Ce système a permit les écoles et les universités de donner plus de libertés aux étudiants dans leurs parcours académiques.

Bien que ce système soit plus libre et démocratique, il est certainement plus complexe à mettre en place et nécessite un modèle bien défini.

Ce projet vise donc à modéliser une base de données relationnelles pour un établissement d'éducation supérieur *libre*, la base de données conçue est utilisable par un établissement scolaire réel ou une plateforme d'éducation complète. Ce modèle n'existe pas encore, mais s'inspire beaucoup du système existant adopté dans beaucoup de pays.

## Le modèle de l'établissement

La philosophie principale de l'établissement est *la liberté de l'éducation*; dans le sens où les étudiants peuvent choisir les matières en toute liberté. L'établissement offre des formations en domaines différents (sciences de la nature et sciences sociales/humaines). La question qui se pose donc : *comment obtenir un diplôme?*

Les règles suivantes répondent à cette question :

+ L'année est divisée en trois trimestres : l'automne, le printemps, et l'été. Il est possible de commencer ou terminer ses études n'importe quel trimestre.
+ Chaque matière est associée à un certain nombre de crédits lié à la quantité de cours et de travail nécessaires pour la valider.
+ Un diplôme est obtenu lors de la validation d'un certain nombre crédits divisés en deux catégories : crédits essentiels et crédits complémentaires.
    + **Crédits essentiels :** Crédits à obtenir en validant des matières associées à ce programme. On dira que ces matières appartiennent à ce programme. Une matière peut appartenir à plusieurs programmes. L'étudiant n'est pas obligé de valider toutes les matières qui appartiennent à un programme pour obtenir le diplôme, il suffit d'obtenir le nombre minimum de crédits essentiels par ces matières.
    + **Crédits complémentaires :** Ce sont des crédits d'enrichissement personnel. Les étudiants obtiendront ces crédits en validant des matières de leurs choix (hors programme).
+ Il n'y a pas de contraintes sur le nombre de crédits/matières qu'un(e) étudiant(e) obtient en un trimestre.
+ Un(e) étudiant(e) peut suivre plusieurs programmes diplômants à la fois (ou aucun).
+ Les étudiants ont la liberté de viser un ou plusieurs diplômes ou de juste suivre des matières pour s'enrichir.
+ L'existence d'un quota pour chaque matière entraine une critère de selection des étudiants, cette critère est détérminée par plusieurs facteurs:
    + Les étudiants qui visent des diplômes contenant tel matière sont prioritaires.
    + Le nombre de fois qu'un(e) étudiant(e) ait suivi la matière antérieurement est un facteur négatif.
    + L'avis du conseiller est un facteur très important.
+ Le choix de viser un diplôme est analogue au projet professionnel, il est donc dynamique et évolue au cours des trimestres. On donne alors aux étudiants la possibilité de changer de diplômes pendant la première année à chaque fin de trimestre, il est aussi possible de changer de diplôme plus tard sous-reserve d'avoir au moins 50% de matières communs déjà validées.
+ Certaines matières demandes la prédisposition de certaines notions exprimées en fonction d'autres matières dites **les prérequises** de la matière. Les matières sans prérequis sont dites des *matières élémentaires*.
+ Afin de garder le niveau académique de l'établissement **les matières** sont catégorisées par **domaines** avec le poste du *responsable académique* qui veille sur le bon déroulement des matières de ce domaine. Il se peut que le responsable soient des enseignants.

## Questions et requêtes

La base de données ne vise pas à répondre aux questions administratives (secretariat, salles de cours, personnels, etc).
En effet, le système de l'établissement ne définit pas *un parcours académique* dans le sens tradition.
Le but de ce projet donc est la conception d'une base de données adaptée pour le traitement les questions liées principalement aux parcours académiques;
cette base de données est donc idéale pour une application web mise à disposition des étudiants, professeurs, conseillers et des futurs étudiants de l'établissement.
Voici des exemples de question/requêtes auxquelles la base de données voudrais répondre:

- Si un(e) étudiant(e) voudrait obtenir le diplôme $X$ en $N$ année, combien de matières doit-il(elle) prendre par trimsetre ?
- Si un(e) étudiant(e) ne peut assister aux cours que les journées $A$ et $B$, combien de trimestres lui faut-il afin d'obtenir le diplôme $X$ ?
- Si un(e) étudiant(e) voudrait préparer les diplôme $X$ et $Y$, quel est le minimum de trimestres possibles afin de finir ses études (sans aucun contraintes le nombre de crédits par semestre).
- Si un(e) étudiant(e) voudrait se réorienter vers le diplôme $X$ quelles sont les matières qu'il/elle doit valider (en crédits d'enrichissement) avant d'officialiser la réorientation?
- Si $L$ est une liste d'étudiants souhaitant suivre la matière $X$, trier la liste $L$ par priorité.
- Si un(e) étudiant(e) voudrait préparer le diplôme $X$, proposer les scénarios possibles pour l'obtenir sachant que l'étudiant(e) prendra entre $A$ et $B$ matières par trimestre (avec $A<B$).
- Si un(e) étudiant(e) voudrait préparer le diplôme $X$, proposer les scénarios possibles pour l'obtenir sachant que l'étudiant(e) n'assistera pas à 2 trimestres consécutifs.
- Si un(e) étudiant(e) décide d'arrêter ses études, mais ne voudrais pas sortir sans diplômes. S'il/elle continue encore pendant un trimestre, quel(s) diplômes peut-il/elle avoir ? (s'il y'en a).
- Si l'établissement décide d'arrêter l'enseignement d'une matière, quelles sont les instances à supprimer de la base de données.
- Si un professeur $X$ part en retraite et le professeur $Y$ prend sa place pour, $Y$ signe un contrat de 2 ans avec l'établissement, quelles sont les instances à modifier?
- Quand est-ce qu'un étudiant/professeur part en vacances ?
- Qui sont les professeurs spécialiste dans le domaine $X$ ?
- Si un(e) étudiant(e) souhaite suivre le cours d'une matière $X$, quel est le minimum de trimestre qu'il lui faut avant de pouvoir s'inscire à ce cours ? (Question de matières prérequise analogue aux algorithmes de planification des tâches dépendantes)
\pagebreak
