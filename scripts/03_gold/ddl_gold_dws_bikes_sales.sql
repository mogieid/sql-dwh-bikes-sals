/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/



-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================

IF OBJECT_ID('gold.dim_products','v') IS NOT NULL
DROP VIEW gold.dim_products;
GO
CREATE VIEW gold.dim_products AS (
SELECT 
		p.productid,
		p.typecode,
		p.prodcategoryid,
		p.createdby,
		p.createdat,
		p.changedby,
		p.changedat,
		p.supplier_partnerid,
		p.taxtariffcode,
		p.quantityunit,
		p.weightmeasure,
		p.weightunit,
		p.currency,
		p.price,
		p.width,
		p.depth,
		p.height,
		p.dimensionunit,
		p.productpicurl,
		pt.short_descr

FROM  silver.products p
LEFT JOIN silver.products_text pt
ON p.productid = pt.productid)

-- =============================================================================
-- Create Dimension: gold.dim_product_categories
-- =============================================================================

IF OBJECT_ID('gold.dim_product_categories','v') IS NOT NULL
DROP VIEW gold.dim_product_categories;
GO
CREATE VIEW gold.dim_product_categories AS(
SELECT 
		c.prodcategoryid,
		c.createdby,				
		c.createdat,
		ct.short_descr
FROM  silver.product_categories c
LEFT JOIN silver.product_categories_text ct
ON      c.prodcategoryid = ct.prodcategoryid
)


-- =============================================================================
-- Create Dimension: gold.fact_sales_order
-- =============================================================================

IF OBJECT_ID('gold.fact_sales_orders','v') IS NOT NULL
DROP VIEW gold.fact_sales_orders;
GO
CREATE VIEW gold.fact_sales_orders AS(
SELECT 

		soi.salesorderid,          
		soi.salesorderitem,			
		soi.productid,				
		soi.noteid,					
		soi.currency,			
		soi.grossamount,			
		soi.netamount,			
		soi.taxamount,				
		soi.itematpstatus,             
		soi.opitempos,				
		soi.quantity,				
		soi.quantityunit,				
		soi.deliverydate,	
		--so.salesorderid AS salesorderid2 ,               
		so.createdby,                  
		so.createdat,              
		so.changedby,               
		so.changedat,            
		so.fiscvariant,                
		so.fiscalyearperiod,       
		--so.noteid,                    
		so.partnerid,              
		so.salesorg,                  
		--so.currency,             
		--so.grossamount,            
		--so.netamount,                   
		--so.taxamount,                  
		so.lifecyclestatus,      
		so.billingstatus,           
		so.deliverystatus       

FROM  silver.sales_order_items soi
FULL OUTER JOIN silver.sales_orders so
ON      soi.salesorderid = so.salesorderid AND
        soi.noteid = so.noteid
WHERE soi.salesorderid IS NOT NULL
)


-- =============================================================================
-- Create Dimension: gold.dim_addresses
-- =============================================================================

IF OBJECT_ID('gold.dim_addresses','v') IS NOT NULL
DROP VIEW gold.dim_addresses;
GO
CREATE VIEW gold.dim_addresses AS(

SELECT 
		addressid,
		city,				
		postalcode,			
		street,						
		building,					
		country,						
		region,						
		addresstype,					
		validity_startdate,		
		validity_enddate,		
		latitude,					
		longitude		

FROM silver.addresses

)


-- =============================================================================
-- Create Dimension: gold.dim_business_partners
-- =============================================================================
IF OBJECT_ID('gold.dim_business_partners','v') IS NOT NULL
DROP VIEW gold.dim_business_partners;
GO
CREATE VIEW gold.dim_business_partners AS(

SELECT 
			partnerid,				
			partnerrole,				
			emailaddress,
			phonenumber,				
			faxnumber,				
			webaddress,				
			addressid,				
			companyname,					
			legalform,				
			createdby,				
			createdat,			
			changedby,				
			changedat,				
			currency
FROM silver.business_partners

)

-- =============================================================================
-- Create Dimension: gold.dim_employees
-- =============================================================================

IF OBJECT_ID('gold.dim_employees','v') IS NOT NULL
DROP VIEW gold.dim_employees;
GO
CREATE VIEW gold.dim_employees AS(

SELECT 
			employeeid,
			name_first,
			name_middle,	
			name_last,					
			name_initials,				
			sex,						
			language,				
			phonenumber	,			
			emailaddress,		
			loginname,				
			addressid,			
			validity_startdate,		
			validity_enddate  
FROM silver.employees

)
