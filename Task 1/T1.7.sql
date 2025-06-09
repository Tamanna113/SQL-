SELECT DISTINCT p.FirstName, p.LastName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader so ON c.CustomerID = so.CustomerID;
