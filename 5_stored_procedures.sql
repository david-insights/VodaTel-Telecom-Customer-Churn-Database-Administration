-- STORED_PROCEDURES.sql
-- Purpose: Automate recurring tasks
-- Procedure: Generate monthly churn report
-- Creates a table with snapshot data for historical tracking
CREATE OR REPLACE PROCEDURE generate_monthly_churn_report()
LANGUAGE plpgsql
AS $$
DECLARE
    report_month DATE := DATE_TRUNC('month', CURRENT_DATE);
    table_name TEXT := 'churn_snapshot_' || TO_CHAR(report_month, 'YYYY_MM');
BEGIN
    -- Create a snapshot table for the current month
    EXECUTE format('
        CREATE TABLE IF NOT EXISTS %I AS
        SELECT 
            region,
            plan_type,
            contract_length_months,
            COUNT(*) AS total_customers,
            SUM(CASE WHEN churned = ''Yes'' THEN 1 ELSE 0 END) AS churned_count,
            CURRENT_TIMESTAMP AS snapshot_date
        FROM customers
        GROUP BY region, plan_type, contract_length_months', table_name);
    
    -- Log the procedure run
    INSERT INTO procedure_log (procedure_name, run_timestamp, notes)
    VALUES ('generate_monthly_churn_report', CURRENT_TIMESTAMP, 'Snapshot created: ' || table_name);
END;
$$;

-- Procedure: Update customer last_updated timestamp (can be used in triggers)
CREATE OR REPLACE PROCEDURE update_customer_timestamp(cust_id TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE customers
    SET last_updated = CURRENT_TIMESTAMP
    WHERE customer_id = cust_id;
END;
$$;

-- Create log table for procedure runs
CREATE TABLE IF NOT EXISTS procedure_log (
    log_id SERIAL PRIMARY KEY,
    procedure_name TEXT,
    run_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT
);



