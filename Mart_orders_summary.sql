Create or replace table olist_raw.mart_orders_summary AS
WITH clean_translation AS (
  SELECT 
    string_field_0 AS cat_pt, 
    string_field_1 AS cat_en 
  FROM `olist_raw.category_translation`
  WHERE string_field_0 != 'product_category_name'
)
Select 
   o.order_id,
   o.order_status,
   Date(o.order_purchase_timestamp) as order_date,
   Date_trunc(o.order_purchase_timestamp, MONTH) as order_month,
   c.customer_city,
   c.customer_state,
   COALESCE(t.cat_en,p.product_category_name, 'Unknown') as category,
   s.seller_state,
   ROUND(oi.price, 2) as item_price,
   ROUND(pay.payment_value,2) as payment_value,
   pay.payment_type,
   r.review_score,
   TIMESTAMP_DIFF(
    o.order_delivered_customer_date,
    o.order_purchase_timestamp, DAY) as deliver_days,
  Case
    when o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Late' 
    ELSE 'On Time'
  END as delivery_status
FROM olist_raw.orders o
JOIN olist_raw.customers c on c.customer_id = o.customer_id
JOIN olist_raw.order_items oi on o.order_id = oi.order_id
JOIN olist_raw.products p on oi.product_id = p.product_id
JOIN olist_raw.sellers s on oi.seller_id = s.seller_id
JOIN olist_raw.order_payments pay on o.order_id = pay.order_id
LEFT JOIN olist_raw.order_reviews r on o.order_id = r.order_id
LEFT JOIN clean_translation t on t.cat_pt = p.product_category_name
WHERE o.order_status = 'delivered';