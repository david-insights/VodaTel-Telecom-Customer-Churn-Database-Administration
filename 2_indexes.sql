-- INDEXES.sql
-- Purpose: Performance optimization for customer analysis
-- Author: [Your Name]
-- Date: 2025
-- Index on region (used in Query 1: churn by region)

CREATE INDEX IF NOT EXISTS idx_customers_region
ON customers(region);

-- Index on churned (used in many queries for filtering)
CREATE INDEX IF NOT EXISTS idx_customers_churned
ON customers(churned);

-- Index on plan_type (used in Query 2)
CREATE INDEX IF NOT EXISTS idx_customers_plan_type
ON customers(plan_type);

-- Composite index for common filters: region + churned
CREATE INDEX IF NOT EXISTS idx_customers_region_churned
ON customers(region, churned);

-- Partial index: only active customers (not churned) – saves space
CREATE INDEX IF NOT EXISTS idx_customers_active
ON customers(registration_date)
WHERE churned = 'No';

-- Verify indexes (optional – run after creation)
-- SELECT indexname, indexdef FROM pg_indexes WHERE tablename = 'customers';