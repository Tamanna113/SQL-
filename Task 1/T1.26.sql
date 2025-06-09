SELECT e.BusinessEntityID, 
       p.FirstName, 
       p.LastName, 
       e.JobTitle
FROM HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
WHERE p.FirstName LIKE '%a%'
ORDER BY p.FirstName;
