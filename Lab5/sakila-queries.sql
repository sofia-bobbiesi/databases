USE sakila;

-- 1. Cree una tabla de `directors` con las columnas: Nombre, Apellido, Número de Películas.
CREATE TABLE directors (
    directors_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (directors_id),
    first_name VARCHAR(45),
    last_name VARCHAR(45),
    number_of_films INTEGER
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

-- 2. El top 5 de actrices y actores de la tabla `actors` que tienen la mayor experiencia (i.e. el mayor número de películas filmadas) son también directores de las películas en las que participaron. Basados en esta información, inserten, utilizando una subquery los valores correspondientes en la tabla `directors`.
INSERT INTO directors (first_name, last_name, number_of_films)
SELECT 
    a.first_name, a.last_name, COUNT(fa.actor_id) AS films
FROM
    actor a
        LEFT JOIN
    film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.first_name , a.last_name
ORDER BY films DESC
LIMIT 5;

-- 3. Agregue una columna `premium_customer` que tendrá un valor 'T' o 'F' de acuerdo a si el cliente es "premium" o no. Por defecto ningún cliente será premium.
ALTER TABLE customer ADD COLUMN premium_customer ENUM('T','F') DEFAULT 'F';

-- 4. Modifique la tabla customer. Marque con 'T' en la columna `premium_customer` de los 10 clientes con mayor dinero gastado en la plataforma.

UPDATE customer AS c 
SET 
    c.premium_customer = 'T'
WHERE
    c.customer_id IN (SELECT 
            *
        FROM
            (SELECT 
                p.customer_id
            FROM
                payment AS p
            GROUP BY customer_id
            ORDER BY SUM(p.amount) DESC
            LIMIT 10) AS table_payment);

-- 5. Listar, ordenados por cantidad de películas (de mayor a menor), los distintos ratings de las películas existentes (Hint: rating se refiere en este caso a la clasificación según edad: G, PG, R, etc).
SELECT rating FROM film GROUP BY rating ORDER BY count(rating) desc;

-- 6.¿Cuáles fueron la primera y última fecha donde hubo pagos?
select min(payment_date) as "first payment", max(payment_date) as "last payment"from payment;

-- 7. Calcule, por cada mes, el promedio de pagos (Hint: vea la manera de extraer el nombre del mes de una fecha).
select monthname(payment_date), avg(amount) from payment group by monthname(payment_date);

-- 8.Listar los 10 distritos que tuvieron mayor cantidad de alquileres (con la cantidad total de alquileres).
SELECT 
    SUM(rxc.total) AS total_rents, a.district
FROM
    (SELECT 
        COUNT(r.rental_id) AS total, r.customer_id, c.address_id
    FROM
        rental AS r
    INNER JOIN customer AS c ON (r.customer_id = c.customer_id)
    GROUP BY r.customer_id , c.address_id) AS rxc
        INNER JOIN
    address AS a ON (rxc.address_id = a.address_id)
GROUP BY a.district
ORDER BY total_rents DESC
LIMIT 10;

-- 9. Modifique la table `inventory_id` agregando una columna `stock` que sea un número entero y representa la cantidad de copias de una misma película que tiene determinada tienda. El número por defecto debería ser 5 copias.
ALTER TABLE inventory ADD COLUMN stock INTEGER DEFAULT 5;

-- 10. Cree un trigger `update_stock` que, cada vez que se agregue un nuevo registro a la tabla rental, haga un update en la tabla `inventory` restando una copia al stock de la película rentada (Hint: revisar que el rental no tiene información directa sobre la tienda, sino sobre el cliente, que está asociado a una tienda en particular).
DELIMITER $$
CREATE TRIGGER update_stock after insert on rental for each row
BEGIN
update inventory set stock = stock - 1 where inventory_id = new.inventory_id and stock > 0;
END;$$ 
DELIMITER ;

-- 11. Cree una tabla `fines` que tenga dos campos: `rental_id` y `amount`. El primero es una clave foránea a la tabla rental y el segundo es un valor numérico con dos decimales.
CREATE TABLE fines (
    fines_id INTEGER NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (fines_id),
    rental_id INTEGER NOT NULL,
    amount DECIMAL(5 , 2 ),
    CONSTRAINT fk_rental_id FOREIGN KEY (rental_id)
        REFERENCES rental (rental_id)
);

-- 12. Cree un procedimiento `check_date_and_fine` que revise la tabla `rental` y cree un registro en la tabla `fines` por cada `rental` cuya devolución (return_date) haya tardado más de 3 días (comparación con rental_date). El valor de la multa será el número de días de retraso multiplicado por 1.5.
delimiter %%
CREATE PROCEDURE check_date_and_fine()
BEGIN
	INSERT INTO fines (rental_id, amount)
	SELECT rental_id, datediff(return_date,rental_date)* 1.5 as dif
	FROM rental
	WHERE datediff(return_date,rental_date) >= 3;
END;%%
delimiter ;

CALL check_date_and_fine();
