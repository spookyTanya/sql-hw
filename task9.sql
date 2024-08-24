CREATE OR REPLACE FUNCTION fn_adjust_book_price()
	RETURNS trigger
	LANGUAGE plpgsql
AS $$
DECLARE
	book_count INT;
BEGIN
	SELECT SUM(quantity)
	FROM sales
	INTO book_count
	WHERE book_id = new.book_id;

	IF book_count >= 10 THEN
		UPDATE books
		SET price = price + (price * 10 / 100)
		WHERE book_id = new.book_id;
	END IF;

	RETURN new;
END;$$;

CREATE TRIGGER tr_adjust_book_price
AFTER INSERT ON sales
FOR EACH ROW
EXECUTE FUNCTION fn_adjust_book_price();

INSERT INTO sales(book_id, customer_id, quantity, sale_date)
VALUES(31, 2, 3, '2024-08-23');