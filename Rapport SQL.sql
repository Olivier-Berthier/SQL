-- a) Quelles lignes de métro (en précisant son numéro) n'a eu aucun incident le 01/01/2024 ?

SELECT numeroLigne 
FROM Ligne 
WHERE numeroLigne NOT IN (
    SELECT numeroLigne 
    FROM Incident 
    WHERE dateI = '2024-01-01');

-- a) bis

SELECT DISTINCT i1.numeroLigne
FROM Incident i1
LEFT JOIN Incident i2 ON i1.numeroLigne = i2.numeroLigne AND i2.dateI = '2024-01-01'
WHERE i2.numeroLigne IS NULL;


-----------------------------------------------------------------------------


-- b) Quels sont les noms des types d'indicent associés à aucune ligne ? Écrire 2 requêtes
-- SQL, une avec NOT IN ou NOT EXISTS et une avec une jointure externe et
-- comparer leur temps d'exécution.

SELECT nomIncident
FROM TableTypeIncident
WHERE tid NOT IN (
    SELECT typeIncident
    FROM Incident);

-- Query complete 00:00:00.037

-- b) bis

SELECT nomIncident
FROM TableTypeIncident
WHERE NOT EXISTS (
    SELECT 1
    FROM Incident
    WHERE Incident.typeIncident = TableTypeIncident.tid);

-- Query complete 00:00:00.041

-- b) ter

SELECT nomIncident
FROM TableTypeIncident 
LEFT JOIN Incident  ON TableTypeIncident.tid = Incident.typeIncident
WHERE Incident.typeIncident IS NULL;

-- Query complete 00:00:00.047

-- Remarque : La requête avec la jointure externe prend en moyenne plus de temps que les deux autres requêtes proposées.


-----------------------------------------------------------------------------


-- c) Quelles lignes (en précisant le numéro) a fait l'objet d'incidents de type 'Régulation'
-- OU 'Malaise voyageur' ? Écrire 2 requêtes SQL, une avec UNION et une sans
-- UNION et comparer leur temps d'exécution.

SELECT DISTINCT numeroLigne
FROM Incident i
JOIN TableTypeIncident tti ON i.typeIncident = tti.TID
WHERE tti.nomIncident = 'Régulation'

UNION

SELECT DISTINCT numeroLigne
FROM Incident i
JOIN TableTypeIncident tti ON i.typeIncident = tti.TID
WHERE tti.nomIncident = 'Malaise voyageur';

-- Query complete 00:00:00.034

-- c) bis

SELECT DISTINCT i.numeroLigne
FROM Incident i
LEFT JOIN TableTypeIncident tti ON i.typeIncident = tti.TID
WHERE tti.nomIncident = 'Malaise voyageur' OR tti.nomIncident = 'Régulation';

-- Query complete 00:00:00.048

-- Remarque : La requête avec UNION prend en moyenne moins de temps que la requête sans UNION.


-------------------------------------------------------------------------------


-- d) Quelles lignes (en précisant le numéro) a fait l'objet d'incidents de type 'Régulation'
-- ET d’incidents de type 'Malaise ? Écrire 2 requêtes SQL, une avec INTERSECT
-- et une sans INTERSECT et comparer leur temps d'exécution.

SELECT DISTINCT numeroLigne
FROM Incident i
JOIN TableTypeIncident tti ON i.typeIncident = tti.TID
WHERE tti.nomIncident = 'Régulation'

INTERSECT

SELECT DISTINCT numeroLigne
FROM Incident i
JOIN TableTypeIncident tti ON i.typeIncident = tti.TID
WHERE tti.nomIncident = 'Malaise voyageur';

-- Query complete 00:00:00.041

-- d) bis

SELECT i.numeroLigne
FROM Incident i
JOIN TableTypeIncident tti ON i.typeIncident = tti.TID
WHERE tti.nomIncident IN ('Malaise voyageur', 'Régulation')
GROUP BY i.numeroLigne
HAVING COUNT(DISTINCT tti.nomIncident) = 2;

-- Query complete 00:00:00.048

-- d) ter

WITH 
LignesMalaise AS (
    SELECT DISTINCT numeroLigne
    FROM Incident i
    JOIN TableTypeIncident tti ON i.typeIncident = tti.TID
    WHERE tti.nomIncident = 'Malaise voyageur'
),

