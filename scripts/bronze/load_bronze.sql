/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data to allow for a future refresh.
    - Uses the bulk 'INSERT` command to load data from csv Files to bronze tables.
===============================================================================
*/

-- SHOW VARIABLES LIKE 'secure_file_priv'; -- Use to check wgere SQL allows to draw data from
-- SHOW VARIABLES LIKE 'local_infile'; SET GLOBAL local_infile = 1; - If Load not allowed in a stored procedure, run 1st to check, if OFF - run second to turn ON

USE bronze;

DROP PROCEDURE IF EXISTS bronze.load_bronze;

DELIMITER $$
CREATE PROCEDURE bronze.load_bronze()
BEGIN

SET @total_load_start_time = NOW();

-- CRM Customer Data
SET @crm_cust_start = NOW();
TRUNCATE TABLE bronze.crm_cust_info;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sql-data-warehouse-project-main/datasets/source_crm/cust_info.csv'
IGNORE INTO TABLE bronze.crm_cust_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SET @crm_cust_end = NOW();

-- CRM Product Data
SET @crm_prd_start = NOW();
TRUNCATE TABLE bronze.crm_prd_info;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sql-data-warehouse-project-main/datasets/source_crm/prd_info.csv'
IGNORE INTO TABLE bronze.crm_prd_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
SET @crm_prd_end = NOW();

-- CRM Sales Data
SET @crm_sales_start = NOW();
TRUNCATE TABLE bronze.crm_sales_details;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sql-data-warehouse-project-main/datasets/source_crm/sales_details.csv'
IGNORE INTO TABLE bronze.crm_sales_details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
SET @crm_sales_end = NOW();

-- ERP Customer AZ12
SET @erp_cust_start = NOW();
TRUNCATE TABLE bronze.erp_cust_az12;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sql-data-warehouse-project-main/datasets/source_erp/cust_az12.csv'
IGNORE INTO TABLE bronze.erp_cust_az12
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
SET @erp_cust_end = NOW();

-- ERP Location A101
SET @erp_loc_start = NOW();
TRUNCATE TABLE bronze.erp_loc_a101;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sql-data-warehouse-project-main/datasets/source_erp/loc_a101.csv'
IGNORE INTO TABLE bronze.erp_loc_a101
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
SET @erp_loc_end = NOW();

-- ERP PX Category G1V2
SET @erp_px_start = NOW();
TRUNCATE TABLE bronze.erp_px_cat_g1v2;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sql-data-warehouse-project-main/datasets/source_erp/px_cat_g1v2.csv'
IGNORE INTO TABLE bronze.erp_px_cat_g1v2
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
SET @erp_px_end = NOW();

SET @total_load_end_time = NOW();

-- Performance Timings
SELECT '=== BRONZE LAYER PERFORMANCE TIMINGS ===' AS progress_message
UNION ALL
SELECT '=================================='
UNION ALL
SELECT CONCAT('CRM Customer Data: ', TIMESTAMPDIFF(SECOND, @crm_cust_start, @crm_cust_end), ' seconds')
UNION ALL
SELECT CONCAT('CRM Product Data: ', TIMESTAMPDIFF(SECOND, @crm_prd_start, @crm_prd_end), ' seconds')
UNION ALL
SELECT CONCAT('CRM Sales Data: ', TIMESTAMPDIFF(SECOND, @crm_sales_start, @crm_sales_end), ' seconds')
UNION ALL
SELECT CONCAT('ERP Customer AZ12: ', TIMESTAMPDIFF(SECOND, @erp_cust_start, @erp_cust_end), ' seconds')
UNION ALL
SELECT CONCAT('ERP Location A101: ', TIMESTAMPDIFF(SECOND, @erp_loc_start, @erp_loc_end), ' seconds')
UNION ALL
SELECT CONCAT('ERP PX Category G1V2: ', TIMESTAMPDIFF(SECOND, @erp_px_start, @erp_px_end), ' seconds')
UNION ALL
SELECT '=================================='
UNION ALL
SELECT CONCAT('🎉 TOTAL DURATION: ', TIMESTAMPDIFF(SECOND, @total_load_start_time, @total_load_end_time), ' seconds');

END $$
DELIMITER ;

CALL bronze.load_bronze;



