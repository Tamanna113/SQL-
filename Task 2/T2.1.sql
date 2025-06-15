
/*
Create a procedure InsertOrderDetails that takes OrderID, ProductID, 
UnitPrice, Quantiy, Discount as input parameters and inserts that order 
information in the Order Details table. After each order inserted, check the 
@@rowcount value to make sure that order was inserted properly. If for any 
reason the order was not inserted, print the message: Failed to place the 
order. Please try again. Also your procedure should have these 
functionalities Make the UnitPrice and Discount parameters optional If no 
UnitPrice is given, then use the UnitPrice value from the product table. If 
no Discount is given, then use a discount of 0. Adjust the quantity in stock 
(UnitsInStock) for the product by subtracting the quantity sold from 
inventory. However, if there is not enough of a product in stock, then abort 
the stored procedure without making any changes to the database. Print a 
message if the quantity in stock of a product drops below its Reorder Level 
as a result of the update.
*/

DROP PROCEDURE IF EXISTS InsertOrderDetails;
GO

CREATE PROCEDURE InsertOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice DECIMAL(10, 2) = NULL,
    @Quantity INT,
    @Discount DECIMAL(10, 2) = 0
AS
BEGIN
    DECLARE @ProductUnitPrice DECIMAL(10, 2);
    DECLARE @UnitsInStock INT;
    DECLARE @ReorderLevel INT;
    
    -- Get the product details
    SELECT 
        @ProductUnitPrice = ListPrice,
        @UnitsInStock = Quantity,
        @ReorderLevel = SafetyStockLevel
    FROM Production.ProductInventory
    JOIN Production.Product ON Production.Product.ProductID = Production.ProductInventory.ProductID
    WHERE Production.Product.ProductID = @ProductID;
    
    -- Use the product price if UnitPrice is not provided
    IF @UnitPrice IS NULL
    BEGIN
        SET @UnitPrice = @ProductUnitPrice;
    END
    
    -- Check if there is enough stock
    IF @UnitsInStock < @Quantity
    BEGIN
        PRINT 'Not enough stock available. Aborting the transaction.';
        RETURN;
    END
    
    BEGIN TRY
        -- Start a transaction
        BEGIN TRANSACTION;
        
        -- Insert the order details
        INSERT INTO Sales.SalesOrderDetail (SalesOrderID, ProductID, UnitPrice, OrderQty, UnitPriceDiscount)
        VALUES (@OrderID, @ProductID, @UnitPrice, @Quantity, @Discount);
        
        -- Check if the insertion was successful
        IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'Failed to place the order. Please try again.';
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Update the stock quantity
        UPDATE Production.ProductInventory
        SET Quantity = Quantity - @Quantity
        WHERE ProductID = @ProductID;
        
        -- Check if the stock drops below reorder level
        IF (SELECT Quantity FROM Production.ProductInventory WHERE ProductID = @ProductID) < @ReorderLevel
        BEGIN
            PRINT 'Warning: The quantity in stock of this product has dropped below its reorder level.';
        END
        
        -- Commit the transaction
        COMMIT TRANSACTION;
        
        PRINT 'Order placed successfully.';
        
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK TRANSACTION;
        PRINT 'An error occurred. The transaction has been rolled back.';
    END CATCH
END