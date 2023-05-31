USE myecommerce
GO
--Full backup
BACKUP DATABASE myecommerce -- file 1
TO DISK = N'C:\backup\Backup.bak'
WITH FORMAT, DESCRIPTION = 'Ecommerce FULL Backup'
GO

-- differ backup 
BACKUP DATABASE myecommerce -- file 2
TO DISK = N'C:\backup\Backup.bak'
WITH DIFFERENTIAL, DESCRIPTION = 'Ecommerce Diff Backup'
GO

-- transaction log backup
BACKUP LOG myecommerce
TO DISK = N'C:\backup\Backup.trn'
WITH DESCRIPTION = 'Ecommerce Log Backup'

-- auto backup transaction log sau moi transaction

--Restore full ve trang thai ban dau
USE master
GO
DROP DATABASE myecommerce
GO

RESTORE DATABASE myecommerce
FROM DISK = N'C:\backup\Backup.bak'
WITH FILE = 1, REPLACE, RECOVERY
GO

-- Restore voi cac transaction
USE master
GO
DROP DATABASE myecommerce
GO

RESTORE DATABASE myecommerce
FROM DISK = N'C:\backup\Backup.bak'
WITH FILE = 1, REPLACE, NORECOVERY
GO

RESTORE DATABASE myecommerce
FROM DISK = N'C:\backup\Backup.bak'
WITH FILE = 2, REPLACE, NORECOVERY
GO

RESTORE LOG myecommerce
FROM DISK = N'C:\backup\Backup.trn'
WITH RECOVERY
GO