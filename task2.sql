WITH temp_name AS (
	SELECT author_id, title, published_date, genre_id
	FROM books
	WHERE title ~* '\ythe'
)
SELECT a.name, title, genre_name, published_date FROM authors a
INNER JOIN temp_name USING(author_id)
INNER JOIN genres USING(genre_id)