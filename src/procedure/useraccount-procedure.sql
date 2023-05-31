USE myecommerce
GO

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
-- DROP PROCEDURE sp_delete_user_account_by_userid
CREATE PROC sp_delete_user_account_by_userid
	@id BIGINT
AS
BEGIN
	IF (@id IS NULL)
		BEGIN
			PRINT 'UserID must not be null'
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
		EXEC sp_delete_all_order_by_userid @id
		DELETE FROM UserAccount
		WHERE UserID = @id
		COMMIT TRANSACTION
		PRINT 'Delete user successfully'
	END TRY
	BEGIN CATCH
		PRINT 'Procedure sp_delete_user_account_by_userid perform failed'
		ROLLBACK TRANSACTION
	END CATCH
END
GO

EXEC sp_select_all_order_by_userid 27
EXEC sp_select_product_by_productid 1
EXEC sp_delete_user_account_by_userid 27
EXEC sp_select_product_by_productid 1
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