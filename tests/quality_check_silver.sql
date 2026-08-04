/*
===============================================================================
Quality Checks - Silver Layer
===============================================================================
Purpose:
    Validate the quality of data loaded into the Silver layer.

Checks Performed:
    1. Null Primary Keys
    2. Duplicate Records
    3. Invalid Date Values
    4. Negative Sales / Price / Quantity
    5. Missing Reference Data
===============================================================================
*/

--==============================================================
-- CRM CUSTOMER INFO
--==============================================================

PRINT 'Checking crm_cust_info...';

-- Null Customer IDs
SELECT *
FROM silver.crm_cust_info
WHERE cst_id IS NULL;

-- Duplicate Customer IDs
SELECT
    cst_id,
    COUNT(*) AS duplicate_count
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1;


--==============================================================
-- CRM PRODUCT INFO
--==============================================================

PRINT 'Checking crm_prd_info...';

-- Null Product IDs
SELECT *
FROM silver.crm_prd_info
WHERE prd_id IS NULL;

-- Negative Product Cost
SELECT *
FROM silver.crm_prd_info
WHERE prd_cost < 0;


--==============================================================
-- CRM SALES DETAILS
--==============================================================

PRINT 'Checking crm_sales_details...';

-- Invalid Sales
SELECT *
FROM silver.crm_sales_details
WHERE sls_sales <= 0;

-- Invalid Quantity
SELECT *
FROM silver.crm_sales_details
WHERE sls_quantity <= 0;

-- Invalid Price
SELECT *
FROM silver.crm_sales_details
WHERE sls_price <= 0;

-- Ship Date before Order Date
SELECT *
FROM silver.crm_sales_details
WHERE sls_ship_dt < sls_order_dt;

-- Due Date before Order Date
SELECT *
FROM silver.crm_sales_details
WHERE sls_due_dt < sls_order_dt;


--==============================================================
-- ERP CUSTOMER
--==============================================================

PRINT 'Checking erp_cust_az12...';

-- Invalid Birth Date
SELECT *
FROM silver.erp_cust_az12
WHERE bdate > GETDATE();

-- Invalid Gender
SELECT *
FROM silver.erp_cust_az12
WHERE gen NOT IN ('Male','Female','N/A');


--==============================================================
-- ERP LOCATION
--==============================================================

PRINT 'Checking erp_loc_a101...';

-- Missing Country
SELECT *
FROM silver.erp_loc_a101
WHERE cntry IS NULL;


--==============================================================
-- ERP PRODUCT CATEGORY
--==============================================================

PRINT 'Checking erp_px_cat_g1v2...';

-- Missing Category
SELECT *
FROM silver.erp_px_cat_g1v2
WHERE cat IS NULL;


PRINT '==============================================================';
PRINT 'Silver Layer Quality Checks Completed';
PRINT '==============================================================';
