
/*
Create a procedure DeleteOrderDetails that takes OrderID and ProductID and 
deletes that from Order Details table. Your procedure should validate 
parameters. It should return an error code (-1) and print a message if the 
parameters are invalid. Parameters are valid if the given order ID appears 
in the table and if the given product ID appears in that order.
*/

CREATE PROCEDURE DeleteOrderDetails
    @OrderID INT,
    @ProductID INT
AS
BEGIN
    -- Declare a variable to check if any rows are returned
    DECLARE @RowCount INT;

    -- Check if the given OrderID and ProductID exist in the SalesOrderDetail table
    SELECT 
        @RowCount = COUNT(*)
    FROM Sales.SalesOrderDetail
    WHERE SalesOrderID = @OrderID AND ProductID = @ProductID;

    -- If no rows are found, print the message and return -1
    IF @RowCount = 0
    BEGIN
        PRINT 'Invalid parameters: The OrderID ' + CAST(@OrderID AS VARCHAR(10)) + ' and ProductID ' + CAST(@ProductID AS VARCHAR(10)) + ' combination does not exist';
        RETURN -1;
    END

    BEGIN TRY
        -- Start a transaction
        BEGIN TRANSACTION;

        -- Delete the order details
        DELETE FROM Sales.SalesOrderDetail
        WHERE SalesOrderID = @OrderID AND ProductID = @ProductID;

        -- Commit the transaction
        COMMIT TRANSACTION;

        PRINT 'Order details deleted successfully.';

    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK TRANSACTION;
        PRINT 'An error occurred. The transaction has been rolled back.';
        RETURN -1;
    END CATCH
END



