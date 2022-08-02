-- Implementing some views in our database.

-- View to display products that are available.
CREATE VIEW available_products AS 
SELECT product_name, description, selling_price
FROM product
WHERE stock > 0;

-- View to display the top customers in descending order (according to amount paid).
CREATE VIEW top_customers AS
SELECT customer_id, name, SUM(amount) AS total_purchases FROM
(customer_payment NATURAL JOIN orders NATURAL JOIN customer)
GROUP BY customer_id, name ORDER BY SUM(amount) DESC;


-- An example query using recursive CTEs.
WITH RECURSIVE subcategories AS (
       SELECT category.category_id, category.category_name, category.parent_id
       FROM category
       WHERE category.category_name = 'Recreation'
       UNION
       SELECT c.category_id, c.category_name, c.parent_id
       FROM category AS c
       INNER JOIN subcategories AS s ON s.category_id = c.parent_id
   ) SELECT product_name FROM subcategories 
   JOIN product_category ON subcategories.category_id = product_category.category_id
   JOIN product ON product_category.product_id = product.product_id;