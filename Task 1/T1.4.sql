SELECT DISTINCT p.FirstName, p.LastName, cr.Name AS CountryRegion
FROM Person.Person p
JOIN Sales.Customer c ON p.BusinessEntityID = c.PersonID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE cr.Name IN ('United Kingdom', 'United States');
