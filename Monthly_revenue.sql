CREATE OR REPLACE VIEW `olist_raw.vw_monthly_revenue` AS
SELECT
  DATE_TRUNC(o.order_purchase_timestamp, MONTH) AS order_month,
  COUNT(DISTINCT o.order_id)                    AS total_orders,
  ROUND(SUM(p.payment_value), 2)                AS total_revenue,
  ROUND(AVG(p.payment_value), 2)                AS avg_order_value
FROM `olist_raw.orders` o
JOIN `olist_raw.order_payments` p
  ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 1;