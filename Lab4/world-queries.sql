USE world;
-- Parte I
-- Listar el nombre de la ciudad y el nombre del país de todas las ciudades que pertenezcan a países con una población menor a 10000 habitantes.
SELECT 
    co.Name AS Country, ct.Name AS City
FROM
    country AS co
        INNER JOIN
    city AS ct ON co.Code = ct.CountryCode
WHERE
    co.Population < 10000;
    
# Con subquery    
SELECT 
    Name, CountryName
FROM
    city,
    (SELECT 
        Code, Name AS CountryName
    FROM
        country
    WHERE
        Population < 10000) AS nations
WHERE
    CountryCode = nations.Code;
    
# Otra forma con subquery
SELECT 
    co.Name, c.Name
FROM
    country AS co,
    city AS c
WHERE
    co.code IN (SELECT 
            cou.code
        FROM
            country AS cou
        WHERE
            cou.Population < 10000
                AND cou.Code = c.CountryCode);
-- Listar todas aquellas ciudades cuya población sea mayor que la población promedio entre todas las ciudades.
SELECT 
    ct.Name AS City
FROM
    city AS ct
WHERE
    ct.Population > (SELECT 
            AVG(Population)
        FROM
            city);
-- Listar todas aquellas ciudades no asiáticas cuya población sea igual o mayor a la población total de algún país de Asia.
SELECT
    ct.Name AS City
FROM
    country AS co
        INNER JOIN
    city AS ct ON co.Code = ct.CountryCode
WHERE
    co.Continent != 'Asia'
        AND ct.Population >= SOME (SELECT 
            Population
        FROM
            country
        WHERE
            Continent = 'Asia');
            
# Otra forma
SELECT 
    ct.name, ct.population
FROM
    city AS ct,
    (SELECT 
        Code, Name AS CountryName
    FROM
        country
    WHERE
        continent <> 'Asia') AS nations
WHERE
    ct.countryCode = nations.code
        AND ct.Population >= SOME (SELECT 
            Population
        FROM
            country
        WHERE
            continent = 'Asia');
# Some == Any, aunque ANY no es la palabra reservada que se usa           

-- Listar aquellos países junto a sus idiomas no oficiales, que superen en porcentaje de hablantes a cada uno de los idiomas oficiales del país.
SELECT 
    c.Name, cl.Language
FROM
    country AS c
        INNER JOIN
    countrylanguage AS cl ON c.Code = cl.CountryCode
        AND cl.IsOfficial = 'F'
WHERE
    cl.Percentage > ALL (SELECT 
            clo.Percentage
        FROM
            countrylanguage AS clo
        WHERE
            clo.isOfficial = 'T'
                AND c.Code = clo.CountryCode);

-- Listar (sin duplicados) aquellas regiones que tengan países con una superficie menor a 1000 km2 y exista (en el país) al menos una ciudad con más de 100000 habitantes. (Hint: Esto puede resolverse con o sin una subquery, intenten encontrar ambas respuestas.

#sin subquery
SELECT 
    c.Region, c.Name
FROM
    country c
WHERE
    c.SurfaceArea < 1000
        AND c.Code IN (SELECT 
            countrycode
        FROM
            city
        WHERE
            population > 100000);

#con subquery
SELECT 
    c.Region, c.Name
FROM
    country c
        INNER JOIN
    city AS ct ON c.Code = ct.CountryCode
WHERE
    c.SurfaceArea < 1000
        AND ct.Population > 100000;

-- 6.Listar el nombre de cada país con la cantidad de habitantes de su ciudad más poblada. (Hint: Hay dos maneras de llegar al mismo resultado. Usando consultas escalares o usando agrupaciones, encontrar ambas).
# Con agrupaciones
SELECT 
    c.name, MAX(ct.population)
FROM
    country c
        LEFT JOIN
    city ct ON c.code = ct.countrycode
GROUP BY c.name;

# Sin agrupaciones
SELECT DISTINCT
    country.name,
    (SELECT 
            MAX(city.population)
        FROM
            city
        WHERE
            City.countrycode = country.code)
FROM
    country;
-- Listar aquellos países y sus lenguajes no oficiales cuyo porcentaje de hablantes sea mayor al promedio de hablantes de los lenguajes oficiales.
SELECT 
    c.Name, cl.Language
FROM
    country AS c
        left JOIN
    countrylanguage AS cl ON c.Code = cl.CountryCode
        AND cl.IsOfficial = 'F'
WHERE
    cl.Percentage > ALL (SELECT 
            avg(clo.Percentage)
        FROM
            countrylanguage AS clo
        WHERE
            clo.isOfficial = 'T'
                AND c.Code = clo.CountryCode);
-- Listar la cantidad de habitantes por continente ordenado en forma descendiente.
SELECT 
    Continent, SUM(Population) AS Pop
FROM
    country
GROUP BY continent
ORDER BY Pop DESC; 
-- Listar el promedio de esperanza de vida (LifeExpectancy) por continente con una esperanza de vida entre 40 y 70 años.
SELECT 
    continent, AVG(LifeExpectancy) AS Avg_Life
FROM
    country
GROUP BY continent
HAVING Avg_Life BETWEEN 40 AND 70;

-- Listar la cantidad máxima, mínima, promedio y suma de habitantes por continente.
SELECT 
	continent,
    MAX(Population) AS MAX,
    MIN(Population) AS MIN,
    AVG(Population) AS AVG,
    SUM(Population) AS SUM
FROM
    country
GROUP BY continent;

-- Parte II
-- Si en la consulta 6 se quisiera devolver, además de las columnas ya solicitadas, el nombre de la ciudad más poblada. ¿Podría lograrse con agrupaciones? ¿y con una subquery escalar?
-- Con agrupaciones:
SELECT country.name AS Pais, city.name AS Ciudad, max(city.population) AS Poblacion
FROM city
INNER JOIN country ON (country.code = city.countrycode)
GROUP BY (city.countrycode);
