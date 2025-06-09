WITH SupervisorCTE AS (
    SELECT e.BusinessEntityID AS EmployeeBusinessEntityID,
           e.OrganizationNode,
           p.FirstName AS EmployeeFirstName,
           p.LastName AS EmployeeLastName
    FROM HumanResources.Employee e
    JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
)
SELECT e.EmployeeBusinessEntityID AS EmployeeID,
       e.EmployeeFirstName,
       e.EmployeeLastName,
       sp.FirstName AS SupervisorFirstName,
       sp.LastName AS SupervisorLastName
FROM SupervisorCTE e
JOIN HumanResources.Employee s ON e.OrganizationNode.GetAncestor(1) = s.OrganizationNode
JOIN Person.Person sp ON s.BusinessEntityID = sp.BusinessEntityID
ORDER BY e.EmployeeBusinessEntityID;

