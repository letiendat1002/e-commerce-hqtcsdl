USE myecommerce
GO

-- OrderDetail
-- Select All OrderDetail
CREATE PROC sp_select_all_orderdetail
AS
BEGIN
	SELECT * FROM OrderDetail
END
GO

--EXEC sp_select_all_orderdetail
--GO

-- Select All OrderDetail By OrderID
CREATE PROC sp_select_orderdetails_by_orderid
	@orderid BIGINT
AS
BEGIN
	DECLARE @isExist BIT
	EXEC sp_exist_order_by_orderid @orderid, @isExist OUT
	IF (@isExist = 0)
		BEGIN
			PRINT 'Order not exist by this OrderID'
			RETURN
		END
	SELECT * FROM OrderDetail WHERE OrderID = @orderid
END
GO

--EXEC sp_select_orderdetails_by_orderid 1
--GO


-- Select All OrderDetail By ProductID
CREATE PROC sp_select_orderdetails_by_productid
	@productid BIGINT
AS
BEGIN
	DECLARE @isExist BIT
	EXEC sp_exist_product_by_productid @productid, @isExist OUT
	IF (@isExist = 0)
		BEGIN
			PRINT 'Product not exist by this ProductID'
			RETURN
		END
	SELECT * FROM OrderDetail WHERE ProductID = @productid
END
GO

--EXEC sp_select_orderdetails_by_productid 1
--GO``


-- Select One OrderDetail By OrderDetailID
CREATE PROC sp_select_orderdetail_by_orderdetailid
	@id BIGINT
AS
BEGIN
	SELECT * FROM OrderDetail WHERE OrderDetailID = @id
END
GO

--EXEC sp_select_orderdetail_by_orderdetailid 1
--GO


-- Select One OrderDetail By OrderID And ProductID
CREATE PROC sp_select_orderdetail_by_orderid_and_productid
	@orderid BIGINT, @productid BIGINT
AS
BEGIN
	DECLARE @isExist BIT
	EXEC sp_exist_order_by_orderid @orderid, @isExist OUT
	IF (@isExist = 0)
		BEGIN
			PRINT 'Order not exist by this OrderID'
			RETURN
		END
	SET @isExist = 0
	EXEC sp_exist_product_by_productid @productid, @isExist OUT
	IF (@isExist = 0)
		BEGIN
			PRINT 'Product not exist by this ProductID'
			RETURN
		END
	SELECT * FROM OrderDetail WHERE OrderID = @orderid AND ProductID = @productid
END
GO

--EXEC sp_select_orderdetail_by_orderid_and_productid 1, 1
--GO


-- Exist OrderDetail By OrderDetailID
CREATE PROC sp_exist_orderdetail_by_orderdetailid
	@id BIGINT, @isExist BIT OUTPUT
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM OrderDetail WHERE OrderDetailID = @id)
		SET @isExist = 0
	ELSE
		SET @isExist = 1
END
GO

--DECLARE @isExist BIT
--EXEC sp_exist_orderdetail_by_orderdetailid 1, @isExist OUT
--SELECT @isExist
--GO

-- Exist OrderDetail By OrderID and ProductID
CREATE PROC sp_exist_orderdetail_by_orderid_and_productid
	@orderid BIGINT, @productid BIGINT, @isExist BIT OUTPUT
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM OrderDetail WHERE OrderID = @orderid AND ProductID = @productid)
		SET @isExist = 0
	ELSE
		SET @isExist = 1
END
GO

--DECLARE @isExist BIT
--EXEC sp_exist_orderdetail_by_orderid_and_productid 1, 1, @isExist OUT
--SELECT @isExist
--GO


-- Transaction
-- Add OrderDetail
-- DROP PROCEDURE sp_add_orderdetail
CREATE PROC sp_add_orderdetail
	@orderid BIGINT, @productid BIGINT, @quantity INT
AS
BEGIN
	IF (@orderid IS NULL)
		BEGIN
			PRINT 'OrderID must not be null'
			RETURN
		END
	IF (@productid IS NULL)
		BEGIN
			PRINT 'ProductID must not be null'
			RETURN
		END
	IF (@quantity IS NULL)
		BEGIN
			PRINT 'Quantity must not be null'
			RETURN
		END
	DECLARE @status VARCHAR(255)
	SELECT @status = Status FROM UserOrder WHERE OrderID = @orderid
	IF (@status IS NULL)
		BEGIN
			PRINT 'Order not exist by this OrderID'
			RETURN
		END
	IF (@status != 'PENDING')
		BEGIN
			PRINT 'Add order detail only able when order is PENDING, but it is '
					+ @status
			RETURN
		END
	DECLARE @isExist BIT
	EXEC sp_exist_product_by_productid @productid, @isExist OUT
	IF (@isExist = 0)
		BEGIN
			PRINT 'Product not exist by this ProductID'
			RETURN
		END
	SET @isExist = 0
	EXEC sp_exist_orderdetail_by_orderid_and_productid @orderid, @productid, @isExist OUT
	IF (@isExist = 1)
		BEGIN
			PRINT 'Order Detail is already exist by this OrderID and ProductID'
			RETURN
		END
	BEGIN TRANSACTION
	BEGIN TRY
		DECLARE @temp INT = -@quantity
		EXEC sp_update_product_quantity_by_amount @productid, @temp
		DECLARE @pprice BIGINT
		SELECT @pprice = UnitPrice FROM Product WHERE ProductID = @productid
		INSERT INTO OrderDetail
		VALUES
			(@orderid, @productid, @pprice, @quantity)
		COMMIT TRANSACTION
		PRINT 'Add Order Detail successfully'
	END TRY
	BEGIN CATCH
		PRINT 'Procedure sp_add_orderdetail perform failed'
		ROLLBACK TRANSACTION
	END CATCH
