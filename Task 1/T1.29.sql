WITH BestCustomer AS (
    SELECT CustomerID, SUM(TotalDue) AS TotalSales
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
    ORDER BY TotalSales DESC
    OFFSET 0 ROWS FETCH NEXT 1 ROW ONLY
)
SELECT soh.SalesOrderID, soh.OrderDate, soh.TotalDue, soh.CustomerID
FROM Sales.SalesOrderHeader soh
JOIN BestCustomer bc ON soh.CustomerID = bc.CustomerID;
