-- Assignment Questions


-- 1. Create a table called employees with the following structure:

create database company;
use company;

CREATE TABLE employees (
    emp_id INT NOT NULL PRIMARY KEY,
    emp_name VARCHAR(255) NOT NULL,
    age INT NOT NULL CHECK (age >= 18),
    email VARCHAR(255) NOT NULL UNIQUE,
    salary DECIMAL(10,2) DEFAULT 30000.00
);

select * from employees;

-- 2. Explain the purpose of constraints and how they help maintain data integrity in a database. Provide examples of common types of constraints.

/* 
ans- Constraints are rules enforced on data in a database to ensure its accuracy, consistency, and validity.
They act as safeguards that prevent invalid or inconsistent data from being entered, updated, or deleted.

Purpose of Constraints:
- Maintain Data Integrity: Prevents incorrect, duplicate, or missing data.
- Enforce Business Rules: Ensures data aligns with real-world expectations (e.g., age cannot be negative).
- Preserve Relationships: Maintains links between tables (e.g., foreign keys).
- Automate Validation: Reduces manual checks by enforcing rules at the database level.

Example- NOT NULL, UNIQUE,PRIMARY KEY,FOREIGN KEY,CHECK,DEFAULT
*/

-- 3.Why would you apply the NOT NULL constraint to a column? Can a primary key contain NULL values? Justify your answer.
/*
ans- The NOT NULL constraint ensures that a column must always contain a value—it cannot be left empty.
 This is crucial for maintaining data integrity, especially when certain fields are mandatory for business logic or relational consistency.
 
Reasons to Use NOT NULL
- Enforces Required Fields: Guarantees that essential data (like EmployeeID, Name, or Email) is always present.
- Prevents Data Gaps: Avoids incomplete records that could break queries or reports.
- Supports Reliable Relationships: Ensures foreign key references are valid and not missing.
- Improves Query Accuracy: Eliminates ambiguity caused by NULL values in filters or joins.



Can a Primary Key Contain NULL Values-
No, a primary key cannot contain NULL values—not even a single one.

Justification
- A primary key uniquely identifies each row in a table.
- Since NULL represents an unknown or missing value, it cannot be used to uniquely identify anything.
- Allowing NULL in a primary key would violate its core purpose: uniqueness and presence.
*/

-- 4. Explain the steps and SQL commands used to add or remove constraints on an existing table. Provide an example for both adding and removing a constraint.
/*ans-
1 Identify the table and column(s) where the constraint is needed.
2 Use ALTER TABLE with ADD CONSTRAINT to define the rule.
*/
use company;
ALTER TABLE Employees
ADD CONSTRAINT chk_age
CHECK (Age >= 18);

/*
1.Find the name of the constraint you want to remove.- You can query system views like INFORMATION_SCHEMA.TABLE_CONSTRAINTS or use your DBMS's GUI.

2.Use ALTER TABLE with DROP CONSTRAINT.
*/

ALTER TABLE Employees
DROP CONSTRAINT chk_age;


-- 5. Explain the consequences of attempting to insert, update, or delete data in a way that violates constraints.Provide an example of an error message that might occur when violating a constraint.
/*ans-
Consequences of Constraint Violations:-

Operation Failure: The SQL statement will not execute successfully.

Error Message Returned: The DBMS will generate a descriptive error.

Data Integrity Preserved: The database remains unchanged to prevent corruption.

Application Disruption: If not handled properly, it may crash or behave unexpectedly.

Debugging Overhead: Developers must investigate and resolve the issue.

example-
Suppose i try to insert a duplicate primary key:-

INSERT INTO students (id, name) VALUES (1, 'RAJ');

If id = 1 already exists then i might get:-

ERROR 1062 (23000): Duplicate entry '1' for key 'PRIMARY'
*/

-- 6. You created a products table without constraints as follows:
create database mall;
use mall;
CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(50),
    price DECIMAL(10, 2));
    
-- 1. Add Primary Key to product_id

ALTER TABLE products
ADD CONSTRAINT pk_product_id PRIMARY KEY (product_id);

-- 2. Add Default Value to price

ALTER TABLE products
MODIFY price DECIMAL(10, 2) DEFAULT 50.00;

-- 7. Write a query to fetch the student_name and class_name for each student using an INNER JOIN.

-- Create the Students table
create database school;
use school;
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    class_id INT
);

