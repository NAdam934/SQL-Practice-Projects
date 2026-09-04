create database gyakszi;
use gyakszi;
-- many to many kapcsolat

CREATE TABLE reviewers (
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL
);

CREATE TABLE series (
	id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100),
    released_year YEAR,
    genre VARCHAR(100)
    );
    
INSERT INTO reviewers (first_name, last_name) VALUES
    ('Thomas', 'Stoneman'),
    ('Wyatt', 'Skaggs'),
    ('Kimbra', 'Masters'),
    ('Domingo', 'Cortes'),
    ('Colt', 'Steele'),
    ('Pinkie', 'Petit'),
    ('Marlon', 'Crafford');
    
INSERT INTO series (title, released_year, genre) VALUES
    ('Archer', 2009, 'Animation'),
    ('Arrested Development', 2003, 'Comedy'),
    ("Bob's Burgers", 2011, 'Animation'),
    ('Bojack Horseman', 2014, 'Animation'),
    ("Breaking Bad", 2008, 'Drama'),
    ('Curb Your Enthusiasm', 2000, 'Comedy'),
    ("Fargo", 2014, 'Drama'),
    ('Freaks and Geeks', 1999, 'Comedy'),
    ('General Hospital', 1963, 'Drama'),
    ('Halt and Catch Fire', 2014, 'Drama'),
    ('Malcolm In The Middle', 2000, 'Comedy'),
    ('Pushing Daisies', 2007, 'Comedy'),
    ('Seinfeld', 1989, 'Comedy'),
    ('Stranger Things', 2016, 'Drama');
    

create TABLE reviews (
	id INT PRIMARY KEY AUTO_INCREMENT,
    rating DECIMAL(2,1),
    series_id INT,
    reviewer_id INT,
    FOREIGN key (series_id) REFERENCES series(id),
    FOREIGN KEY (reviewer_id) REFERENCES reviewers(id)
    );
    
INSERT INTO reviews(series_id, reviewer_id, rating) VALUES
    (1,1,8.0),
    (1,2,7.5),
    (1,3,8.5),
    (1,4,7.7),(1,5,8.9),
    (2,1,8.1),(2,4,6.0),(2,3,8.0),(2,6,8.4),(2,5,9.9),
    (3,1,7.0),(3,6,7.5),(3,4,8.0),(3,3,7.1),(3,5,8.0),
    (4,1,7.5),(4,3,7.8),(4,4,8.3),(4,2,7.6),(4,5,8.5),
    (5,1,9.5),(5,3,9.0),(5,4,9.1),(5,2,9.3),(5,5,9.9),
    (6,2,6.5),(6,3,7.8),(6,4,8.8),(6,2,8.4),(6,5,9.1),
    (7,2,9.1),(7,5,9.7),
    (8,4,8.5),(8,2,7.8),(8,6,8.8),(8,5,9.3),
    (9,2,5.5),(9,3,6.8),(9,4,5.8),(9,6,4.3),(9,5,4.5),
    (10,5,9.9),
    (13,3,8.0),(13,4,7.2),
    (14,2,8.5),(14,3,8.9),(14,4,8.9);
    

-- 1. Kérdezd le az értékeléssel rendelkező sorozatok címeit és értékelését
select * from reviews;
select * from series;

select series.title as Title,
		reviews.rating as Ratings
	from series
    right outer join reviews
		on series.id = reviews.series_id;


-- 2. Kérdezd le az értékeléssel rendelkező sorozatok címeit és átlagos értékelését, századra kerekítve
-- Rendezzük a lekérdezést az átlagos értékelés szerint növekvő sorrendbe
select series.title as Title,
		round(avg(reviews.rating),2) as Ratings
	from series
    right outer join reviews
		on series.id = reviews.series_id
	group by Title
    order by Ratings asc;

-- 3. Kérdezd le az értékelést adó személy keresztnevét, családnevét és az értékelést amit adott
select * from reviewers;
select * from reviews;

select concat(reviewers.first_name, ' ', reviewers.last_name) as Name,
		reviews.rating as Rating
	from reviewers
    left outer join reviews
		on reviewers.id = reviews.reviewer_id;

-- 4. Kérdezd le azokat a sorozatokat és címeit amik nem kaptak értékelést.
select*from series;
select*from reviews;

select series.title as Title,
		reviews.rating as Ratings
	from series
    left outer join reviews
		on series.id = reviews.series_id
	where Rating is Null;		
	


-- 5. Kérdezd le az értékeléssel rendelkező sorozatok műfajait , az átlagos értékelést a műfajok szerint, századra kerekítve
select*from series;
select*from reviews;

select series.genre as Genre,
		round(avg(reviews.rating),2) As Rating
        from series
        right outer join reviews
			on series.id = reviews.series_id
		group by Genre
        ;


-- 6. Kérdezd le a keresztnevét, családnevét, értékelések számát, min, max értékeléseket, és az átlagot
select*from reviews;
select*from reviewers;

select
	concat(first_name, ' ', last_name) as Name,
    count(rating) as Total_rating,
    min(rating) as Min_Rating,
    max(rating) as Max_Rating,
    avg(rating) as Average_Rating
    from reviewers
    left outer join reviews
    on reviewers.id = reviews.reviewer_id
    group by Name;
    


-- 7. Kérdezd le a címet, értékelést, az értékelő nevét egy oszlopban
select*from reviews;
select*from reviewers;
select*from series;

select
        title,
		format(rating, 2) as Rating,
		concat(first_name, ' ', last_name) as Name
	from series
    left join reviews
		on series.id = reviews.series_id
	left join reviewers
		on reviews.reviewer_id = reviewers.id;
        
        
