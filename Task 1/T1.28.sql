SELECT soh.SalesOrderID, pr.Name AS ProductName FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID
ORDER BY soh.SalesOrderID;
