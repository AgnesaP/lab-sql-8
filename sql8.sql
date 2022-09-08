/* Instructions
1.Rank films by length (filter out the rows with nulls or zeros in length column). Select only columns title, length and rank in your output.
2.Rank films by length within the rating category (filter out the rows with nulls or zeros in length column). In your output, only select the columns title, length, rating and rank.
3.How many films are there for each of the categories in the category table? Hint: Use appropriate join between the tables "category" and "film_category".
4.Which actor has appeared in the most films? Hint: You can create a join between the tables "actor" and "film actor" and count the number of times an actor appears.
5.Which is the most active customer (the customer that has rented the most number of films)? Hint: Use appropriate join between the tables "customer" and "rental" and count the rental_id for each customer.
6.Bonus: Which is the most rented film? (The answer is Bucket Brotherhood).
This query might require using more than one join statement. Give it a try. We will talk about queries with multiple join statements later in the lessons.
Hint: You can use join between three tables - "Film", "Inventory", and "Rental" and count the rental ids for each film. */

use sakila;

# 1.Rank films by length (filter out the rows with nulls or zeros in length column). Select only columns title, length and rank in your output.
select * from sakila.film;
select title, length, rank() over (order by length desc) as "rank" from sakila.film where length is not null and length > 0;


#2.Rank films by length within the rating category (filter out the rows with nulls or zeros in length column). In your output, only select the columns title, length, rating and rank.
select title, length, rating, rank() over (partition by rating order by length desc) as "rank" from sakila.film where length is not null and length > 0;


#3.How many films are there for each of the categories in the category table? Hint: Use appropriate join between the tables "category" and "film_category".

select * from sakila.category;
select * from sakila.film_category;

SELECT 
    c.name as categories_of_the_films, count(f.film_id)as films 
FROM
 category as c 
        left JOIN
    sakila.film_category AS f ON f.category_id = c.category_id
    group by c.category_id, c.name;
    
#4.Which actor has appeared in the most films? Hint: You can create a join between the tables "actor" and "film actor" and count the number of times an actor appears.
select * from actor;
select * from film_actor;

select a.first_name, a.last_name, count(a.first_name) as count  
from actor as a
join film_actor as f on a.actor_id=f.actor_id 
group by a.actor_id, a.first_name, a.last_name
order by count(*) desc limit 1;

#5.Which is the most active customer(the customer that has rented the most number of films)? 
# Hint: Use appropriate join between the tables "customer" and "rental" and count the rental_id for each customer.
select * from customer;
select * from rental;

select c.customer_id, c.first_name, c.last_name, count(r.rental_id) from customer c
join rental r on
c.customer_id = r.customer_id group by c.first_name order by count(r.rental_id) desc limit 1;

# 6.Bonus: Which is the most rented film?
select * from sakila.film;
select * from sakila.rental;
select * from inventory;


select count(r.rental_id), f.title from rental r
join inventory i on
r.inventory_id = i.inventory_id
join film f on
i.film_id = f.film_id group by title order by count(r.rental_id) desc limit 2