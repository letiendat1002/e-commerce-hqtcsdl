USE myecommerce
GO

-- UserOrder
-- Select All UserOrder
CREATE PROC sp_select_all_order
AS
BEGIN
	SELECT * FROM UserOrder
END
GO

--EXEC sp_select_all_order
--GO


-- Select All UserOrder By UserID
--DROP PROCEDURE sp_select_all_order_by_userid
CREATE PROC sp_select_all_order_by_userid
	@userid BIGINT
AS
BEGIN
	DECLARE @isExist BIT
	EXEC sp_exist_user_account_by_userid @userid, @isExist OUT
	IF (@isExist = 0)
		BEGIN
			PRINT 'UserAccount not exist by this UserID'
			RETURN
		END
	SELECT * FROM UserOrder WHERE UserID = @userid
END
GO

--EXEC sp_select_all_order_by_userid 4
--GO


-- Select One UserOrder By OrderID
CREATE PROC sp_select_order_by_orderid
	@id BIGINT
AS
BEGIN
	SELECT * FROM UserOrder WHERE OrderID = @id
END
GO

--EXEC sp_select_order_by_orderid 1
--GO


-- Add UserOrder
CREATE PROC sp_add_order
	@userid BIGINT,
	@aprice BIGINT,
	@pType VARCHAR(255),
	@address VARCHAR(255)
AS
BEGIN
	IF (@aprice IS NULL)
		BEGIN
			PRINT 'Additional price must not be null'
			RETURN
		END
	IF (@pType IS NULL)
		BEGIN
			PRINT 'Payment type must not be null'
			RETURN
		END
	IF (@address IS NULL)
		BEGIN
			PRINT 'Address must not be null'
			RETURN
		END

	IF (@pType != 'COD')
		BEGIN
			PRINT 'Payment type must be COD'
			RETURN
		END

	DECLARE @isExist BIT
	EXEC sp_exist_user_account_by_userid @userid, @isExist OUT
	IF (@isExist = 0)
		BEGIN
			PRINT 'UserAccount not exist by this UserID'
			RETURN
		END
	INSERT INTO UserOrder
	VALUES
		(@userid, @aprice, @pType, @address, 'PENDING', GETDATE(), null, null, null)

	PRINT 'Add order successfully'
END
GO

--EXEC sp_add_order 27, 10000, 'COD', '133 Nguyen Van A'
--GO


-- Exist UserOrder By OrderID
CREATE PROC sp_exist_order_by_orderid
	@id BIGINT, @isExist BIT OUTPUT
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM UserOrder WHERE OrderID = @id)
		SET @isExist = 0
	ELSE
		SET @isExist = 1
END
GO

--DECLARE @isExist BIT
--EXEC sp_exist_order_by_orderid 1, @isExist OUT
--SELECT @isExist


-- Exist UserOrder By OrderID And UserID
CREATE PROC sp_exist_order_by_orderid_and_userid
	@orderid BIGINT, @userid BIGINT, @isExist BIT OUTPUT
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM UserOrder WHERE OrderID = @orderid AND UserID = @userid)
		SET @isExist = 0
	ELSE
		SET @isExist = 1
END
GO

--DECLARE @isExist BIT
--EXEC sp_exist_order_by_orderid_and_userid 1,1, @isExist OUT
--SELECT @isExist


-- Select UserOrder Status
--DROP PROCEDURE sp_select_order_status_by_orderid
CREATE PROC sp_select_order_status_by_orderid
	@id BIGINT, @status VARCHAR(255) OUTPUT
AS
BEGIN
	DECLARE @isExist BIT
	EXEC sp_exist_order_by_orderid @id, @isExist OUT
	IF (@isExist = 0)
		BEGIN
			PRINT 'UserOrder not exist by this OrderID'
			RETURN
		END
	SELECT @status = Status FROM UserOrder WHERE OrderID = @id
END
GO

