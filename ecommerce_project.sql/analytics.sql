-- Top Selling Products
SELECT p.name, SUM(oi.quantity) AS total_sold
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.name
ORDER BY total_sold DESC;

-- Revenue by Category
SELECT c.category_name, SUM(oi.quantity * oi.price_at_purchase) AS revenue
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
JOIN Categories c ON p.category_id = c.category_id
GROUP BY c.category_name;

-- Customer Lifetime Value (CLV)
SELECT u.first_name, u.last_name, SUM(o.total_amount) AS total_spent
FROM Users u
LEFT JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id;

-- Revenue Growth
SELECT 
    YEAR(order_date) AS yr, 
    MONTH(order_date) AS mth,
    SUM(total_amount) AS monthly_revenue,
    LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date), MONTH(order_date)) AS prev_month_revenue,
    (SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date), MONTH(order_date))) / 
    LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date), MONTH(order_date)) * 100 AS growth_percentage
FROM Orders
GROUP BY yr, mth;

-- RFM (Recency)
SELECT 
    u.user_id,
    u.first_name,
    MAX(o.order_date) AS last_purchase_date,
    DATEDIFF(CURDATE(), MAX(o.order_date)) AS days_since_last_order,
    CASE 
        WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) < 30 THEN 'Active'
        WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) BETWEEN 30 AND 90 THEN 'Slipping'
        ELSE 'Churned'
    END AS customer_status
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id;

-- Inventory Analysis
SELECT 
    p.name,
    p.stock_quantity,
    COALESCE(SUM(oi.quantity), 0) AS total_sold,
    p.stock_quantity / NULLIF(SUM(oi.quantity), 0) AS stock_health_ratio
FROM Products p
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY p.product_id
ORDER BY stock_health_ratio ASC;

-- Pareto Analysis
WITH ProductRevenue AS (
    SELECT p.name, SUM(oi.quantity * oi.price_at_purchase) AS revenue
    FROM Products p
    JOIN Order_Items oi ON p.product_id = oi.product_id
    GROUP BY p.name
),
RunningTotal AS (
    SELECT name, revenue,
    SUM(revenue) OVER (ORDER BY revenue DESC) AS cumulative_revenue,
    SUM(revenue) OVER () AS total_revenue
    FROM ProductRevenue
)
SELECT name, revenue, (cumulative_revenue / total_revenue) * 100 AS pct_of_total
FROM RunningTotal
WHERE (cumulative_revenue / total_revenue) <= 0.80;