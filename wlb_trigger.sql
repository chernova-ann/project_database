-- Тригер и процедура
USE wildberries_project;

-- 1.В таблице products есть два текстовых поля: name с названием товара и
-- description с его описанием. Допустимо присутствие обоих полей или одного из них.
-- Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены.
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.

DELIMITER //

CREATE TRIGGER validate_name_description_insert BEFORE INSERT ON products
FOR EACH ROW BEGIN
  IF NEW.name IS NULL AND NEW.description IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Both name and description are NULL';
  END IF;
END//

DELIMITER ;

INSERT INTO products
  (name, description, price, catalog_id, category_id)
VALUES
  (NULL, NULL, 9360.00, 2, 8);

INSERT INTO products
  (name, description, price, catalog_id, category_id)
VALUES
  ('pencil', 'red pencil', 50.00, 3, 9);

INSERT INTO products
  (name, description, price, catalog_id, category_id)
VALUES
  (NULL, 'red pencil', 50.00, 3, 9);
 

-- Процедура с курсором

DROP PROCEDURE IF EXISTS messages_analysis;
DELIMITER //
CREATE PROCEDURE messages_analysis()
BEGIN
  DECLARE done BOOLEAN DEFAULT FALSE;
  DECLARE message_id INT;
  DECLARE message_body TEXT;
  
  DECLARE reading_message CURSOR FOR SELECT id, body FROM messages;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN reading_message;

  read_loop: LOOP
    FETCH reading_message INTO message_id, message_body;
   
    IF done THEN
      LEAVE read_loop;
    END IF;
    
    SELECT CONCAT(
      "Message id ", 
      message_id, 
      IF(message_body LIKE '%forbidden%'," is wrong!", " is fine!")
      ) AS Result;
    
  END LOOP;

  CLOSE reading_message;
END//
DELIMITER ;

CALL messages_analysis;

  
