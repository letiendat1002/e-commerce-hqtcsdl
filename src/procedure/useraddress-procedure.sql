USE myecommerce
GO

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
