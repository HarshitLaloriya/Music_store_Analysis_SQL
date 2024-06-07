--> Analysis Part(01) : Level Easy

/* Q1: Who is the senior most employee based on job title? */

SELECT employee_id, first_name || ' ' || last_name AS fullname, title
FROM EMPLOYEE
ORDER BY LEVELS DESC
LIMIT 1;

/* Q2: Which countries have the most Invoices? */
SELECT COUNT(*) AS number_of_invoices, billing_country
FROM INVOICE
GROUP BY billing_country
ORDER BY number_of_invoices DESC
LIMIT 1;

/* Q3: What are top 3 values of total invoice ? */
SELECT TOTAL
FROM INVOICE
ORDER BY TOTAL DESC
LIMIT 3;

/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */
SELECT BILLING_CITY, SUM(TOTAL) AS SUM_OF_TOTAL
FROM INVOICE
GROUP BY BILLING_CITY
ORDER BY SUM_OF_TOTAL DESC
LIMIT 1;

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

SELECT cus.customer_id, first_name, last_name, SUM(inv.total) as total_purchase
FROM CUSTOMER AS cus JOIN INVOICE as inv ON cus.customer_id = inv.customer_id
GROUP BY cus.customer_id
ORDER BY total_purchase DESC
LIMIT 1;


