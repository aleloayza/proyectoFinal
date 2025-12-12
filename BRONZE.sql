CREATE SCHEMA [BRONZE]
GO

-- category_id,category_name,extra_note
CREATE TABLE [BRONZE].[CATEGORY] (
    [category_id] VARCHAR(50),
    [category_name] VARCHAR(50),
    [extra_note] VARCHAR(50)
   )
GO
-- Product_ID,Product_Name,Category_ID,Launch_Date,Price,notes
CREATE TABLE [BRONZE].[PRODUCTS](
    [Product_ID] VARCHAR(50),
    [Product_Name] VARCHAR(50),
    [Category_ID] VARCHAR(50),
    [Launch_Date] VARCHAR(50),
    [Price] VARCHAR(50),
    [notes] VARCHAR(50)
)
GO

-- sale_id,sale_date,store_id,product_id,quantity
CREATE TABLE [BRONZE].[SALES](
    [sale_id] VARCHAR(50),
    [sale_date] VARCHAR(50),
    [store_id] VARCHAR(50),
    [product_id] VARCHAR(50),
    [quantity] VARCHAR(50)
)
GO

-- Store_ID,Store_Name,City,Country,opened
CREATE TABLE [BRONZE].[STORES] (
    [Store_ID] VARCHAR(50),
    [Store_Name] VARCHAR(50),
    [City] VARCHAR(100),
    [Country] VARCHAR(50),
    [opened] VARCHAR(50)
)
GO

-- claim_id,claim_date,sale_id,repair_status
CREATE TABLE [BRONZE].[WARRANTY] (
    [claim_id] VARCHAR(25),
    [claim_date] VARCHAR(50),
    [sale_id] VARCHAR(25),
    [repair_status] VARCHAR(25)
)
GO