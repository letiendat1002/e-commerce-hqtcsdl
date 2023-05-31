USE myecommerce
GO

-- Auth
-- Register
CREATE PROC sp_register
	@phone VARCHAR(255),
	@password VARCHAR(255),
	@name VARCHAR(255),
	@gender VARCHAR(255)
AS
BEGIN
	IF (@gender != 'Male' AND @gender != 'Female' AND @gender != 'Other')
		PRINT 'Gender must be Male / Female / Other'
	ELSE
		BEGIN
			DECLARE @isExist BIT
			EXEC sp_exist_user_account_by_phone @phone, @isExist OUT
			IF (@isExist = 1)
				PRINT 'This phone is already existed'
			ELSE
				INSERT INTO UserAccount
				VALUES
					(@phone, HASHBYTES('SHA2_256', @password), @name, @gender, 'CUSTOMER')
		END
END
GO

--EXEC sp_register '5555555555', 'password', 'New5', 'Male'
--GO


-- Authenticate (Login)
CREATE PROC sp_authenticate
	@phone VARCHAR(255), @password VARCHAR(255), @isAuthenticated BIT OUTPUT
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM UserAccount WHERE Phone = @phone AND Password = HASHBYTES('SHA2_256', @password))
		SET @isAuthenticated = 0
	ELSE
		SET @isAuthenticated = 1
END
GO

--DECLARE @isAuthenticated BIT
--EXEC sp_authenticate '1111111111', 'password', @isAuthenticated OUT
--SELECT @isAuthenticated
--GO


-- Change Passsword
CREATE PROC sp_change_password
	@phone VARCHAR(255),
	@oldpassword VARCHAR(255),
	@newpassword VARCHAR(255)
AS
BEGIN
	DECLARE @isAuthenticated BIT
	EXEC sp_authenticate @phone, @oldpassword, @isAuthenticated OUT
	IF (@isAuthenticated = 0)
		PRINT 'Username or Password is invalid'
	ELSE
		BEGIN
		UPDATE UserAccount
		SET Password = HASHBYTES('SHA2_256', @newpassword)
		WHERE Phone = @phone

		PRINT 'Change password successfully'
	END
END
GO

--EXEC sp_change_password '1111111111', 'password', 'newpassword'
--GO


-- Reset Password
CREATE PROC sp_reset_password
	@phone VARCHAR(255)
AS
BEGIN
	DECLARE @newpassword VARCHAR(40) = SUBSTRING(CONVERT(varchar(40), NEWID()),0,9)
	UPDATE UserAccount
	SET Password = HASHBYTES('SHA2_256', @newpassword)
	WHERE Phone = @phone

	SELECT @newpassword
END
GO

--EXEC sp_reset_password '1111111111'
--GO



-- UserAccount
-- Select All UserAccount
CREATE PROC sp_select_all_user_account
AS
BEGIN
	SELECT * FROM UserAccount
END
GO

--EXEC sp_select_all_user_account
--GO


-- Select UserAccounts By Role
CREATE PROC sp_select_user_accounts_by_role
	@role VARCHAR(255)
AS
BEGIN
	IF (@role != 'ADMIN' AND @role != 'EMPLOYEE' AND @role != 'CUSTOMER')
		PRINT 'Role must be ADMIN / EMPLOYEE / CUSTOMER'
	ELSE
		SELECT * FROM UserAccount WHERE Role = @role
END
GO

-- EXEC sp_select_user_accounts_by_role 'CUSTOMER'
--GO


-- Select One UserAccount By UserID
CREATE PROC sp_select_user_account_by_userid
	@id BIGINT
AS
BEGIN
	SELECT * FROM UserAccount WHERE UserID = @id
END
GO

--EXEC sp_select_user_account_by_userid 1
--GO


-- Select One UserAccount By Phone
CREATE PROC sp_select_user_account_by_phone
	@phone VARCHAR(255)
AS
BEGIN
	SELECT * FROM UserAccount WHERE Phone = @phone
END
GO

--EXEC sp_select_user_account_by_phone '1111111111'
--GO


