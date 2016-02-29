SELECT	
	name			AS 'Logical Name',
	physical_name	AS 'Physical Name',
	size			AS 'Total Pages',
	FILEPROPERTY(name, 'SpaceUsed')			AS 'Used Pages',
	size/128								AS 'Total Space MB',
	FILEPROPERTY(name, 'SpaceUsed')/ 128	AS 'Used Space MB',
	size/128 - FILEPROPERTY(name, 'SpaceUsed') /128	 AS 'Free Space MB'
FROM sys.database_files;


DBCC SHRINKFILE (HW_file3);

