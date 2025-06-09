SELECT p.Name, pi.Quantity AS UnitsInStock
FROM Production.Product p
JOIN Production.ProductInventory pi ON p.ProductID = pi.ProductID
WHERE pi.Quantity < 10

;
