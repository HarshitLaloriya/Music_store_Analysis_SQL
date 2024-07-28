--> Analysis Part(03) : Level Advance

/* Q1: Determine the total amount that each customer has paid for artists. 
Write a query to return customer name, artist name and total spent ? */

WITH artist_sellings AS 
(
    SELECT art.artist_id, art.name, SUM(invl.quantity*invl.unit_price) AS total
    FROM invoice_line AS invl
    JOIN track AS trk ON trk.track_id = invl.track_id
	JOIN album AS alb ON alb.album_id = trk.album_id
	JOIN artist AS art ON art.artist_id = alb.artist_id
    GROUP BY art.artist_id
    ORDER BY total DESC
    LIMIT 1
)
SELECT cust.first_name || ' ' || cust.last_name AS customer_name,  asl.name AS artist_name, SUM(invl.quantity*invl.unit_price) AS spended
FROM customer AS cust 
JOIN invoice AS inv ON inv.customer_id = cust.customer_id
JOIN invoice_line AS invl ON invl.invoice_id = inv.invoice_id
JOIN track AS trk ON trk.track_id = invl.track_id
JOIN album AS alb ON alb.album_id = trk.album_id
JOIN artist_sellings AS asl ON asl.artist_id = alb.artist_id
GROUP BY cust.first_name, cust.last_name, asl.name
ORDER BY spended DESC; 


/* Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */


/* Method -> 1 
    ->USING simple CTE and Windows Function row_number() */


WITH popular_genre AS
(
    SELECT inv.customer_id, inv.billing_country, COUNT(invl.quantity) AS quantity, gnr.name, gnr.genre_id,
    ROW_NUMBER() OVER(PARTITION BY inv.billing_country ORDER BY COUNT(invl.quantity) DESC ) AS row_number
    FROM invoice AS inv
    JOIN invoice_line AS invl ON invl.invoice_id = inv.invoice_id
    JOIN track AS trk ON trk.track_id = invl.track_id
    JOIN genre AS gnr ON gnr.genre_id = trk.genre_id
    GROUP BY inv.billing_country, gnr.genre_id, inv.customer_id 
    ORDER BY inv.billing_country ASC,  COUNT(invl.quantity) DESC
)
SELECT  pg.billing_country AS country, pg.name AS top_genre, pg.quantity  AS Orders
FROM popular_genre AS pg WHERE row_number=1;


/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

/* Method -> 1 
    ->USING simple CTE and Windows Function row_number() */

WITH top_customer AS 
(
    SELECT cust.customer_id, cust.first_name || ' ' || cust.last_name AS Customer_name, inv.billing_country, SUM(inv.total) AS spent,
    ROW_NUMBER() OVER(PARTITION BY inv.billing_country ORDER BY SUM(inv.total) DESC)
    FROM customer AS cust 
    JOIN invoice AS inv ON inv.customer_id = cust.customer_id
    GROUP BY cust.customer_id, inv.billing_country
    ORDER BY billing_country ASC, spent DESC
)
SELECT customer_id,customer_name, billing_country, spent FROM top_customer
WHERE row_number = 1;
