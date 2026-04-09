use portfolio;

select * from zepto_v2
where mrp <= 0;

SET SQL_SAFE_UPDATES = 0;
UPDATE zepto_v2 
SET 
    mrp = (SELECT 
            avg_mrp
        FROM
            (SELECT 
                AVG(mrp) AS avg_mrp
            FROM
                zepto_v2
            WHERE
                mrp > 0) AS t)
WHERE
    mrp <= 0;

SET SQL_SAFE_UPDATES = 1;

-- 1. order number by  category

SELECT 
    Category, COUNT(*) AS total_orders
FROM
    zepto_v2
GROUP BY Category
ORDER BY total_orders DESC;

-- 2. Average discount by category --
SELECT 
    category, AVG(discountPercent) AS avg_discount
FROM
    zepto_v2
GROUP BY Category
ORDER BY avg_discount;

-- 3. Most expensive products --
SELECT 
    Category, mrp
FROM
    zepto_v2
ORDER BY mrp DESC
LIMIT 10;

-- 4. Out of stock analysis --
SELECT 
    Category, COUNT(*) AS outOfStock_products
FROM
    zepto_v2
WHERE
    outOfStock = 'True'
GROUP BY Category
ORDER BY outOfStock_products DESC;

-- 5. Inventory analysis --
SELECT 
    Category, SUM(availableQuantity) AS total_stock
FROM
    zepto_v2
GROUP BY Category
ORDER BY total_stock DESC;

-- 6. Discount vs Selling price difference--
SELECT 
    name,
    Category,
    mrp,
    discountedSellingPrice,
    (mrp - discountedSellingPrice) AS discount_value
FROM
    zepto_v2
ORDER BY discount_value DESC;

-- 7. Revenue by product--
SELECT 
    Category,
    SUM(discountedSellingPrice * quantity) AS total_revenue
FROM
    zepto_v2
GROUP BY Category
ORDER BY total_revenue DESC;
	
-- 8. price range analysis--

SELECT 
    Category,
    CASE
        WHEN mrp < 10000 THEN 'Low Price'
        WHEN mrp BETWEEN 10000 AND 60000 THEN 'Medium price'
        ELSE 'High Price'
    END AS Price_range,
    COUNT(*) AS total_products
FROM
    zepto_v2
GROUP BY Category , Price_range;

-- 9. Top 3 Products per Category--
SELECT *
FROM (
    SELECT category, name, mrp,
           RANK() OVER (PARTITION BY category ORDER BY mrp DESC) AS rnk
    FROM zepto_v2
) ranked
WHERE rnk <= 3;
