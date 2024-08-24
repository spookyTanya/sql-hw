WITH temp_name AS (
	SELECT author_id, COUNT(book_id) AS book_count
	FROM books
	GROUP BY author_id
)
SELECT a.author_id, a.name, a.date_of_birth, temp_name.book_count FROM authors a
INNER JOIN temp_name USING (author_id)
WHERE temp_name.book_count > 3