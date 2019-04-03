## SQL queries
use sakila;

# Display the first and last names of all actors from the table `actor`.
select first_name, last_name 
from actor;

# Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
alter table actor 
add column Actor_Name varchar(100) after last_name;

update actor 
set Actor_Name = concat (first_name, ' ', last_name);

# You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
select actor_id, first_name, last_name 
from actor 
where first_name = "Joe";

# Find all actors whose last name contain the letters `GEN`.
select Actor_Name 
from actor 
where last_name like "%GEN%";

# Find all actors whose last names contain the letters `LI`. Order the rows by last name and first name.
select last_name, first_name 
from actor 
where last_name like "%LI%";

# Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China.
select country_id, country
from country 
where country in ("Afghanistan", "Bangladesh", "China");

# You want to keep a description of each actor. You don't think you will be performing queries on a description. 
# Thus, create a column in the table `actor` named `description` and use the data type `BLOB`. 
alter table actor 
add column description blob;

# Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
alter table actor
drop description;

# List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name)
from actor
group by last_name;

# List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
select last_name, count(last_name)
from actor
group by last_name
having count(*) > 1;

# The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
update actor
set first_name = "HARPO"
where Actor_Name = "GROUCHO WILLIAMS";

# Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! 
# In a single query, change `HARPO` back to `GROUCHO`.
update actor
set first_name = "GROUCHO"
where Actor_Name = "GROUCHO WILLIAMS";

# You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

# Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`.
select s.first_name, s.last_name, a.address
from staff s 
inner join address a on s.address_id = a.address_id;
    
# Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
select s.first_name, s.last_name,  sum(p.amount) as "Total Amount"
from staff s 
inner join payment p on s.staff_id = p.staff_id
where p.payment_date like "2005-08%"
group by p.staff_id;

# List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
select f.title, count(fa.actor_id) as "Number of Actors"
from film f 
inner join film_actor fa on f.film_id = fa.film_id
group by f.title;

# How many copies of the film `Hunchback Impossible` exist in the inventory system?
select f.title, count(i.inventory_id) as "Number of Copies"
from film f 
inner join inventory i on f.film_id = i.film_id
where f.title = "Hunchback Impossible"
group by f.title;

# Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. 
# List the customers alphabetically by last name:
select c.first_name, c.last_name, sum(p.amount) as "Total Amount Paid"
from payment p
inner join customer c on p.customer_id = c.customer_id
group by c.customer_id
order by last_name;
    
# The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
# As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. 
# Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
select title
from film
where title like ("K%") or title like ("Q%") and language_id in (
		select language_id from language
        where name = "English");

# Use subqueries to display all actors who appear in the film `Alone Trip`.
select Actor_Name 
from actor
where actor_id in (
		select actor_id 
        from film_actor
        where film_id in (
			select film_id 
            from film
            where title = 'Alone Trip'));
            
# You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select c.first_name, c.last_name, c.email 
from customer c
left join address a on a.address_id = c.address_id
left join city ct on ct.city_id = a.city_id
left join country cy on cy.country_id = ct.country_id
where country = "Canada";

# Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
# Identify all movies categorized as _family_ films.
select * from film_category;
select title
from film f
left join film_category fc on fc.film_id = f.film_id
left join category cat on cat.category_id = fc.category_id
where name = "Family";

# Display the most frequently rented movies in descending order.
select title 
from film
order by rental_duration desc;

#  Write a query to display how much business, in dollars, each store brought in.
select store.store_id as 'Store ID', sum(amount) as 'Total Business' from payment
left join staff on staff.staff_id = payment.staff_id
left join store on store.store_id = staff.store_id
group by store.store_id;

#  Write a query to display for each store its store ID, city, and country.
select store.store_id as 'Store ID', sum(amount) as 'Total Business' from payment
left join staff on staff.staff_id = payment.staff_id
left join store on store.store_id = staff.store_id
group by store.store_id;

# List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select category.name as 'Genre', sum(amount) as 'Gross Revenue' from category
left join film_category on film_category.category_id = category.category_id
left join inventory on inventory.film_id = film_category.film_id
left join rental on rental.inventory_id = inventory.inventory_id
left join payment on payment.rental_id = rental.rental_id
group by Genre
order by `Gross Revenue` desc
limit 5;

# In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
create view Top_5_Categories_by_Gross_Revenue as
	select category.name as 'Genre', sum(amount) as 'Gross Revenue' from category
	left join film_category on film_category.category_id = category.category_id
	left join inventory on inventory.film_id = film_category.film_id
	left join rental on rental.inventory_id = inventory.inventory_id
	left join payment on payment.rental_id = rental.rental_id
	group by Genre
	order by `Gross Revenue` desc
	limit 5;
    
# How would you display the view that you created in 8a?
select * from Top_5_Categories_by_Gross_Revenue;

# You find that you no longer need the view `top_five_genres`. Write a query to delete it.
drop view if exists
Top_5_Categories_by_Gross_Revenue;