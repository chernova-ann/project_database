-- Наполнение базы данных WILDBERRIES. 

USE wildberries_project;

SELECT * FROM products;

UPDATE products SET 
    price = (RAND()*30000),
    catalog_id = FLOOR(1 + RAND()*8),
    category_id = FLOOR(1 + RAND()*24),
    media_id = FLOOR(1 + RAND()*100),
    manufacture_id = FLOOR(1 + RAND()*80);
   
SELECT * FROM catalogs;

SELECT * FROM categories;

SELECT * FROM manufacturer LIMIT 20;

UPDATE manufacturer SET 
    logo_id = FLOOR(1 + RAND()*80);
   
SELECT * FROM admins;
   
SELECT * FROM storehouses;

UPDATE storehouses SET
   name = 'Москва, поселение Сосенское',
   address = 'Москва, поселение Сосенское, деревня Николо-Хованское, вл.1031'
  WHERE id = 1;

 UPDATE storehouses SET
   name = 'Подольск',
   address = '142103, г. Подольск, ул. Поливановская, д.9'
  WHERE id = 2;
 
UPDATE storehouses SET
   name = 'МО, д. Крёкшино',
   address = 'Москва, д.Крёкшино, Тупиковый проезд 1'
  WHERE id = 3;

UPDATE storehouses SET
   name = 'Подольск 2 (Коледино)',
   address = 'Подольский район, д. Коледино, ул. Троицкая, д. 20'
  WHERE id = 4;

UPDATE storehouses SET
   name = 'Домодедово',
   address = 'МО, Домодедово, ул. Логистическая, строение 9 А, административно-складской корпус 3'
  WHERE id = 5;
 
UPDATE storehouses SET
   name = 'Новосибирск',
   address = '630088, г. Новосибирск, ул. Петухова, д.71'
  WHERE id = 6;

UPDATE storehouses SET
   name = 'Санкт-Петербург',
   address = '188682, Ленинградская обл., Всеволожский р-н, г.п. Свердловское, д. Новосаратовка, участок № 1'
  WHERE id = 7;

UPDATE storehouses SET
   name = 'Хабаровск',
   address = '680045, г. Хабаровск, ул. Краснореченская, д.118, лит Т'
  WHERE id = 8;
 
UPDATE storehouses SET
   name = 'Екатеринбург',
   address = '620060, г. Екатеринбург, ул. Горнистов проезд, стр.1А'
  WHERE id = 9;
 
UPDATE storehouses SET
   name = 'Краснодар',
   address = '350912, г. Краснодар, ул. Почтовое отделение №27, 4'
  WHERE id = 10;

SELECT * FROM users;

UPDATE users SET birthday = DATE_ADD(birthday, INTERVAL -10 YEAR) WHERE YEAR(birthday) > 2004;

UPDATE users SET 
  city = ELT(FLOOR(1 + (RAND() * 12)),
    'Краснодар', 'Москва', 'Подольск', 'Мытищи', 'Жуковский', 
    'Санкт-Петербург', 'Минск', 'Новосибирск', 'Ереван', 'Бишкек', 'Алматы', 'Астана'),
  pass = CONCAT(char(65+rand()*26,65+rand()*26,65+rand()*26,65+rand()*26), FLOOR(1 + (RAND()*10000)));

UPDATE users SET   
   phone = CONCAT('+9', FLOOR(1000000000 + (RAND()*100000000000))) WHERE city = 'Бишкек';

UPDATE users SET   
   phone = CONCAT('+7', FLOOR(100000000 + (RAND()*10000000000))) 
     WHERE city = 'Краснодар' OR city ='Москва' OR city = 'Новосибирск' OR city = 'Алматы' OR city = 'Астана'
     OR city = 'Жуковский' OR city = 'Санкт-Петербург' OR city = 'Мытищи';

UPDATE users SET   
   phone = CONCAT('+3', FLOOR(100000000 + (RAND()*10000000000))) 
     WHERE city = 'Ереван' OR city ='Минск';

SELECT * FROM discounts;

ALTER TABLE discounts CHANGE COLUMN  started_et  started_at DATETIME;

UPDATE discounts SET finished_at = DATE_ADD(finished_at , INTERVAL 2 MONTH) WHERE started_at > finished_at;


UPDATE discounts SET
   order_id = FLOOR(1 + (RAND()*150)),
   product_id = FLOOR(1 + (RAND()*150)),
   discount = CONCAT(FLOOR(1 + (RAND()*80)));
  
