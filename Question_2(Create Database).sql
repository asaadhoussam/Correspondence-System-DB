CREATE DATABASE Correspondences_DB
ON PRIMARY 
	( NAME       = 'Correspondences System DB',
	  FILENAME	 = 'D:\Database\Project\DatabaseFiles\CSDB.mdf', 
	  SIZE       = 4 MB,
	  FILEGROWTH = 1 MB
	),
	
	(
	  NAME       = 'HW_file1',
	  FILENAME	 = 'D:\Database\Project\DatabaseFiles\HW_file1.ndf',
	  SIZE       = 2 MB,
	  FILEGROWTH = 1 MB
	),
	
	(
	  NAME	 = 'HW_file2',
	  FILENAME	 = 'D:\Database\Project\DatabaseFiles\HW_file2.ndf',
	  SIZE	 = 2 MB,
	  FILEGROWTH = 1 MB
	),
		
FILEGROUP HW_FileGroup
	(
	  NAME	 = 'HW_file3',
	  FILENAME	 = 'D:\Database\Project\DatabaseFiles\HW_file3.ndf',
	  SIZE       = 2 MB,
	  FILEGROWTH = 1 MB
	),
	
	(
	  NAME	 = 'HW_file4',
	  FILENAME	 = 'D:\Database\Project\DatabaseFiles\HW_file4.ndf',
	  SIZE	 = 2 MB,
	  FILEGROWTH = 1 MB
		),
FILEGROUP BigFiles_FileGroup
	(
	  NAME	 = 'BigFiles',
	  FILENAME	 = 'D:\Database\Project\DatabaseFiles\BigFiles.ndf',
	  SIZE	 = 512 MB,
	  FILEGROWTH = 50 MB
	)
LOG ON		
	(
	  NAME	 = 'HW_log1',
	  FILENAME	 = 'D:\Database\Project\DatabaseFiles\HW_log1.ldf',
	  SIZE	 = 1 MB,
	  FILEGROWTH = 512 KB
	),
	
	(
	  NAME	 = 'HW_log2',
	  FILENAME	 = 'D:\Database\Project\DatabaseFiles\HW_log2.ldf',
	  SIZE       = 1 MB,
	  FILEGROWTH = 512 KB
	)
GO 
CREATE SCHEMA DB;