LignesRegulation AS (
    SELECT DISTINCT numeroLigne
    FROM Incident i
    JOIN TableTypeIncident tti ON i.typeIncident = tti.TID
    WHERE tti.nomIncident = 'Régulation'
)

-- Jointure des deux sous-requêtes 
SELECT LM.numeroLigne
FROM LignesMalaise LM
JOIN LignesRegulation LR ON LM.numeroLigne = LR.numeroLigne;

-- Query complete 00:00:00.067


-- Remarque : La requête avec INTERSECT est la plus rapide en moyenne, celle avec les deux sous-requêtes est la plus lente.


------------------------------------------------------------------------------


-- e) Quels types d'incidents (en précisant tous ses attributs) sont associés à toutes les
-- lignes ?

SELECT tti.tid, tti.nomIncident
FROM Incident i
JOIN TableTypeIncident tti ON i.typeIncident = tti.tid
GROUP BY tti.tid, tti.nomIncident
HAVING COUNT(DISTINCT i.numeroLigne) = (SELECT COUNT(*) FROM Ligne);


------------------------------------------------------------------------------


-- f) Quelle est la moyenne des heures de perturbations par jour et par ligne (i.e. pour
-- chaque ligne et chaque jour, la somme du nombre d'heures du jour divisé par le
-- nombre d’incidents du jour) ?

SELECT 
    dateI,
	numeroLigne,  
    SUM(nbHeures) / SUM(nbIncidents) AS moyenne_heures_par_incident
FROM 
    Incident
GROUP BY 
    dateI,
	numeroLigne
ORDER BY 
    dateI,
	numeroLigne;


---------------------------------------------------------------------------


-- g) Quelles sont les lignes (en précisant leur numéro) avec le plus d’incidents ? Écrire
-- 3 requêtes SQL, une avec ALL, une avec MAX et un avec NOT EXISTS.

SELECT numeroLigne, nbincidents
FROM Ligne
WHERE nbIncidents >= ALL (SELECT nbIncidents FROM Ligne);

-- g) bis

SELECT numeroLigne, nbincidents
FROM Ligne
WHERE nbIncidents = (SELECT MAX(nbIncidents) FROM Ligne);

-- g) ter

SELECT L1.numeroLigne, nbincidents
FROM Ligne L1
WHERE NOT EXISTS (
    SELECT 1
    FROM Ligne L2
    WHERE L2.nbIncidents > L1.nbIncidents);


-------------------------------------------------------------------------------


-- h) Quel est, pour chaque ligne (en précisant leur numéro), le nombre d’heures
-- d’incidents, en numérotant les lignes de métro de la moins impactée à la plus
-- impactée.

SELECT 
    RANK() OVER (ORDER BY nbHeuresIncidents) AS rang,
    numeroLigne,
    nbHeuresIncidents
FROM 
    Ligne



--------------------------------------------------------------------------------


-- i) Quelles sont les lignes impactées par un incident à chaque date ? Votre requête devra
-- renvoyer pour chaque date, la liste des numéros de lignes séparés par une virgule.

SELECT 
    dateI,
    STRING_AGG(numeroLigne, ',') AS listelignes
FROM 
    Incident
GROUP BY 
    dateI
ORDER BY 
    dateI ASC;



---------------------------------------------------------------------------------


-- j) Quels sont le nombre d'incidents et le nombre d'heures par numéro de ligne et par
-- type d'incidents, en calculant le total par ligne et le total pour toutes les lignes.

SELECT
    COALESCE(L.numeroLigne, 'Total') AS numeroLigne,
    COALESCE(TI.nomIncident, 'Total') AS nomIncident,
    SUM(I.nbIncidents) AS nbTotalIncidents,
    SUM(I.nbHeures) AS nbTotalHeures
FROM
    Incident I
JOIN 
    Ligne L ON I.numeroLigne = L.numeroLigne
JOIN 
    TableTypeIncident TI ON I.typeIncident = TI.TID
GROUP BY 
    ROLLUP(L.numeroLigne, TI.nomIncident)
ORDER BY 
    L.numeroLigne ASC,
    TI.nomIncident ASC;
