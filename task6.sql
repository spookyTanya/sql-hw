CREATE OR REPLACE FUNCTION fn_avg_price_by_genre(
	 p_genre_id INT
)
RETURNS NUMERIC(10, 2)
LANGUAGE plpgsql
AS $$
DECLARE
	avg_price NUMERIC(10, 2);
BEGIN
	SELECT
		round(avg(price), 2)
	FROM books
	INTO avg_price
	WHERE genre_id = p_genre_id

	RETURN avg_price;
END;$$;

SELECT fn_avg_price_by_genre(2);