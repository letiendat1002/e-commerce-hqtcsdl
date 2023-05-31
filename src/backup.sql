--FUll backup vao CN
BACKUP DATABASE myecommerce -- file 1
TO DISK = N'C:\backup\Backup.bak';

-- differ backup 
BACKUP DATABASE myecommerce -- file 2
TO DISK = N'C:\backup\Backup.bak'
WITH DIFFERENTIAL;

--Phuc hoi full
RESTORE DATABASE myecommerce
FROM DISK = N'C:\backup\Backup.bak'
WITH FILE = 1, REPLACE, RECOVERY;


-- Phuc hoi Diff
RESTORE DATABASE myecommerce
FROM DISK = N'C:\backup\Backup.bak'
WITH FILE = 1, REPLACE, NORECOVERY;

RESTORE DATABASE myecommerce
FROM DISK = N'C:\backup\Backup.bak'
WITH FILE = 2, RECOVERY;
