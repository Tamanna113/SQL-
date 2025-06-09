SELECT pc.Name AS CategoryName, SUM(sod.LineTotal) AS TotalSales
FROM Production.ProductCategory pc
JOIN Production.ProductSubcategory psc ON pc.ProductCategoryID = psc.ProductCategoryID
JOIN Production.Product p ON psc.ProductSubcategoryID = p.ProductSubcategoryID
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
GROUP BY pc.Name;
