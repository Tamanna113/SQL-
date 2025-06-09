SELECT DISTINCT p.FirstName, p.LastName, a.City
FROM Person.Person p
JOIN Sales.Customer c ON p.BusinessEntityID = c.PersonID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
WHERE a.City IN ('Berlin', 'London');
