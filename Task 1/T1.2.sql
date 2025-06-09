SELECT s.Name AS CompanyName, c.CustomerID
FROM Sales.Customer c
JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID
WHERE s.Name LIKE '%N';