-- Insert sample data into Students table
INSERT INTO Students (student_id, student_name, class_id) VALUES
(1, 'Alice', 101),
(2, 'Bob', 102),
(3, 'Charlie', 101);


-- Create the class table
use school;
create table classes(
class_id int primary key,
class_name varchar(50)
);

insert into classes (class_id,class_name) values
(101,'Math'),
(102,'Science'),
(103,'History');

SELECT 
    s.student_name,
    c.class_name
FROM 
    Students s
INNER JOIN 
    Classes c ON s.class_id = c.class_id;
    
    
-- 8.Write a query that shows all order_id, customer_name, and product_name, ensuring that all products are listed even if they are not associated with an order 

create database Supermarket;
use Supermarket;

CREATE TABLE Orders (
    order_id INT,
    order_date DATE,
    customer_id INT
);

INSERT INTO Orders VALUES
(1, '2024-01-01', 101),
(2, '2024-01-03', 102);


CREATE TABLE Customers (
    customer_id INT,
    customer_name VARCHAR(50)
);

INSERT INTO Customers VALUES
(101, 'Alice'),
(102, 'Bob');


CREATE TABLE Products (
    product_id INT,
    product_name VARCHAR(50),
    order_id INT
);

INSERT INTO Products VALUES
(1, 'Laptop', 1),
(2, 'Phone', NULL);

SELECT 
    p.order_id,
    c.customer_name,
    p.product_name
FROM Products p
LEFT JOIN Orders o ON p.order_id = o.order_id
INNER JOIN Customers c ON o.customer_id = c.customer_id;

-- 9.Write a query to find the total sales amount for each product using an INNER JOIN and the SUM() function.

create database shop;
use shop;

CREATE TABLE Sales (
    sale_id INT,
    product_id INT,
    amount INT
);

INSERT INTO Sales VALUES
(1, 101, 500),
(2, 102, 300),
(3, 101, 700);

CREATE TABLE Products (
    product_id INT,
    product_name VARCHAR(50)
);

INSERT INTO Products VALUES
(101, 'Laptop'),
(102, 'Phone');

SELECT 
    p.product_name,
    SUM(s.amount) AS total_sales
FROM Sales s
INNER JOIN Products p ON s.product_id = p.product_id
GROUP BY p.product_name;


-- 10.Write a query to display the order_id, customer_name, and the quantity of products ordered by each customer using an INNER JOIN between all three tables.

create database shop_2;
use shop_2;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);

INSERT INTO Customers (customer_id, customer_name) VALUES
(1, 'Alice'),
(2, 'Bob');


CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Orders (order_id, order_date, customer_id) VALUES
(1, '2024-01-02', 1),
(2, '2024-01-05', 2);


