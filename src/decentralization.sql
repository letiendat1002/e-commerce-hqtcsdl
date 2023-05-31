use myecommerce
go
-----------------
-- Create user --
-----------------
create login user_test with password = '1234'
create user user_test from login user_test

create login employee_product with password = '1234'
create user employee_product from login employee_product

create login admin_test with password = '1234'
create user admin_test from login admin_test

-- Create role customer
USE [myecommerce]
GO
CREATE ROLE [customer]
GO

-- Set role customer
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_order_by_orderid] TO [customer]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_user_account_by_phone] TO [customer]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_update_user_account_info_by_phone] TO [customer]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_delete_user_address] TO [customer]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_delete_all_order_by_userid] TO [customer]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_update_user_account_info_by_userid] TO [customer]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_user_accounts_by_role] TO [customer]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_all_user_address] TO [customer]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_delete_order] TO [customer]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_update_user_account_role_by_userid] TO [customer]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_all_user_account] TO [customer]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_add_order] TO [customer]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_change_password] TO [customer]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_update_user_account_role_by_phone] TO [customer]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_all_user_address_by_userid] TO [customer]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_user_account_by_userid] TO [customer]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_order_status_by_orderid] TO [customer]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_update_useraddress] TO [customer]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_reset_password] TO [customer]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_user_address_by_useraddressid] TO [customer]
GO

-- Create role employee
USE [myecommerce]
GO
CREATE ROLE [employee]
GO

-- Set role employee
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_add_category] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_update_product_quantity_when_order_cancelled] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_orderdetail_by_orderid_and_productid] TO [employee]
GO
use [myecommerce]
GO
GRANT CONTROL ON [dbo].[sp_exist_product_by_productid] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_all_orderdetail] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_delete_product] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_add_product] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_all_product] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_products_by_categoryid] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_delete_order] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_user_account_by_userid] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_all_order_by_status] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_orderdetails_by_productid] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_update_category] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_update_order_status_by_orderid] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_orderdetails_by_orderid] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_product_by_productid] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_update_user_account_role_by_phone] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_update_product_quantity] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_exist_order_by_orderid_and_userid] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_user_accounts_by_role] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_exist_order_by_orderid] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_category_by_categoryid] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_update_product_discount] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_update_useraddress] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_update_user_account_info_by_phone] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_update_product_quantity_by_amount] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_all_order] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_order_by_orderid] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_delete_all_order_by_userid] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_update_product_name] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_exist_category_by_categoryid] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_update_user_account_info_by_userid] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_order_status_by_orderid] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_product_quantity_by_productid] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_update_product_all] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_delete_category] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_all_order_by_userid] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_update_product_unit_price] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_user_address_by_useraddressid] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_update_user_account_role_by_userid] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_orderdetail_by_orderdetailid] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_update_product_description] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_user_account_by_phone] TO [employee]
GO
use [myecommerce]
GO
GRANT EXECUTE ON [dbo].[sp_select_all_category] TO [employee]
GO

-- Test
USE [myecommerce]
GO
ALTER ROLE [customer] ADD MEMBER [user_test]
GO
