/*******************************************************************************
Script Name : proc_load_bronze.sql
Purpose     : Stored Procedure to truncate and bulk load all raw source files 
              (CRM and ERP CSVs) into the Bronze Schema tables.

Usage       : EXEC bronze.load_bronze;
Parameters  : None. This stored procedure does not accept any paramters or return any values.
*******************************************************************************/

USE DataWarehouse;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		
		PRINT '================================================';
		PRINT 'LOADING BRONZE LAYER';
		PRINT '================================================';
	
		-- =====================================================================
		-- CRM TABLES
		-- =====================================================================
		PRINT '------------------------------------------------';
		PRINT 'LOADING CRM TABLES';
		PRINT '------------------------------------------------';
		
		-- Table: bronze.crm_cust_info
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
	
		PRINT '>> Inserting data into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM '/var/opt/mssql/data/cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			FORMAT = 'CSV',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' ms';
		PRINT '------------------------------------------------';
		
		-- Table: bronze.crm_prd_info
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
	
		PRINT '>> Inserting data into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM '/var/opt/mssql/data/prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			FORMAT = 'CSV',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' ms';
		PRINT '------------------------------------------------';
	
		-- Table: bronze.crm_sales_details
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
	
		PRINT '>> Inserting data into: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM '/var/opt/mssql/data/sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			FORMAT = 'CSV',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' ms';
		PRINT '------------------------------------------------';
		
		-- =====================================================================
		-- ERP TABLES
		-- =====================================================================
		PRINT '------------------------------------------------';
		PRINT 'LOADING ERP TABLES';
		PRINT '------------------------------------------------';
	
		-- Table: bronze.erp_cust_az12
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
	
		PRINT '>> Inserting data into: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM '/var/opt/mssql/data/cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			FORMAT = 'CSV',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' ms';
		PRINT '------------------------------------------------';
		
		-- Table: bronze.erp_loc_a101
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
	
		PRINT '>> Inserting data into: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM '/var/opt/mssql/data/loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			FORMAT = 'CSV',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' ms';
		PRINT '------------------------------------------------';
	
		-- Table: bronze.erp_px_cat_g1v2
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
	
		PRINT '>> Inserting data into: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM '/var/opt/mssql/data/px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			FORMAT = 'CSV',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' ms';
		PRINT '------------------------------------------------';

		SET @batch_end_time = GETDATE();
		PRINT '================================================';
		PRINT 'BRONZE LAYER LOAD COMPLETED SUCCESSFULLY!';
		PRINT 'Total Execution Time: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '================================================';

	END TRY
	BEGIN CATCH
		PRINT '================================================';
		PRINT 'ERROR OCCURRED DURING BRONZE LAYER LOAD!';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Number : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State  : ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '================================================';
	END CATCH
END;
GO
