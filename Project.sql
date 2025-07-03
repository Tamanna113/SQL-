DROP TABLE IF EXISTS EmployeeLogins;
DROP TABLE IF EXISTS EmployeeWorkHours;

-- Create the Input Table For Getting Employer ID , Check in time and check out time 
CREATE TABLE EmployeeLogins (
    EmployerID INT,
    Name VARCHAR(100),
    CheckInTime DATETIME,
    CheckOutTime DATETIME
);

-- Inserting sample data from the given hint documentation 
INSERT INTO EmployeeLogins (EmployerID, Name, CheckInTime, CheckOutTime) VALUES
(1, 'Him', '2024-03-01 10:08', '2024-03-01 11:11'),
(1, 'Him', '2024-03-01 12:08', '2024-03-01 14:12'),
(1, 'Him', '2024-03-01 15:08', '2024-03-01 18:08'),
(2, 'Raj', '2024-03-01 10:10', '2024-03-01 12:12'),
(2, 'Raj', '2024-03-01 12:25', '2024-03-01 15:12'),
(3, 'Anu', '2024-03-01 10:12', '2024-03-01 12:35'),
(3, 'Anu', '2024-03-01 12:40', '2024-03-01 18:35');

-- Created the Output Table to display the first check in time and last checkin time and total work hours and total Out Coun
CREATE TABLE EmployeeWorkHours (
    EmployerID INT,
    Name VARCHAR(100),
    FirstCheckInTime DATETIME,
    LastCheckOutTime DATETIME,
    TotalOutCount INT,
    TotalWorkHours VARCHAR(5)
);

-- Calculating the Required Fields of employer
INSERT INTO EmployeeWorkHours (
    EmployerID, Name, FirstCheckInTime, LastCheckOutTime, TotalOutCount, TotalWorkHours
)
SELECT 
    EmployerID,
    Name,
    MIN(CheckInTime),
    MAX(CheckOutTime),
    COUNT(*) AS TotalOutCount, 
    RIGHT('0' + CAST(SUM(DATEDIFF(MINUTE, CheckInTime, CheckOutTime)) / 60 AS VARCHAR), 2) + ':' +
    RIGHT('0' + CAST(SUM(DATEDIFF(MINUTE, CheckInTime, CheckOutTime)) % 60 AS VARCHAR), 2)
FROM EmployeeLogins
GROUP BY EmployerID, Name;

-- View the output
SELECT * FROM EmployeeWorkHours
ORDER BY EmployerID;
