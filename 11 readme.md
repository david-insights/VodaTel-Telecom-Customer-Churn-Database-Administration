VodaTel Telecom Customer Management & Churn Analysis

A complete PostgreSQL database project demonstrating DBA skills: schema design, performance tuning, automation, monitoring, backup, and disaster recovery.



Project Overview

This project simulates a telecom customer database with 500+ records, tracking subscriptions, usage, support tickets, satisfaction, and churn. It showcases production-ready database administration capabilities.




Tools Used

-PostgreSQL         core database engine  
-pgAdmin            management and query tool  
-Excel              synthetic data generation (CSV import)  



Test automation
CALL generate_monthly_churn_report();
SELECT * FROM v_churn_by_region;



Sample Insights (from analysis queries)
KPI	Finding
Region with highest churn	    Dodoma (29%)
Plan type with highest churn	Standard (28%)
Top churn reason	            Poor Support (30%)
Contract length impact	        36-month contracts churn 8% less than 12-month



DBA Skills Demonstrated
Schema design            -primary keys, foreign keys, CHECK constraints

Indexing                -single, composite, partial indexes for query speed

Views                   -abstract complex aggregations for business users

Stored procedures       -automate monthly reporting

Triggers                -maintain last_updated and audit trails

Monitoring              -detect bloat, unused indexes, long queries, cache ratio

Backup & Recovery        -pg_dump script, retention policy, documented DR plan



Author
David Lyatuu Data & Database Portfolio
email        thegreatdavidlyatuu@gmail.com