USE classicmodels_class;

-- 1. Melyek azok az ügyfelek (customerName), akik az USA-ban találhatók és 
-- Kalifornia államban (state = 'CA') laknak, név szerint ábécé sorrendben?
select*from customers;

select customerName
from customers
where country = 'USA' and state = 'CA'
order by customerName asc;




-- 2. Kik voltak 2003-ban a top 5 értékesítők 
-- (értékesítési összeg szerint csökkenő sorrendben), 
-- és mennyi volt az egyéni eladásuk?
select*from employees;
select*from payments;
select*from orders;
select*from customers;
select*from orderdetails;


select concat(lastName, ' ', firstName) As Name,
		sum(amount) as Total_Amount
	from employees
        inner join customers
			on customers.salesRepEmployeeNumber = employees.employeeNumber
		inner join payments
			on customers.customerNumber = payments.customerNumber
		group by Name 
        order by Total_Amount desc               
        limit 5;
        


-- 3. Mennyi a motorok gyártói által gyártott motorok átlagos száma 
-- (két tizedesjegy pontossággal)?
select * from products;
select * from productlines;

select 	round(avg(quantityInStock),2) as Average_Quantity
	from products
    where productLine = 'Motorcycles';
    
    
-----------------------------------------------------------------------
use sakila;

-- 1. Jelenítsd meg a leggyakrabban kölcsönzött filmeket csökkenő sorrendben.

select * from film;
select * from rental;
select * from inventory;

select film.title, COUNT(film.title) as Rental from film
Inner join
	(Select rental.rental_id, inventory.film_id from rental
    JOIN inventory on inventory.inventory_id = rental.inventory_id) a
    ON a.film_id = film.film_id
    group by film.title
    order by Rental desc;
    
-- 2. Írj egy lekérdezést, amely megjeleníti, hogy mekkora bevételt hozott, dollárban kifejezve, minden egyes üzlet.

select * from store;
select * from payment;
select * from rental;
select * from inventory;

select sum(payment.amount) as TotalAmmount, 
		store.store_id as Store from payment
left join rental
		on payment.rental_id = rental.rental_id
left join inventory
		on rental.inventory_id = inventory.inventory_id
left join store
		on inventory.store_id = store.store_id
group by Store
order by TotalAmmount;   

-- 3. Írj egy lekérdezést, amely megjeleníti minden egyes üzlethez tartozó üzletazonosítót, várost és országot.

select * from store;
select * from address;
select * from city;
select * from country;

Select store.store_id, city, country from store
left join address
		on store.address_id = address.address_id
left join city
		on address.city_id = city.city_id
left join country
		on city.country_id = country.country_id;


--------------        
--Adományozók
--------------

DROP DATABASE TEST;

CREATE DATABASE TEST;

USE test;


-- Create supporter table
CREATE TABLE supporter (
    id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

-- Insert data into supporter table
INSERT INTO supporter (id, first_name, last_name) VALUES
(1, 'Marlene', 'Wagner'),
(2, 'Lonnie', 'Goodwin'),
(3, 'Sophie', 'Peters'),
(4, 'Edwin', 'Paul'),
(5, 'Hugh', 'Thornton'),
(12, 'Adam', 'Jackson'),
(18, 'Peter', 'Wright'),
(19, 'Gabriel', 'Jones'),
(20, 'Martin', 'Turner');

-- Create project table
CREATE TABLE project (
    id INT PRIMARY KEY,
    category VARCHAR(50),
    author_id INT,
    minimal_amount DECIMAL(10, 2),
    FOREIGN KEY (author_id) REFERENCES supporter(id)
);

-- Insert data into project table
INSERT INTO project (id, category, author_id, minimal_amount) VALUES
(1, 'music', 1, 1677),
(2, 'music', 5, 21573),
(3, 'traveling', 2, 4952),
(4, 'traveling', 5, 3135),
(5, 'traveling', 2, 8555),
(6, 'art', 1, 5000),
(8, 'technology', 3, 12000),
(10, 'education', 2, 2500);

-- Create donation table
CREATE TABLE donation (
    id INT PRIMARY KEY,
    project_id INT,
    supporter_id INT,
    amount DECIMAL(10, 2),
    donated DATE,
    FOREIGN KEY (project_id) REFERENCES project(id),
    FOREIGN KEY (supporter_id) REFERENCES supporter(id)
);

-- Insert data into donation table
INSERT INTO donation (id, project_id, supporter_id, amount, donated) VALUES
(1, 4, 4, 928.40, '2016-09-07'),
(2, 8, 18, 384.38, '2016-12-16'),
(3, 6, 12, 367.21, '2016-01-21'),
(4, 2, 19, 108.62, '2016-12-29'),
(5, 10, 20, 842.58, '2016-11-30');


INSERT INTO donation (id, project_id, supporter_id, amount, donated) VALUES
(6, 4, 18, 350.40, '2016-11-07');


-- 1. Szerezd meg azoknak a projekteknek az azonosítóját, minimális összegét és 
-- a teljes adományozott összeget, amelyek a minimális összeget meghaladó 
-- adományokat kaptak.

Select * from donation;
Select * from project;
select * from supporter;

WITH project_revenue AS (
				SELECT 
					project_id,
					SUM(amount) as sum_amount
				FROM donation
				GROUP by project_id 
				order by sum_amount desc )

SELECT 
	p.id, p.minimal_amount, pr.sum_amount
FROM project_revenue pr 
INNER JOIN project p ON pr.project_id = p.id
WHERE pr.sum_amount <= p.minimal_amount ;
