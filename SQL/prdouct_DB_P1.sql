-------------------------------------------------
-- PHASE 1
-------------------------------------------------

CREATE DATABASE product_sales_db;
GO

USE product_sales_db;
GO

IF OBJECT_ID ('product_sales_dataset_final','U') IS NOT NULL
	DROP TABLE product_sales_dataset_final;
GO

-- Creating the table structure 
CREATE TABLE product_sales_dataset_final (
    Order_ID INT,
    Order_Date VARCHAR(50), 
    Customer_Name VARCHAR(100),
    City VARCHAR(100),
    State VARCHAR(100),
    Region VARCHAR(100),
    Country VARCHAR(100),
    Category VARCHAR(100),
    Sub_Category VARCHAR(100),
    Product_Name VARCHAR(255),
    Quantity INT,
    Unit_Price FLOAT,
    Revenue FLOAT,
    Profit FLOAT
);

-- Data loading from CSV into the table
BULK INSERT product_sales_dataset_final
FROM 'D:\Project\New folder\product_sales_dataset_final.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK 
);
