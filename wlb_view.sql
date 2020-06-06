USE wildberries_project;

-- 1.Представление, которое выводит название name товарной позиции из таблицы products и 
-- соответствующее название каталога name из таблицы catalogs.

CREATE OR REPLACE VIEW products_catalogs AS
SELECT
  p.name AS product,
  c.name_catalog AS name_catalog
FROM
  products AS p
JOIN
  catalogs AS c
ON
  p.catalog_id = c.id;
 
 desc categories;
 
-- 2. Предствление, которое выводит количество продуктов для каждого раздела каталога.
 CREATE OR REPLACE VIEW catalogs_quantity AS SELECT catalog_id, count(*) AS quantity FROM products  GROUP BY catalog_id;

SELECT * FROM catalogs_quantity;
 
-- 3. Представление, которое выводит состав заказов каждого пользователя (логи пользователя, id заказа, название товара).

 CREATE OR REPLACE VIEW history_orders AS 
   SELECT users.login AS user_name, orders_products.order_id AS number_order, products.name AS product_name
     FROM users
       LEFT JOIN orders ON users.id = orders.user_id 
       LEFT JOIN orders_products on orders.id = orders_products.order_id
       LEFT JOIN products on products.id = orders_products.product_id;
 
 SELECT * FROM history_orders;

-- Транзакция. Добавление товара в заказ. Вычитание соответствующего количества товара из запасов со склада.
SELECT value FROM storehouses_products sp WHERE product_id = 101 AND storehouse_id = 2; -- количество товара id = 101 на 2 складе
SELECT total_quanity FROM orders_products op WHERE order_id = 74 AND product_id = 101; -- количество товара id = 101 в заказе id = 74

START TRANSACTION;
SELECT total_quanity FROM orders_products op WHERE product_id = 101 AND order_id = 74;
UPDATE storehouses_products SET value = value - 1 WHERE product_id = 101 AND storehouse_id = 2;
UPDATE orders_products SET total_quanity = total_quanity + 1 WHERE product_id = 101 AND order_id = 74;

  