CREATE TABLE Order_Details (
    order_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

INSERT INTO Order_Details (order_id, product_id, quantity) VALUES
(1, 201, 2),
(1, 202, 1),
(2, 201, 3);

SELECT 
    o.order_id,
    c.customer_name,
    od.quantity
FROM 
    Orders o
INNER JOIN 
    Customers c ON o.customer_id = c.customer_id
INNER JOIN 
    Order_Details od ON o.order_id = od.order_id;
    
    

 -- SQL commands
 


-- 1.Identify the primary keys and foreign keys in maven movies db. Discuss the differences


/* ans-
1. Core Entity Tables (Primary Keys)

Each "entity" table typically has a single-column primary key—for example:

film (film_id PK)

customer (customer_id PK)

staff (staff_id PK)

store (store_id PK)

payment (payment_id PK)

rental (rental_id PK)

category (category_id PK)

language (language_id PK) */


 /* 2. Transactional and Lookup Tables (Foreign Keys)

Tables that store events or reference other entities usually include foreign keys to relevant tables:

inventory (inventory_id PK, film_id FK → film, store_id FK → store)

rental (rental_id PK, inventory_id FK → inventory, customer_id FK → customer, staff_id FK → staff)

payment (payment_id PK, customer_id FK → customer, staff_id FK → staff, rental_id FK → rental) */



/* Key Differences Explained

Primary Key (PK):

 1.Uniquely identifies each record in a table.

2.Must be non-null and unique, often auto-generated.

3.Essential to entity integrity and indexing 
Medium
Shiksha
IBM
.

Foreign Key (FK):

1. Enforces a relationship between tables.

2. Typically allows duplicates or nulls depending on design.

3. Ensures referential integrity: the referenced key must exist 
Medium
IBM
Cockroach Labs
.

Composite Primary Key:

Uses a combination of two or more columns to uniquely identify records, often used in join tables.

Junction Table Patterns:

Use composite keys or a surrogate primary key plus FKs to link many-to-many relationships (e.g., film_actor, film_category) 
Stack Overflow
Medium
Analytics Vidhya.
*/

-- 2. List all details of actors.
-- ans-
use mavenmovies;
select *
from actor;

-- 3List all customer information from DB.
-- ans- 
select * 
from customer;

-- 4.List different countries.
-- ans- 
select *
from country; 

-- 5.-Display all active customers.
-- ans-
select *
from customer
where active = "1";

-- 6 -List of all rental IDs for customer with ID 1.
-- ans- 
select * 
from rental
where customer_id =1;

-- 7 - Display all the films whose rental duration is greater than 5
-- ans
select film_id , title , rental_duration 
from film
where rental_duration > 5;

-- 8 .List the total number of films whose replacement cost is greater than $15 and less than $20.
-- ans-
select count(*) as total_films
from film
where replacement_cost > 15 
and replacement_cost < 20;


-- 9 - Display the count of unique first names of actors.
-- ans-
USE mavenmovies;

SELECT COUNT(DISTINCT first_name) AS unique_first_names
FROM actor;

-- 10. Display the first 10 records from the customer table .
-- ans- 
select *
from customer
limit 10;


-- 11. Display the first 3 records from the customer table whose first name starts with ‘b’.

SELECT *
FROM customer
WHERE first_name LIKE 'b%'
LIMIT 3;

-- 12. Display the names of the first 5 movies which are rated as ‘G’.
-- ans-
select film_id,title,rating
from film
where rating = "G"
limit 5;

-- 13. Find all customers whose first name starts with "a".
-- ans-
select *
from customer 
where first_name like 'a%';

-- 14. Find all customers whose first name ends with "a".
-- ans- 
select *
from customer 
where first_name like '%a';

-- 15.  Display the list of first 4 cities which start and end with ‘a’ .
-- ans- 
select *
from city 
where city like 'a%a';

-- 16.  Find all customers whose first name have "NI" in any position.
-- ans- 
SELECT *
FROM customer
WHERE first_name LIKE '%NI%';

-- 17.Find all customers whose first name have "r" in the second position.
-- ans- 
SELECT *
FROM customer
WHERE first_name LIKE '_r%';

-- 18.- Find all customers whose first name starts with "a" and are at least 5 characters in length.
-- ans- 
select *
from customer 
where first_name like 'a%' and length(first_name)>=5;

-- 19.  Find all customers whose first name starts with "a" and ends with "o".
-- ans-
SELECT *
FROM customer
WHERE first_name LIKE 'a%o';

-- 20.Get the films with pg and pg-13 rating using IN operator.
-- ans-
SELECT *
FROM film
WHERE rating IN ('PG', 'PG-13');

-- 21.Get the films with length between 50 to 100 using between operator.
-- ans-
SELECT *
FROM film
WHERE length BETWEEN 50 AND 100;

-- 22. Get the top 50 actors using limit operator.
-- ans- 
select *
from actor
limit 50;

-- 23.Get the distinct film ids from inventory table.
-- ans- 
SELECT DISTINCT film_id
FROM inventory;



-- functions


-- 1. Question 1:

-- Retrieve the total number of rentals made in the Sakila database.
-- ans- 
use mavenmovies;
SELECT COUNT(*) AS total_rentals
FROM rental;

-- Question 2:

-- Find the average rental duration (in days) of movies rented from the Sakila database.
-- ans-
 SELECT AVG(rental_duration) AS avg_rental_duration_days
FROM film;

-- String Functions:

-- Question 3:

-- Display the first name and last name of customers in uppercase.
-- ans- 
SELECT 
    UPPER(first_name) AS first_name_upper,
    UPPER(last_name) AS last_name_upper
FROM customer;

-- Question 4:

-- Extract the month from the rental date and display it alongside the rental ID.
-- ans- 
SELECT 
    rental_id,
    MONTH(rental_date) AS rental_month
FROM rental;



-- Question 5:

-- Retrieve the count of rentals for each customer (display customer ID and the count of rentals).
-- ans- 
SELECT 
    customer_id,
    COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id
ORDER BY rental_count DESC;

-- Question 6:

-- Find the total revenue generated by each store.
-- ans- 
use mavenmovies; 
SELECT 
    s.store_id,
    SUM(p.amount) AS total_revenue
FROM payment p
JOIN staff st ON p.staff_id = st.staff_id
JOIN store s ON st.store_id = s.store_id
GROUP BY s.store_id;



-- Question 7:

-- Determine the total number of rentals for each category of movies.

SELECT 
    c.name AS category_name,
    COUNT(r.rental_id) AS total_rentals
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name
ORDER BY total_rentals DESC;


-- Question 8:

-- Find the average rental rate of movies in each language.
-- ans- 
SELECT 
    l.name AS language_name,
    ROUND(AVG(f.rental_rate), 2) AS average_rental_rate
FROM film f
JOIN language l ON f.language_id = l.language_id
GROUP BY l.name
ORDER BY average_rental_rate DESC;



-- joins


-- Questions 9 -

-- Display the title of the movie, customer s first name, and last name who rented it.

-- ans-
use mavenmovies;
SELECT 
    f.title AS Movie_Title,
    c.first_name AS Customer_FirstName,
    c.last_name AS Customer_LastName
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN customer c ON r.customer_id = c.customer_id;

-- Question 10:

-- Retrieve the names of all actors who have appeared in the film "Gone with the Wind."

select a.first_name,a.last_name
from actor a
join film_actor fa on fa.actor_id = a.actor_id
join film f on f.film_id = fa.film_id
where title = "Gone with the Wind";


-- Question 11:

-- Retrieve the customer names along with the total amount they've spent on rentals.

-- ans-
SELECT 
    c.first_name,
    c.last_name,
    SUM(p.amount) AS total_amount_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
JOIN rental r ON p.rental_id = r.rental_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_amount_spent DESC;

-- Question 12:

-- List the titles of movies rented by each customer in a particular city (e.g., 'London').

-- ans-
SELECT 
    c.first_name,
    c.last_name,
    ci.city,
    f.title AS movie_title
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE ci.city = 'London'
GROUP BY c.customer_id, f.title, c.first_name, c.last_name, ci.city
ORDER BY c.last_name, c.first_name, f.title;

-- Question 13:

-- Display the top 5 rented movies along with the number of times they've been rented.
-- ans-
SELECT 
    f.title AS movie_title,
    COUNT(r.rental_id) AS times_rented
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
ORDER BY times_rented DESC
LIMIT 5;

-- Question 14:

-- Determine the customers who have rented movies from both stores (store ID 1 and store ID 2).
-- ans-
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT i.store_id) = 2;


