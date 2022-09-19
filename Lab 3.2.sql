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

SELECT f.film_id, f.title FROM sakila.film f
JOIN film_category fc USING (film_id)
JOIN category c USING (category_id)
WHERE c.name = 'Family';

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins.
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys,
-- that will help you get the relevant information.
Select customer_id, concat(first_name, ' ', last_name) from sakila.customer
WHERE address_id = (
SELECT address_id FROM sakila.address
WHERE city_id = (
SELECT city_id FROM sakila.city
WHERE country_id = (
SELECT country_id FROM sakila.country
WHERE country = 'Canada')));

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
-- 8. Customers who spent more than the average payments.


