WITH Managers AS (
    SELECT e.BusinessEntityID, 
           p.FirstName + ' ' + p.LastName AS ManagerName, 
           e.JobTitle, 
           edh.DepartmentID
    FROM HumanResources.Employee e
    JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
    JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
    WHERE (e.JobTitle LIKE '%Manager%'
            )
      AND edh.EndDate IS NULL
)
SELECT m.ManagerName, 
       m.JobTitle, 
       d.Name AS DepartmentName, 
       COUNT(e.BusinessEntityID) AS NumberOfEmployees
FROM Managers m
JOIN HumanResources.EmployeeDepartmentHistory edh ON m.DepartmentID = edh.DepartmentID
JOIN HumanResources.Employee e ON edh.BusinessEntityID = e.BusinessEntityID
JOIN HumanResources.Department d ON m.DepartmentID = d.DepartmentID
WHERE edh.EndDate IS NULL
GROUP BY m.ManagerName, m.JobTitle, d.Name
HAVING COUNT(e.BusinessEntityID) > 4
ORDER BY m.ManagerName;
