
/*================
CREATE FACT TABLES
================*/

CREATE TABLE dbo.FactOrderLines (
    OrderItemID BIGINT PRIMARY KEY,
    OrderID BIGINT,
    CustomerKey INT,
    ProductKey INT,
    ShippingKey INT,
    GeographyKey INT,
    DepartmentKey INT,
    OrderDateKey INT,
    Quantity INT,
    SalesAmount DECIMAL(18,2),
    DiscountAmount DECIMAL(18,2),
    ProfitRatio DECIMAL(18,4)
);

INSERT INTO dbo.FactOrderLines
    (OrderItemID, OrderID, CustomerKey)
SELECT DISTINCT
    OrderItemID,
    OrderID,
	CustomerKey
FROM dbo.vw_DataCo_Cleaned
JOIN dbo.DimCustomer
ON dbo.vw_DataCo_Cleaned.CustomerID = dbo.DimCustomer.CustomerID

SELECT DISTINCT
    OrderItemID,
    OrderID,
	CustomerKey,
	ProductKey,
	ShippingKey,
	GeographyKey,
	DepartmentKey,
	OrderDateKey
FROM dbo.vw_DataCo_Cleaned
JOIN dbo.DimCustomer
ON dbo.vw_DataCo_Cleaned.CustomerID = dbo.DimCustomer.CustomerID
JOIN dbo.DimProduct
ON dbo.vw_DataCo_Cleaned.ProductID = dbo.DimProduct.ProductID
JOIN dbo.DimShipping
ON dbo.vw_DataCo_Cleaned.ShippingMode = dbo.DimShipping.ShippingMode
JOIN DimGeography
ON dbo.vw_DataCo_Cleaned.City = dbo.DimGeography.City
JOIN DimDepartment
ON dbo.vw_DataCo_Cleaned.DepartmentName = dbo.DimDepartment.DepartmentName
JOIN DimDate
ON dbo.vw_DataCo_Cleaned.OrderDate = dbo.DimDate.FullDate;


select top 3 *
from dbo.DimDate


select top 3 *
from dbo.vw_DataCo_Cleaned







CREATE TABLE dbo.FactOrderPerformance (
    OrderID BIGINT PRIMARY KEY,
    CustomerKey INT,
    ShippingKey INT,
    GeographyKey INT,
    StatusKey INT,
    OrderDateKey INT,
    ShippingDateKey INT,
    ActualShippingDays INT,
    ScheduledShippingDays INT,
    LateDeliveryRisk INT,
    OrderSales DECIMAL(18,2)
);

WITH OrderSummary AS (
    SELECT
        OrderID,
        MAX(CustomerID) AS CustomerID,
        MAX(OrderDate) AS OrderDate,
        MAX(ShippingDate) AS ShippingDate,
        MAX(ShippingMode) AS ShippingMode,
        MAX(DeliveryStatus) AS DeliveryStatus,
        MAX(ActualShippingDays) AS ActualDays,
        MAX(ScheduledShippingDays) AS ScheduledDays,
        MAX(LateDeliveryRisk) AS LateRisk,
        SUM(SalesAmount) AS OrderSales
    FROM dbo.vw_DataCo_Cleaned
    WHERE OrderID IS NOT NULL
    GROUP BY OrderID
)
SELECT *
FROM OrderSummary;

SELECT *
FROM dbo.vw_DataCo_Cleaned;