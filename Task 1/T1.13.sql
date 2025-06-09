SELECT SalesOrderID, AVG(OrderQty) AS AverageQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;