-- Exist UserAccount By UserID
CREATE PROC sp_exist_user_account_by_userid
	@id BIGINT, @isExist BIT OUTPUT
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM UserAccount WHERE UserID = @id)
		SET @isExist = 0
	ELSE
		SET @isExist = 1
END
GO

--DECLARE @isExist BIT
--EXEC sp_exist_user_account_by_userid 1, @isExist OUT
--SELECT @isExist
--GO


-- Exist UserAccount By Phone
CREATE PROC sp_exist_user_account_by_phone
	@phone VARCHAR(255), @isExist BIT OUTPUT
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM UserAccount WHERE Phone = @phone)
		SET @isExist = 0
	ELSE
		SET @isExist = 1
END
GO

--DECLARE @isExist BIT
--EXEC sp_exist_user_account_by_phone '1111111111', @isExist OUT
--SELECT @isExist
--GO


-- Add UserAccount
CREATE PROC sp_add_user_account
	@phone VARCHAR(255),
	@password VARCHAR(255),
	@name VARCHAR(255),
	@gender VARCHAR(255),
	@role VARCHAR(255)
AS
BEGIN
	IF (@gender != 'Male' AND @gender != 'Female' AND @gender != 'Other')
		PRINT 'Gender must be Male / Female / Other';
	ELSE IF (@role != 'ADMIN' AND @role != 'EMPLOYEE' AND @role != 'CUSTOMER')
		PRINT 'Role must be ADMIN / EMPLOYEE / CUSTOMER'
	ELSE
		BEGIN
			DECLARE @isExist BIT
			EXEC sp_exist_user_account_by_phone @phone, @isExist OUT
			IF (@isExist = 1)
				PRINT 'This phone is already existed'
			ELSE
				BEGIN
					INSERT INTO UserAccount
					VALUES
						(@phone, HASHBYTES('SHA2_256', @password), @name, @gender, @role)

					PRINT 'Add user account successfully'
				END
		END
END
GO

--EXEC sp_add_user_account '9999999999', 'password', 'customer', 'Other', 'CUSTOMER'
--GO


-- Update UserAccount Info By UserID
CREATE PROC sp_update_user_account_info_by_userid
	@userid BIGINT,
	@name VARCHAR(255),
	@gender VARCHAR(255)
AS
BEGIN
	IF (@gender != 'Male' AND @gender != 'Female' AND @gender != 'Other')
		PRINT 'Gender must be Male / Female / Other';
	ELSE
		BEGIN
			DECLARE @isExist BIT
			EXEC sp_exist_user_account_by_userid @userid, @isExist OUT
			IF (@isExist = 0)
				PRINT 'UserAccount not exist by this UserID'
			ELSE
				BEGIN
					UPDATE UserAccount
					SET
						Name = @name, Gender = @gender
					WHERE
						UserID = @userid

					PRINT 'Update user account info successfully'
				END
		END
END
GO

--EXEC sp_select_user_account_by_userid 2
--EXEC sp_update_user_account_info_by_userid 2, 'user-new-name', 'Male'
--EXEC sp_select_user_account_by_userid 2
--GO


-- Update UserAccount Info By Phone
CREATE PROC sp_update_user_account_info_by_phone
	@phone VARCHAR(255),
	@name VARCHAR(255),
	@gender VARCHAR(255)
AS
BEGIN
	IF (@gender != 'Male' AND @gender != 'Female' AND @gender != 'Other')
		PRINT 'Gender must be Male / Female / Other';
	ELSE
		BEGIN
			DECLARE @isExist BIT
			EXEC sp_exist_user_account_by_phone @phone, @isExist OUT
			IF (@isExist = 0)
				PRINT 'UserAccount not exist by this Phone number'
			ELSE
				BEGIN
					UPDATE UserAccount
					SET
						Name = @name, Gender = @gender
					WHERE
						Phone = @phone

					PRINT 'Update user account info successfully'
				END
		END
END
GO

--EXEC sp_select_user_account_by_phone '1111111111'
--EXEC sp_update_user_account_info_by_phone '1111111111', 'new-name', 'Female'
--EXEC sp_select_user_account_by_phone '1111111111'
--GO


