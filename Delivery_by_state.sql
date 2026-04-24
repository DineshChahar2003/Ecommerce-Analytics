Create or replace view olist_raw.vw_delivery_by_state AS
Select 
  c.customer_state,
  COUNT(distinct o.order_id) as total_orders,
  ROUND(AVG(TIMESTAMP_DIFF(
    o.order_delivered_customer_date,
    o.order_purchase_timestamp, Day)),1) as avg_delivery_days,
  ROUND(AVG(r.review_score),2) as avg_review_score,
  COUNTIF(
    o.order_delivered_customer_date
    > o.order_estimated_delivery_date) as late_deliveries,
  ROUND(COUNTIF(
    o.order_delivered_customer_date
    > o.order_estimated_delivery_date
  )*100.0/COUNT(*), 1) as late_pct
  FROM olist_raw.orders o
  JOIN olist_raw.customers c
    ON o.customer_id = c.customer_id
  JOIN olist_raw.order_reviews r
    on o.order_id = r.order_id
  WHERE o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
  GROUP BY 1
  ORDER BY avg_delivery_days DESC;