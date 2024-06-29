WITH ranked_messages AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY order_id, sender ORDER BY message_timestamp) AS rn
    FROM messages
),

conversation_starts AS (
    SELECT 
        order_id,
        city_code,
        MIN(CASE WHEN sender = 'courier' THEN message_timestamp END) AS first_courier_message,
        MIN(CASE WHEN sender = 'customer' THEN message_timestamp END) AS first_customer_message,
        MIN(message_timestamp) AS first_message_timestamp
    FROM ranked_messages
    WHERE rn = 1
    GROUP BY order_id, city_code
),

conversation_counts AS (
    SELECT
        order_id,
        COUNT(CASE WHEN sender = 'courier' THEN 1 END) AS courier_message_count,
        COUNT(CASE WHEN sender = 'customer' THEN 1 END) AS customer_message_count
    FROM messages
    GROUP BY order_id
),

conversation_ends AS (
    SELECT
        order_id,
        MAX(message_timestamp) AS last_message_timestamp,
        FIRST_VALUE(order_stage) OVER (PARTITION BY order_id ORDER BY message_timestamp DESC) AS last_message_order_stage
    FROM messages
    GROUP BY order_id
)

SELECT
    cs.order_id,
    cs.city_code,
    cs.first_courier_message,
    cs.first_customer_message,
    cc.courier_message_count,
    cc.customer_message_count,
    CASE WHEN cs.first_courier_message < cs.first_customer_message THEN 'courier' ELSE 'customer' END AS first_sender,
    cs.first_message_timestamp,
    COALESCE(
        TIMESTAMPDIFF(SECOND, cs.first_message_timestamp, 
                      LEAST(cs.first_courier_message, cs.first_customer_message)), 
        0
    ) AS time_to_first_response,
    ce.last_message_timestamp,
    ce.last_message_order_stage
FROM conversation_starts cs
JOIN conversation_counts cc ON cs.order_id = cc.order_id
JOIN conversation_ends ce ON cs.order_id = ce.order_id;
