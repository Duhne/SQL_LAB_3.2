-- In this lab, you will be using the Sakila database of movie rentals. Create appropriate joins wherever necessary.
-- Instructions
-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT * FROM sakila.inventory;
SELECT * FROM sakila.film;

SELECT count(i.inventory_id)
FROM sakila.inventory i
JOIN sakila.film f USING (film_id)
WHERE title = 'Hunchback Impossible';

-- 2. List all films whose length is longer than the average of all the films.
SELECT film_id, title, length FROM sakila.film
WHERE length > (
SELECT AVG(length) FROM sakila.film)
ORDER BY length ASC;

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT * FROM sakila.film
where title = 'Alone Trip';
SELECT * FROM sakila.actor;
SELECT * FROM sakila.film_actor;

SELECT actor_id, first_name, last_name FROM sakila.actor a
JOIN sakila.film_actor fa USING (actor_id)
JOIN sakila.film f USING (film_id)
WHERE title = 'Alone Trip';

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
SELECT * FROM sakila.film;
SELECT * FROM sakila.category;
SELECT * FROM sakila.film_category
WHERE category_id = 8;

SELECT f.film_id, f.title, c.name, c.category_id FROM sakila.film f
JOIN sakila.film_category fc USING (film_id)
JOIN sakila.category c USING (category_id)
WHERE c.name = 'Family';

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins.
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys,
-- that will help you get the relevant information.
#############################################
Select c.customer_id, concat(c.first_name, ' ', c.last_name) AS 'Name', c.email, co.country 
FROM sakila.customer c, sakila.address a
WHERE address_id = (SELECT address_id, city_id FROM sakila.city ci
WHERE (SELECT city_id, co.country_id FROM sakila.country co
WHERE co.country = 'Canada'));

Select customer_id, concat(first_name, ' ', last_name) AS 'Name', email, co.country FROM sakila.customer
JOIN sakila.address a USING (address_id)
JOIN sakila.city ci USING (city_id)
JOIN sakila.country co USING (country_id) 
WHERE country = 'Canada';

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has 
-- acted in the most number of films. First you will have to find the most prolific actor and then use that 
-- actor_id to find the different films that he/she starred.
SELECT film_id, title FROM sakila.film;
SELECT * FROM sakila.actor;
SELECT * FROM sakila.film_actor;

SELECT f.film_id, f.title FROM sakila.film f
WHERE film_id IN (
	SELECT film_id FROM sakila.film_actor fa
		WHERE fa.actor_id IN 
			(SELECT actor_id FROM
				(SELECT actor_id, count(film_id) as movies FROM sakila.film_actor fa 
                GROUP BY actor_id
                ORDER BY movies DESC
                LIMIT 1)as foo));
-- Previous try
SELECT film_id, title FROM sakila.film
JOIN sakila.film_actor USING (film_id)
WHERE actor_id = (107);

SELECT MAX(movies) as number_movies, actor_id
FROM (SELECT count(film_id) as movies
, actor_id, concat(first_name, ' ',last_name) as actor 
FROM sakila.film f
JOIN sakila.film_actor fa USING (film_id)
JOIN sakila.actor a USING (actor_id)
GROUP BY actor_id
ORDER BY movies DESC
)foo;

-- 7. Films rented by most profitable customer. You can use the customer table and payment 
-- table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT film_id, title FROM sakila.film f
WHERE film_id IN (
SELECT film_id FROM sakila.inventory
WHERE inventory_id IN (
	SELECT inventory_id FROM sakila.rental
		WHERE customer_id IN 
			(SELECT customer_id FROM
				(SELECT customer_id, sum(amount) as amount FROM sakila.payment p 
                GROUP BY customer_id
                ORDER BY amount DESC
                LIMIT 1)
                as foo)));

-- 8. Customers who spent more than the average payments.

SELECT customer_id, concat(first_name, ' ', last_name) FROM sakila.customer
WHERE customer_id IN (
SELECT customer_id FROM sakila.payment 
WHERE amount > (SELECT avg(amount) FROM sakila.payment)  -- 4.2 avg amount
GROUP BY customer_id);