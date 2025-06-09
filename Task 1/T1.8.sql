SELECT DISTINCT p.FirstName, p.LastName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader so ON c.CustomerID = so.CustomerID
JOIN Person.Address a ON so.ShipToAddressID = a.AddressID
JOIN Sales.SalesOrderDetail sod ON so.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID
WHERE a.City = 'London' AND pr.Name = 'Chai';
