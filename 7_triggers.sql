-- TRIGGERS.sql
-- Purpose: Enforce data integrity automatically
-- Step 1: Create a function that updates the timestamp
CREATE OR REPLACE FUNCTION update_last_updated_column()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.last_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

-- Step 2: Create trigger on customers table
DROP TRIGGER IF EXISTS trigger_update_last_updated ON customers;

CREATE TRIGGER trigger_update_last_updated
BEFORE UPDATE ON customers
FOR EACH ROW
EXECUTE FUNCTION update_last_updated_column();

-- Optional: Trigger to log churn changes (audit trail)
CREATE TABLE churn_audit_log (
    audit_id SERIAL PRIMARY KEY,
    customer_id TEXT,
    old_churned TEXT,
    new_churned TEXT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by TEXT DEFAULT CURRENT_USER
);

CREATE OR REPLACE FUNCTION log_churn_changes()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF OLD.churned IS DISTINCT FROM NEW.churned THEN
        INSERT INTO churn_audit_log (customer_id, old_churned, new_churned)
        VALUES (NEW.customer_id, OLD.churned, NEW.churned);
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trigger_churn_audit
AFTER UPDATE OF churned ON customers
FOR EACH ROW
EXECUTE FUNCTION log_churn_changes();



-- Update a specific customer
UPDATE customers SET support_tickets = 5 WHERE customer_id = 'CUST0001';

-- Check last_updated column 
SELECT customer_id, support_tickets, last_updated FROM customers WHERE customer_id = 'CUST0001';

-- Check audit log
UPDATE customers SET churned = 'Yes' WHERE customer_id = 'CUST0001';

-- Now check audit log
SELECT * FROM churn_audit_log;


