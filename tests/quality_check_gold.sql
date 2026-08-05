/*
===============================================================================
Quality Checks: Gold Layer
===============================================================================

Script Purpose:
    This script validates the quality and integrity of the Gold Layer views.

    The following validations are performed:

        1. Duplicate Customer Keys
        2. Duplicate Product Keys
        3. NULL Customer Keys
        4. NULL Product Keys
        5. Foreign Key Integrity - Customers
        6. Foreign Key Integrity - Products
        7. Sales Amount Validation

Usage:
    Execute this script after creating all Gold Layer views.

Expected Result:
    All queries should return zero rows.
    If any query returns records, those records should be investigated
    before using the data for reporting and analytics.

===============================================================================
*/

-- =============================================================================
-- Check 1: Duplicate Customer Keys
-- =============================================================================
SELECT
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;


-- =============================================================================
-- Check 2: Duplicate Product Keys
-- =============================================================================
SELECT
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;


-- =============================================================================
-- Check 3: NULL Customer Keys in Fact View
-- =============================================================================
SELECT *
FROM gold.fact_sales
WHERE customer_key IS NULL;


-- =============================================================================
-- Check 4: NULL Product Keys in Fact View
-- =============================================================================
SELECT *
FROM gold.fact_sales
WHERE product_key IS NULL;


-- =============================================================================
-- Check 5: Foreign Key Integrity - Customers
-- =============================================================================
SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
WHERE c.customer_key IS NULL;


-- =============================================================================
-- Check 6: Foreign Key Integrity - Products
-- =============================================================================
SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
WHERE p.product_key IS NULL;


-- =============================================================================
-- Check 7: Validate Sales Amount
-- Sales Amount = Quantity × Price
-- =============================================================================
SELECT *
FROM gold.fact_sales
WHERE sales_amount <> quantity * price;


/*
===============================================================================
End of Gold Layer Quality Checks
===============================================================================

Expected Output:
    ✓ No duplicate customer keys
    ✓ No duplicate product keys
    ✓ No NULL foreign keys
    ✓ No orphan customer records
    ✓ No orphan product records
    ✓ Sales amount correctly calculated

===============================================================================
*/
