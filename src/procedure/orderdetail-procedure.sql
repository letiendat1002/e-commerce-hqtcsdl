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
--GO


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

DECLARE @isExist BIT
EXEC sp_exist_orderdetail_by_orderdetailid 1, @isExist OUT
SELECT @isExist
GO


-- Add OrderDetail
CREATE PROC sp_add_orderdetail
	@orderid BIGINT, @productid BIGINT, @pprice BIGINT, @quantity INT
AS
BEGIN
	IF (@pprice IS NULL)
		BEGIN
			PRINT 'Purchase price must not be null'
			RETURN
		END
	IF (@quantity IS NULL)
		BEGIN
			PRINT 'Quantity must not be null'
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
END
GO


-- Update Product Quantity When Order Cancelled



-- Delete All OrderDetail By OrderID




