/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'BikesSalesDW' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.
	
WARNING:
    Running this script will drop the entire 'BikesSalesDW' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'BikesSalesDW' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'BikesSalesDW')
BEGIN
    ALTER DATABASE BikesSalesDW SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE  BikesSalesDW ;
END;
GO

-- Create the 'BikesSalesDW' database
CREATE DATABASE BikesSalesDW;
GO

USE BikesSalesDW;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
