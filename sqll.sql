/*==========================================================
        E-COMMERCE SQL ANALYSIS PROJECT (TOP 30 QUERIES)
==========================================================*/

/* 1. Total Orders */
SELECT COUNT(*) AS total_orders FROM orders;

/* 2. Total Customers */
SELECT COUNT(*) AS total_customers FROM customers;

/* 3. Total Sellers */
SELECT COUNT(*) AS total_sellers FROM sellers;

/* 4. Total Products */
SELECT COUNT(*) AS total_products FROM products;

/* 5. Total Revenue */
SELECT ROUND(SUM(payment_value),2) AS total_revenue FROM payments;

/* 6. Average Order Value */
SELECT ROUND(AVG(payment_value),2) AS avg_order_value FROM payments;

/* 7. Order Status Distribution */
SELECT order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

/* 8. Orders by Weekday */
SELECT TO_CHAR(order_purchase_timestamp,'Day') AS weekday,
COUNT(*) AS total_orders
FROM orders
GROUP BY weekday
ORDER BY total_orders DESC;

/* 9. Monthly Orders */
SELECT DATE_TRUNC('month',order_purchase_timestamp) AS month,
COUNT(*) AS total_orders
FROM orders
GROUP BY DATE_TRUNC('month',order_purchase_timestamp)
ORDER BY DATE_TRUNC('month',order_purchase_timestamp);

/* 10. Customers by State */
SELECT customer_state, COUNT(*) AS customers
FROM customers
GROUP BY customer_state
ORDER BY customers DESC;

/* 11. Customers by City */
SELECT customer_city, COUNT(*) AS customers
FROM customers
GROUP BY customer_city
ORDER BY customers DESC
LIMIT 10;

/* 12. Payment Method Distribution */
SELECT payment_type, COUNT(*) AS transactions
FROM payments
GROUP BY payment_type
ORDER BY transactions DESC;

/* 13. Average Installments by Payment Type */
SELECT payment_type,
ROUND(AVG(payment_installments),2) AS avg_installments
FROM payments
GROUP BY payment_type;

/* 14. Top 10 Highest Payments */
SELECT order_id,payment_value
FROM payments
ORDER BY payment_value DESC
LIMIT 10;

/* 15. Product Categories by Sales */
SELECT p.product_category_name,
COUNT(*) AS products_sold
FROM order_items oi
JOIN products p ON oi.product_id=p.product_id
GROUP BY p.product_category_name
ORDER BY products_sold DESC
LIMIT 10;

/* 16. Revenue by Category */
SELECT p.product_category_name,
ROUND(SUM(oi.price),2) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id=p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10;

/* 17. Top Sellers by Revenue */
SELECT seller_id,
ROUND(SUM(price),2) AS revenue
FROM order_items
GROUP BY seller_id
ORDER BY revenue DESC
LIMIT 10;

/* 18. Average Review Score */
SELECT ROUND(AVG(review_score),2) AS avg_review_score
FROM reviews;

/* 19. Review Score Distribution */
SELECT review_score,
COUNT(*) AS reviews
FROM reviews
GROUP BY review_score
ORDER BY review_score;

/* 20. Average Delivery Days */
SELECT ROUND(
AVG(EXTRACT(EPOCH FROM
(order_delivered_customer_date-order_purchase_timestamp))/86400),2)
AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

/* 21. Revenue by State */
SELECT c.customer_state,
ROUND(SUM(p.payment_value),2) AS revenue
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN payments p ON o.order_id=p.order_id
GROUP BY c.customer_state
ORDER BY revenue DESC;

/* 22. Revenue by City */
SELECT c.customer_city,
ROUND(SUM(p.payment_value),2) AS revenue
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN payments p ON o.order_id=p.order_id
GROUP BY c.customer_city
ORDER BY revenue DESC
LIMIT 10;

/* 23. Monthly Revenue */
SELECT DATE_TRUNC('month',o.order_purchase_timestamp) AS month,
ROUND(SUM(p.payment_value),2) AS revenue
FROM orders o
JOIN payments p ON o.order_id=p.order_id
GROUP BY DATE_TRUNC('month',o.order_purchase_timestamp)
ORDER BY DATE_TRUNC('month',o.order_purchase_timestamp);

/* 24. Top Customers by Spending */
SELECT c.customer_unique_id,
ROUND(SUM(p.payment_value),2) AS spent
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN payments p ON o.order_id=p.order_id
GROUP BY c.customer_unique_id
ORDER BY spent DESC
LIMIT 10;

/* 25. Repeat Customers */
SELECT customer_unique_id,
COUNT(order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
GROUP BY customer_unique_id
HAVING COUNT(order_id)>1
ORDER BY total_orders DESC;

/* 26. Average Freight by State */
SELECT c.customer_state,
ROUND(AVG(oi.freight_value),2) AS avg_freight
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN order_items oi ON o.order_id=oi.order_id
GROUP BY c.customer_state
ORDER BY avg_freight DESC;

/* 27. Highest Rated Categories */
SELECT p.product_category_name,
ROUND(AVG(r.review_score),2) AS avg_rating
FROM reviews r
JOIN orders o ON r.order_id=o.order_id
JOIN order_items oi ON oi.order_id=o.order_id
JOIN products p ON oi.product_id=p.product_id
GROUP BY p.product_category_name
HAVING COUNT(*)>100
ORDER BY avg_rating DESC;

/* 28. Lowest Rated Categories */
SELECT p.product_category_name,
ROUND(AVG(r.review_score),2) AS avg_rating
FROM reviews r
JOIN orders o ON r.order_id=o.order_id
JOIN order_items oi ON oi.order_id=o.order_id
JOIN products p ON oi.product_id=p.product_id
GROUP BY p.product_category_name
HAVING COUNT(*)>100
ORDER BY avg_rating ASC;

/* 29. Top Products by Revenue */
SELECT product_id,
ROUND(SUM(price),2) AS revenue
FROM order_items
GROUP BY product_id
ORDER BY revenue DESC
LIMIT 10;

/* 30. Top Sellers by Orders */
SELECT seller_id,
COUNT(*) AS orders
FROM order_items
GROUP BY seller_id
ORDER BY orders DESC
LIMIT 10;

