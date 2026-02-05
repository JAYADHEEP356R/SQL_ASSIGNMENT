CREATE DATABASE ecommerce;
GO

use ecommerce;
go


CREATE TABLE gold_member_users (
    userid VARCHAR(20),
    signup_date DATE
);


CREATE TABLE users (
    userid VARCHAR(20) ,
    signup_date DATE
);

CREATE TABLE sales (
    userid VARCHAR(20),
    created_date DATE,
    product_id INT 
);
CREATE TABLE product (
    product_id INT,
    product_name VARCHAR(50),
    price INT
);

INSERT INTO gold_member_users (userid, signup_date)
VALUES
('John', '2017-09-22'),
('Mary', '2017-04-21');

INSERT INTO users (userid, signup_date)
VALUES
('John', '2014-09-02'),
('Michel', '2015-01-15'),
('Mary', '2014-04-11');

INSERT INTO sales (userid, created_date, product_id)
VALUES
('John', '2017-04-19', 2),
('Mary', '2019-12-18', 1),
('Michel', '2020-07-20', 3),
('John', '2019-10-23', 2),
('John', '2018-03-19', 3),
('Mary', '2016-12-20', 2),
('John', '2016-11-09', 1),
('John', '2016-05-20', 3),
('Michel', '2017-09-24', 1),
('John', '2017-03-11', 2),
('John', '2016-03-11', 1),
('Mary', '2016-11-10', 1),
('Mary', '2017-12-07', 2);

INSERT INTO product (product_id, product_name, price)
VALUES
(1, 'Mobile', 980),
(2, 'Ipad', 870),
(3, 'Laptop', 330);


SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_CATALOG = 'ecommerce';


  SELECT 'gold_member_users' AS table_name, COUNT(*) AS total_records
FROM gold_member_users
UNION ALL
SELECT 'users', COUNT(*) FROM users
UNION ALL
SELECT 'sales', COUNT(*) FROM sales
UNION ALL
SELECT 'product', COUNT(*) FROM product;

SELECT 
    s.userid,
    SUM(p.price) AS total_amount_spent
FROM sales s
JOIN product p
    ON s.product_id = p.product_id
GROUP BY s.userid
ORDER BY s.userid;

SELECT DISTINCT
    created_date AS visit_date,
    userid AS customer_name
FROM sales
ORDER BY customer_name, visit_date;

SELECT
    u.userid,
    p.product_name,
    s.created_date AS first_purchase_date
FROM users u
JOIN sales s
    ON u.userid = s.userid
JOIN product p
    ON s.product_id = p.product_id
WHERE s.created_date = (
    SELECT MIN(s2.created_date)
    FROM sales s2
    WHERE s2.userid = u.userid
)
ORDER BY u.userid;


SELECT
    userid AS customer_name,
    COUNT(*) AS item_count
FROM sales
GROUP BY userid, product_id
HAVING COUNT(*) = (
    SELECT MAX(cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM sales s2
        WHERE s2.userid = sales.userid
        GROUP BY product_id
    ) t
)
ORDER BY customer_name;

SELECT u.userid
FROM users u
LEFT JOIN gold_member_users g
    ON u.userid = g.userid
WHERE g.userid IS NULL;


SELECT
    s.userid,
    SUM(p.price) AS amount_spent_as_gold_member
FROM sales s
JOIN gold_member_users g
    ON s.userid = g.userid
JOIN product p
    ON s.product_id = p.product_id
WHERE s.created_date >= g.signup_date
GROUP BY s.userid
ORDER BY s.userid;


SELECT userid
FROM users
WHERE userid LIKE 'M%';

SELECT DISTINCT userid
FROM users;


EXEC sp_rename 
    'product.price',
    'price_value',
    'COLUMN';
SELECT * FROM product;

UPDATE product
SET product_name = 'Iphone'
WHERE product_name = 'Ipad';

SELECT * FROM product;

EXEC sp_rename 
    'gold_member_users',
    'gold_membership_users';

SELECT * FROM gold_membership_users;


UPDATE gold_membership_users
SET Status = 'Yes';
SELECT * FROM gold_membership_users;


BEGIN TRANSACTION;

DELETE FROM users WHERE userid = 'John';
DELETE FROM users WHERE userid = 'Michel';

SELECT * FROM users;

ROLLBACK;

INSERT INTO product (product_id, product_name, price_value)
VALUES (3, 'Laptop', 330);
SELECT * FROM product;


SELECT 
    product_id,
    product_name,
    price_value,
    COUNT(*) AS duplicate_count