-- Update UserAccount Role By UserID
CREATE PROC sp_update_user_account_role_by_userid
	@userid BIGINT,
	@newrole VARCHAR(255)
AS
BEGIN
	IF (@newrole != 'ADMIN' AND @newrole != 'EMPLOYEE' AND @newrole != 'CUSTOMER')
		PRINT 'Role must be ADMIN / EMPLOYEE / CUSTOMER'
	ELSE
		BEGIN
			DECLARE @isExist BIT
			EXEC sp_exist_user_account_by_userid @userid, @isExist OUT
			IF (@isExist = 0)
				PRINT 'UserAccount not exist by this UserID'
			ELSE
				BEGIN
					UPDATE UserAccount
					SET Role = @newrole
					WHERE UserID = @userid

					PRINT 'Update role successfully'
				END
		END
END
GO

--EXEC sp_select_user_account_by_userid 2
--EXEC sp_update_user_account_role_by_userid 2, 'CUSTOMER'
--EXEC sp_select_user_account_by_userid 2
--GO


-- Update UserAccount Role By Phone
CREATE PROC sp_update_user_account_role_by_phone
	@phone VARCHAR(255),
	@newrole VARCHAR(255)
AS
BEGIN
	IF (@newrole != 'ADMIN' AND @newrole != 'EMPLOYEE' AND @newrole != 'CUSTOMER')
		PRINT 'Role must be ADMIN / EMPLOYEE / CUSTOMER'
	ELSE
		BEGIN
			DECLARE @isExist BIT
			EXEC sp_exist_user_account_by_phone @phone, @isExist OUT
			IF (@isExist = 0)
				PRINT 'UserAccount not exist by this Phone number'
			ELSE
				BEGIN
					UPDATE UserAccount
					SET Role = @newrole
					WHERE Phone = @phone

					PRINT 'Update role successfully'
				END
		END
END
GO

--EXEC sp_select_user_account_by_phone '1111111111'
--EXEC sp_update_user_account_role_by_phone '1111111111', 'EMPLOYEE'
--EXEC sp_select_user_account_by_phone '1111111111'
--GO

-- Transaction
-- Delete UserAccount By UserID
CREATE PROC sp_delete_user_account_by_userid
	@userid BIGINT
AS
BEGIN
	DECLARE @isExist BIT
	EXEC sp_exist_user_account_by_userid @userid, @isExist OUT
	IF (@isExist = 0)
		PRINT 'UserAccount not exist by this UserID'
	ELSE
		BEGIN
			DELETE FROM UserAccount
			WHERE UserID = @userid

			PRINT 'Delete user account successfully'
		END
END
GO

--EXEC sp_delete_user_account_by_userid 30
--GO


-- Delete UserAccount By Phone
CREATE PROC sp_delete_user_account_by_phone
	@phone VARCHAR(255)
AS
BEGIN
	DECLARE @isExist BIT
	EXEC sp_exist_user_account_by_phone @phone, @isExist OUT
	IF (@isExist = 0)
		PRINT 'UserAccount not exist by this Phone number'
	ELSE
		BEGIN
			DELETE FROM UserAccount
			WHERE Phone = @phone

			PRINT 'Delete user account successfully'
		END
END
GO

--EXEC sp_delete_user_account_by_phone '9999999999'
--GO



-- UserAddress
-- Select All UserAddress
CREATE PROC sp_select_all_user_address
AS
BEGIN
	SELECT * FROM UserAddress
END
GO

--EXEC sp_select_all_user_address
--GO


-- Select All UserAddress By UserID
CREATE PROC sp_select_all_user_address_by_userid
	@id BIGINT
AS
BEGIN
	SELECT * FROM UserAddress WHERE UserID = @id
END
GO

--EXEC sp_select_all_user_address_by_userid 1
--GO


-- Select One UserAddress By UserAddressID
CREATE PROC sp_select_user_address_by_useraddressid
	@useraddressid BIGINT
