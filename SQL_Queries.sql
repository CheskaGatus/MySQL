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

# You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."  <br> What is one query would you use to obtain this information?
select actor_id, first_name, last_name 
from actor 
where first_name = "Joe";

# Find all actors whose last name contain the letters `GEN`:
select Actor_Name 
from actor 
where last_name like "%GEN%";

# Find all actors whose last names contain the letters `LI`. <br> This time, order the rows by last name and first name, in that order.
select last_name, first_name 
from actor 
where last_name like "%LI%";

# Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China.
select country_id, country
from country 
where country in ("Afghanistan", "Bangladesh", "China");

# You want to keep a description of each actor. You don't think you will be performing queries on a description. <br> Thus, create a column in the table `actor` named `description` and use the data type `BLOB`. 
alter table actor 
add column description blob;

# Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
alter table actor
drop description;

# List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name)
from actor
group by last_name;

# List last names of actors and the number of actors who have that last name, <br> but only for names that are shared by at least two actors.
select last_name, count(last_name)
from actor
group by last_name
having count(*) > 1;

# The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.

update actor
set first_name = "HARPO"
where Actor_Name = "GROUCHO WILLIAMS";

# Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! <br> In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
update actor
set first_name = "GROUCHO"
where Actor_Name = "GROUCHO WILLIAMS";

# You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

# Use `JOIN` to display the first and last names, as well as the address, of each staff member. <br> Use the tables `staff` and `address`.
select s.first_name, s.last_name, a.address
from staff s 
inner join address a on s.address_id = a.address_id;
    
* 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.

* 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.

* 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?

* 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:

  ![Total amount paid](Images/total_payment.png)

* 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.

* 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.

* 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

* 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.

* 7e. Display the most frequently rented movies in descending order.

* 7f. Write a query to display how much business, in dollars, each store brought in.

* 7g. Write a query to display for each store its store ID, city, and country.

* 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

* 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

* 8b. How would you display the view that you created in 8a?

* 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.

select * from actor where first_name like "%harpo%";