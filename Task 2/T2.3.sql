
/*
Create a procedure GetOrderDetails that takes OrderID as input parameter and 
returns all the records for that OrderID. If no records are found in Order 
Details table, then it should print the line: "The OrderID XXXX does not 
exits", where XXX should be the OrderID entered by user and the procedure 
should RETURN the value 1.
*/

CREATE PROCEDURE GetOrderDetails
    @OrderID INT
AS
BEGIN
    -- Declare a variable to check if any rows are returned
    DECLARE @RowCount INT;

    -- Select the order details for the given OrderID
    SELECT 
        SalesOrderID,
        ProductID,
        UnitPrice,
        OrderQty,
        UnitPriceDiscount
    FROM Sales.SalesOrderDetail
    WHERE SalesOrderID = @OrderID;

    -- Check if any rows were returned
    SET @RowCount = @@ROWCOUNT;

    -- If no rows were found, print the message and return 1
    IF @RowCount = 0
    BEGIN
        PRINT 'The OrderID ' + CAST(@OrderID AS VARCHAR(10)) + ' does not exist';
        RETURN 1;
    END
END
