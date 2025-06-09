SELECT DISTINCT p.FirstName, p.LastName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader so ON c.CustomerID = so.CustomerID
JOIN Sales.SalesOrderDetail sod ON so.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID
JOIN Production.ProductSubcategory psc ON pr.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
WHERE pc.Name = 'Beverages';
