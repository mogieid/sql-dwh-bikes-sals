/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '------------------------------------------------';

		-- Loading silver.addresses
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.addresses';
		TRUNCATE TABLE silver.addresses;
		PRINT '>> Inserting Data Into: silver.addresses';
		INSERT INTO silver.addresses (
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
		)
		SELECT 
			addressid,
			city,
			postalcode,
			TRIM(street) AS street,
			building,
			country,
			TRIM(region) AS region ,
			addresstype,	
			CAST(CAST(validity_startdate AS VARCHAR) AS DATE) AS validity_startdate,
			CAST(CAST(validity_enddate AS VARCHAR) AS DATE) AS validity_enddate,
			latitude,			
			longitude

		FROM bronze.addresses
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';


				-- Loading silver.business_partners
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.business_partners';
		TRUNCATE TABLE silver.business_partners;
		PRINT '>> Inserting Data Into: silver.business_partners';
		INSERT INTO silver.business_partners (
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
			currency)
			SELECT 
			partnerid,				
			partnerrole,				
			emailaddress,
			CAST(phonenumber AS FLOAT) AS phonenumber,				
			faxnumber,				
			webaddress,				
			CAST(addressid AS FLOAT) AS addressid,				
			companyname,					
			legalform,				
			createdby,				
			CAST(CAST(createdat AS VARCHAR) AS DATE) AS createdat,			
			changedby,				
			CAST(CAST(changedat AS VARCHAR) AS DATE) AS changedat,				
			currency		
		FROM bronze.business_partners

		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		-- Loading silver.employees
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.employees';
		TRUNCATE TABLE silver.employees;
		PRINT '>> Inserting Data Into: silver.employees';
		INSERT INTO silver.employees (
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
		  )

		SELECT
			employeeid,
			name_first,
			name_middle,	
			name_last,					
			name_initials,				
			CASE
				WHEN sex = 'F' THEN 'FEMALE'
				WHEN sex = 'M' THEN 'MALE'
				ELSE 'n/a'
			END AS sex,					
			language,				
			REPLACE(phonenumber,' ','-') phonenumber,			
			emailaddress,		
			loginname,				
			addressid,			
			CAST(validity_startdate AS DATE) AS validity_startdate,		
			CAST(validity_enddate AS DATE) AS validity_enddate       
		FROM bronze.employees 

		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		-- silver.product_categories
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.product_categories';
		TRUNCATE TABLE silver.product_categories;
		PRINT '>> Inserting Data Into: silver.product_categories';
		INSERT INTO silver.product_categories (
		prodcategoryid,
		createdby,				
		createdat
		  )
		SELECT
		prodcategoryid,
		createdby,				
		CAST(createdat AS DATE)
		FROM bronze.product_categories
		
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';


				-- silver.product_categories_text
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.product_categories_text';
		TRUNCATE TABLE silver.product_categories_text;
		PRINT '>> Inserting Data Into: silver.product_categories_text';
		INSERT INTO silver.product_categories_text (
		prodcategoryid,
		language,
		short_descr,
		medium_descr,
		long_descr 
		  )
		SELECT
		prodcategoryid,
		language,
		short_descr,
		medium_descr,
		long_descr 
		FROM bronze.product_categories_text


		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';


						-- silver.products
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.products';
		TRUNCATE TABLE silver.products;
		PRINT '>> Inserting Data Into: silver.products';
		INSERT INTO silver.products (
		PRODUCTID,
		TYPECODE,
		PRODCATEGORYID,
		CREATEDBY,
		CREATEDAT,
		CHANGEDBY,
		CHANGEDAT,
		SUPPLIER_PARTNERID,
		TAXTARIFFCODE,
		QUANTITYUNIT,
		WEIGHTMEASURE,
		WEIGHTUNIT,
		CURRENCY,
		PRICE,
		WIDTH,
		DEPTH,
		HEIGHT	,
		DIMENSIONUNIT,
		PRODUCTPICURL    
		)
		SELECT 
		PRODUCTID,
		TYPECODE,
		PRODCATEGORYID,
		CREATEDBY,
		CREATEDAT,
		CHANGEDBY,
		CHANGEDAT,
		SUPPLIER_PARTNERID,
		TAXTARIFFCODE,
		QUANTITYUNIT,
		WEIGHTMEASURE,
		WEIGHTUNIT,
		CURRENCY,
		PRICE,
		WIDTH,
		DEPTH,
		HEIGHT,
		DIMENSIONUNIT,
		PRODUCTPICURL    
		FROM bronze.products


		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';


						-- silver.products_text
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.products_text';
		TRUNCATE TABLE silver.products_text;
		PRINT '>> Inserting Data Into: silver.products_text';
		INSERT INTO silver.products_text (
		productid,                  
		language,            
		short_descr,         
		medium_descr,          
		long_descr				
		  )
		SELECT
		productid,                  
		language,            
		short_descr,         
		medium_descr,          
		long_descr	
		FROM bronze.products_text


		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';


						-- silver.sales_order_items
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.sales_order_items';
		TRUNCATE TABLE silver.sales_order_items;
		PRINT '>> Inserting Data Into: silver.sales_order_items';
		INSERT INTO silver.sales_order_items (
		salesorderid,          
		salesorderitem,			
		productid,				
		noteid,					
		currency,			
		grossamount,			
		netamount,			
		taxamount,				
		itematpstatus,             
		opitempos,				
		quantity,				
		quantityunit,				
		deliverydate					
		  )
		SELECT
		salesorderid,          
		salesorderitem,			
		productid,				
		noteid,					
		currency,			
		grossamount,			
		netamount,			
		taxamount,				
		itematpstatus,             
		opitempos,				
		quantity,				
		quantityunit,				
		deliverydate
		FROM bronze.sales_order_items


		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';




								-- silver.sales_orders--
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.sales_orders';
		TRUNCATE TABLE silver.sales_orders;
		PRINT '>> Inserting Data Into: silver.sales_orders';
		INSERT INTO silver.sales_orders (
		salesorderid,               
		createdby,                  
		createdat,              
		changedby,               
		changedat,            
		fiscvariant,                
		fiscalyearperiod,       
		noteid,                    
		partnerid,              
		salesorg,                  
		currency,             
		grossamount,            
		netamount,                   
		taxamount,                  
		lifecyclestatus,      
		billingstatus,           
		deliverystatus         			
		  )
		SELECT
		salesorderid,               
		createdby,                  
		createdat,              
		changedby,               
		changedat,            
		fiscvariant,                
		fiscalyearperiod,       
		noteid,                    
		partnerid,              
		salesorg,                  
		currency,             
		grossamount,            
		netamount,                   
		taxamount,                  
		lifecyclestatus,      
		billingstatus,           
		deliverystatus  
		FROM bronze.sales_orders


		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';






		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
		
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END

--EXEC silver.load_silver
