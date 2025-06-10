# Projet SQL — Analyse d’incidents sur le réseau de transport

Ce projet a été réalisé dans le cadre du module de Bases de Données Relationnelles de l’Executive Master Statistique & Intelligence Artificielle à l’Université Paris Dauphine PSL.
L’objectif est d’explorer et d’analyser, via des requêtes SQL, des données d’incidents sur différentes lignes de métro/RER afin de répondre à des problématiques courantes en exploitation de réseaux de transport.

Objectifs pédagogiques : 

Manipulation avancée du langage SQL (jointures, sous-requêtes, fonctions analytiques, agrégations…)
Résolution de problématiques métiers : identification des lignes les plus impactées, calculs d’indicateurs de performance, classement des lignes…
Mise en œuvre de bonnes pratiques en data management (scripts reproductibles, documentation, nomenclature claire).
Description des données
La base de données simulée se compose des relations suivantes :

Ligne : informations sur chaque ligne (numéro, terminus, nombre d’incidents, nombre d’heures perdues).  
Incident : détails de chaque incident (date, ligne concernée, type d’incident, nombre d’incidents, nombre d’heures perdues…).  

Exemples d’analyses réalisées :

Calcul du rapport moyen entre heures perdues et incidents par ligne et par date.
Identification des lignes ayant connu le plus d’incidents (via différentes approches SQL : ALL, MAX, NOT EXISTS).
Classement des lignes en fonction de leur impact global (heures d’incident cumulées) à l’aide de fonctions analytiques.

Apports du projet : 

Approfondissement des techniques avancées de requêtes SQL utilisées dans l’industrie.
Démonstration de compétences en nettoyage, agrégation, et restitution de données à des fins décisionnelles.
Capacité à documenter, tester, et automatiser l’analyse au travers de scripts.