AS
BEGIN
	SELECT * FROM UserAddress WHERE UserAddressID = @useraddressid
END
GO

-- EXEC sp_select_user_address_by_useraddressid 1
--GO


-- Exist UserAddress By UserAddressID
CREATE PROC sp_exist_user_address_by_useraddressid
	@id BIGINT, @isExist BIT OUTPUT
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM UserAddress WHERE UserAddressID = @id)
		SET @isExist = 0
	ELSE
		SET @isExist = 1
END
GO

--DECLARE @isExist BIT
--EXEC sp_exist_user_address_by_useraddressid 1, @isExist OUT
--SELECT @isExist
--GO


-- Add UserAddress
CREATE PROC sp_add_user_address
	@userid BIGINT,
	@address VARCHAR(255)
AS
BEGIN
	DECLARE @isExist BIT
	EXEC sp_exist_user_account_by_userid @userid, @isExist OUT
	IF (@isExist = 0)
		PRINT 'User not exist by this UserID'
	ELSE
		BEGIN
			INSERT INTO UserAddress
			VALUES
				(@userid, @address)

			PRINT 'Add user address successfully'
		END
END
GO

--EXEC sp_add_user_address 2, '111 Le Van A'
--GO


-- Update UserAddress
CREATE PROC sp_update_useraddress
	@id BIGINT,
	@address VARCHAR(255)
AS
BEGIN
	DECLARE @isExist BIT
	EXEC sp_exist_user_address_by_useraddressid @id, @isExist OUT
	IF (@isExist = 0)
		PRINT 'UserAddress not exist by this UserAddressID'
	ELSE
		BEGIN
			UPDATE UserAddress
			SET Address = @address
			WHERE UserAddressID = @id

			PRINT 'Update UserAddress successfully'
		END
END
GO

--EXEC sp_select_user_address_by_useraddressid 1
--EXEC sp_update_useraddress 1, 'new-address'
--EXEC sp_select_user_address_by_useraddressid 1
--GO


-- Delete UserAddress
CREATE PROC sp_delete_user_address
	@id BIGINT
AS
BEGIN
	DECLARE @isExist BIT
	EXEC sp_exist_user_address_by_useraddressid @id, @isExist OUT
	IF (@isExist = 0)
		PRINT 'UserAddress not exist by this UserAddressID'
	ELSE
		BEGIN
			DELETE FROM UserAddress
			WHERE UserAddressID = @id

			PRINT 'Delete user address successfully'
		END
END
GO

--EXEC sp_delete_user_address 1
--GO



-- Category
-- Select All Category
CREATE PROC sp_select_all_category
AS
BEGIN
	SELECT * FROM Category
END
GO

--EXEC sp_select_all_category
--GO


-- Select One Category By CategoryID
CREATE PROC sp_select_category_by_categoryid
	@id BIGINT
AS
BEGIN
	SELECT * FROM Category WHERE CategoryID = @id
END
GO

--EXEC sp_select_category_by_categoryid 1
--GO


-- Exist Category By CategoryID
CREATE PROC sp_exist_category_by_categoryid
	@id BIGINT, @isExist BIT OUTPUT
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM Category WHERE CategoryID = @id)
		SET @isExist = 0
	ELSE
		SET @isExist = 1
END
GO

--DECLARE @isExist BIT
--EXEC sp_exist_category_by_categoryid 1, @isExist OUT
--SELECT @isExist
--GO


-- Add Category
CREATE PROC sp_add_category
	@name VARCHAR(255)
AS
BEGIN
	INSERT INTO Category
	VALUES
		(@name)

	PRINT 'Add category successfully'
END
GO

--EXEC sp_add_category 'tai nghe'
--GO


-- Update Category
CREATE PROC sp_update_category
	@id BIGINT, @name VARCHAR(255)
AS
BEGIN
	UPDATE Category
	SET Name = @name
	WHERE CategoryID = @id

	PRINT 'Update category successfully'
END
GO

--EXEC sp_select_category_by_categoryid 1
--EXEC sp_update_category 1, 'laptop-new'
--EXEC sp_select_category_by_categoryid 1
--GO


