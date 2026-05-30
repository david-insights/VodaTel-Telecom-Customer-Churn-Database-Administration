-- VodaTel Telecom Database Schema
-- Customer Management & Churn Analysis
CREATE TABLE customers (
    customer_id TEXT PRIMARY KEY,
    registration_date DATE NOT NULL,
    customer_name TEXT NOT NULL,
    region TEXT NOT NULL,
    plan_type TEXT CHECK (plan_type IN ('Basic','Standard','Premium')),
    monthly_charge INTEGER NOT NULL,
    contract_length_months INTEGER CHECK (contract_length_months IN (12,24,36)),
    data_usage_mb INTEGER,
    voice_minutes INTEGER,
    sms_count INTEGER,
    support_tickets INTEGER DEFAULT 0,
    avg_resolution_days DECIMAL(3,1) DEFAULT 0,
    satisfaction_score INTEGER CHECK (satisfaction_score BETWEEN 1 AND 5),
    churned TEXT CHECK (churned IN ('Yes','No')) DEFAULT 'No',
    churn_reason TEXT,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

copy customers(
    customer_id, registration_date, customer_name, region, plan_type,
    monthly_charge, contract_length_months, data_usage_mb, voice_minutes,
    sms_count, support_tickets, avg_resolution_days, satisfaction_score,
    churned, churn_reason
)
FROM 'C:\Program Files\PostgreSQL\18\data\telecom_data.csv'
DELIMITER ','
CSV HEADER;



-- QUERY 1: Churn Rate by Region
-- Calculates percentage of customers who have churned per region
SELECT 
    region,
    COUNT(*) as total_customers,
    SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) as churned_count,
    ROUND(SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as churn_rate_percent
FROM customers
GROUP BY region
ORDER BY churn_rate_percent DESC;
-- RESULT: Dodoma highest churn (29.09%), Mwanza lowest (12.50%)
-- INSIGHT: Dar es Salaam (25.76%) underperforms vs Mwanza
-- RECOMMENDATION: Investigate Dodoma network quality. Replicate Mwanza strategies.




-- QUERY 2: Churn by Plan Type
-- Shows which subscription plans lose the most customers
SELECT 
    plan_type,
    COUNT(*) as total_customers,
    SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) as churned_count,
    ROUND(SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as churn_rate_percent
FROM customers
GROUP BY plan_type
ORDER BY churn_rate_percent DESC;
-- RESULT: Standard plan highest churn (27.89%), Basic lowest (20.83%)
-- INSIGHT: Price doesn't guarantee loyalty – Standard plan underperforms
-- RECOMMENDATION: Review Standard plan pricing and features urgently




-- QUERY 3: Satisfaction Score Comparison
-- Shows if unhappy customers are leaving
SELECT 
    churned,
    ROUND(AVG(satisfaction_score), 2) as avg_satisfaction,
    COUNT(*) as customer_count
FROM customers
GROUP BY churned;
-- RESULT: Churned (2.92) vs Retained (2.95) – almost identical
-- INSIGHT: Satisfaction scores do NOT predict churn in this dataset
-- Both groups are dissatisfied (below 3). Action: Raise overall satisfaction.




-- QUERY 4: Top Churn Reasons
-- Shows why customers left the network
SELECT 
    churn_reason,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers WHERE churned = 'Yes'), 2) as percentage_of_churned
FROM customers
WHERE churned = 'Yes'
GROUP BY churn_reason
ORDER BY count DESC;
-- RESULT: Support (29.7%) is top churn reason, followed by Price (25.4%)
-- INSIGHT: Poor customer service drives more churn than network or price alone
-- RECOMMENDATION: Invest in support training and faster ticket resolution



-- QUERY 5: Average Support Tickets for Churned vs Retained
-- Shows if more complaints lead to leaving
SELECT 
    churned,
    ROUND(AVG(support_tickets), 2) as avg_support_tickets,
    ROUND(AVG(avg_resolution_days), 2) as avg_resolution_days
FROM customers
GROUP BY churned;
--	RESULT: Churned customers had slightly fewer tickets (2.40 vs 2.50)
--  INSIGHT: Ticket volume doesn't predict churn. Support quality matters more.
--  RECOMMENDATION: Measure customer effort and first-contact resolution.


-- QUERY 6: Churn Rate by Contract Length
-- Shows if longer contracts retain customers better
SELECT 
    contract_length_months,
    COUNT(*) as total_customers,
    SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) as churned_count,
    ROUND(SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as churn_rate_percent
FROM customers
GROUP BY contract_length_months
ORDER BY contract_length_months;
-- RESULT: 12‑month contracts highest churn (27.4%), 36‑month lowest (19.3%)
-- INSIGHT: Longer contracts improve retention by ~8 percentage points
-- RECOMMENDATION: Incentivize 36‑month contracts with discounts or device bundles



-- QUERY 7: Churn Rate by Registration Month (approximate trend)
SELECT 
    TO_CHAR(registration_date, 'YYYY-MM') as reg_month,
    COUNT(*) as registered,
    SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) as churned,
    ROUND(SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as churn_rate
FROM customers
GROUP BY reg_month
ORDER BY reg_month;
-- RESULT: January 2024 cohort worst (54.55% churn), multiple months at 0%
-- INSIGHT: Cohort quality varies widely; not seasonal
-- RECOMMENDATION: Investigate Jan 2024 acquisition sources and marketing







