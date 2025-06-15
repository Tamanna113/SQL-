--		Functions

/*
Create a function that takes an input parameter type datetime and returns 
the date in the format MM/DD/YYYY. For example if I pass in '2006-11-21 
23:34:05.920', the output of the functions should be 11/21/2006
*/

DROP FUNCTION IF EXISTS dbo.FormatDate;
GO

CREATE FUNCTION dbo.FormatDate (@InputDate DATETIME)
RETURNS VARCHAR(10)
AS
BEGIN
    RETURN FORMAT(@InputDate, 'MM/dd/yyyy');
END;
GO 
SELECT dbo.FormatDate('2006-11-21 23:34:05.920') AS FormattedDate;


/*
Create a function that takes an input parameter type datetime and returns 
the date in the format YYYYMMDD
*/

DROP FUNCTION IF EXISTS dbo.FormatDate;
GO

CREATE FUNCTION dbo.FormatDate (@InputDate DATETIME)
RETURNS CHAR(8)
AS
BEGIN
    RETURN CONVERT(CHAR(8), @InputDate, 112);
END;
GO  
SELECT dbo.FormatDate('2006-11-21 23:34:05.920') AS FormattedDate;