-- Delete Category
CREATE PROC sp_delete_category
	@id BIGINT
AS
BEGIN
	DECLARE @isExist BIT
	EXEC sp_exist_category_by_categoryid @id, @isExist OUT
	IF (@isExist = 0)
		PRINT 'Category not exist by this CategoryID'
	ELSE
		BEGIN
			DELETE FROM Category
			WHERE CategoryID = @id

			PRINT 'Delete category successfully'
		END
END
GO

--EXEC sp_delete_category 1
--GO



-- Product
-- Select All Product
CREATE PROC sp_select_all_product
AS
BEGIN
	SELECT * FROM Product
END
GO

--EXEC sp_select_all_product
--GO

-- Select All Product By CategoryID
CREATE PROC sp_select_products_by_categoryid
	@id BIGINT
AS
BEGIN
	SELECT * FROM Product WHERE CategoryID = @id
END
GO

--EXEC sp_select_products_by_categoryid 1
--GO


-- Select One Product By ProductID
CREATE PROC sp_select_product_by_productid
	@id BIGINT
AS
BEGIN
	SELECT * FROM Product WHERE ProductID = @id
END
GO

--EXEC sp_select_product_by_productid 1
--GO


-- Exist Product By ProductID
CREATE PROC sp_exist_product_by_productid
	@id BIGINT, @isExist BIT OUTPUT
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM Product WHERE ProductID = @id)
		SET @isExist = 0
	ELSE
		SET @isExist = 1
END
GO

--DECLARE @isExist BIT
--EXEC sp_exist_product_by_productid 1, @isExist OUT
--SELECT @isExist
--GO


-- Add Product
CREATE PROC sp_add_product
	@categoryid BIGINT,
	@name VARCHAR(255),
	@unitprice BIGINT,
	@quantity INT,
	@discount INT,
	@description NVARCHAR(MAX)
AS
BEGIN
	IF (@unitprice < 0)
		PRINT 'Unit price must be > 0'
	ELSE IF (@quantity < 0)
		PRINT 'Quantity must be > 0'
	ELSE IF (@discount < 0 OR @discount > 100)
		PRINT 'Discount must be between 0 and 100'
	ELSE
		BEGIN
			DECLARE @isExist BIT
			EXEC sp_exist_category_by_categoryid @categoryid, @isExist OUT
			IF (@isExist = 0)
				PRINT 'Category not exist by this CategoryID'
			ELSE
				BEGIN
					INSERT INTO Product
					VALUES
						(@categoryid,
						ISNULL(@name, ''),
						ISNULL(@unitprice, 0),
						ISNULL(@quantity, 0),
						ISNULL(@discount, 0),
						ISNULL(@description, ''))

					PRINT 'Add product successfully'
				END
		END
END
GO

--EXEC sp_add_product 1, 'test-name', 1000000, 120, 20, 'Test description'
--GO


-- Update Product All
CREATE PROC sp_update_product_all
	@id BIGINT,
	@name VARCHAR(255),
	@unitprice BIGINT,
	@quantity INT,
	@discount INT,
	@description NVARCHAR(MAX)
AS
BEGIN
	IF (@unitprice < 0)
		PRINT 'Unit price must be > 0'
	ELSE IF (@quantity < 0)
		PRINT 'Quantity must be > 0'
	ELSE IF (@discount < 0 OR @discount > 100)
		PRINT 'Discount must be between 0 and 100'
	ELSE
		BEGIN
			DECLARE @isExist BIT
			EXEC sp_exist_product_by_productid @id, @isExist OUT
			IF (@isExist = 0)
				PRINT 'Product not exist by this ProductID'
			ELSE
				BEGIN
					UPDATE Product
					SET
						Name = ISNULL(@name, ''),
						UnitPrice = ISNULL(@unitprice, 0),
						Quantity = ISNULL(@quantity, 0),
						Discount = ISNULL(@discount, 0),
						Description = ISNULL(@description, '')
					WHERE
						ProductID = @id

					PRINT 'Update product successfully'
				END
		END