FROM product
GROUP BY product_id, product_name, price_value
HAVING COUNT(*) > 1;







-- ASSIGNMENT 2:

CREATE TABLE product_details (
    sell_date DATE,
    product VARCHAR(50)
);

INSERT INTO product_details (sell_date, product)
VALUES
('2020-05-30', 'Headphones'),
('2020-06-01', 'Pencil'),
('2020-06-02', 'Mask'),
('2020-05-30', 'Basketball'),
('2020-06-01', 'Book'),
('2020-06-02', ' Mask '),
('2020-05-30', 'T-Shirt');
select * from product_details;

SELECT
    sell_date,
    COUNT(*) AS num_sold,
    STRING_AGG(product, ', ') 
        WITHIN GROUP (ORDER BY product) AS product_list
FROM (
    SELECT DISTINCT
        sell_date,
        LTRIM(RTRIM(product)) AS product
    FROM product_details
) t
GROUP BY sell_date
ORDER BY sell_date;


--ASSIGNMENT 3

CREATE TABLE dept_tbl (
    id_deptname VARCHAR(20),
    emp_name VARCHAR(50),
    salary INT
);
INSERT INTO dept_tbl VALUES
('1111-MATH', 'RAHUL', 10000),
('1111-MATH', 'RAKESH', 20000),
('2222-SCIENCE', 'AKASH', 10000),
('222-SCIENCE', 'ANDREW', 10000),
('22-CHEM', 'ANKIT', 25000),
('3333-CHEM', 'SONIKA', 12000),
('4444-BIO', 'HITESH', 2300),
('44-BIO', 'AKSHAY', 10000);

SELECT * from dept_tbl;

SELECT
    UPPER(SUBSTRING(id_deptname, CHARINDEX('-', id_deptname) + 1, LEN(id_deptname))) AS dept_name,
    SUM(salary) AS total_salary
FROM dept_tbl
GROUP BY
    SUBSTRING(id_deptname, CHARINDEX('-', id_deptname) + 1, LEN(id_deptname))
ORDER BY dept_name;

--Assignment 4

CREATE TABLE email_signup (
    id INT,
    email_id VARCHAR(100),
    signup_date DATE
);
INSERT INTO email_signup VALUES
(1, 'Rajesh@Gmail.com', '2022-02-01'),
(2, 'Rakesh_gmail@rediffmail.com', '2023-01-22'),
(3, 'Hitest@Gmail.com', '2020-09-08'),
(4, 'Salil@Gmmail.com', '2019-07-05'),
(5, 'Himanshu@Yahoo.com', '2023-05-09'),
(6, 'Hitesh@Twitter.com', '2015-01-01'),
(7, 'Rakesh@facebook.com', NULL);

select * from email_signup;

UPDATE email_signup
SET signup_date = '1970-01-01'
WHERE signup_date IS NULL;

SELECT
    COUNT(*) AS count_gmail_account,
    MAX(signup_date) AS latest_signup_date,
    MIN(signup_date) AS first_signup_date,
    DATEDIFF(
        DAY,
        MIN(signup_date),
        MAX(signup_date)
    ) AS diff_in_days
FROM email_signup
WHERE LOWER(email_id) LIKE '%@gmail.com';

--ASSIGNMENT-5

CREATE TABLE sales_data (
    productid INT,
    sale_date DATE,
    quantity_sold INT
);
INSERT INTO sales_data VALUES
(1, '2022-01-01', 20),
(2, '2022-01-01', 15),
(1, '2022-01-02', 10),
(2, '2022-01-02', 25),
(1, '2022-01-03', 30),
(2, '2022-01-03', 18),
(1, '2022-01-04', 12),
(2, '2022-01-04', 22);

select * from sales_data;

SELECT *,
       RANK() OVER (PARTITION BY productid ORDER BY sale_date DESC) AS rnk
FROM sales_data;

SELECT
    productid,
    sale_date,
    quantity_sold,
    LAG(quantity_sold) OVER (
        PARTITION BY productid ORDER BY sale_date
    ) AS previous_quantity,
    quantity_sold - LAG(quantity_sold) OVER (
        PARTITION BY productid ORDER BY sale_date
    ) AS difference
FROM sales_data;


SELECT
    productid,
    FIRST_VALUE(quantity_sold) OVER (
        PARTITION BY productid ORDER BY sale_date
    ) AS first_quantity,
    LAST_VALUE(quantity_sold) OVER (
        PARTITION BY productid ORDER BY sale_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_quantity
FROM sales_data
GROUP BY productid, sale_date, quantity_sold;





