SELECT
	title,
	genre_id,
	price,
	rank () over (partition BY genre_id ORDER BY price DESC)
FROM books