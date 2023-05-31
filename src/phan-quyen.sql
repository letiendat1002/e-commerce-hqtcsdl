USE [myecommerce]
GO
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
-- user account
GRANT EXECUTE ON [dbo].[sp_select_user_account_by_userid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_select_user_account_by_phone] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_exist_user_account_by_userid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_exist_user_account_by_phone] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_update_user_account_info_by_userid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_update_user_account_info_by_phone] TO [customer]
GO

-- user address
GRANT EXECUTE ON [dbo].[sp_select_all_user_address_by_userid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_select_user_address_by_useraddressid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_exist_user_address_by_useraddressid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_add_user_address] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_update_useraddress] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_delete_user_address] TO [customer]
GO

-- order
GRANT EXECUTE ON [dbo].[sp_select_all_order_by_userid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_select_order_by_orderid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_add_order] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_exist_order_by_orderid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_exist_order_by_orderid_and_userid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_select_order_status_by_orderid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_update_order_status_by_orderid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_delete_order] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_delete_all_order_by_userid] TO [customer]
GO

-- order detail
GRANT EXECUTE ON [dbo].[sp_select_orderdetails_by_orderid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_select_orderdetail_by_orderdetailid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_select_orderdetail_by_orderid_and_productid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_exist_orderdetail_by_orderdetailid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_exist_orderdetail_by_orderid_and_productid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_add_orderdetail] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_update_product_quantity_when_order_cancelled] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_delete_all_orderdetail_by_orderid] TO [customer]
GO

-- product
GRANT EXECUTE ON [dbo].[sp_select_all_product] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_select_products_by_categoryid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_select_product_by_productid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_update_product_quantity_by_amount] TO [customer]
GO

-- category
GRANT EXECUTE ON [dbo].[sp_select_all_category] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_select_category_by_categoryid] TO [customer]
GO

-- Auth
GRANT EXECUTE ON [dbo].[sp_register] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_authenticate] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_change_password] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_reset_password] TO [customer]
GO


-- Create role employee
USE [myecommerce]
GO
CREATE ROLE [employee]
GO

-- Set role employee
-- user account
GRANT EXECUTE ON [dbo].[sp_select_user_account_by_userid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_select_user_account_by_phone] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_exist_user_account_by_userid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_exist_user_account_by_phone] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_update_user_account_info_by_userid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_update_user_account_info_by_phone] TO [customer]
GO

-- user address
GRANT EXECUTE ON [dbo].[sp_select_all_user_address_by_userid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_select_user_address_by_useraddressid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_exist_user_address_by_useraddressid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_add_user_address] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_update_useraddress] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_delete_user_address] TO [customer]
GO

-- order
GRANT EXECUTE ON [dbo].[sp_select_all_order_by_userid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_select_order_by_orderid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_add_order] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_exist_order_by_orderid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_exist_order_by_orderid_and_userid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_select_order_status_by_orderid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_update_order_status_by_orderid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_delete_order] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_delete_all_order_by_userid] TO [customer]
GO

-- order detail
GRANT EXECUTE ON [dbo].[sp_select_orderdetails_by_orderid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_select_orderdetail_by_orderdetailid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_select_orderdetail_by_orderid_and_productid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_exist_orderdetail_by_orderdetailid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_exist_orderdetail_by_orderid_and_productid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_add_orderdetail] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_update_product_quantity_when_order_cancelled] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_delete_all_orderdetail_by_orderid] TO [customer]
GO

-- product
GRANT EXECUTE ON [dbo].[sp_select_all_product] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_select_products_by_categoryid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_select_product_by_productid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_exist_product_by_productid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_add_product] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_update_product_all] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_update_product_name] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_update_product_unit_price] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_update_product_quantity] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_update_product_discount] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_update_product_description] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_delete_product] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_update_product_quantity_by_amount] TO [customer]
GO

-- category
GRANT EXECUTE ON [dbo].[sp_select_all_category] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_select_category_by_categoryid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_exist_category_by_categoryid] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_add_category] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_update_category] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_delete_category] TO [customer]
GO

-- Auth
GRANT EXECUTE ON [dbo].[sp_register] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_authenticate] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_change_password] TO [customer]
GO
GRANT EXECUTE ON [dbo].[sp_reset_password] TO [customer]
GO

-- Test
USE [myecommerce]
GO
ALTER ROLE [customer] ADD MEMBER [user_test]
GO
ALTER ROLE [employee] ADD MEMBER [employee_product]
GO
