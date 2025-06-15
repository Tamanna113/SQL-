
--   	View


/*
Create a view vwCustomerOrders which returns CompanyName, OrderID. 
OrderDate, ProductID. Product Name Quantity UnitPrice. Quantity od. 
UnitPrice
*/
DROP VIEW IF EXISTS vwCustomerOrders;
GO

CREATE VIEW vwCustomerOrders AS
SELECT 
    c.AccountNumber,
    soh.SalesOrderID AS OrderID,
    soh.OrderDate,
    sod.ProductID,
    p.Name AS ProductName,
    sod.OrderQty AS Quantity,
    sod.UnitPrice,
    sod.OrderQty * sod.UnitPrice AS TotalPrice
FROM 
    Sales.Customer AS c
    INNER JOIN Sales.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID
    INNER JOIN Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
    INNER JOIN Production.Product AS p ON sod.ProductID = p.ProductID;
GO

-- Test the view
SELECT * FROM vwCustomerOrders;
GO




/*
Create a copy of the above view and modify it so that it only returns the 
above information for orders that were placed yesterday
*/

DROP VIEW IF EXISTS vwCustomerOrdersYesterday;
GO

CREATE VIEW vwCustomerOrdersYesterday AS
SELECT 
    c.AccountNumber,
    soh.SalesOrderID AS OrderID,
    soh.OrderDate,
    sod.ProductID,
    p.Name AS ProductName,
    sod.OrderQty AS Quantity,
    sod.UnitPrice,
    sod.OrderQty * sod.UnitPrice AS TotalPrice
FROM 
    Sales.Customer AS c
    INNER JOIN Sales.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID
    INNER JOIN Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
    INNER JOIN Production.Product AS p ON sod.ProductID = p.ProductID
WHERE 
    CAST(soh.OrderDate AS DATE) = CAST(GETDATE() - 1 AS DATE);
GO

-- Test the view
SELECT * FROM vwCustomerOrdersYesterday;
GO



/*
Use a CREATE VIEW statement to create a view called MyProducts. Your view 
should contain the ProductID, ProductName, QuantityPerUnit and UnitPrice 
columns from the Products table. It should also contain the CompanyName 
column from the Suppliers table and the CategoryName column from the 
Categories table. Your view should only contain products that are not 
discontinued.
*/

DROP VIEW IF EXISTS MyProducts;
GO

CREATE VIEW MyProducts AS
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    p.StandardCost AS UnitPrice,
    v.Name AS SupplierName,
    pc.Name AS CategoryName
FROM 
    Production.Product AS p
    INNER JOIN Purchasing.ProductVendor AS pv ON p.ProductID = pv.ProductID
    INNER JOIN Purchasing.Vendor AS v ON pv.BusinessEntityID = v.BusinessEntityID
    INNER JOIN Production.ProductSubcategory AS psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
    INNER JOIN Production.ProductCategory AS pc ON psc.ProductCategoryID = pc.ProductCategoryID
WHERE 
    p.SellEndDate IS NULL;
GO

-- Test the view
SELECT * FROM MyProducts;
GO