--DECLARE @orderstatus VARCHAR(255)
--EXEC sp_select_order_status_by_orderid 1, @orderstatus OUT
--SELECT @orderstatus
--GO


-- Transaction
-- Update UserOrder Status
-- DROP PROCEDURE sp_update_order_status_by_orderid
CREATE PROC sp_update_order_status_by_orderid
	@id BIGINT,
	@status VARCHAR(255)
AS
BEGIN
	IF (@status IS NULL)
		BEGIN
			PRINT 'Status must not be null'
			RETURN
		END
	IF (@status != 'PENDING' 
			AND @status != 'CONFIRMED' 
			AND @status != 'ON_SHIPPING' 
			AND @status != 'COMPLETED'
			AND @status != 'CANCELLED')
		BEGIN
			PRINT 'Status must be PENDING / CONFIRMED / ON_SHIPPING / COMPLETED / CANCELLED'
			RETURN
		END
	IF (@id IS NULL)
		BEGIN
			PRINT 'OrderID must be not null'
			RETURN
		END
	DECLARE @isExist BIT
	EXEC sp_exist_order_by_orderid @id, @isExist OUT
	IF (@isExist = 0)
		BEGIN
			PRINT 'Order not exist by this OrderID'
			RETURN
		END
	BEGIN TRANSACTION
	BEGIN TRY
		DECLARE @beforestatus VARCHAR(255)
		EXEC sp_select_order_status_by_orderid @id, @beforestatus OUT

		IF (@beforestatus != @status)
			BEGIN
				DECLARE @checkdate DATETIME
				IF (@status = 'PENDING' OR @status = 'CANCELLED')
					BEGIN
						UPDATE UserOrder
						SET Status = @status
						WHERE OrderID = @id
					END
				IF (@status = 'CONFIRMED')
					BEGIN
						SET @checkdate = NULL
						SELECT @checkdate = DateConfirmed FROM UserOrder WHERE OrderID = @id
						IF (@checkdate IS NULL)
							BEGIN
								DECLARE @dConfirmed DATETIME = GETDATE()
								UPDATE UserOrder
								SET Status = @status, DateConfirmed = @dConfirmed
								WHERE OrderID = @id
							END
						ELSE
							BEGIN
								UPDATE UserOrder
								SET Status = @status
								WHERE OrderID = @id
							END
					END
				IF (@status = 'ON_SHIPPING')
					BEGIN
						SET @checkdate = NULL
						SELECT @checkdate = DateShipping FROM UserOrder WHERE OrderID = @id
						IF (@checkdate IS NULL)
							BEGIN
								DECLARE @dShipping DATETIME = GETDATE()
								UPDATE UserOrder
								SET Status = @status, DateShipping = @dShipping
								WHERE OrderID = @id
							END
						ELSE
							BEGIN
								UPDATE UserOrder
								SET Status = @status
								WHERE OrderID = @id
							END
					END
				IF (@status = 'COMPLETED')
					BEGIN
						SET @checkdate = NULL
						SELECT @checkdate = DateCompleted FROM UserOrder WHERE OrderID = @id
						IF (@checkdate IS NULL)
							BEGIN
								DECLARE @dCompleted DATETIME = GETDATE()
								UPDATE UserOrder
								SET Status = @status, DateCompleted = @dCompleted
								WHERE OrderID = @id
							END
						ELSE
							BEGIN
								UPDATE UserOrder
								SET Status = @status
								WHERE OrderID = @id
							END
					END				
			END

		DECLARE @isBeforeStatusAbleToUpdateQuantity BIT = 0
		IF (@beforestatus = 'PENDING' 
			OR @beforestatus = 'CONFIRMED' 
			OR @beforestatus = 'ON_SHIPPING')
			BEGIN
				SET @isBeforeStatusAbleToUpdateQuantity = 1
			END

		IF (@isBeforeStatusAbleToUpdateQuantity = 1 AND @status = 'CANCELLED')
			BEGIN
				EXEC sp_update_product_quantity_when_order_cancelled @id
			END
		COMMIT TRANSACTION
		PRINT 'Update order status successfully'
	END TRY
	BEGIN CATCH
		PRINT 'Procedure sp_update_order_status perform failed'
		ROLLBACK TRANSACTION
	END CATCH
