SELECT DISTINCT pr.Name AS ProductName
FROM Production.Product pr
JOIN Sales.SalesOrderDetail sod ON pr.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE pr.SellEndDate IS NOT NULL
  AND soh.OrderDate BETWEEN '1-1-1997 and 1-1-1998'
ORDER BY ProductName;

