USE myecommerce
GO

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