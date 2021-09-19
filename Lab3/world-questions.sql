USE world
-- ¿Devuelven los mismos valores las siguientes consultas? ¿Por qué? 
-- Devuelven los mismos valores porque la restricción se aplica sobre la intersección de la tabla.
-- Aunque en ambos casos la consulta se hace en distinto orden, se hace sobre el mismo conjunto y 
-- es no afecta el resultado

SELECT city.Name, country.Name
FROM city
INNER JOIN country ON city.CountryCode = country.Code AND country.Name = 'Argentina';

SELECT city.Name, country.Name
FROM city
INNER JOIN country ON city.CountryCode = country.Code
WHERE country.Name = 'Argentina';

-- ¿Y si en vez de INNER JOIN fuera un LEFT JOIN?
SELECT city.Name as Ciudad, country.Name as Country
FROM city
LEFT JOIN country ON city.CountryCode = country.Code AND country.Name = 'Argentina';
-- Acá se hace primero el join y luego se aplican la restricción --> quedan valores null.

SELECT city.Name, country.Name
FROM city
LEFT JOIN country ON city.CountryCode = country.Code
WHERE country.Name = 'Argentina';
-- En este caso primero se aplica la restricción y luego se hace el join.
