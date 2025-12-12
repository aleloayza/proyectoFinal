CREATE SCHEMA [GOLD]
GO

-- DIM_DATE sa saca del sale (venta)
CREATE TABLE [GOLD].[DIM_DATE] (
    [date_key] int PRIMARY KEY IDENTITY(1, 1),
    [sale_date] date
)
GO

-- DIM_STORES sale de store 
CREATE TABLE [GOLD].[DIM_STORES] (
    [store_key] INT PRIMARY KEY IDENTITY(1, 1),
    [store_id] NVARCHAR(50) NOT NULL,
    [store_name] NVARCHAR(100),
    [city] NVARCHAR(100),
    [country] NVARCHAR(50)
    -- Se omite 'opened' si no es crítica para el análisis inmediato.
)
GO

-- DIM_PRODUCTS sale de products 
CREATE TABLE [GOLD].[DIM_PRODUCTS] (
    [product_key] INT PRIMARY KEY IDENTITY(1, 1),
    [product_id] NVARCHAR(50) NOT NULL,
    [product_name] NVARCHAR(50),
    [category_id] NVARCHAR(50),
    [price] DECIMAL(10, 2), -- Transformación: De VARCHAR a DECIMAL
    [launch_date] DATE              -- Transformación: De VARCHAR a DATE
)
GO

-- FACT_SALES 
CREATE TABLE [GOLD].[FACT_SALES] (
    [sale_fact_id] BIGINT PRIMARY KEY IDENTITY(1, 1),
    [sale_id] NVARCHAR(50) NOT NULL,

    -- Claves Foráneas
    [date_key] INT NOT NULL,
    [store_key] INT NOT NULL,
    [product_key] INT NOT NULL,

    -- Métricas
    [quantity_sold] INT NOT NULL, -- Transformación: De VARCHAR a INT
    -- Atributos de Garantía
    [is_claimed] BIT NOT NULL, -- 1 = Claim existe, 0 = No hay claim (Transformación en Data Flow)
    [claim_date] DATE NULL,
    [repair_status] NVARCHAR(25) NULL
)
GO

--------------------------------------------------------------------------------
-- 3. RELACIONES
--------------------------------------------------------------------------------

ALTER TABLE [GOLD].[FACT_SALES] 
ADD CONSTRAINT FK_FACT_STORES FOREIGN KEY ([store_key])
 REFERENCES [GOLD].[DIM_STORES] ([store_key])
GO

ALTER TABLE [GOLD].[FACT_SALES] 
ADD CONSTRAINT FK_FACT_PRODUCTS FOREIGN KEY ([product_key]) 
REFERENCES [GOLD].[DIM_PRODUCTS] ([product_key])
GO

ALTER TABLE [GOLD].[FACT_SALES] 
ADD CONSTRAINT FK_FACT_DATE FOREIGN KEY ([date_key]) 
REFERENCES [GOLD].[DIM_DATE] ([date_key])
GO
