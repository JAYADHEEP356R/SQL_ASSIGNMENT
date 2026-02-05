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


