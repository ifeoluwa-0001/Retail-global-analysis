-- 1. Create and select the database
CREATE DATABASE IF NOT EXISTS global_retail_db;
USE global_retail_db;

-- 2. Create Tables 

CREATE TABLE Customers (
    CustomerKey INT PRIMARY KEY,
    Gender VARCHAR(20),
    Name VARCHAR(100),
    City VARCHAR(100),
    State_Code VARCHAR(10),
    State VARCHAR(100),
    Zip_Code VARCHAR(20),
    Country VARCHAR(100),
    Continent VARCHAR(100),
    Birthday DATE
);

CREATE TABLE Stores (
    StoreKey INT PRIMARY KEY,
    Country VARCHAR(100),
    State VARCHAR(100),
    Square_Meters INT,
    Open_Date DATE
);

CREATE TABLE Products (
    ProductKey INT PRIMARY KEY,
    Product_Name VARCHAR(255),
    Brand VARCHAR(100),
    Color VARCHAR(50),
    Unit_Cost_USD DECIMAL(10,2),
    Unit_Price_USD DECIMAL(10,2),
    SubcategoryKey VARCHAR(20),
    Subcategory VARCHAR(100),
    CategoryKey VARCHAR(20),
    Category VARCHAR(100)
);

CREATE TABLE Exchange_Rates (
    Date DATE,
    Currency VARCHAR(10),
    Exchange DECIMAL(10,4),
    PRIMARY KEY (Date, Currency)
);



CREATE TABLE Sales (
    Order_Number INT,
    Line_Item INT,
    Order_Date DATE,
    Delivery_Date DATE, -- Can be NULL based on the data
    CustomerKey INT,
    StoreKey INT,
    ProductKey INT,
    Quantity INT,
    Currency_Code VARCHAR(10),
    PRIMARY KEY (Order_Number, Line_Item),
    
    -- Defining the Relationships
    CONSTRAINT fk_sales_customer FOREIGN KEY (CustomerKey) REFERENCES Customers(CustomerKey) ON DELETE SET NULL,
    CONSTRAINT fk_sales_store FOREIGN KEY (StoreKey) REFERENCES Stores(StoreKey) ON DELETE SET NULL,
    CONSTRAINT fk_sales_product FOREIGN KEY (ProductKey) REFERENCES Products(ProductKey) ON DELETE SET NULL
);