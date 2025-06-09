SELECT sp.BusinessEntityID AS SalesPersonID,
       p.FirstName + ' ' + p.LastName AS SalesPersonName,
       SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesPerson sp
JOIN HumanResources.Employee e ON sp.BusinessEntityID = e.BusinessEntityID
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON sp.BusinessEntityID = soh.SalesPersonID
GROUP BY sp.BusinessEntityID, p.FirstName, p.LastName
ORDER BY TotalSales DESC;
