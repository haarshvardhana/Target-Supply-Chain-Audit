SELECT 
    p.`product category` AS Category,  -- Notice the backticks `` around the name
    COUNT(o.order_id) AS Total_Orders,
    AVG(DATE_DIFF(o.order_delivered_customer_date, o.order_purchase_timestamp, DAY)) AS Avg_Actual_Days,
    AVG(DATE_DIFF(o.order_estimated_delivery_date, o.order_purchase_timestamp, DAY)) AS Avg_Estimated_Days,
    AVG(DATE_DIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date, DAY)) AS Avg_Delay_Days,
    ROUND(
        COUNTIF(o.order_delivered_customer_date > o.order_estimated_delivery_date) / COUNT(o.order_id) * 100, 
        2
    ) AS Late_Delivery_Percentage
FROM `target-project-2026.Datasets.orders` o
JOIN `target-project-2026.Datasets.order_items` oi ON o.order_id = oi.order_id
JOIN `target-project-2026.Datasets.products` p ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
GROUP BY 1
HAVING Total_Orders > 50
ORDER BY Late_Delivery_Percentage DESC;