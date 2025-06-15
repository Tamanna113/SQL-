
/*
Create a procedure UpdateOrderDetails that takes OrderID, ProductID, 
UnitPrice, Quantity, and discount, and updates these values for that 
ProductID in that Order. All the parameters except the OrderID and ProductID 
should be optional so that if the user wants to only update Quantity s/he 
should be able to do so without providing the rest of the values. You need 
to also make sure that if any of the values are being passed in as NULL, 
then you want to retain the original value instead of overwriting it with 
NULL. To accomplish this, look for the ISNULL() function in google or sql 
server books online. Adjust the UnitsInStock value in products table 
accordingly.
*/

DROP PROCEDURE IF EXISTS UpdateOrderDetails2;
GO

CREATE PROCEDURE UpdateOrderDetails2
    @OrderID INT,
    @ProductID INT,
    @UnitPrice DECIMAL(10, 2) = NULL,
    @Quantity INT = NULL,
    @Discount DECIMAL(10, 2) = NULL
AS
BEGIN
    DECLARE @CurrentUnitPrice DECIMAL(10, 2);
    DECLARE @CurrentQuantity INT;
    DECLARE @CurrentDiscount DECIMAL(10, 2);
    DECLARE @UnitsInStock INT;
    DECLARE @OriginalQuantity INT;
    
    -- Get current order details
    SELECT 
        @CurrentUnitPrice = UnitPrice,
        @CurrentQuantity = OrderQty,
        @CurrentDiscount = UnitPriceDiscount
    FROM Sales.SalesOrderDetail
    WHERE SalesOrderID = @OrderID AND ProductID = @ProductID;
    
    -- Get current product inventory
    SELECT @UnitsInStock = Quantity
    FROM Production.ProductInventory
    WHERE ProductID = @ProductID;

    -- Check if the original quantity is retrieved properly
    IF @CurrentQuantity IS NULL
    BEGIN
        PRINT 'Order details not found for the provided OrderID and ProductID.';
        RETURN;
    END

    -- Retain original values if parameters are not provided
    SET @UnitPrice = ISNULL(@UnitPrice, @CurrentUnitPrice);
    SET @Quantity = ISNULL(@Quantity, @CurrentQuantity);
    SET @Discount = ISNULL(@Discount, @CurrentDiscount);

    -- Adjust the quantity in stock
    SET @OriginalQuantity = @CurrentQuantity;
    SET @UnitsInStock = @UnitsInStock + @OriginalQuantity - @Quantity;

    -- Check if there is enough stock available for the update
    IF @UnitsInStock < 0
    BEGIN
        PRINT 'Not enough stock available. Aborting the transaction.';
        RETURN;
    END

    BEGIN TRY
        -- Start a transaction
        BEGIN TRANSACTION;

        -- Update the order details
        UPDATE Sales.SalesOrderDetail
        SET UnitPrice = @UnitPrice,
            OrderQty = @Quantity,
            UnitPriceDiscount = @Discount
        WHERE SalesOrderID = @OrderID AND ProductID = @ProductID;

        -- Check if the update was successful
        IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'Failed to update the order. Please try again.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Update the stock quantity
        UPDATE Production.ProductInventory
        SET Quantity = @UnitsInStock,
            ModifiedDate = GETDATE()
        WHERE ProductID = @ProductID;

        -- Check if the stock drops below reorder level
        IF (SELECT Quantity FROM Production.ProductInventory WHERE ProductID = @ProductID) 
            < (SELECT SafetyStockLevel FROM Production.Product WHERE ProductID = @ProductID)
        BEGIN
            PRINT 'Warning: The quantity in stock of this product has dropped below its reorder level.';
        END

        -- Commit the transaction
        COMMIT TRANSACTION;

        PRINT 'Order updated successfully.';

    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK TRANSACTION;
        PRINT 'An error occurred. The transaction has been rolled back.';
    END CATCH
END;
GO

