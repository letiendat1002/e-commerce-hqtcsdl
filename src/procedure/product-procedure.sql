USE myecommerce
GO

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
--DROP PROCEDURE sp_update_product_quantity_by_amount
CREATE PROC sp_update_product_quantity_by_amount
	@id BIGINT,
	@amount INT
AS
BEGIN
	DECLARE @isExist BIT
	EXEC sp_exist_product_by_productid @id, @isExist OUT
	IF (@isExist = 0)
		BEGIN
			PRINT 'Product not exist by this ProductID'
			;THROW 50000, '', 1;
		END
	DECLARE @quantity INT
	SELECT @quantity = Quantity FROM Product WHERE ProductID = @id

	IF (@amount < 0)
		BEGIN
			DECLARE @absoluteAmount INT = ABS(@amount)
			IF (@quantity < @absoluteAmount)
				BEGIN
					PRINT 'Product quantity in stock is not enough'
					;THROW 50000, '', 1; 
				END
		END
	DECLARE @newquantity INT = @quantity + @amount

	UPDATE Product
	SET Quantity = @newquantity
	WHERE ProductID = @id
END
GO

--EXEC sp_select_product_by_productid 5
--EXEC sp_update_product_quantity_by_amount 5, -1000
--EXEC sp_select_product_by_productid 5
--GO

