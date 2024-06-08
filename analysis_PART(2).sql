--> Analysis Part(02) : Level Average

/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

/* Method -> 1
	->Easy and Understandable way */
SELECT DISTINCT customer.email, customer.first_name, customer.last_name, genre.name
FROM customer 
JOIN invoice ON customer.customer_id=invoice.customer_id
JOIN invoice_line ON invoice.invoice_id=invoice_line.invoice_id
JOIN track ON invoice_line.track_id=track.track_id
JOIN genre ON track.genre_id=genre.genre_id
WHERE genre.name='Rock' 
ORDER BY customer.email;

/* Method -> 2
	->Logic based(@_@) 
    ->same problem, different methodology  */
SELECT DISTINCT customer.email, customer.first_name, customer.last_name, 'Rock' AS genre
FROM customer
JOIN invoice ON customer.customer_id=invoice.customer_id
JOIN invoice_line ON invoice.invoice_id=invoice_line.invoice_id
WHERE track_id IN 
	(SELECT track_id FROM track JOIN genre ON track.genre_id=genre.genre_id WHERE genre.name='Rock')
ORDER BY customer.email;


/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */
SELECT artist.name, COUNT(*) AS number_of_tracks
FROM artist
JOIN album ON artist.artist_id=album.artist_id
JOIN track ON album.album_id=track.album_id
JOIN genre ON track.genre_id=genre.genre_id
WHERE genre.name='Rock'
GROUP BY artist.name
ORDER BY number_of_tracks DESC
LIMIT 10;


/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */
SELECT NAME,MILLISECONDS FROM TRACK
WHERE MILLISECONDS > (SELECT AVG(MILLISECONDS) AS average_ms FROM TRACK)
ORDER BY MILLISECONDS DESC;