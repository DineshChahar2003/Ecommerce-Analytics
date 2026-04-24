CREATE OR REPLACE VIEW `olist_raw.vw_category_revenue` AS
WITH clean_translation AS (
  SELECT 
    string_field_0 AS cat_pt, 
    string_field_1 AS cat_en 
  FROM `olist_raw.category_translation`
  WHERE string_field_0 != 'product_category_name'
)
SELECT
  COALESCE(t.cat_en, p.product_category_name, 'Unknown') AS category,
  COUNT(DISTINCT oi.order_id)                  AS total_orders,
  ROUND(SUM(oi.price), 2)                      AS total_revenue,
  ROUND(AVG(oi.price), 2)                      AS avg_item_price,
  COUNT(DISTINCT oi.product_id)                AS unique_products
FROM `olist_raw.order_items` oi
JOIN `olist_raw.orders` o
  ON oi.order_id = o.order_id
JOIN `olist_raw.products` p
  ON oi.product_id = p.product_id
LEFT JOIN clean_translation t
  ON p.product_category_name = t.cat_pt
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY total_revenue DESC
LIMIT 20;