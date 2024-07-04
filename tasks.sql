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
    category,
    title,
    rent_count
FROM
    rental_counts
WHERE
    row_number = 1;

-- Calculate the total amount spent by the customer who rented the most movies.
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    x.total_amount
FROM
    (
        SELECT
            p.customer_id,
            COUNT(*),
            SUM(amount) AS total_amount
        FROM
            payment AS p
        GROUP BY
            p.customer_id
        ORDER BY
            COUNT(*) DESC
        LIMIT
            1
    ) AS x
    JOIN customer AS c ON c.customer_id = x.customer_id;

-- Find the number of movies rented each month in the last year (2005).
SELECT
    TO_CHAR(r.rental_date, 'YYYY-MM') AS rental_month,
    COUNT(*) AS rental_count
FROM
    rental AS r
    JOIN inventory AS i ON i.inventory_id = r.inventory_id
WHERE
    EXTRACT(
        YEAR
        FROM
            r.rental_date
    ) = 2006 - 1 -- This should use WITH CURRENT_DATE() but we ARE IN 2024
GROUP BY
    TO_CHAR(r.rental_date, 'YYYY-MM')
ORDER BY
    TO_CHAR(r.rental_date, 'YYYY-MM');

-- Calculate the total rental revenue for each actor's movies.
SELECT
    a.first_name,
    a.last_name,
    f.title AS film,
    SUM(p.amount)
FROM
    film_actor AS fa
    JOIN actor AS a ON a.actor_id = fa.actor_id
    JOIN film AS f ON f.film_id = fa.film_id
    JOIN inventory AS i ON i.film_id = f.film_id
    JOIN rental AS r ON r.inventory_id = i.inventory_id
    JOIN payment AS p ON r.rental_id = p.rental_id
GROUP BY
    1,
    2,
    3
ORDER BY
    1,
    2 -- Find the least rented movies in each category and list them with their rental counts.
    WITH least_rental_count AS (
        SELECT
            c.name AS category,
            f.title,
            COUNT(*) AS rental_count,
            ROW_NUMBER() OVER(
                PARTITION BY c.name
                ORDER BY
                    COUNT(r.rental_id) ASC
            ) AS row_number
        FROM
            rental AS r
            JOIN inventory AS i ON i.inventory_id = r.inventory_id
            JOIN film AS f ON f.film_id = i.film_id
            JOIN film_category AS fc ON fc.film_id = f.film_id
            JOIN category AS c ON c.category_id = fc.category_id
        GROUP BY
            c.name,
            f.title
    )
SELECT
    category,
    title,
    rental_count
FROM
    least_rental_count
WHERE
    row_number = 1;

-- Identify the top 10 movies by rental revenue and list their total earnings.
SELECT
    f.title,
    SUM(p.amount) AS total_amount
FROM
    film AS f
    JOIN inventory AS i ON i.film_id = f.film_id
    JOIN rental AS r ON r.inventory_id = i.inventory_id
    JOIN payment AS p ON p.rental_id = r.rental_id
GROUP BY
    f.title
ORDER BY
    2 DESC
LIMIT
    10;

-- Calculate the average rental duration for each customer and list the top 10 customers with the longest average rental durations.
SELECT
    c.first_name,
    c.last_name,
    AVG(r.return_date - r.rental_date) AS average_rental_duration
FROM
    rental AS r
    JOIN customer AS c ON c.customer_id = r.customer_id
GROUP BY
    c.first_name,
    c.last_name
ORDER BY
    average_rental_duration DESC
LIMIT
    10;

-- Compute the total rental duration for each movie and identify the movies rented for the longest total duration.
SELECT
    f.title,
    SUM(r.return_date - r.rental_date) AS total_rental_duration
FROM
    rental AS r
    JOIN inventory AS i ON i.inventory_id = r.inventory_id
    JOIN film AS f ON f.film_id = i.film_id
GROUP BY
    f.title
ORDER BY
    total_rental_duration DESC;

-- Identify the most rented category in the last 6 months and list the total rentals for that category.
SELECT
    c.name AS category,
    COUNT(*) AS rental_count
FROM
    rental AS r
    JOIN inventory AS i ON i.inventory_id = r.inventory_id
    JOIN film AS f ON f.film_id = i.film_id
    JOIN film_category AS fc ON fc.film_id = f.film_id
    JOIN category AS c ON c.category_id = fc.category_id
WHERE
    r.rental_date BETWEEN DATE '2006-01-01' - INTERVAL '6 month'
    AND DATE '2006-01-01' -- You should use NOW but we ARE IN 2024
GROUP BY
    c.name
ORDER BY
    COUNT(*) DESC
LIMIT
    1;

-- Find the staff members who generated the most revenue and list their total earnings.
SELECT
    s.first_name,
    s.last_name,
    SUM(p.amount) AS total_earnings
FROM
    staff AS s
    JOIN payment AS p ON p.staff_id = s.staff_id
GROUP BY
    s.first_name,
    s.last_name
ORDER BY
    total_earnings DESC
LIMIT
    1;

-- Calculate each customer's total spending, rental count, and average spending.
SELECT
    c.first_name,
    c.last_name,
    SUM(p.amount) AS total_spending,
    COUNT(p.payment_id) AS rental_count,
    AVG(p.amount) AS average_spending
FROM
    payment AS p
    JOIN customer AS c ON c.customer_id = p.customer_id
GROUP BY
    c.first_name,
    c.last_name;

-- Identify the top 10 movies with the longest average rental durations.
SELECT
    f.title,
    AVG(r.return_date - r.rental_date) AS average_rental_duration
FROM
    rental AS r
    JOIN inventory AS i ON r.inventory_id = i.inventory_id
    JOIN film AS f ON i.film_id = f.film_id
GROUP BY
    f.title
ORDER BY
    average_rental_duration DESC
LIMIT
    10;

-- Compare the total rental revenue for movies rented in 2005 versus 2006.
SELECT
    EXTRACT(
        YEAR
        FROM
            r.rental_date
    ) AS rental_year,
    SUM(p.amount) AS total_revenue
FROM
    rental AS r
    JOIN payment AS p ON r.rental_id = p.rental_id
WHERE
    EXTRACT(
        YEAR
        FROM
            r.rental_date
    ) IN (2005, 2006)
GROUP BY
    rental_year
ORDER BY
    rental_year;

-- Determine which cities have the most rentals and list the total rental counts for each city.
SELECT
    ci.city,
    COUNT(*) AS rental_count_per_city
FROM
    rental AS r
    JOIN customer AS c ON r.customer_id = c.customer_id
    JOIN address AS a ON c.address_id = a.address_id
    JOIN city AS ci ON a.city_id = ci.city_id
GROUP BY
    ci.city
ORDER BY
    rental_count_per_city DESC;

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