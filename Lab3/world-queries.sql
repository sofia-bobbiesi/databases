-- Parte I - Consultas
USE world;
-- Lista el nombre de la ciudad, nombre del país, región y forma de gobierno de las 10 ciudades más pobladas del mundo.
SELECT 
    ct.Name AS City,
    co.Name AS Country,
    co.Region,
    co.GovernmentForm
FROM
    country AS co
        JOIN
    city AS ct ON ct.CountryCode = co.Code
ORDER BY ct.Population DESC
LIMIT 10;
-- Listar los 10 países con menor población del mundo, junto a sus ciudades capitales (Hint: puede que uno de estos países no tenga ciudad capital asignada, en este caso deberá mostrar "NULL").
SELECT 
    co.Name AS Country, ct.Name AS Capital
FROM
    country AS co
        LEFT JOIN
    city AS ct ON co.Capital = ct.ID
WHERE
    co.IndepYear <= 2021
ORDER BY co.Population ASC
LIMIT 10;

-- Otra opción
SELECT 
    co.NAME, c.Name
FROM
    city AS c
        INNER JOIN
    country AS co ON c.id = co.capital
        AND co.IndepYear IS NOT NULL
ORDER BY co.population ASC
LIMIT 10;
-- Listar el nombre, continente y todos los lenguajes oficiales de cada país. (Hint: habrá más de una fila por país si tiene varios idiomas oficiales).
SELECT 
    co.Continent, co.Name, cl.Language
FROM
    country AS co
        INNER JOIN
    countrylanguage AS cl ON cl.CountryCode = co.Code
WHERE
    cl.IsOfficial = 'T';
-- Listar el nombre del país y nombre de capital, de los 20 países con mayor superficie del mundo.
SELECT 
    co.Name AS Country, ct.Name AS Capital
FROM
    country AS co
        JOIN
    city AS ct ON co.Capital = ct.ID
WHERE
    co.IndepYear <= 2021
ORDER BY co.SurfaceArea DESC
LIMIT 20;
-- Listar las ciudades junto a sus idiomas oficiales (ordenado por la población de la ciudad) y el porcentaje de hablantes del idioma.
SELECT 
    ct.Name AS City, cl.Language AS Language, cl.Percentage
FROM
    city AS ct
        INNER JOIN
    countrylanguage AS cl ON cl.CountryCode = ct.CountryCode
WHERE
    cl.IsOfficial = 'T'
ORDER BY ct.Population DESC;
-- Listar los 10 países con mayor población y los 10 países con menor población (que tengan al menos 100 habitantes) en la misma consulta.
(SELECT 
    co.Name AS Country, co.Population
FROM
    country AS co
ORDER BY co.Population DESC
LIMIT 10) UNION (SELECT 
    co.Name AS Country, co.Population
FROM
    country AS co
ORDER BY co.Population ASC
LIMIT 10);
-- Listar aquellos países cuyos lenguajes oficiales son el Inglés y el Francés (hint: no debería haber filas duplicadas).   
SELECT 
    co.Name, cl.Language
FROM
    country AS co
        INNER JOIN
    countrylanguage AS cl ON cl.CountryCode = co.Code
WHERE
    cl.IsOfficial = 'T'
        AND cl.Language = 'English'
        AND EXISTS( SELECT 
            cl2.Language
        FROM
            countrylanguage AS cl2
        WHERE
            cl.countrycode = cl2.countrycode
                AND cl2.IsOfficial = 'T'
                AND cl2.Language = 'French');
-- Listar aquellos países que tengan hablantes del Inglés pero no del Español en su población.
SELECT 
    co.Name, cl.Language
FROM
    country AS co
        INNER JOIN
    countrylanguage AS cl ON cl.CountryCode = co.Code
WHERE
    cl.IsOfficial = 'T'
        AND cl.Language = 'English'
        AND NOT EXISTS( SELECT 
            cl2.Language
        FROM
            countrylanguage AS cl2
        WHERE
            cl.countrycode = cl2.countrycode
                AND cl2.IsOfficial = 'T'
                AND (cl2.Language = 'Spanish'));