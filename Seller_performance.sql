Create or replace view olist_raw.vw_seller_performance AS
Select 
  s.seller_id,
  s.seller_city,
  s.seller_state,
  COUNT(Distinct oi.order_id) as total_orders,
  ROUND(SUM(oi.price),2) as total_revenue,
  ROUND(AVG(r.review_score),2) as avg_review_score,
  ROUND(AVG(TIMESTAMP_DIFF(
    o.order_delivered_customer_date,
    o.order_purchase_timestamp, DAY)),1) as avg_delivery_days
FROM olist_raw.sellers s
JOIN olist_raw.order_items oi on s.seller_id = oi.seller_id
JOIN olist_raw.orders o on oi.order_id = o.order_id
JOIN olist_raw.order_reviews r on o.order_id = r.order_id
WHERE o.order_status = 'delivered' 
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY 1,2,3
HAVING total_orders >= 10
ORDER BY total_revenue DESC;
