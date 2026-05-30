Disaster Recovery Plan VodaTel Telecom Database

Objective
Ensure database availability and data integrity in case of hardware failure, data corruption, or natural disaster.

Recovery Time Objective (RTO)
- Target:                                       4 hours
- Maximum acceptable downtime:                  8 hours

Recovery Point Objective (RPO)
- Target:                                       15 minutes (transaction log backups)
- Maximum data loss:                            1 hour

Backup Strategy
Backup Type                 Frequency            Retention       Location    
Full database backup        Daily at 2 AM        30 days         Local + offsite
Transaction log (WAL)       Every 15 minutes     7 days          Local only 
Schema-only backup          Weekly               90 days         Offsite only

Recovery Procedures
Scenario 1: Accidental data deletion
1. Stop application access to database
2. Restore from most recent full backup
3. Apply transaction logs up to the point before deletion
4. Verify data integrity
5. Resume operations

Scenario 2: Hardware failure
1. Provision new database server
2. Restore latest full backup from offsite
3. Apply all transaction logs
4. Redirect application connection
5. Verify replication health

Scenario 3: Data corruption
1. Identify corrupted tables via monitoring queries
2. Restore only affected tables from point-in-time recovery
3. Run consistency checks
4. Document incident

Contact List
Role                Name                Phone               Email 
DBA Lead            David Lyatuu        0695-119187         thegreatdavidlyatuu@gmail.com
IT Manager              -                       -                   -

Last Test
-Full recovery test:                    [May_26_2026] Successful
-Next scheduled test:                   [September_2026]