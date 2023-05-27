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

--EXEC sp_register '5555555555', 'password', 'New5', 'Male';


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

--EXEC sp_change_password '1111111111', 'password', 'newpassword';


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

--EXEC sp_reset_password '1111111111';


-- UserAccount
-- Select All UserAccount
CREATE PROC sp_select_all_user_account
AS
BEGIN
	SELECT * FROM UserAccount
END
GO

--EXEC sp_select_all_user_account;


-- Select UserAccounts By Role
CREATE PROC sp_select_user_accounts_by_role
	@Role VARCHAR(255)
AS
BEGIN
	SELECT * FROM UserAccount WHERE Role = @Role
END
GO

--EXEC sp_select_user_accounts_by_role 'CUSTOMER';


-- Select One UserAccount By UserID
CREATE PROC sp_select_user_account_by_userid
	@id BIGINT
AS
BEGIN
	SELECT * FROM UserAccount WHERE UserID = @id
END
GO

--EXEC sp_select_user_account_by_userid 1;


-- Select One UserAccount By Phone
CREATE PROC sp_select_user_account_by_phone
	@phone VARCHAR(255)
AS
BEGIN
	SELECT * FROM UserAccount WHERE Phone = @phone
END
GO

--EXEC sp_select_user_account_by_phone '1111111111';


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
	ELSE
		BEGIN
			DECLARE @isExist BIT
			EXEC sp_exist_user_account_by_phone @phone, @isExist OUT
			IF (@isExist = 1)
				PRINT 'This phone is already existed'
			ELSE
				INSERT INTO UserAccount
				VALUES
					(@phone, HASHBYTES('SHA2_256', @password), @name, @gender, @role)

				PRINT 'Add user account successfully'
		END
END
GO

--EXEC sp_add_user_account '6666666666', 'password', 'customer', 'Other', 'CUSTOMER';


-- Update UserAccount Info
CREATE PROC sp_update_user_account_info
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
				UPDATE UserAccount
				SET
					Name = @name, Gender = @gender
				WHERE
					Phone = @phone

				PRINT 'Update user account info successfully'
		END
END
GO

--DROP PROCEDURE sp_update_user_account_info;
--EXEC sp_select_user_account_by_phone '1111111111';
--EXEC sp_update_user_account_info '1111111111', 'employee1-new-name', 'Female';
--EXEC sp_select_user_account_by_phone '1111111111';


-- Update UserAccount Role
CREATE PROC sp_update_user_account_role
	@phone VARCHAR(255),
	@newrole VARCHAR(255)
AS
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
GO

--EXEC sp_update_user_account_role '1111111111', 'CUSTOMER';


-- Delete UserAccount
CREATE PROC sp_delete_user_account
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

--EXEC sp_delete_user_account '5555555555';


-- UserAddress
-- Select All UserAddress


-- Select All UserAddress By UserID


-- Select One UserAddress By UserAddressID


-- Add UserAddress


-- Update UserAddress


-- Delete UserAddress



-- Category
-- Select All Category


-- Select One Category By CategoryID


-- Add Category


-- Update Category


-- Delete Category


-- Exist Category By CategoryID



-- Product
-- Select All Product


-- Select All Product By CategoryID


-- Select One Product By ProductID


-- Add Product


-- Update Product


-- Delete Product


-- Exist Product By ProductID


-- Update Product Quantity By Amount



-- UserOrder
-- Select All UserOrder


-- Select All UserOrder By UserID


-- Select All UserOrder By OrderStatus


-- Select One UserOrder By OrderID


-- Add UserOrder


-- Update UserOrder


-- Delete UserOrder


-- Exist UserOrder By OrderID


-- Exist UserOrder By OrderID And User


-- Delete All UserOrder By UserID



-- OrderDetail
-- Select All OrderDetail


-- Select All OrderDetail By OrderID


-- Select All OrderDetail By ProductID


-- Select One OrderDetail By OrderDetailID


-- Select One OrderDetail By OrderID And ProductID


-- Add OrderDetail


-- Update Product Quantity When Order Cancelled


-- Delete All OrderDetail By OrderID


-- Exist OrderDetail By OrderDetailID




