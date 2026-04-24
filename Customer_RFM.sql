CREATE OR REPLACE VIEW `olist_raw.vw_customer_rfm` AS
WITH base AS (
  SELECT
    o.customer_id,
    DATE_DIFF(DATE '2018-10-01',
      MAX(DATE(o.order_purchase_timestamp)), DAY) AS recency_days,
    COUNT(DISTINCT o.order_id)                    AS frequency,
    ROUND(SUM(p.payment_value), 2)                AS monetary
  FROM `olist_raw.orders` o
  JOIN `olist_raw.order_payments` p
    ON o.order_id = p.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY 1
),
scored AS (
  SELECT *,
    NTILE(4) OVER (ORDER BY recency_days DESC) AS r_score,
    NTILE(4) OVER (ORDER BY frequency ASC)     AS f_score,
    NTILE(4) OVER (ORDER BY monetary ASC)      AS m_score
  FROM base
)
SELECT *,
  CASE
    WHEN r_score = 4 AND f_score >= 3 THEN 'Champion'
    WHEN r_score >= 3 AND f_score >= 2 THEN 'Loyal'
    WHEN r_score >= 3 AND f_score = 1  THEN 'Promising'
    WHEN r_score = 2                   THEN 'At Risk'
    WHEN r_score = 1                   THEN 'Lost'
    ELSE 'Others'
  END AS rfm_segment
FROM scored;