END
GO

--EXEC sp_update_product_all 41, 'new-name', 1, 1, 1, 'new-description'
--GO


-- Update Product Name
CREATE PROC sp_update_product_name
	@id BIGINT,
	@name VARCHAR(255)
AS
BEGIN
	DECLARE @isExist BIT
	EXEC sp_exist_product_by_productid @id, @isExist OUT
	IF (@isExist = 0)
		PRINT 'Product not exist by this ProductID'
	ELSE
		BEGIN
			UPDATE Product
			SET
				Name = ISNULL(@name, '')
			WHERE
				ProductID = @id

			PRINT 'Update product name successfully'
		END
END
GO

--EXEC sp_select_product_by_productid 41
--EXEC sp_update_product_name 41, 'new-name'
--EXEC sp_select_product_by_productid 41
--GO

-- Update Product Unit Price
CREATE PROC sp_update_product_unit_price
	@id BIGINT,
	@unitprice BIGINT
AS
BEGIN
	IF (@unitprice < 0)
		PRINT 'Unit price must be > 0'
	ELSE
		BEGIN
			DECLARE @isExist BIT
			EXEC sp_exist_product_by_productid @id, @isExist OUT
			IF (@isExist = 0)
				PRINT 'Product not exist by this ProductID'
			ELSE
				BEGIN
					UPDATE Product
					SET
						UnitPrice = ISNULL(@unitprice,0)
					WHERE
						ProductID = @id

					PRINT 'Update product unit price successfully'
				END
		END
END
GO

--EXEC sp_select_product_by_productid 41
--EXEC sp_update_product_unit_price 41, 2500000
--EXEC sp_select_product_by_productid 41
--GO

-- Update Product Quantity
CREATE PROC sp_update_product_quantity
	@id BIGINT,
	@quantity INT
AS
BEGIN
	IF (@quantity < 0)
		PRINT 'Quantity must be > 0'
	ELSE
		BEGIN
			DECLARE @isExist BIT
			EXEC sp_exist_product_by_productid @id, @isExist OUT
			IF (@isExist = 0)
				PRINT 'Product not exist by this ProductID'
			ELSE
				BEGIN
					UPDATE Product
					SET
						Quantity = ISNULL(@quantity, 0)
					WHERE
						ProductID = @id

					PRINT 'Update product quantity successfully'
				END
		END
END
GO

--EXEC sp_select_product_by_productid 41
--EXEC sp_update_product_quantity 41, 150
--EXEC sp_select_product_by_productid 41
--GO

-- Update Product Discount
CREATE PROC sp_update_product_discount
	@id BIGINT,
	@discount INT
AS
BEGIN
	IF (@discount < 0 OR @discount > 100)
		PRINT 'Discount must be between 0 and 100'
	ELSE
		BEGIN
			DECLARE @isExist BIT
			EXEC sp_exist_product_by_productid @id, @isExist OUT
			IF (@isExist = 0)
				PRINT 'Product not exist by this ProductID'
			ELSE
				BEGIN
					UPDATE Product
					SET
						Discount = ISNULL(@discount, 0)
					WHERE
						ProductID = @id

					PRINT 'Update product discount successfully'
				END
		END
END
GO

--EXEC sp_select_product_by_productid 41
--EXEC sp_update_product_discount 41, 33
--EXEC sp_select_product_by_productid 41
--GO


-- Update Product Description
CREATE PROC sp_update_product_description
	@id BIGINT,
	@description NVARCHAR(MAX)
AS
BEGIN
	DECLARE @isExist BIT
	EXEC sp_exist_product_by_productid @id, @isExist OUT
	IF (@isExist = 0)
		PRINT 'Product not exist by this ProductID'
	ELSE
		BEGIN
			UPDATE Product
			SET
				Description = ISNULL(@description, '')
			WHERE
				ProductID = @id

			PRINT 'Update product description successfully'
		END
END
GO

--EXEC sp_select_product_by_productid 41
--EXEC sp_update_product_description 41, 'new-description'
--EXEC sp_select_product_by_productid 41
--GO


