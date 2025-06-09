SELECT TOP 10 c.CustomerID, SUM(soh.TotalDue) AS TotalBusiness
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY c.CustomerID
ORDER BY TotalBusiness DESC;
