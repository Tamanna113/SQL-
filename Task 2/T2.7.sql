
-- 		Triggers


/*
If someone cancels an order in northwind database, then you want to delete 
that order from the Orders table. But you will not be able to delete that 
Order before deleting the records from Order Details table for that 
particular order due to referential integrity constraints. Create an Instead 
of Delete trigger on Orders table so that if some one tries to delete an 
Order that trigger gets fired and that trigger should first delete 
everything in order details table and then delete that order from the Orders 
table
*/

USE Northwind;

CREATE TRIGGER DeleteOrderWithDetails
ON Orders
INSTEAD OF DELETE
AS
BEGIN
    -- Delete records from Order Details table first
    DELETE FROM [Order Details]
    WHERE OrderID IN (SELECT OrderID FROM deleted);

    -- Now delete the order from the Orders table
    DELETE FROM Orders
    WHERE OrderID IN (SELECT OrderID FROM deleted);
END;



/*
When an order is placed for X units of product Y, we must first check the 
Products table to ensure that there is sufficient stock to fill the order. 
This trigger will operate on the Order Details table. If sufficient stock 
exists, then fill the order and decrement X units from the UnitsInStock 
column in Products. If insufficient stock exists, then refuse the order (ie. 
do not insert it) and notify the user that the order could not be filled 
because of insufficient stock.
*/

CREATE TRIGGER CheckStockAndFillOrder
ON [Order Details]
INSTEAD OF INSERT
AS
BEGIN
    -- Check if there is sufficient stock for each order detail
    IF EXISTS (
        SELECT od.ProductID, p.UnitsInStock, SUM(od.Quantity) AS RequiredUnits
        FROM inserted od
        INNER JOIN Products p ON od.ProductID = p.ProductID
        GROUP BY od.ProductID, p.UnitsInStock
        HAVING SUM(od.Quantity) <= p.UnitsInStock
    )
    BEGIN
        -- Sufficient stock available, fill the order and decrement UnitsInStock
        DECLARE @ProductID INT;
        DECLARE @Quantity INT;

        DECLARE order_cursor CURSOR FOR
            SELECT ProductID, Quantity FROM inserted;

        OPEN order_cursor;
        FETCH NEXT FROM order_cursor INTO @ProductID, @Quantity;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            UPDATE Products
            SET UnitsInStock = UnitsInStock - @Quantity
            WHERE ProductID = @ProductID;

            FETCH NEXT FROM order_cursor INTO @ProductID, @Quantity;
        END;

        CLOSE order_cursor;
        DEALLOCATE order_cursor;

        -- Insert the order details into the table
        INSERT INTO [Order Details]
        SELECT * FROM inserted;
    END
    ELSE
    BEGIN
        -- Insufficient stock, refuse the order and notify the user
        RAISERROR ('Order could not be filled due to insufficient stock.', 16, 1);
    END
END;