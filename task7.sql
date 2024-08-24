CREATE OR REPLACE FUNCTION fn_get_top_n_books_by_genre(
	p_genre_id INT,
	p_top_n INT
)
RETURNS table (
	book_id int,
	title varchar,
	total_revenue numeric(10,2)
)
LANGUAGE plpgsql
AS $$
BEGIN
	return query
	WITH genre_sales AS (
		SELECT sales.book_id, books.title, quantity, price FROM sales
		INNER JOIN books USING(book_id)
		WHERE genre_id = p_genre_id
	)

	SELECT
		genre_sales.book_id,
		genre_sales.title,
		SUM(price * quantity) AS total_revenue
	FROM genre_sales 
	GROUP BY genre_sales.book_id, genre_sales.title
	ORDER BY total_revenue DESC
	limit p_top_n;

END;$$;

SELECT * FROM fn_get_top_n_books_by_genre(12, 5);