END
GO

--EXEC sp_select_product_by_productid 1
--EXEC sp_add_orderdetail 11, 1, 10
--EXEC sp_select_product_by_productid 1
--GO


-- Transaction
-- Update Product Quantity When Order Cancelled
-- DROP PROCEDURE sp_update_product_quantity_when_order_cancelled
CREATE PROC sp_update_product_quantity_when_order_cancelled
	@orderid BIGINT
AS
BEGIN
	IF (@orderid IS NULL)
		BEGIN
			PRINT 'OrderID must be not null'
			RETURN
		END
	DECLARE @isExist BIT
	EXEC sp_exist_order_by_orderid @orderid, @isExist OUT
	IF (@isExist = 0)
		BEGIN
			PRINT 'Order not exist by this OrderID'
			RETURN
		END
	BEGIN TRANSACTION
	BEGIN TRY
		DECLARE @tempid BIGINT
		SELECT @tempid = MIN(OrderDetailID) FROM OrderDetail WHERE OrderID = @orderid
		WHILE (@tempid IS NOT NULL)
			BEGIN
				DECLARE @productid BIGINT
				SELECT @productid = ProductID FROM OrderDetail WHERE OrderDetailID = @tempid
				DECLARE @amount INT
				SELECT @amount = Quantity FROM OrderDetail WHERE OrderDetailID = @tempid
				EXEC sp_update_product_quantity_by_amount @productid, @amount
				SELECT @tempid = MIN(OrderDetailID) FROM OrderDetail WHERE OrderDetailID > @tempid AND OrderID = @orderid
			END
		COMMIT TRANSACTION
		PRINT 'Update product quantity when order cancelled successfully'
	END TRY
	BEGIN CATCH
		PRINT ' Procedure sp_update_product_quantity_when_order_cancelled perform failed'
		ROLLBACK TRANSACTION
	END CATCH
END
GO

--EXEC sp_select_orderdetails_by_orderid 1
--EXEC sp_select_product_by_productid 1
--EXEC sp_select_product_by_productid 2
--EXEC sp_select_product_by_productid 3
--EXEC sp_update_product_quantity_when_order_cancelled 1
--EXEC sp_select_product_by_productid 1
--EXEC sp_select_product_by_productid 2
--EXEC sp_select_product_by_productid 3
--GO


-- Transaction
-- Delete All OrderDetail By OrderID
CREATE PROC sp_delete_all_orderdetail_by_orderid
	@orderid BIGINT
AS
BEGIN
	IF (@orderid IS NULL)
		BEGIN
			PRINT 'OrderID must be not null'
			RETURN
		END
	DECLARE @isExist BIT
	EXEC sp_exist_order_by_orderid @orderid, @isExist OUT
	IF (@isExist = 0)
		BEGIN
			PRINT 'Order not exist by this OrderID'
			RETURN
		END
	BEGIN TRANSACTION
	BEGIN TRY
		DECLARE @tempid BIGINT
		SELECT @tempid = MIN(OrderDetailID) FROM OrderDetail WHERE OrderID = @orderid
		WHILE (@tempid IS NOT NULL)
			BEGIN
				DECLARE @productid BIGINT
				SELECT @productid = ProductID FROM OrderDetail WHERE OrderDetailID = @tempid
				DECLARE @amount INT
				SELECT @amount = Quantity FROM OrderDetail WHERE OrderDetailID = @tempid
				EXEC sp_update_product_quantity_by_amount @productid, @amount
				DELETE FROM OrderDetail WHERE OrderDetailID = @tempid
				SELECT @tempid = MIN(OrderDetailID) FROM OrderDetail WHERE OrderDetailID > @tempid AND OrderID = @orderid
			END
		COMMIT TRANSACTION
		PRINT 'Delete all order detail by OrderID successfully'
	END TRY
	BEGIN CATCH
		PRINT ' Procedure sp_delete_all_orderdetail_by_orderid perform failed'
		ROLLBACK TRANSACTION
	END CATCH
END
GO

--EXEC sp_select_orderdetails_by_orderid 2
--EXEC sp_select_product_by_productid 1
--EXEC sp_select_product_by_productid 2
--EXEC sp_select_product_by_productid 3
--EXEC sp_delete_all_orderdetail_by_orderid 2
--EXEC sp_select_product_by_productid 1
--EXEC sp_select_product_by_productid 2
--EXEC sp_select_product_by_productid 3
--EXEC sp_select_orderdetails_by_orderid 2
--GO

