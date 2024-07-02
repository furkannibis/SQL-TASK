-- Find the title and rental count of the most rented movie in each category
WITH rental_counts AS(
    SELECT
        c.name AS category,
        f.title,
        COUNT(*) AS rent_count,
        ROW_NUMBER() OVER(
            PARTITION BY c.name
            ORDER BY
                COUNT(r.rental_id) DESC
        ) AS row_number
    FROM
        rental AS r
        JOIN inventory AS i ON i.film_id = r.inventory_id
        JOIN film AS f ON i.film_id = f.film_id
        JOIN film_category AS fc ON fc.film_id = i.film_id
        JOIN category AS c ON c.category_id = fc.category_id
    GROUP BY
        1,
        2
)
SELECT
    category, title, rent_count
FROM
    rental_counts
WHERE
    row_number = 1;
	

-- Calculate the total amount spent by the customer who rented the most movies.
-- Find the number of movies rented each month in the last year.
-- Calculate the total rental revenue for each actor's movies.
-- Find the least rented movies in each category and list them with their rental counts.
-- Identify the top 10 movies by rental revenue and list their total earnings.
-- Calculate the average rental duration for each customer and list the top 10 customers with the longest average rental durations.
-- Compute the total rental duration for each movie and identify the movies rented for the longest total duration.
-- Identify the most rented category in the last 6 months and list the total rentals for that category.
-- Find the staff members who generated the most revenue and list their total earnings.
-- Calculate each customer's total spending, rental count, and average spending.
-- Identify the top 10 movies with the longest average rental durations.
-- Compare the total rental revenue for movies rented in 2005 versus 2006.
-- Determine which cities have the most rentals and list the total rental counts for each city.
-- Calculate the average rental duration for each actor's movies.
-- Compute the total number of movies and total rental duration for each category.
-- Find movies rented at least 10 times and their total revenue.
-- Identify the top 10 movies with the longest rental durations.
-- Calculate each customer's total movie rentals and total spending in the last year.
-- Compute the total rental duration for each staff member.
-- List the top 5 actors by rental count and their total rentals.
-- Find all movies rented in the last year and compute their total revenue.
-- Identify the top 3 most rented movies in each category and list their rental counts.
-- Find the top 5 customers by total spending and list their total spending amounts.
-- Identify customers who rented the fewest movies and list their total rentals.
-- Calculate each staff member's average rental duration and total rentals.
-- Compute the total rental duration for each actor's movies.
-- Calculate the total number of movies and total rental duration for each category.
-- Identify movies rented at least 10 times and their average rental durations.
-- Identify the top 5 movies by total rental duration.
-- Calculate each customer's total spending and average spending in the last year.
-- Compute the total rental duration for each staff member.
-- Identify the top 5 most rented categories and list their total rentals.
-- Calculate the total rental counts and revenue for each actor's movies.
-- Find all movies rented in the last year and compute their average rental durations.
-- List the top 10 actors by total rental count.
-- Identify the least rented movies in each category and list their total rentals.
-- Identify the top 10 movies by total rental duration.
-- List customers who rented the fewest movies and their total spending.
-- Calculate each staff member's average rental duration and total rentals.
-- Calculate the average rental duration for each actor's movies.
-- Identify movies rented at least 10 times and their total revenue.
-- Identify the top 10 movies by total rental duration.
-- Find the top 5 customers by total spending in the last year.
-- Compute the total rental duration for each staff member.
-- Identify the top 5 most rented categories and their total revenue.
-- Determine which actors appear in the most movies and list their total rentals.
-- Find all movies rented in the last year and their total rental counts.
-- Identify the top 5 actors by rental count and their total rentals.
-- Identify the least rented movies in each category and list their total rentals.
-- Identify the top 10 movies by total rental duration.
-- List customers who rented the fewest movies and their total spending.
-- Calculate each staff member's average rental duration and total rentals.
-- Compute the total rental duration for each actor's movies.
-- Identify movies rented at least 10 times and their average rental durations.
-- Identify the top 5 movies by total rental duration.
-- Find the top customer by total rentals and calculate their total spending.
-- Compute the average rental duration for each staff member.
-- Identify the top 5 most rented categories and their total rentals.
-- Calculate the total rental counts and revenue for each actor's movies.
-- Find all movies rented in the last year and compute their average rental durations.
-- List the top 10 actors by total rental count.
-- Identify the least rented movies in each category and list their total rentals.
-- Identify the top 10 movies by total rental duration.
-- List customers who rented the fewest movies and their total spending.
-- Calculate each staff member's average rental duration and total rentals.
-- Calculate the average rental duration for each actor's movies.
-- Identify movies rented at least 10 times and their total revenue.
-- Identify the top 10 movies by total rental duration.
-- Find the top 5 customers by total spending in the last year.
-- Compute the total rental duration for each staff member.
-- Identify the top 5 most rented categories and their total revenue.
-- Determine which actors appear in the most movies and list their total rentals.
-- Find all movies rented in the last year and their total rental counts.
-- Identify the top 5 actors by rental count and their total rentals.
-- Identify the least rented movies in each category and list their total rentals.
-- Identify the top 10 movies by total rental duration.
-- List customers who rented the fewest movies and their total spending.
-- Calculate each staff member's average rental duration and total rentals.
-- Compute the total rental duration for each actor's movies.
-- Identify movies rented at least 10 times and their average rental durations.
-- Identify the top 5 movies by total rental duration.
-- Find the top customer by total rentals and calculate their total spending.
-- Compute the average rental duration for each staff member.
-- Identify the top 5 most rented categories and their total rentals.
-- Calculate the total rental counts and revenue for each actor's movies.
-- Find all movies rented in the last year and compute their average rental durations.
-- List the top 10 actors by total rental count.
-- Identify the least rented movies in each category and list their total rentals.
-- Identify the top 10 movies by total rental duration.
-- List customers who rented the fewest movies and their total spending.
-- Calculate each staff member's average rental duration and total rentals.
-- Calculate the average rental duration for each actor's movies.
-- Identify movies rented at least 10 times and their total revenue.
-- Identify the top 10 movies by total rental duration.
-- Find the top 5 customers by total spending in the last year.
-- Compute the total rental duration for each staff member.
-- Identify the top 5 most rented categories and their total revenue.
-- Determine which actors appear in the most movies and list their total rentals.
-- Find all movies rented in the last year and their total rental counts.
