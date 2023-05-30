use myecommerce
go
-----------------
-- Create user --
-----------------
create login user_test with password = '1234'
create user user_test from login user_test

-- Create role user
USE [myecommerce]
GO
CREATE ROLE [user]
GO
USE [myecommerce]
GO
ALTER AUTHORIZATION ON SCHEMA::[db_owner] TO [user]
GO

-- User's role invole table
use [myecommerce]
GO
DENY UPDATE ON [dbo].[UserOrder] ([DateOrder]) TO [user]
GO
use [myecommerce]
GO
DENY UPDATE ON [dbo].[UserOrder] ([Status]) TO [user]
GO
use [myecommerce]
GO
GRANT UPDATE ON [dbo].[UserOrder] ([Address]) TO [user]
GO
use [myecommerce]
GO
GRANT DELETE ON [dbo].[UserOrder] TO [user]
GO
use [myecommerce]
GO
GRANT INSERT ON [dbo].[UserOrder] TO [user]
GO
use [myecommerce]
GO
GRANT SELECT ON [dbo].[UserOrder] TO [user]
GO
use [myecommerce]
GO
DENY UPDATE ON [dbo].[UserOrder] ([UserID]) TO [user]
GO
use [myecommerce]
GO
GRANT SELECT ON [dbo].[UserAccount] TO [user]
GO
use [myecommerce]
GO
GRANT UPDATE ON [dbo].[UserAccount] TO [user]
GO
use [myecommerce]
GO
DENY UPDATE ON [dbo].[UserOrder] ([OrderID]) TO [user]
GO
use [myecommerce]
GO
GRANT UPDATE ON [dbo].[UserOrder] ([PaymentType]) TO [user]
GO
use [myecommerce]
GO
DENY UPDATE ON [dbo].[UserOrder] ([AdditionalPrice]) TO [user]
GO
use [myecommerce]
GO
GRANT INSERT ON [dbo].[OrderDetail] TO [user]
GO
use [myecommerce]
GO
GRANT SELECT ON [dbo].[OrderDetail] TO [user]
GO
--Change password
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_change_password] TO [user]
GO


-- Add member in user's role
ALTER ROLE [user] ADD MEMBER [user_test]
GO

--------------------------------
-- Create user employee_table --
--------------------------------
create login employee_product with password = '1234'
create user employee_product from login employee_product

-- Create role employee
USE [myecommerce]
GO
CREATE ROLE [employee]
GO
USE [myecommerce]
GO
ALTER AUTHORIZATION ON SCHEMA::[db_owner] TO [employee]
GO

-- Employee's role invole table
use [myecommerce]
GO
GRANT INSERT ON [dbo].[OrderDetail] TO [employee]
GO
use [myecommerce]
GO
GRANT SELECT ON [dbo].[OrderDetail] TO [employee]
GO
use [myecommerce]
GO
GRANT UPDATE ON [dbo].[OrderDetail] TO [employee]
GO
use [myecommerce]
GO
GRANT DELETE ON [dbo].[Category] TO [employee]
GO
use [myecommerce]
GO
GRANT INSERT ON [dbo].[Category] TO [employee]
GO
use [myecommerce]
GO
GRANT SELECT ON [dbo].[Category] TO [employee]
GO
use [myecommerce]
GO
GRANT UPDATE ON [dbo].[Category] TO [employee]
GO
use [myecommerce]
GO
GRANT DELETE ON [dbo].[Product] TO [employee]
GO
use [myecommerce]
GO
GRANT INSERT ON [dbo].[Product] TO [employee]
GO
use [myecommerce]
GO
GRANT SELECT ON [dbo].[Product] TO [employee]
GO
use [myecommerce]
GO
GRANT UPDATE ON [dbo].[Product] TO [employee]
GO
use [myecommerce]
GO
GRANT DELETE ON [dbo].[UserAccount] TO [employee]
GO
use [myecommerce]
GO
GRANT INSERT ON [dbo].[UserAccount] TO [employee]
GO
use [myecommerce]
GO
GRANT SELECT ON [dbo].[UserAccount] TO [employee]
GO
use [myecommerce]
GO
GRANT UPDATE ON [dbo].[UserAccount] TO [employee]
GO
use [myecommerce]
GO
GRANT DELETE ON [dbo].[UserOrder] TO [employee]
GO
use [myecommerce]
GO
GRANT INSERT ON [dbo].[UserOrder] TO [employee]
GO
use [myecommerce]
GO
GRANT SELECT ON [dbo].[UserOrder] TO [employee]
GO
use [myecommerce]
GO
GRANT UPDATE ON [dbo].[UserOrder] TO [employee]
GO

-- Employee's role invole user
use [myecommerce]
GO
GRANT ALTER ON ROLE::[user] TO [employee]
GO
use [myecommerce]
GO
GRANT CONTROL ON ROLE::[user] TO [employee]
GO
use [myecommerce]
GO
GRANT TAKE OWNERSHIP ON ROLE::[user] TO [employee]
GO
use [myecommerce]
GO
GRANT VIEW DEFINITION ON ROLE::[user] TO [employee]
GO
use [myecommerce]
GO
GRANT ALTER ON ROLE::[employee] TO [employee]
GO
use [myecommerce]
GO
GRANT CONTROL ON ROLE::[employee] TO [employee]
GO
use [myecommerce]
GO
GRANT TAKE OWNERSHIP ON ROLE::[employee] TO [employee]
GO
use [myecommerce]
GO
DENY VIEW DEFINITION ON ROLE::[employee] TO [employee]
GO
-- Change password
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_change_password] TO [employee]
GO

-- Add member in employee's role
USE [myecommerce]
GO
ALTER ROLE [employee] ADD MEMBER [employee_product]
GO

------------------------------
-- Create user admin_system --
------------------------------
create login admin_test with password = '1234'
create user admin_test from login admin_test


-- Create role admin_db
use [myecommerce]
GO
CREATE ROLE [admin_db] 
GO

-- Set role admin_db
use [myecommerce]
GO
exec sp_addrolemember db_owner, admin_db

-- Add member in admin_db's role
exec sp_addrolemember admin_db, admin_test