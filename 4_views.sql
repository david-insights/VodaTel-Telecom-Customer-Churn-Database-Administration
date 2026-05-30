-- VIEWS.sql
-- Purpose: Business-facing report views
-- View 1: Churn summary by region (reusable report)
CREATE OR REPLACE VIEW v_churn_by_region AS
SELECT 
    region,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) AS churned_count,
    ROUND(SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_percent
FROM customers
GROUP BY region
ORDER BY churn_rate_percent DESC;

-- View 2: Churn by plan type and contract length
CREATE OR REPLACE VIEW v_churn_by_plan_contract AS
SELECT 
    plan_type,
    contract_length_months,
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM customers
GROUP BY plan_type, contract_length_months
ORDER BY plan_type, contract_length_months;

-- View 3: Top churn reasons summary
CREATE OR REPLACE VIEW v_churn_reasons AS
SELECT 
    churn_reason,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers WHERE churned = 'Yes'), 2) AS percentage_of_churned
FROM customers
WHERE churned = 'Yes'
GROUP BY churn_reason
ORDER BY count DESC;
-- Grant SELECT to reporting role (example – adjust as needed)
-- GRANT SELECT ON v_churn_by_region TO reporting_user;



