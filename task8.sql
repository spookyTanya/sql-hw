CREATE TABLE CustomersLog (
 log_id SERIAL PRIMARY KEY,
 field_name VARCHAR(50),
 old_value TEXT,
 new_value TEXT,
 changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 changed_by VARCHAR(50) -- This assumes you can track the user making the change
);

CREATE OR REPLACE FUNCTION fn_log_sensitive_data_changes()
	RETURNS trigger
	LANGUAGE plpgsql
AS $$
BEGIN
	IF old.first_name <> new.first_name THEN
		insert into CustomersLog(field_name, old_value, new_value, changed_at, changed_by)
		values ('first_name', old.first_name, new.first_name, now(), (select current_user));
	END IF;
	IF old.last_name <> new.last_name THEN
		insert into CustomersLog(field_name, old_value, new_value, changed_at, changed_by)
		values ('last_name', old.last_name, new.last_name, now(), (select current_user));
	END IF;
	IF old.email <> new.email THEN
		insert into CustomersLog(field_name, old_value, new_value, changed_at, changed_by)
		values ('email', old.email, new.email, now(), (select current_user));
	END IF;

	return new;
END;$$;


CREATE TRIGGER tr_log_sensitive_data_changes
AFTER UPDATE ON customers
FOR EACH ROW EXECUTE FUNCTION fn_log_sensitive_data_changes();

UPDATE customers SET first_name = 'Tania', email = 'tanyabilanyuk@gmail.com' WHERE customer_id = 1