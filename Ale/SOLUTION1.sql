select * from customer_courier;WITH ranked_messages AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY message_sent_time) AS RAN
    FROM customer_courier
),
conversation_starts AS (
SELECT 
        t1.order_id,
        MIN(CASE WHEN customer_id = from_id THEN message_sent_time END) AS first_customer_message,
        MIN(CASE WHEN courier_id = from_id THEN message_sent_time END) AS first_courier_message,
        MIN(message_sent_time) AS first_message_timestamp
    FROM ranked_messages as t1
    GROUP BY t1.order_id),
    
conversation_ends AS (
SELECT 
        t1.order_id,
        max(CASE WHEN customer_id = from_id THEN message_sent_time END) AS last_customer_message,
        max(CASE WHEN courier_id = from_id THEN message_sent_time END) AS last_courier_message,
        max(message_sent_time) AS last_message_timestamp
    FROM ranked_messages as t1
    GROUP BY t1.order_id),
    
conversation_counts AS (
    SELECT
        order_id,
        COUNT(CASE WHEN courier_id = from_id THEN 1 END) AS courier_message_count,
        COUNT(CASE WHEN customer_id = from_id THEN 1 END) AS customer_message_count
    FROM customer_courier
    GROUP BY order_id
),

status_delivery as (SELECT order_id,order_stage,message_sent_time from customer_courier)

SELECT
    cs.order_id,
    o.city_code,
    cs.first_courier_message,
    coalesce(cs.first_customer_message,"NONE") AS first_customer_message,
    cc.courier_message_count,
    cc.customer_message_count,
    CASE WHEN cs.first_courier_message < cs.first_customer_message THEN 'courier' ELSE 'customer' END AS first_sender,
    coalesce(TIMESTAMPDIFF(SECOND, cs.first_customer_message,cs.first_courier_message),"SIN RESPUESTA") AS tiempo,
    cs.first_message_timestamp,
	ce.last_message_timestamp,
    sd.order_stage
FROM conversation_starts cs
JOIN conversation_counts cc ON cs.order_id = cc.order_id
JOIN orders o ON cs.order_id = o.order_id
JOIN conversation_ends ce ON o.order_id = ce.order_id
LEFT JOIN status_delivery sd ON o.order_id = sd.order_id

where sd.message_sent_time = ce.last_message_timestamp;

