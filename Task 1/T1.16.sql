SELECT SalesOrderID, SUM(OrderQty) AS TotalQty
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING SUM(OrderQty) > 300;
