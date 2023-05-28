USE myecommerce
GO

--Create user
create login user_test with password = '1234'
create user user_test from login user_test
-- Read and update profile
create view my_profile as select * from UserAccount
GRANT SELECT ON [dbo].[my_profile] TO [user_test]
GO
GRANT UPDATE ON [dbo].[UserAccount] TO [user_test]
GO

-- Dat hang va mua hang
GRANT DELETE ON [dbo].[UserOrder] TO [user_test]
GO
GRANT INSERT ON [dbo].[UserOrder] TO [user_test]
GO
GRANT SELECT ON [dbo].[UserOrder] TO [user_test]
GO
DENY UPDATE ON [dbo].[UserOrder] ([AdditionalPrice]) TO [user_test]
GO
GRANT UPDATE ON [dbo].[UserOrder] ([PaymentType]) TO [user_test]
GO
GRANT UPDATE ON [dbo].[UserOrder] ([Address]) TO [user_test]
GO
DENY UPDATE ON [dbo].[UserOrder] ([Status]) TO [user_test]
GO
DENY UPDATE ON [dbo].[UserOrder] ([UserID]) TO [user_test]
GO
DENY UPDATE ON [dbo].[UserOrder] ([OrderID]) TO [user_test]
GO
DENY UPDATE ON [dbo].[UserOrder] ([DateOrder]) TO [user_test]
GO
GRANT INSERT ON [dbo].[OrderDetail] TO [user_test]
GO
GRANT SELECT ON [dbo].[OrderDetail] TO [user_test]
GO

