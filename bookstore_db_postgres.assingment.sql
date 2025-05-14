CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255),
    price DECIMAL(10,2) CHECK (price >= 0),
    stock INT CHECK (stock >= 0),
    published_year INT  
);
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    joined_date DATE DEFAULT CURRENT_DATE 
);

CREATE TABLE orders(
	id SERIAL PRIMARY KEY,
	customer_id INT NOT NULL,
	book_id INT NOT NULL,
	quantity INT CHECK (quantity > 0),
	order_date DATE DEFAULT CURRENT_DATE,

	CONSTRAINT customerforeignkey FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    CONSTRAINT bookforeignkey FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);
                        
                        -- INSERT BOOKS INFORMATION IN THE TABLE
INSERT INTO books (title, author, price, stock, published_year) VALUES
('Marhaba JavaScript', 'Jhankar Mahbub', 630.00, 100, 2025),
('Clean Code', 'Robert C. Martin', 35.00, 5, 2008),
('Database Design Principles', 'Jane Smith', 20.00, 0, 2018);

                        -- INSERT CUSTOMERS INFORMATION IN THE TABLE
INSERT INTO customers (name, email, joined_date) VALUES
('emtiaz', 'emtiaz@gmail.com', '2025-03-24'),
('bob', 'bob@gmail.com', '2022-05-15'),
('charlie', 'charlie@gmail.com', '2023-06-20');

                        -- INSERT ORDER DATA IN THE TABLE 
INSERT INTO orders (customer_id, book_id, quantity, order_date) VALUES
(2, 1, 1, '2024-03-10'),
(1, 1, 1, '2024-02-20'),
(1, 3, 2, '2024-03-05');


                        -- TO SEE ALL THE TALBE 
SELECT * FROM orders;
SELECT * FROM books;
SELECT * FROM customers;


-- task-01
--  find the books that are out of stock
-- so basically if we got any zero from order then that will be out off stock

SELECT title
FROM books
WHERE stock=0;

-- task-02
-- find the most expensive book in the store .
-- just check the higest number in the price .

SELECT title,author,price,published_year
FROM books
WHERE price=(SELECT MAX(price)FROM books)


-- task-03
-- find the total number of order placed by each customer.
-- join the 'orders' table with the 'customer' table on the customer ID and group the result by customer name to count the total number of orders for each customer.

SELECT c.id,c.name AS customer_name,COUNT(o.id) AS  total_orders
FROM order o
JOIN customers c ON o.customer_id =c.id
GROUP BY  c.id,c.name;

-- Task-04
-- Calculate the total revenue generated from book sales.

SELECT SUM(subquery.total) AS total_revenue
FROM (
    SELECT b.price * o.quantity AS total
    FROM orders o
    JOIN books b ON o.book_id = b.id
) AS subquery;

-- Task-05
-- List all customers who have placed more than one order.

SELECT c.name,COUNT(o.id) as orders_count
FROM customers c
JOIN orders o ON c.id=o.customer_id
GROUP BY c.id
HAVING COUNT(o.id)>1;

-- Task-06
-- Find the average price of books in the store.

SELECT ROUND(AVG(price),2) as avg_book_price
FROM books

-- Task-07
-- Increase the price of all books published before 2000 by 10%.

UPDATE books
set price=price*1.10
WHERE published_year<2000;

SELECT * FROM books;

-- Task-08
--  Delete customers who haven't placed any orders.

DELETE FROM customers c
WHERE NOT EXISTS(
SELECT 1
FROM order o
WHERE  o.customer_id=c.id
);













