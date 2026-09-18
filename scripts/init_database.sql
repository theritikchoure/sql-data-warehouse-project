/*******************************************************************************
Script Name : init_database.sql
Purpose     : Sets up the DataWarehouse database foundation and establishes the
              three-layer Medallion Architecture schemas (Bronze, Silver, Gold).

--------------------------------------------------------------------------------
WARNINGS & PRECAUTIONS:
1. PERMISSIONS: Requires 'CREATE ANY DATABASE' or 'sysadmin' permissions on the
   SQL Server instance.
2. EXISTING DATABASE: If a database named 'DataWarehouse' already exists, this
   script will fail at the database creation step.
3. CONTEXT SWITCH: Ensure you execute this script in an environment that supports
   batch terminators ('GO'), such as SQL Server Management Studio (SSMS) or Azure
   Data Studio.
--------------------------------------------------------------------------------
*******************************************************************************/

-- Switch to master database to execute database creation
USE master;
GO

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO;

-- Create the primary analytical database
CREATE DATABASE DataWarehouse;
GO

-- Switch context to the newly created Data Warehouse database
USE DataWarehouse;
GO

-- =============================================================================
-- Schema Creation (Medallion Architecture)
-- =============================================================================

-- Bronze Schema: Stores raw, ingested data directly from source systems
CREATE SCHEMA bronze;
GO

-- Silver Schema: Stores cleaned, transformed, and validated data
CREATE SCHEMA silver;
GO

-- Gold Schema: Stores business-ready data, aggregated models, and data marts
CREATE SCHEMA gold;
GO