-- Windows Function 


-- 1.Rank the customers based on the total amount they've spent on rentals.
-- ans-
use mavenmovies;
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(p.amount) AS total_spent,
    RANK() OVER (ORDER BY SUM(p.amount) DESC) AS rank_position
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- 2.calculate the cumulative revenue generated by each film over time.
-- ans-
SELECT 
    f.film_id,
    f.title,
    p.payment_date,
    SUM(p.amount) AS daily_revenue,
    SUM(SUM(p.amount)) OVER (
        PARTITION BY f.film_id 
        ORDER BY p.payment_date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_revenue
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.film_id, f.title, p.payment_date
ORDER BY f.title, p.payment_date;

-- 3. Determine the average rental duration for each film, considering films with similar lengths.
-- ans-
SELECT 
    f.film_id,
    f.title,
    f.length,
    AVG(DATEDIFF(r.return_date, r.rental_date)) AS avg_rental_duration,
    AVG(AVG(DATEDIFF(r.return_date, r.rental_date))) 
        OVER (PARTITION BY ROUND(f.length, -10)) AS avg_duration_for_similar_length
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.return_date IS NOT NULL
GROUP BY f.film_id, f.title, f.length
ORDER BY f.length, f.title;


-- 4. Identify the top 3 films in each category based on their rental counts.
-- ans-
WITH film_rentals AS (
  SELECT
      c.category_id,
      c.name AS category_name,
      f.film_id,
      f.title AS film_title,
      COUNT(r.rental_id) AS rental_count
  FROM category c
  JOIN film_category fc ON c.category_id = fc.category_id
  JOIN film f          ON fc.film_id = f.film_id
  JOIN inventory i     ON f.film_id = i.film_id
  JOIN rental r        ON i.inventory_id = r.inventory_id
  GROUP BY c.category_id, c.name, f.film_id, f.title
),
ranked AS (
  SELECT
      category_name,
      film_title,
      rental_count,
      DENSE_RANK() OVER (
        PARTITION BY category_id
        ORDER BY rental_count DESC
      ) AS rank_in_category
  FROM film_rentals
)
SELECT
    category_name,
    film_title,
    rental_count,
    rank_in_category
FROM ranked
WHERE rank_in_category <= 3
ORDER BY category_name, rank_in_category, rental_count DESC, film_title
limit 3;

-- 5.Calculate the difference in rental counts between each customer's total rentals and the average rentals across all customers.
-- ans-
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(r.rental_id) AS total_rentals,
    AVG(COUNT(r.rental_id)) OVER () AS avg_rentals_all_customers,
    COUNT(r.rental_id) - AVG(COUNT(r.rental_id)) OVER () AS diff_from_avg
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY diff_from_avg DESC;

-- 6. Find the monthly revenue trend for the entire rental store over time.
-- ans-

SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS month,
    SUM(amount) AS total_revenue
FROM payment
GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
ORDER BY month;

-- 7.Identify the customers whose total spending on rentals falls within the top 20% of all customers. 
-- ans-
WITH customer_spending AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(p.amount) AS total_spent,
        PERCENT_RANK() OVER (ORDER BY SUM(p.amount) DESC) AS pr
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT customer_id, customer_name, total_spent
FROM customer_spending
WHERE pr <= 0.2
ORDER BY total_spent DESC;


-- 8. Calculate the running total of rentals per category, ordered by rental count.
-- ans-
SELECT 
    c.name AS category,
    COUNT(r.rental_id) AS rental_count,
    SUM(COUNT(r.rental_id)) OVER (ORDER BY COUNT(r.rental_id) DESC) AS running_total
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY rental_count DESC;

-- 9. Find the films that have been rented less than the average rental count for their respective categories.
-- ans-
WITH film_rentals AS (
    SELECT 
        f.film_id,
        f.title,
        c.name AS category,
        COUNT(r.rental_id) AS rental_count
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    GROUP BY f.film_id, f.title, c.name
),
category_avg AS (
    SELECT 
        category,
        AVG(rental_count) AS avg_rentals
    FROM film_rentals
    GROUP BY category
)
SELECT 
    fr.film_id,
    fr.title,
    fr.category,
    fr.rental_count,
    ca.avg_rentals
FROM film_rentals fr
JOIN category_avg ca ON fr.category = ca.category
WHERE fr.rental_count < ca.avg_rentals
ORDER BY fr.category, fr.rental_count ASC;


-- 10. Identify the top 5 months with the highest revenue and display the revenue generated in each month.
-- ans-
SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS month,
    SUM(amount) AS total_revenue
FROM payment
GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
ORDER BY total_revenue DESC
LIMIT 5;
 
 
 
 -- Normalisation & CTE
 
 
 /* 1. First Normal Form (1NF):
 a. Identify a table in the Sakila database that violates 1NF. Explain how you would normalize it to achiev */
 -- ans-
 use mavenmovies;


-- 1. Create new normalized table
CREATE TABLE actor_award_normalized (
  actor_award_id SMALLINT UNSIGNED NOT NULL,
  award VARCHAR(20) NOT NULL,
  PRIMARY KEY (actor_award_id, award),
  FOREIGN KEY (actor_award_id) REFERENCES actor_award(actor_award_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- 2. Insert normalized data (example: splitting values manually)
-- In real life, you’d parse the comma-separated list into rows.
-- Here’s a sample for demonstration:

INSERT INTO actor_award_normalized (actor_award_id, award)
VALUES
(1, 'Emmy'), (1, 'Oscar'), (1, 'Tony'),
(2, 'Emmy'), (2, 'Oscar'), (2, 'Tony'),
(8, 'Emmy'), (8, 'Oscar'),
(36, 'Emmy'), (36, 'Tony');


-- Get all awards won by actor_id 1
SELECT aa.first_name, aa.last_name, an.award
FROM actor_award aa
JOIN actor_award_normalized an
  ON aa.actor_award_id = an.actor_award_id
WHERE aa.actor_award_id = 1;


/*2. Second Normal Form (2NF):

 a. Choose a table in Sakila and describe how you would determine whether it is in 2NF. 

 If it violates 2NF, explain the step to normalize it .*/
 -- ans-
 
-- Step 1: Why it violates 2NF

/*The primary key is actor_award_id.

But first_name and last_name don’t depend on actor_award_id, they depend on actor_id.

This creates a partial dependency, violating 2NF.*/

-- Step 2: Normalize to 2NF

-- We keep actor details only in the actor table and link using actor_id.
CREATE TABLE actor_award_2NF (
  actor_award_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  actor_id SMALLINT UNSIGNED NOT NULL,   -- ✅ match parent column
  awards VARCHAR(45) NOT NULL,
  PRIMARY KEY (actor_award_id),
  FOREIGN KEY (actor_id) REFERENCES actor(actor_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Step 3: Move data into new normalized table

INSERT INTO actor_award_2NF (actor_award_id, actor_id, awards)
SELECT actor_award_id, actor_id, awards
FROM actor_award
WHERE actor_id IS NOT NULL;

/*3. Third Normal Form (3NF):

 a. Identify a table in Sakila that violates 3NF. Describe the transitive dependencies 

 present and outline the step to normalize the table to 3NF.*/
 
-- ans-
 /*🔹 Identify the table

address table.

🔹 Find the transitive dependency

Primary Key: address_id

Non-key attributes: district, city_id, postal_code, phone

But city_id → country_id → country (via the city table).

So:

address_id → city_id → country_id → country


This is a transitive dependency, violating 3NF.

🔹 Normalization step (to 3NF)

Keep only city_id in address.

Store city–country relationship separately in city and country.

Query country info via joins instead of duplicating it.*/



/*4. Normalization Process:

 a. Take a specific table in Sakila and guide through the process of normalizing it from the initial 

 unnormalized form up to at least 2NF.*/
 -- ans-
 /*Step 1: Pick a table (we’ll use actor_award from your Mavenmovies dataset)

This one is great because it actually violates 1NF and 2NF.

Unnormalized Form (UNF)
actor_award(
  actor_award_id,
  actor_id,
  first_name,
  last_name,
  awards
)


Problem 1: awards column stores multiple values (e.g., 'Emmy, Oscar, Tony').

Problem 2: first_name and last_name are stored here, even though they already exist in the actor table.

Step 2: Convert to 1NF

Rules for 1NF:

Eliminate repeating groups / multi-valued attributes.

Ensure atomic values.

Fix:

Split awards into separate rows. Create a new table for awards linked to the actor.

actor_award_1NF(
  actor_award_id,
  actor_id,
  award
)


Now each row stores one award per actor (atomic values).

🔹 Step 3: Check for 2NF

Rules for 2NF:

Must already be in 1NF.

No partial dependencies (non-key attribute depending on only part of a composite primary key).

Here in actor_award_1NF:

Primary Key = actor_award_id

Non-key attributes = actor_id, award

Problem: first_name and last_name (in the original UNF) depended on actor_id, not on the full key → that was a partial dependency.

Fix (2NF):

Remove actor details from actor_award. Keep them only in actor table.
Final structure:

actor(actor_id, first_name, last_name, ...)

actor_award_2NF(
  actor_award_id,
  actor_id,   -- foreign key
  award
)


Now:

award depends entirely on actor_award_id.

Actor details (first_name, last_name) are stored only once in actor.

No partial dependencies remain.

🔹 Final Result

UNF: multi-valued awards, actor details repeated.

1NF: split awards into separate rows.

2NF: remove redundant actor details, link via actor_id.*/
-- 1NF version (atomic awards)
CREATE TABLE actor_award_1NF (
  actor_award_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  actor_id SMALLINT UNSIGNED NOT NULL,
  award VARCHAR(45) NOT NULL,
  PRIMARY KEY (actor_award_id)
);

-- 2NF version (normalized, referencing actor)
CREATE TABLE actor_award_2NF (
  actor_award_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  actor_id SMALLINT UNSIGNED NOT NULL,
  award VARCHAR(45) NOT NULL,
  PRIMARY KEY (actor_award_id),
  FOREIGN KEY (actor_id) REFERENCES actor(actor_id)
);

/*5.CTE Basics:

 a. Write a query using a CTE to retrieve the distinct list of actor names and the number of films they 

 have acted in from the actor and film_actor table*/
 -- ans-
 WITH ActorFilmCounts AS (
    SELECT 
        a.actor_id,
        CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
        COUNT(DISTINCT fa.film_id) AS film_count
    FROM actor a
    JOIN film_actor fa 
        ON a.actor_id = fa.actor_id
    GROUP BY a.actor_id, a.first_name, a.last_name
)
SELECT DISTINCT actor_name, film_count
FROM ActorFilmCounts
ORDER BY film_count DESC;


/*6. CTE with Joins:

 a. Create a CTE that combines information from the film and language tables to display the film title, 

 language name, and rental rate.*/
 -- ans-
 WITH film_language_cte AS (
    SELECT 
        f.title AS film_title,
        l.name AS language_name,
        f.rental_rate
    FROM film f
    JOIN language l 
        ON f.language_id = l.language_id
)
SELECT * 
FROM film_language_cte;

 /*7.CTE for Aggregation:

 a. Write a query using a CTE to find the total revenue generated by each customer (sum of payments) 

 from the customer and payment table*/
 -- ans-
 WITH customer_revenue AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(p.amount) AS total_revenue
    FROM customer c
    JOIN payment p 
        ON c.customer_id = p.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT * 
FROM customer_revenue
ORDER BY total_revenue DESC;


/*8.CTE with Window Functions:

 a. Utilize a CTE with a window function to rank films based on their rental duration from the film table.*/
 -- ans-
 WITH film_ranking AS (
    SELECT 
        film_id,
        title,
        rental_duration,
        RANK() OVER (ORDER BY rental_duration DESC) AS duration_rank
    FROM film
)
SELECT * 
FROM film_ranking
ORDER BY duration_rank, title;

/*9.CTE and Filtering:

 a. Create a CTE to list customers who have made more than two rentals, and then join this CTE with the 

 customer table to retrieve  additional customer details.*/
 -- ans-
 WITH frequent_renters AS (
    SELECT 
        customer_id,
        COUNT(rental_id) AS total_rentals
    FROM rental
    GROUP BY customer_id
    HAVING COUNT(rental_id) > 2
)
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    c.store_id,
    fr.total_rentals
FROM frequent_renters fr
JOIN customer c 
    ON fr.customer_id = c.customer_id
ORDER BY fr.total_rentals DESC;

/*10. CTE for Date Calculations:

 a. Write a query using a CTE to find the total number of rentals made each month, considering the 

 rental_date from the rental table.*/
 -- ans-
 WITH monthly_rentals AS (
    SELECT 
        DATE_FORMAT(rental_date, '%Y-%m') AS rental_month,
        COUNT(rental_id) AS total_rentals
    FROM rental
    GROUP BY DATE_FORMAT(rental_date, '%Y-%m')
)
SELECT * 
FROM monthly_rentals
ORDER BY rental_month;

/*11.CTE and Self-Join:

 a. Create a CTE to generate a report showing pairs of actors who have appeared in the same film 

 together, using the film_actor table.*/
 -- ans-
 WITH actor_pairs AS (
    SELECT 
        fa1.film_id,
        fa1.actor_id AS actor1_id,
        fa2.actor_id AS actor2_id
    FROM film_actor fa1
    JOIN film_actor fa2 
        ON fa1.film_id = fa2.film_id
       AND fa1.actor_id < fa2.actor_id   -- avoid duplicate & self-pairs
)
SELECT 
    ap.film_id,
    f.title AS film_title,
    CONCAT(a1.first_name, ' ', a1.last_name) AS actor1_name,
    CONCAT(a2.first_name, ' ', a2.last_name) AS actor2_name
FROM actor_pairs ap
JOIN actor a1 ON ap.actor1_id = a1.actor_id
JOIN actor a2 ON ap.actor2_id = a2.actor_id
JOIN film f ON ap.film_id = f.film_id
ORDER BY f.title, actor1_name, actor2_name;

/*12.CTE for Recursive Search:

 a. Implement a recursive CTE to find all employees in the staff table who report to a specific manager, 
considering the reports_to column*/
-- ans
SELECT 
    s.staff_id,
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
    st.store_id,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name
FROM staff s
JOIN store st 
    ON s.store_id = st.store_id
JOIN staff m 
    ON st.manager_staff_id = m.staff_id;


