CREATE TABLE IF NOT EXISTS `customer_courier_chat_messages_1` (
    `sender_app_type` VARCHAR(15) CHARACTER SET utf8,
    `customer_id` INT,
    `from_id` INT,
    `to_id` INT,
    `chat_started_by_message` VARCHAR(1) CHARACTER SET utf8,
    `order_id` INT,
    `order_stage` VARCHAR(16) CHARACTER SET utf8,
    `courier_id` INT,
    `message_sent_time` DATETIME
);
INSERT INTO `customer_courier_chat_messages_1` VALUES ('Customer iOS',17071099,17071099,16293039,'f',59528555,'PICKING_UP',16293039,'2019-08-19 08:03:00'),
	('Courier iOS',17071099,16293039,17071099,'f',59528555,'ARRIVING',16293039,'2019-08-19 08:01:00'),
	('Customer iOS',17071099,17071099,16293039,'f',59528555,'PICKING_UP',16293039,'2019-08-19 08:00:00'),
	('Courier Android',12874122,18325287,12874122,'t',59528038,'ADDRESS_DELIVERY',18325287,'2019-08-19 07:59:00');
