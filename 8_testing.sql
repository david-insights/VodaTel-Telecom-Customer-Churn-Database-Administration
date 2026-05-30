-- Check indexes exist
SELECT indexname FROM pg_indexes WHERE tablename = 'customers';

-- Test view
SELECT * FROM v_churn_by_region LIMIT 5;

-- Test trigger (check last_updated)
UPDATE customers SET support_tickets = 3 WHERE customer_id = 'CUST0001';
SELECT customer_id, last_updated FROM customers WHERE customer_id = 'CUST0001';

-- Test audit log
SELECT * FROM churn_audit_log;

-- Test stored procedure
CALL generate_monthly_churn_report();
SELECT * FROM churn_snapshot_2026_05;


--Backup script 
SELECT run_backup();
SELECT * FROM backup_log;
