
DROP DATABASE IF EXISTS Pruebas;
CREATE DATABASE Pruebas;
USE Pruebas;

DROP TABLE IF EXISTS `customer_courier`;
CREATE TABLE IF NOT EXISTS `customer_courier` (
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
INSERT INTO `customer_courier` VALUES ('Customer iOS',17071099,17071099,16293039,'f',59528555,'PICKING_UP',16293039,'2019-08-19 08:03:00'),
	('Courier iOS',17071099,16293039,17071099,'f',59528555,'ARRIVING',16293039,'2019-08-19 08:01:00'),
	('Customer iOS',17071099,17071099,16293039,'f',59528555,'PICKING_UP',16293039,'2019-08-19 08:00:00'),
	('Courier Android',12874122,18325287,12874122,'t',59528038,'ADDRESS_DELIVERY',18325287,'2019-08-19 07:59:00');

CREATE TABLE IF NOT EXISTS `orders` (
    `order_id` INT,
    `city_code` VARCHAR(3) CHARACTER SET utf8
);
INSERT INTO `orders` VALUES (59528555,'BCN'),
	(59528038,'MAD');

ALTER TABLE `pruebas`.`orders` 
CHANGE COLUMN `order_id` `order_id` INT NOT NULL ,
ADD PRIMARY KEY (`order_id`);
;

ALTER TABLE `pruebas`.`customer_courier` 
ADD INDEX `order_id_idx` (`order_id` ASC) VISIBLE;
;
ALTER TABLE `pruebas`.`customer_courier` 
ADD CONSTRAINT `order_id`
  FOREIGN KEY (`order_id`)
  REFERENCES `pruebas`.`orders` (`order_id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
