CREATE OR REPLACE PROCEDURE sp_archive_old_sales(
     p_cutoff_date DATE
)
LANGUAGE plpgsql
AS $$
DECLARE
	sales_cursor CURSOR FOR
		SELECT *
		FROM sales
		WHERE sale_date < p_cutoff_date;
	sales_record record;
BEGIN
	OPEN sales_cursor;

	LOOP
		FETCH NEXT FROM sales_cursor INTO sales_record;
		EXIT WHEN NOT FOUND;

		INSERT INTO salesarchive (sale_id, book_id, customer_id, quantity, sale_date)
			VALUES(sales_record.sale_id, sales_record.book_id, sales_record.customer_id, sales_record.quantity, sales_record.sale_date);
		DELETE FROM sales WHERE sale_id = sales_record.sale_id;
	END LOOP;

	CLOSE sales_cursor;
END;$$;

CALL sp_archive_old_sales('2022-06-23');