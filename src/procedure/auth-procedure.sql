USE myecommerce
GO

-- Auth
-- Transaction
-- Register
-- DROP PROCEDURE sp_register
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
				BEGIN
					PRINT 'This phone is already existed'
					RETURN
				END
			BEGIN TRANSACTION
			BEGIN TRY
				DECLARE @t nvarchar(4000)
				SET @t = N'CREATE LOGIN ' + QUOTENAME(@phone) + ' WITH PASSWORD = ' + QUOTENAME(@password, '''')
				EXEC(@t)
				SET @t = N'CREATE USER ' + QUOTENAME(@phone) + ' FROM LOGIN ' + QUOTENAME(@phone)
				EXEC(@t)
				SET @t = N'ALTER ROLE [customer] ADD MEMBER ' + QUOTENAME(@phone)
				EXEC(@t)
				INSERT INTO UserAccount
				VALUES
					(@phone, HASHBYTES('SHA2_256', @password), @name, @gender, 'CUSTOMER')
				COMMIT TRANSACTION
				PRINT 'Register successfully'
			END TRY
			BEGIN CATCH
				PRINT 'Procedure sp_register perform failed'
				ROLLBACK TRANSACTION
			END CATCH
		END
END
GO

EXEC sp_register '0867808506', 'password', 'Test Customer', 'Male'
GO


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
--EXEC sp_authenticate '0867808506', 'password', @isAuthenticated OUT
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

--EXEC sp_change_password '0867808506', 'password', 'newpassword'
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

--EXEC sp_reset_password '0867808506'
--GO