-- Delete Product
CREATE PROC sp_delete_product
	@id BIGINT
AS
BEGIN
	DECLARE @isExist BIT
	EXEC sp_exist_product_by_productid @id, @isExist OUT
	IF (@isExist = 0)
		PRINT 'Product not exist by this ProductID'
	ELSE
		BEGIN
			DELETE FROM Product
			WHERE ProductID = @id

			PRINT 'Delete product successfully'
		END	
END
GO

--EXEC sp_delete_product 41
--GO


-- Select Product Quantity
CREATE PROC sp_select_product_quantity_by_productid
	@id BIGINT,
	@quantity INT OUTPUT
AS
BEGIN
	SELECT @quantity = Quantity
	FROM Product
	WHERE ProductID = @id
END
GO

--DECLARE @quantity INT
--EXEC sp_select_product_quantity_by_productid 40, @quantity OUT
--print @quantity


-- Update Product Quantity By Amount
CREATE PROC sp_update_product_quantity_by_amount
	@id BIGINT,
	@amount INT
AS
BEGIN
	DECLARE @isExist BIT
	EXEC sp_exist_product_by_productid @id, @isExist OUT
	IF (@isExist = 0)
		PRINT 'Product not exist by this ProductID'
	ELSE
		BEGIN
			DECLARE @quantity INT
			EXEC sp_select_product_quantity_by_productid 40, @quantity OUT
			IF (@amount < 0)
				BEGIN
					DECLARE @absoluteAmount INT = ABS(@amount)
					IF (@quantity < @absoluteAmount)
						BEGIN
							PRINT 'Product quantity in stock is not enough'
							RETURN;
						END
				END
			UPDATE Product
			SET Quantity = (@quantity + @amount)
			WHERE ProductID = @id
		END	
END
GO

--EXEC sp_select_product_by_productid 40
--EXEC sp_update_product_quantity_by_amount 40, -10
--EXEC sp_select_product_by_productid 40
--GO



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


-- Select All UserOrder By OrderStatus
CREATE PROC sp_select_all_order_by_status
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
	SELECT * FROM UserOrder WHERE Status = @status
END
GO

--EXEC sp_select_all_order_by_status 'PENDING'
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

--EXEC sp_add_order 4, 10000, 'COD', '133 Nguyen Van A'
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
CREATE PROC sp_update_order_status
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
	
	DECLARE @beforestatus VARCHAR(255)
	EXEC sp_select_order_status_by_orderid @id, @beforestatus OUT

	IF (@beforestatus != @status AND @status = 'CONFIRMED')
		BEGIN
			DECLARE @dConfirmed DATETIME = GETDATE()
			UPDATE UserOrder
			SET Status = @status, DateConfirmed = @dConfirmed
			WHERE OrderID = @id
		END
	IF (@beforestatus != @status AND @status = 'ON_SHIPPING')
		BEGIN
			DECLARE @dShipping DATETIME = GETDATE()
			UPDATE UserOrder
			SET Status = @status, DateShipping = @dShipping
			WHERE OrderID = @id
		END
	IF (@beforestatus != @status AND @status = 'COMPLETED')
		BEGIN
			DECLARE @dCompleted DATETIME = GETDATE()
			UPDATE UserOrder
			SET Status = @status, DateCompleted = @dCompleted
			WHERE OrderID = @id
		END

	DECLARE @isBeforeStatusAbleToUpdateQuantity BIT = 0
	IF (@beforestatus = 'PENDING' 
		OR @beforestatus = 'CONFIRMED' 
		OR @beforestatus = 'ON_SHIPPING')
		BEGIN
			SET @isBeforeStatusAbleToUpdateQuantity = 1
		END

	--IF (@isBeforeStatusAbleToUpdateQuantity = 1 AND @status = 'CANCELLED')
		-- TODO: OrderDetail update product quantity when Order cancelled

	PRINT 'Update order status successfully'
END
GO


-- Transaction
-- Delete UserOrder


-- Transaction
-- Delete All UserOrder By UserID




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




