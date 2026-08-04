/*
===============================================================================
Stored Procedure: Load Silver Layer
===============================================================================
Procedure Purpose:
    This stored procedure loads data into the Silver layer from the Bronze layer.

    Actions Performed:
    - Truncates Silver layer tables.
    - Cleans and transforms source data.
    - Removes duplicate records.
    - Standardizes values.
    - Handles missing or invalid data.
    - Loads transformed data into Silver tables.

Source:
    Bronze Layer

Target:
    Silver Layer

Author: Archit Goyal
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN
    BEGIN TRY

        DECLARE
            @Start_time DATETIME,
            @End_time DATETIME,
            @batch_start_time DATETIME,
            @batch_end_time DATETIME;

        SET @batch_start_time = GETDATE();

        PRINT '==============================================================';
        PRINT 'Loading Silver Layer';
        PRINT '==============================================================';

        PRINT '------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '------------------------------------------';

        ----------------------------------------------------------
        -- Load CRM Customer Information
        ----------------------------------------------------------

                SET @Start_time = GETDATE();
PRINT '==Truncate table into silver.crm_cust_info=='
TRUNCATE TABLE silver.crm_cust_info
PRINT '==Inserting  table into silver.crm_cust_info=='
INSERT INTO silver.crm_cust_info (
cst_id,
cst_key,
cst_firstname,
cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date
)
SELECT
    cst_id,
    cst_key,
    TRIM(cst_firstname) AS cst_firstname,
    TRIM(cst_lastname) AS cst_lastname,
    CASE
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        ELSE 'n/a'
    END AS cst_marital_status,
    CASE
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        ELSE 'n/a'
    END AS cst_gndr,
    cst_create_date
FROM
(SELECT *,
           ROW_NUMBER() OVER
           (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
) AS t
WHERE flag_last = 1;

        SET @End_time = GETDATE();

        PRINT 'Load Duration : '
            + CAST(DATEDIFF(SECOND,@Start_time,@End_time) AS NVARCHAR)
            + ' seconds';

        ----------------------------------------------------------
        -- Load CRM Product Info
        ----------------------------------------------------------

        SET @Start_time = GETDATE();

PRINT '==Truncate table into silver.crm_prd_info=='
TRUNCATE TABLE silver.crm_prd_info
PRINT '==Inserting  table into silver.crm_prd_info=='
INSERT INTO silver.crm_prd_info(
prd_id,
prd_key,
cat_id,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
)
select
prd_id,
SUBSTRING(prd_key,7,len(prd_key)) as prd_key,
REPLACE(SUBSTRING(prd_key,1,5),'-','_') as cat_id,
prd_nm,
ISNULL(prd_cost,0) as prd_cost,
CASE UPPER(TRIM(prd_line)) 
WHEN 'M' THEN 'Mountain'
WHEN 'R' THEN 'Road'
WHEN 'S' THEN 'Other Sales'
WHEN 'T' THEN 'Touring'
ELSE 'N/A'
END as prd_line,
prd_start_dt,
LEAD(prd_start_dt) OVER (PARTITION BY (prd_key) ORDER BY prd_start_dt)-1 as prd_end_dt
from bronze.crm_prd_info

  SET @End_time = GETDATE();

        PRINT 'Load Duration : '
            + CAST(DATEDIFF(SECOND,@Start_time,@End_time) AS NVARCHAR)
            + ' seconds';

        ----------------------------------------------------------
        -- Load CRM Sales Details
        ----------------------------------------------------------

        SET @Start_time = GETDATE();

PRINT '==Truncate table into silver.crm_sales_details=='
TRUNCATE TABLE silver.crm_sales_details
PRINT '==Inserting  table into silver.crm_sales_details=='
INSERT INTO silver.crm_sales_details(
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
)
SELECT 
sls_ord_num,
sls_prd_key,
sls_cust_id,
CASE WHEN sls_order_dt=0 OR LEN(sls_order_dt)!=8 THEN NULL
 ELSE CAST(CAST(sls_order_dt as VARCHAR)AS DATE)
 END AS sls_order_dt,
CASE WHEN sls_ship_dt=0 OR LEN(sls_ship_dt)!=8 THEN NULL
 ELSE CAST(CAST(sls_ship_dt as VARCHAR)AS DATE)
 END AS sls_ship_dt,
 CASE WHEN sls_due_dt=0 OR LEN(sls_due_dt)!=8 THEN NULL
 ELSE CAST(CAST(sls_due_dt as VARCHAR)AS DATE)
 END AS sls_due_dt,
 CASE WHEN sls_sales IS NULL OR sls_sales <= 0 
 THEN sls_quantity * abs(sls_price)
 ELSE sls_sales
 END AS sls_sales,
 sls_quantity,
 CASE WHEN sls_price IS NULL OR sls_price<=0
 THEN sls_sales / NULLIF(sls_quantity,0)
 ELSE sls_price
 END AS sls_price
 from bronze.crm_sales_details;

 SET @End_time = GETDATE();

        PRINT 'Load Duration : '
            + CAST(DATEDIFF(SECOND,@Start_time,@End_time) AS NVARCHAR)
            + ' seconds';

      ----------------------------------------------------------
        -- Load ERP Customer
        ----------------------------------------------------------

SET @Start_time = GETDATE();

PRINT '==Truncate table into silver.erp_cust_az12=='
TRUNCATE TABLE silver.erp_cust_az12
PRINT '==Inserting  table into silver.erp_cust_az12=='
INSERT INTO silver.erp_cust_az12(cid,bdate,gen)
SELECT 
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(CID,4,LEN(cid))
ELSE cid
END AS cid,
CASE WHEN bdate > GETDATE() THEN NULL
ELSE bdate
END AS bdate,
 CASE WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
  WHEN UPPER(TRIM(gen)) IN('F','FEMALE') THEN 'Female'
 ELSE 'N/A'
 END AS gen
FROM bronze.erp_cust_az12

 SET @End_time = GETDATE();

        PRINT 'Load Duration : '
            + CAST(DATEDIFF(SECOND,@Start_time,@End_time) AS NVARCHAR)
            + ' seconds';

 ----------------------------------------------------------
        -- Load ERP Location
        ----------------------------------------------------------

        SET @Start_time = GETDATE();

PRINT '==Truncate table into silver.erp_loc_a101=='
TRUNCATE TABLE silver.erp_loc_a101
PRINT '==Inserting  table into silver.erp_loc_a101=='
INSERT INTO silver.erp_loc_a101(cid,cntry)
SELECT 
REPLACE(cid,'-','') cid,
CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
     WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
	 WHEN TRIM(cntry) ='' OR cntry IS NULL THEN 'N/A'
	 ELSE TRIM(cntry)
	 END AS cntry
FROM bronze.erp_loc_a101

        SET @End_time = GETDATE();

        PRINT 'Load Duration : '
            + CAST(DATEDIFF(SECOND,@Start_time,@End_time) AS NVARCHAR)
            + ' seconds';

    ----------------------------------------------------------
        -- Load ERP Product Category
        ----------------------------------------------------------

     SET @Start_time = GETDATE();

PRINT '==Truncate table into silver.erp_px_cat_g1v2=='
TRUNCATE TABLE silver.erp_px_cat_g1v2
PRINT '==Inserting  table into silver.erp_px_cat_g1v2=='
INSERT INTO silver.erp_px_cat_g1v2(
id,
cat,
subcat,
maintenance)
SELECT 
id,
cat,
subcat,
maintenance
from bronze.erp_px_cat_g1v2

  SET @End_time = GETDATE();

        PRINT 'Load Duration : '
            + CAST(DATEDIFF(SECOND,@Start_time,@End_time) AS NVARCHAR)
            + ' seconds';

        ----------------------------------------------------------
        -- Batch Completed
        ----------------------------------------------------------
        
        SET @batch_end_time = GETDATE();

        PRINT '==============================================================';
        PRINT 'Silver Layer Loaded Successfully';
        PRINT '==============================================================';

        PRINT 'Total Load Duration: '
            + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '==============================================================';

    END TRY

    BEGIN CATCH

        PRINT '==============================================================';
        PRINT 'ERROR OCCURRED WHILE LOADING SILVER LAYER';
        PRINT '==============================================================';

        PRINT 'Error Number : '
            + CAST(ERROR_NUMBER() AS NVARCHAR);

        PRINT 'Error Message: '
            + ERROR_MESSAGE();

        PRINT 'Error Line   : '
            + CAST(ERROR_LINE() AS NVARCHAR);

        PRINT 'Error Procedure: '
            + ISNULL(ERROR_PROCEDURE(), 'N/A');

        PRINT '==============================================================';

        THROW;

    END CATCH
END;
GO

EXEC silver.load_silver;
GO
