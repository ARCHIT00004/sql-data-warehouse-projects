CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    BEGIN TRY

        DECLARE @Start_time DATETIME,
                @End_time DATETIME,
                @batch_start_time DATETIME,
                @batch_end_time DATETIME;

        SET @batch_start_time = GETDATE();

        PRINT '==============================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '==============================================================';

        PRINT '------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '------------------------------------------';

        ----------------------------------------------------------
        -- Load CRM Customer Info
        ----------------------------------------------------------

        SET @Start_time = GETDATE();

        PRINT '-> Truncating Table : bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '-> Inserting Data Into : bronze.crm_cust_info';

        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\91889\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @End_time = GETDATE();

        PRINT 'Load Duration : '
            + CAST(DATEDIFF(SECOND,@Start_time,@End_time) AS NVARCHAR)
            + ' seconds';

        ----------------------------------------------------------
        -- Load CRM Product Info
        ----------------------------------------------------------

        SET @Start_time = GETDATE();

        PRINT '-> Truncating Table : bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '-> Inserting Data Into : bronze.crm_prd_info';

        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\91889\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @End_time = GETDATE();

        PRINT 'Load Duration : '
            + CAST(DATEDIFF(SECOND,@Start_time,@End_time) AS NVARCHAR)
            + ' seconds';

        ----------------------------------------------------------
        -- Load CRM Sales Details
        ----------------------------------------------------------

        SET @Start_time = GETDATE();

        PRINT '-> Truncating Table : bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '-> Inserting Data Into : bronze.crm_sales_details';

        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\91889\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @End_time = GETDATE();

        PRINT 'Load Duration : '
            + CAST(DATEDIFF(SECOND,@Start_time,@End_time) AS NVARCHAR)
            + ' seconds';

        PRINT '------------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '------------------------------------------';

        ----------------------------------------------------------
        -- Load ERP Location
        ----------------------------------------------------------

        SET @Start_time = GETDATE();

        PRINT '-> Truncating Table : bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '-> Inserting Data Into : bronze.erp_loc_a101';

        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\91889\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @End_time = GETDATE();

        PRINT 'Load Duration : '
            + CAST(DATEDIFF(SECOND,@Start_time,@End_time) AS NVARCHAR)
            + ' seconds';

        ----------------------------------------------------------
        -- Load ERP Customer
        ----------------------------------------------------------

        SET @Start_time = GETDATE();

        PRINT '-> Truncating Table : bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '-> Inserting Data Into : bronze.erp_cust_az12';

        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\91889\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @End_time = GETDATE();

        PRINT 'Load Duration : '
            + CAST(DATEDIFF(SECOND,@Start_time,@End_time) AS NVARCHAR)
            + ' seconds';

        ----------------------------------------------------------
        -- Load ERP Product Category
        ----------------------------------------------------------

        SET @Start_time = GETDATE();

        PRINT '-> Truncating Table : bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '-> Inserting Data Into : bronze.erp_px_cat_g1v2';

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\91889\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @End_time = GETDATE();

        PRINT 'Load Duration : '
            + CAST(DATEDIFF(SECOND,@Start_time,@End_time) AS NVARCHAR)
            + ' seconds';

        ----------------------------------------------------------
        -- Batch Completed
        ----------------------------------------------------------

        SET @batch_end_time = GETDATE();

        PRINT '==============================================================';
        PRINT 'LAYER COMPLETED';
        PRINT '==============================================================';

        PRINT 'Total Load Duration : '
            + CAST(DATEDIFF(SECOND,@batch_start_time,@batch_end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '==============================================================';

    END TRY

    BEGIN CATCH

        PRINT '==============================================================';
        PRINT 'AN ERROR OCCURRED';
        PRINT 'Error Number : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error Message : ' + ERROR_MESSAGE();
        PRINT '==============================================================';

    END CATCH

END;
GO

EXEC bronze.load_bronze;
