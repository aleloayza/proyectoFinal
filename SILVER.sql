CREATE SCHEMA [silver]
GO

CREATE TABLE [SILVER].[PRODUCTS](
    [product_id]     nvarchar(50),
    [product_name]   nvarchar(100),
    [category_id]    nvarchar(50),
    [launch_date]    date,
    [price]          decimal(10,2),
    [notes]          nvarchar(255)
);
GO

CREATE TABLE [SILVER].[SALES](
    [sale_id]      nvarchar(50),
    [sale_date]    date,
    [store_id]     nvarchar(50),
    [product_id]   nvarchar(50),
    [quantity]     int
);
GO 

CREATE TABLE [SILVER].[STORES](
    [store_id]     nvarchar(50),
    [store_name]   nvarchar(100),
    [city]         nvarchar(100),
    [country]      nvarchar(100),
    [opened]       date
);
GO

CREATE TABLE [SILVER].[WARRANTY](
    [claim_id]        nvarchar(50),
    [claim_date]      date,
    [sale_id]         nvarchar(50),
    [repair_status]   nvarchar(100)
);
GO 