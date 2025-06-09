SELECT p.FirstName, p.LastName, COUNT(so.SalesOrderID) AS TotalOrders, SUM(so.TotalDue) AS TotalSales
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader so ON c.CustomerID = so.CustomerID
GROUP BY p.FirstName, p.LastName;
