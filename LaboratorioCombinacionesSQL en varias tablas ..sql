-- 1. Escriba una consulta para mostrar para cada tienda su ID de tienda, ciudad y país.
USE sakila;
SELECT st.store_id, ci.city, co.country
FROM store AS st
LEFT JOIN address AS ad
ON st.address_id=ad.address_id
LEFT JOIN city AS ci
ON ad.city_id=ci.city_id
LEFT JOIN country AS co
ON ci.country_id=co.country_id
;

-- 2. Escriba una consulta para mostrar cuánto negocio, en dólares, generó cada tienda.
SELECT st.store_id, SUM(pa.amount)
FROM payment AS pa
LEFT JOIN staff AS st
ON pa.staff_id = st.staff_id
GROUP BY st.store_id;

-- 3. ¿Cuál es el tiempo medio de ejecución de las películas por categoría?
SELECT ca.category_id, AVG(fi.length)
FROM film AS fi
LEFT JOIN film_category AS ca
ON fi.film_id = ca.film_id
GROUP BY ca.category_id;

-- 4. ¿Qué categorías de películas son más largas?
SELECT ca.category_id, AVG(fi.length) AS avg_length
FROM film AS fi
LEFT JOIN film_category AS ca
ON fi.film_id=ca.film_id
GROUP BY ca.category_id
ORDER BY avg_length DESC
LIMIT 1
;

-- 5. Muestra las películas alquiladas con más frecuencia en orden descendente.
SELECT fi.title, COUNT(re.rental_id) AS cantidad_alquileres
FROM film AS fi
LEFT JOIN inventory AS inv
ON inv.film_id = fi.film_id
LEFT JOIN rental AS re
ON inv.inventory_id = re.inventory_id
GROUP BY title
ORDER BY cantidad_alquileres DESC;

-- 6. Enumere los cinco géneros con mayores ingresos brutos en orden descendente.
SELECT ca.name, sum(pa.amount) AS gross_revenue
FROM category AS ca
INNER JOIN film_category fc
ON ca.category_id = fc.category_id
INNER JOIN film fi
ON fi.film_id = fc.film_id
INNER JOIN inventory inv
ON inv.film_id = fi.film_id
INNER JOIN rental re
ON re.inventory_id = inv.inventory_id
INNER JOIN payment pa
ON pa.rental_id = re.rental_id
GROUP BY name
ORDER BY gross_revenue DESC;

-- 7. ¿Está "Academy Dinosaur" disponible para alquilar en la Tienda 1?
SELECT fi.title, inv.store_id
FROM film AS fi
INNER JOIN inventory inv ON fi.film_id = inv.film_id
WHERE inv.store_id = 1
AND fi.title = 'Academy Dinosaur'
AND (
    SELECT COUNT(*)
    FROM rental r
    WHERE r.inventory_id = inv.inventory_id
    AND r.return_date IS NULL
) < (
    SELECT COUNT(*)
    FROM inventory inv2
    WHERE inv2.film_id = fi.film_id
);
