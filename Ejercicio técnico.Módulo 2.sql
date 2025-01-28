/*El ejercicio técnico*/

USE sakila;

/*1. Todos los títulos de películas sin duplicados */
SELECT DISTINCT title AS All_movie_title
FROM film;

/*2. Todas las películas con clasificación "PG-13" */
SELECT
title AS "Movies PG13"
FROM film
WHERE rating = 'PG-13';

/*3. Título y descripción de todas las películas que contengan "amazing" en su descripción*/
SELECT 
title Title,
description Description
FROM film
WHERE description LIKE '%amazing%';

/*4. Título de las películas que duren más de 120 minutos*/
SELECT
title "More than 2h movies"
FROM film
WHERE length > 120;

/*5. Mostrar el nombre y apellido de todos los actores en una columna llamada "nombre_actor".*/
SELECT
CONCAT(first_name," ", last_name) "Actor full name"
FROM actor;

/*6. Nombre y apellido de actores que contengan "Gibson" en su apellido.*/
SELECT
CONCAT(first_name," ", last_name) "All Gibson"
FROM actor
WHERE last_name = 'Gibson';

/*7. Nombre de los actores con "10 < actor_id >20".*/
SELECT
first_name "Actor id between 10 and 20"
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

/*8. Título de las películas de la tabla "film" que no tengan clasificación ni "R" ni "PG-13".*/
SELECT
title "All films except rating R and PG13"
FROM film
WHERE rating NOT IN('R', 'PG-13');

/*9. Muestra la cantidad de películas que hay en cada clasificación y su recuento.*/
SELECT
rating Rating ,
COUNT(film_id) "Total amount"
FROM film
GROUP BY rating;

/*10. Muestra el ID de cada cliente, su nombre y su apellido junto a la cantidad de películas que ha alquilado.*/
SELECT
c.customer_id "Customer id",
CONCAT(c.first_name, '', c.last_name) "Customer full name",
COUNT(r.rental_id) "Amount of rentals"
FROM customer c
INNER JOIN rental r
ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

SELECT *
FROM customer;
SELECT *
FROM rental;

/*11. Encuentra la cantidad total de películas alquiladas en cada categoría y muestra el nombre de la categoría junto al recuento de alquileres.*/
SELECT
c.name "Category",
COUNT(r.rental_id) "Rental amount"
FROM category c
INNER JOIN film_category fc
ON c.category_id = fc.category_id
INNER JOIN inventory i
ON fc.film_id = i.film_id
INNER JOIN rental r
ON i.inventory_id = r.inventory_id
GROUP BY c.name;

SELECT *
FROM category;
SELECT *
FROM inventory;
SELECT *
FROM rental;

/*12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y
muestra la clasificación junto con el promedio de duración.*/
SELECT
rating "Rating",
AVG(length) "Average length"
FROM film
GROUP BY rating;

/*13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".*/
SELECT
CONCAT(a.first_name, " " , a.last_name) "The cast of Indian Love"
FROM actor a
INNER JOIN film_actor fa
ON a.actor_id = fa.actor_id
INNER JOIN film f
ON fa.film_id = f.film_id
WHERE f.title = 'Indian Love';

SELECT *
FROM actor;
SELECT *
FROM film;

/*14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.*/
SELECT
title "Films with dogs or cats"
FROM film
WHERE description LIKE '%dog%' OR description LIKE '%cat%';

/*15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.*/
SELECT
CONCAT(a.first_name, " " , a.last_name) "Actor full name"
FROM actor a
LEFT JOIN film_actor fa
ON a.actor_id = fa.actor_id
WHERE fa.actor_id IS NULL;

SELECT *
FROM actor;
SELECT *
FROM film_actor;

/*16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.*/
SELECT
title "Films released between 2005 and 2010"
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

/*17. Encuentra el título de todas las películas que son de la misma categoría que "Family".*/
SELECT
f.title "Family films"
FROM film f
INNER JOIN film_category fc
ON f.film_id = fc.film_id
INNER JOIN category c
ON fc.category_id = c.category_id
WHERE c.name = 'Family';

