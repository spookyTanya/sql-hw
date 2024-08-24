CREATE OR REPLACE PROCEDURE sp_bulk_update_book_prices_by_genre(
	p_genre_id INTEGER,
	p_percentage_change NUMERIC(5, 2)
)
LANGUAGE plpgsql
AS $$
DECLARE
	row_count INTEGER;
BEGIN
	UPDATE books
	SET price = price + (price * p_percentage_change / 100)
	WHERE genre_id = p_genre_id;

	GET DIAGNOSTICS row_count = ROW_COUNT;
    RAISE NOTICE 'Number of rows updated: %', row_count;
	
	COMMIT;
END;$$;

-- CALL sp_bulk_update_book_prices_by_genre(5, 10);