SELECT * FROM messages;

UPDATE messages SET is_decided = 0 WHERE is_delivered = 0;

UPDATE messages SET
   from_user_id = FLOOR(1 + (RAND()*150)),
   to_admin_id = FLOOR(1 + (RAND()*10));
  
SELECT * FROM media_types;

INSERT INTO media_types (name) VALUES
   ('photo'), 
   ('video'), 
   ('logo');
 
SELECT * FROM media;

UPDATE media SET
   media_type_id = FLOOR(1 + (RAND()*3)),
   product_id = FLOOR(1 + (RAND()*150));

CREATE TEMPORARY TABLE exts (name VARCHAR(10));

INSERT INTO exts VALUES
   ('png'),
   ('avi'),
   ('jpeg'),
   ('mp4');
  
UPDATE media SET filename = CONCAT(
   'https://dropbox.com/wildb/',
   filename,
   FLOOR(10000 + RAND()*20000),
   '.',
   (SELECT name FROM exts ORDER BY RAND() LIMIT 1));
  
UPDATE media SET size_f = FLOOR(10000 + RAND()*1000000);


UPDATE media SET metadata = CONCAT('{"owner":"',
    (SELECT name FROM products WHERE id = product_id),
    '"}');
   
ALTER TABLE media MODIFY COLUMN metadata JSON;

SELECT * FROM order_statuses;

TRUNCATE order_statuses;

INSERT INTO order_statuses(name_status) VALUES
   ('Открыт'),  
   ('Резерв'),  
   ('Собран'), 
   ('У курьера'), 
   ('Готов к получению');

SELECT * FROM orders;

ALTER TABLE orders ADD COLUMN delivery_id INT UNSIGNED AFTER ship_name;

UPDATE orders SET 
   ship_name = ELT(FLOOR(1 + (RAND() * 2)), 'Доставка курьером', 'Самовывоз'),
   ship_country = ELT(FLOOR(1 + (RAND() * 5)), 'RUS', 'KAZ', 'KGZ', 'BLR', 'ARM');

UPDATE orders SET
   status_id = FLOOR(1 + (RAND()*5)),
   user_id = FLOOR(1 + (RAND()*150));

UPDATE orders SET
   delivery_id = FLOOR(1 + (RAND()*50)) WHERE ship_name = 'Самовывоз';

UPDATE orders SET   
   ship_city = ELT(FLOOR(1 + (RAND()*5)), 'Краснодар', 'Москва', 'Подольск', 'Мытищи', 'Жуковский', 
    'Санкт-Петербург', 'Новосибирск') WHERE ship_country = 'RUS';

UPDATE orders SET   
   ship_city = ELT(FLOOR(1 + (RAND()*2)), 'Алматы', 'Астана') WHERE ship_country = 'KAZ';

UPDATE orders SET ship_city = 'Ереван' WHERE ship_country = 'ARM';
UPDATE orders SET ship_city = 'Минск' WHERE ship_country = 'BLR';
UPDATE orders SET ship_city = 'Бишкек' WHERE ship_country = 'KGZ';


SELECT * FROM orders_products;

UPDATE orders_products SET update_at = NOW() WHERE created_at > update_at;

UPDATE orders_products SET
   order_id = FLOOR(1 + (RAND()*150)),
   product_id = FLOOR(1 + (RAND()*150)),
   total_quanity = FLOOR(1 + (RAND()*25)),
   total_price = FLOOR(100 + (RAND()*1000000));

SELECT * FROM delivery;

UPDATE delivery SET   
   phone = CONCAT('8', '(800)',  FLOOR(1000000 + (RAND()*1000000)));
  
SELECT * FROM favorites;

ALTER TABLE favorites CHANGE COLUMN requsted_at confirmed_at DATETIME DEFAULT CURRENT_TIMESTAMP();
ALTER TABLE favorites CHANGE COLUMN confirme_at canceled_at DATETIME DEFAULT CURRENT_TIMESTAMP();

UPDATE favorites SET
   user_id = FLOOR(1 + (RAND()*150)),
   product_id = FLOOR(1 + (RAND()*150));
  
UPDATE favorites SET
   canceled_at = NULL WHERE favor = 1;
  
UPDATE favorites SET confirmed_at = DATE_ADD(confirmed_at , INTERVAL -2 MONTH) WHERE confirmed_at > canceled_at;