END
GO

--EXEC sp_select_order_by_orderid 5
--EXEC sp_select_orderdetails_by_orderid 6
--EXEC sp_select_product_by_productid 1
--EXEC sp_select_product_by_productid 2
--EXEC sp_select_product_by_productid 3
--EXEC sp_update_order_status_by_orderid 6, 'PENDING'
--EXEC sp_select_product_by_productid 1
--EXEC sp_select_product_by_productid 2
--EXEC sp_select_product_by_productid 3
--EXEC sp_select_order_by_orderid 1
--GO

-- Transaction
-- Delete UserOrder
CREATE PROC sp_delete_order
	@id BIGINT
AS
BEGIN
	IF (@id IS NULL)
		BEGIN
			PRINT 'OrderID must be not null'
			RETURN
		END
	DECLARE @isExist BIT
	EXEC sp_exist_order_by_orderid @id, @isExist OUT
	IF (@isExist = 0)
		BEGIN
			PRINT 'Order not exist by this OrderID'
			RETURN
		END
	BEGIN TRANSACTION
	BEGIN TRY
		DECLARE @status VARCHAR(255)
		EXEC sp_select_order_status_by_orderid @id, @status OUT

		IF (@status = 'PENDING' 
			OR @status = 'CONFIRMED' 
			OR @status = 'ON_SHIPPING')
			BEGIN
				EXEC sp_delete_all_orderdetail_by_orderid @id
			END
		DELETE FROM UserOrder WHERE OrderID = @id
		COMMIT TRANSACTION
		PRINT 'Delete order successfully'
	END TRY
	BEGIN CATCH
		PRINT 'Procedure sp_delete_order perform failed'
		ROLLBACK TRANSACTION
	END CATCH
END
GO

--EXEC sp_select_order_by_orderid 6
--EXEC sp_select_orderdetails_by_orderid 6
--EXEC sp_select_product_by_productid 1
--EXEC sp_select_product_by_productid 2
--EXEC sp_select_product_by_productid 3
--EXEC sp_delete_order 6
--EXEC sp_select_product_by_productid 1
--EXEC sp_select_product_by_productid 2
--EXEC sp_select_product_by_productid 3
--EXEC sp_select_order_by_orderid 6
--GO

-- Transaction
-- Delete All UserOrder By UserID
CREATE PROC sp_delete_all_order_by_userid
	@id BIGINT
AS
BEGIN
	IF (@id IS NULL)
		BEGIN
			PRINT 'UserID must be not null'
			RETURN
		END
	DECLARE @isExist BIT
	EXEC sp_exist_user_account_by_userid @id, @isExist OUT
	IF (@isExist = 0)
		BEGIN
			PRINT 'User not exist by this UserID'
			RETURN
		END
	BEGIN TRANSACTION
	BEGIN TRY
		DECLARE @tempid BIGINT
		SELECT @tempid = MIN(OrderID) FROM UserOrder WHERE UserID = @id
		WHILE (@tempid IS NOT NULL)
			BEGIN
				EXEC sp_delete_order @tempid
				SELECT @tempid = MIN(OrderID) FROM UserOrder WHERE UserID = @id AND OrderID > @tempid
			END
		COMMIT TRANSACTION
		PRINT 'Delete all orders by UserID successfully'
	END TRY
	BEGIN CATCH
		PRINT 'Procedure sp_delete_all_order_by_userid perform failed'
		ROLLBACK TRANSACTION
	END CATCH
END
GO

--EXEC sp_select_product_by_productid 1
--EXEC sp_delete_all_order_by_userid 19
--EXEC sp_select_product_by_productid 1
