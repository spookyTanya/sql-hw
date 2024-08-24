CREATE OR REPLACE PROCEDURE sp_update_customer_join_date()
LANGUAGE plpgsql
AS $$
BEGIN
	 WITH first_sales AS (
        SELECT customer_id, MIN(sale_date) AS first_sale_date
        FROM sales
        GROUP BY customer_id
    )
    
    UPDATE customers
    SET join_date = first_sales.first_sale_date
    FROM first_sales
    WHERE customers.customer_id = first_sales.customer_id
    AND customers.join_date > first_sales.first_sale_date;

    COMMIT;
END;$$;

-- CALL sp_update_customer_join_date()
