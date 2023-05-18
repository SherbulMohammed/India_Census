-- 2011 India Census

SELECT * 
FROM Data1

SELECT * 
FROM Data2

-- number of rows in our dataset

SELECT COUNT(*)
FROM Data1

SELECT COUNT(*)
FROM Data2

-- show dataset for Uttar Pradesh and Punjab

SELECT *
FROM Data1
WHERE State IN ('Uttar Pradesh', 'Punjab')

-- show population of India

SELECT SUM(Population) AS Total_Population
FROM Data2;

-- show average growth

SELECT AVG(Growth)*100 AS Avg_Growth
FROM Data1

-- show average growth by state

SELECT State, AVG(Growth)*100 AS Avg_Growth
FROM Data1
GROUP BY State

-- show average sex ratio by state

SELECT State, ROUND(AVG(Sex_Ratio),0) AS Avg_Sex_Ratio
FROM Data1
GROUP BY State
ORDER BY Avg_Sex_Ratio DESC;

-- show average literacy ratio

SELECT State, ROUND(AVG(Literacy),0) AS Avg_Literacy_Ratio
FROM Data1
GROUP BY State
ORDER BY Avg_Literacy_Ratio DESC;

-- show average literacy ratio above 90

SELECT State, ROUND(AVG(Literacy),0) AS Avg_Literacy_Ratio
FROM Data1
GROUP BY State
HAVING ROUND(AVG(Literacy),0)> 90
ORDER BY Avg_Literacy_Ratio DESC;

-- list top 5 states which show highest average growth ratio

SELECT TOP 5 State, ROUND(AVG(Growth)*100,0) AS Avg_Growth_Ratio
FROM Data1
GROUP BY State
ORDER BY Avg_Growth_Ratio DESC

-- list bottom 5 states showing lowest average sex ratio

SELECT Top 5 State, ROUND(AVG(Sex_Ratio),0) AS Avg_Sex_Ratio
FROM Data1
GROUP BY State
ORDER BY Avg_Sex_Ratio;

-- show top and bottom 5 states for literacy rates

DROP TABLE IF EXISTS topstates;
CREATE TABLE topstates
(state nvarchar(255),
topstates float
)

INSERT INTO topstates

SELECT State, ROUND(AVG(Literacy),0) AS Avg_Literacy_Rate
FROM Data1
GROUP BY State
ORDER BY Avg_Literacy_Rate;

SELECT TOP 5 *
FROM topstates
ORDER BY topstates.topstates DESC;


DROP TABLE IF EXISTS bottomstates;
CREATE TABLE bottomstates
(state nvarchar(255),
bottomstates float
)

INSERT INTO bottomstates

SELECT State, ROUND(AVG(Literacy),0) AS Avg_Literacy_Rate
FROM Data1
GROUP BY State
ORDER BY Avg_Literacy_Rate;

SELECT TOP 5 *
FROM bottomstates
ORDER BY bottomstates.bottomstates ASC;

--union operator to combine both tables

SELECT * FROM (
	SELECT TOP 5 *
	FROM topstates
	ORDER BY topstates.topstates DESC) a
UNION
	SELECT * FROM (
	SELECT TOP 5 *
	FROM bottomstates
	ORDER BY bottomstates.bottomstates ASC) b


-- List states starting with letter P

SELECT DISTINCT state
FROM Data1
WHERE lower(state) LIKE 'p%'

-- List states starting with letter M and ending with letter A

SELECT DISTINCT state
FROM Data1
WHERE lower(state) LIKE 'm%' AND lower(state) LIKE '%a'

-- 
SELECT * 
FROM Data1

SELECT * 
FROM Data2

-- total no. of males and females

SELECT c.District, c.State, ROUND(c.Population / (c.Sex_Ratio + 1),0) AS Males, ROUND((c.Population * c.Sex_Ratio) / (c.Sex_Ratio + 1),0) AS Females
FROM (
    SELECT a.District, a.State, a.Sex_Ratio / 1000 AS Sex_Ratio, b.Population
    FROM Data1 a
    INNER JOIN Data2 b ON a.District = b.District
) c;

-- show by state

SELECT d.State, SUM(d.Males) Males, SUM(d.Females) Females 
FROM
(SELECT c.District, c.State, ROUND(c.Population / (c.Sex_Ratio + 1),0) AS Males, ROUND((c.Population * c.Sex_Ratio) / (c.Sex_Ratio + 1),0) AS Females
FROM
    (SELECT a.District, a.State, a.Sex_Ratio / 1000 AS Sex_Ratio, b.Population
    FROM Data1 a
    INNER JOIN Data2 b ON a.District = b.District
) c) d
GROUP BY d.State;