SELECT * FROM storehouses_products;

UPDATE storehouses_products SET
   storehouse_id = FLOOR(1 + (RAND()*10)),
   product_id = FLOOR(1 + (RAND()*150)),
   value = FLOOR(1 + (RAND()*1000));

-- Внешние ключи.

SELECT * FROM media LIMIT 10;

ALTER TABLE products
  ADD CONSTRAINT products_catalog_id_fk 
    FOREIGN KEY (catalog_id) REFERENCES catalogs(id)
      ON DELETE RESTRICT,
  ADD CONSTRAINT products_category_id_fk
    FOREIGN KEY (category_id) REFERENCES categories(id)
      ON DELETE RESTRICT,
  ADD CONSTRAINT products_media_id_fk
    FOREIGN KEY (media_id) REFERENCES media(id)
      ON DELETE SET NULL,
  ADD CONSTRAINT products_manufacture_id_fk
    FOREIGN KEY (manufacture_id) REFERENCES manufacturer(id)
      ON DELETE SET NULL;
     
ALTER TABLE categories 
  ADD CONSTRAINT categories_catalog_id_fk 
    FOREIGN KEY (catalog_id) REFERENCES catalogs(id)
      ON DELETE RESTRICT;

ALTER TABLE manufacturer 
  ADD CONSTRAINT manufacturer_logo_id_fk 
    FOREIGN KEY (logo_id) REFERENCES media(id)
      ON DELETE SET NULL;

ALTER TABLE media 
  ADD CONSTRAINT media_media_type_id_fk 
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
      ON DELETE RESTRICT,
  ADD CONSTRAINT media_product_id_fk
    FOREIGN KEY (product_id) REFERENCES products(id)
      ON DELETE CASCADE;

ALTER TABLE favorites 
  ADD CONSTRAINT favorites_product_id_fk 
    FOREIGN KEY (product_id) REFERENCES products(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT favorites_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE;
     
ALTER TABLE orders 
  ADD CONSTRAINT orders_status_id_fk 
    FOREIGN KEY (status_id) REFERENCES order_statuses(id)
      ON DELETE RESTRICT,
  ADD CONSTRAINT orders_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE RESTRICT,
   ADD CONSTRAINT orders_delivery_id_fk 
    FOREIGN KEY (delivery_id) REFERENCES delivery(id)
      ON DELETE SET NULL;
     
   
ALTER TABLE storehouses_products 
  ADD CONSTRAINT storehouses_products_product_id_fk 
    FOREIGN KEY (product_id) REFERENCES products(id)
      ON DELETE SET NULL,
  ADD CONSTRAINT storehouses_products_storehouse_id_fk
    FOREIGN KEY (storehouse_id) REFERENCES storehouses(id)
      ON DELETE RESTRICT;


ALTER TABLE orders_products 
  ADD CONSTRAINT orders_products_product_id_fk 
    FOREIGN KEY (product_id) REFERENCES products(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT orders_products_order_id_fk
    FOREIGN KEY (order_id) REFERENCES orders(id)
      ON DELETE CASCADE;
     
ALTER TABLE discounts 
  ADD CONSTRAINT discounts_product_id_fk 
    FOREIGN KEY (product_id) REFERENCES products(id)
      ON DELETE SET NULL,
  ADD CONSTRAINT discounts_order_id_fk
    FOREIGN KEY (order_id) REFERENCES orders(id)
      ON DELETE SET NULL;

ALTER TABLE messages 
  ADD CONSTRAINT messages_from_user_id_fk 
    FOREIGN KEY (from_user_id) REFERENCES users(id)
      ON DELETE RESTRICT,
  ADD CONSTRAINT messages_to_admin_id_fk
    FOREIGN KEY (to_admin_id) REFERENCES admins(id)
      ON DELETE RESTRICT;

-- Индексы.

-- Отсортировать поиск по названию товара по возрастанию или убыванию цены.

SELECT * FROM products WHERE name = 'eum' ORDER BY price;

CREATE INDEX products_name_price_idx ON products(price, name); 


-- Товары поступившие в последнем месяце.

SELECT * FROM products WHERE EXTRACT(MONTH FROM created_at) = '01' AND EXTRACT(YEAR FROM created_at) = '2020';

CREATE INDEX products_created_at_idx ON media(created_at);
