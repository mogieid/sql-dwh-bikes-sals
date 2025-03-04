/*
===============================================================================
DDL Script: Create silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'silver' Tables
===============================================================================
*/


IF OBJECT_ID('silver.addresses', 'U') IS NOT NULL
    DROP TABLE silver.addresses;
GO
CREATE TABLE silver.addresses (

addressid					INT,
city						NVARCHAR(50),
postalcode					NVARCHAR(50),
street						NVARCHAR(50),
building					NVARCHAR(50),
country						NVARCHAR(50),
region						NVARCHAR(50),
addresstype					INT,
validity_startdate			DATE,
validity_enddate			DATE,
latitude					FLOAT,
longitude					FLOAT,
dwh_create_date    DATETIME2 DEFAULT GETDATE()
);

GO

IF OBJECT_ID('silver.business_partners', 'U') IS NOT NULL
    DROP TABLE silver.business_partners;
GO
CREATE TABLE silver.business_partners (

partnerid					NVARCHAR(100),
partnerrole					NVARCHAR(100),
emailaddress				NVARCHAR(100),
phonenumber					NVARCHAR(100),
faxnumber					NVARCHAR(100),
webaddress					NVARCHAR(100),
addressid					NVARCHAR(100),
companyname					NVARCHAR(100),
legalform					NVARCHAR(100),
createdby					NVARCHAR(100),
createdat					NVARCHAR(100),
changedby					NVARCHAR(100),
changedat					NVARCHAR(100),
currency					NVARCHAR(100),
dwh_create_date    DATETIME2 DEFAULT GETDATE()

);

GO

IF OBJECT_ID('silver.employees', 'U') IS NOT NULL
    DROP TABLE silver.employees;
GO
CREATE TABLE silver.employees (

employeeid					INT,
name_first					NVARCHAR(50),
name_middle					NVARCHAR(50),
name_last					NVARCHAR(50),
name_initials				NVARCHAR(50),
sex							NVARCHAR(50),
language					NVARCHAR(50),
phonenumber					NVARCHAR(50),
emailaddress				NVARCHAR(50),
loginname					NVARCHAR(50),
addressid					INT,
validity_startdate			DATE,
validity_enddate            DATE,
dwh_create_date    DATETIME2 DEFAULT GETDATE()

);

GO

IF OBJECT_ID('silver.product_categories', 'U') IS NOT NULL
    DROP TABLE silver.product_categories;
GO
CREATE TABLE silver.product_categories (

prodcategoryid				 NVARCHAR(50),
createdby					 INT,
createdat					 DATE,
dwh_create_date    DATETIME2 DEFAULT GETDATE()

);



IF OBJECT_ID('silver.product_categories_text', 'U') IS NOT NULL
    DROP TABLE silver.product_categories_text;
GO
CREATE TABLE silver.product_categories_text (

prodcategoryid				NVARCHAR(50),
language					NVARCHAR(50),
short_descr					NVARCHAR(50),
medium_descr				NVARCHAR(50),
long_descr                  NVARCHAR(50),
dwh_create_date    DATETIME2 DEFAULT GETDATE()

); 

GO

IF OBJECT_ID('silver.products', 'U') IS NOT NULL
    DROP TABLE silver.products;
GO
CREATE TABLE silver.products (

PRODUCTID                   NVARCHAR(50),
TYPECODE                    NVARCHAR(50),
PRODCATEGORYID              NVARCHAR(50),
CREATEDBY                   INT,
CREATEDAT                   DATE,
CHANGEDBY                   INT,
CHANGEDAT                   DATE,
SUPPLIER_PARTNERID			INT,
TAXTARIFFCODE				INT,
QUANTITYUNIT                NVARCHAR(50),
WEIGHTMEASURE               FLOAT,
WEIGHTUNIT                  NVARCHAR(50),
CURRENCY                    NVARCHAR(50),
PRICE						FLOAT,
WIDTH						FLOAT,
DEPTH						FLOAT,
HEIGHT						FLOAT,
DIMENSIONUNIT               NVARCHAR(50),
PRODUCTPICURL               NVARCHAR(50),
dwh_create_date    DATETIME2 DEFAULT GETDATE()

); 

GO

IF OBJECT_ID('silver.products_text', 'U') IS NOT NULL
    DROP TABLE silver.products_text;
GO
CREATE TABLE silver.products_text (

productid                   NVARCHAR(50),
language                    NVARCHAR(50),
short_descr                 NVARCHAR(50),
medium_descr                NVARCHAR(50),
long_descr					NVARCHAR(50),
dwh_create_date    DATETIME2 DEFAULT GETDATE()

); 

GO

IF OBJECT_ID('silver.sales_order_items', 'U') IS NOT NULL
    DROP TABLE silver.sales_order_items;
GO
CREATE TABLE silver.sales_order_items (

salesorderid                INT,
salesorderitem				INT,
productid					NVARCHAR(50),
noteid						NVARCHAR(50),
currency					NVARCHAR(50),
grossamount					INT,
netamount					FLOAT,
taxamount					FLOAT,
itematpstatus               NVARCHAR(50),
opitempos					NVARCHAR(50),
quantity					FLOAT,
quantityunit				NVARCHAR(50),
deliverydate				DATE,
dwh_create_date    DATETIME2 DEFAULT GETDATE()

); 

GO

IF OBJECT_ID('silver.sales_orders', 'U') IS NOT NULL
    DROP TABLE silver.sales_orders;
GO
CREATE TABLE silver.sales_orders (

salesorderid                NVARCHAR(100),
createdby                   NVARCHAR(100),
createdat                   NVARCHAR(100),
changedby                   NVARCHAR(100),
changedat                   NVARCHAR(100),
fiscvariant                 NVARCHAR(100),
fiscalyearperiod            NVARCHAR(100),
noteid                      NVARCHAR(100),
partnerid                   NVARCHAR(100),
salesorg                    NVARCHAR(100),
currency                    NVARCHAR(100),
grossamount                 NVARCHAR(100),
netamount                   NVARCHAR(100),
taxamount                   NVARCHAR(100),
lifecyclestatus             NVARCHAR(100),
billingstatus               NVARCHAR(100),
deliverystatus              NVARCHAR(100),
dwh_create_date    DATETIME2 DEFAULT GETDATE()


); 