/*18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.*/
SELECT
CONCAT(a.first_name, " " , a.last_name) "Actors performing in 10 or more films"
FROM actor a
INNER JOIN film_actor fa
ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING COUNT(fa.film_id) > 10;

/*19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.*/
SELECT
title "More than 2h films and R rating"
FROM film
WHERE rating = 'R' AND length > 120;

/*20. Categorías de películas que tienen un promedio de duración superior a 120 minutos
y muestra el nombre de la categoría junto con el promedio de duración.*/
SELECT
c.name "Category",
AVG(f.length) "Length"
FROM category c
INNER JOIN film_category fc
ON c.category_id = fc.category_id
INNER JOIN film f
ON fc.film_id = f.film_id
GROUP BY c.category_id
HAVING AVG(f.length) > 120;

SELECT *
FROM category;
SELECT *
FROM film_category;
SELECT *
FROM film;


/*21. Encuentra los actores que han actuado en al menos 5 películas y
muestra el nombre del actor junto con la cantidad de películas en las que han actuado.*/
SELECT
CONCAT(a.first_name, " " , a.last_name) "Actor performing in 5 or more films",
COUNT(fa.film_id) "Total films"
FROM actor a
INNER JOIN film_actor fa
ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING COUNT(fa.film_id) >= 5;

SELECT *
FROM actor;
SELECT *
FROM film_actor;


/*22. Encuentra el título de todas las películas que fueron alquiladas durante más de 5 días. Utiliza una
subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona
las películas correspondientes. Pista: Usamos DATEDIFF para calcular la diferencia entre una
fecha y otra, ej: DATEDIFF(fecha_inicial, fecha_final) */

SELECT f.title "Movie"
FROM film f
WHERE f.film_id IN (
	SELECT i.film_id
	FROM rental r
    JOIN inventory i
	ON r.inventory_id = i.inventory_id
	WHERE DATEDIFF(r.return_date, r.rental_date) > 5
    );

SELECT *
FROM film;
SELECT *
FROM rental;
SELECT *
FROM inventory;

/*23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la
categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en
películas de la categoría "Horror" y luego exclúyelos de la lista de actores. */

SELECT CONCAT(a.first_name, " " , a.last_name) "Actor"
FROM actor a
WHERE a.actor_id NOT IN(
	SELECT fa.actor_id
    FROM film_actor fa
    JOIN film_category fc
    ON fa.film_id = fc.film_id
    JOIN category c
    ON fc.category_id = c.category_id
    WHERE c.name = "horror"
    );



SELECT *
FROM actor;
SELECT *
FROM film_actor;
SELECT *
FROM category;
SELECT *
FROM film_category;


/*24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180
minutos en la tabla film con subconsultas.*/

SELECT f.title "More than 180min comedy movies"
FROM film f
WHERE f.film_id IN(
	SELECT fc.film_id
    FROM film_category fc
    JOIN category c
    ON fc.category_id = c.category_id
    WHERE c.name = "Comedy"
) AND f.length > 180;

SELECT *
FROM film;
SELECT *
FROM film_category;
SELECT *
FROM category;

/*25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La
consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que
han actuado juntos. Pista: Podemos hacer un JOIN de una tabla consigo misma, poniendole un
alias diferente.*/

SELECT
CONCAT(a1.first_name, " " , a1.last_name) "Actor 1",
CONCAT(a2.first_name, " " , a2.last_name) "Actor 2",
COUNT(fa1.film_id) "Total movies"
FROM film_actor fa1
JOIN film_actor fa2 /*Self join film_actor*/
ON fa1.film_id = fa2.film_id
INNER JOIN actor a1 /*Inner join entre film actor y actor*/
ON a1.actor_id = fa1.actor_id
JOIN actor a2
ON a2.actor_id = fa2.actor_id
WHERE a1.actor_id < a2.actor_id
GROUP BY a1.actor_id, a2.actor_id
HAVING COUNT(fa1.film_id) > 0;

SELECT *
FROM film_actor;
SELECT *
FROM actor;