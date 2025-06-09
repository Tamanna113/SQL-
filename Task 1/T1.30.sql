-- Check fax numbers from Person.PersonPhone
SELECT soh.SalesOrderID, soh.OrderDate, soh.CustomerID
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN Person.PersonPhone pp ON p.BusinessEntityID = pp.BusinessEntityID AND pp.PhoneNumberTypeID = (
    SELECT PhoneNumberTypeID FROM Person.PhoneNumberType WHERE Name = 'Fax'
)
WHERE pp.PhoneNumber IS NULL;
