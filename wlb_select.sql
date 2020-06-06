USE wildberries_project;

-- 1. Составьте список пользователей users, которые осуществили хотя бы оди заказ orders в интернет магазине.
     
SELECT u.id, u.login, COUNT(*) AS quantity 
   FROM users AS u 
   JOIN orders AS o 
    ON u.id = o.user_id 
    GROUP BY id;

 
-- 2. Предпочтения (избранные товары) из заданной категории.

SELECT p.name, f.user_id, f.favor, p.category_id 
   FROM products p
   LEFT JOIN favorites f
   ON p.id = f.product_id
   WHERE category_id = 3;
      
-- 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился 
-- и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, 
-- чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.

SELECT
  *
FROM
  storehouses_products
ORDER BY
  IF(value > 0, 0, 1),
  value;
-- 4. Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
-- Отсортируйте записи в порядке, заданном в списке IN.


SELECT * FROM catalogs WHERE id IN (5, 1, 2); 

SELECT*FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIELD(id, 5, 1, 2);

-- 5. Подсчитайте средний возраст пользователей в системе

SELECT*FROM users;

SELECT AVG(
    (YEAR(CURRENT_DATE) - YEAR(birthday)) -                             
    (DATE_FORMAT(CURRENT_DATE, '%m%d') < DATE_FORMAT(birthday, '%m%d')) 
  ) AS average_age
FROM users;

-- 6. Определить кто сделал больше заказов - мужчины или женщины?

SELECT
	(SELECT gender FROM users WHERE id = orders.user_id) AS gender,
	COUNT(*) AS total
    FROM orders
    GROUP BY gender
    ORDER BY total DESC
    LIMIT 1; 
  

-- 7. Оконные функции
-- Построить запрос, который будет выводить следующие столбцы:
-- имя категории name_category
-- количество товаров в данной категории products_in_category
-- количество заказов с продуктами из каждой категории category_in_orders
-- общее количество заказов в системе orders_total
-- отношение в процентах заказов по категории (количество заказов с продуктами из каждой категории / общее количество заказов в системе) * 100

SELECT DISTINCT 
 categories.name_category AS name_category,
 COUNT(products.id) OVER(PARTITION BY categories.id) AS products_in_category,
 COUNT(orders_products.order_id) OVER (PARTITION BY categories.id) AS category_in_orders,
 (SELECT COUNT(*) FROM orders) AS orders_total,
 COUNT(orders_products.order_id) OVER (PARTITION BY categories.id)/ (SELECT COUNT(*) FROM orders) * 100 AS '%%'
    FROM categories
      LEFT JOIN products
        ON products.category_id = categories.id
      LEFT JOIN orders_products
        ON products.id = orders_products.product_id
      LEFT JOIN orders
        ON orders.id = orders_products.order_id;
 
       
