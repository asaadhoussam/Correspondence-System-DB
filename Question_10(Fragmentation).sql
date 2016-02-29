--I love Employee Table so all the insert and delete and update will be on it 
--Along side with clustered index, we will add two another index that used before

create nonclustered index NCIX_Full_Name_Salary on DB.Employee(FirstName,lastName,Salary);
create nonclustered index NCIX_Adminstration_ID on DB.Employee(Adminstration_ID) include (FirstName,LastName,Salary,Gender);
Go

create procedure DB.TestFragmentation(@department_count int,@N int) as 
Begin
declare @i int;
set @i = 0;
while(@i < @N)
Begin
	--Delete Row
	delete from DB.Employee where (ID = @i);
	--Insert Row
	insert into DB.Employee (FirstName,LastName,Birthday,Salary,Adminstration_ID,Gender,Phonenumber)
			values (
				DB.random_string(7), 
				DB.random_string(8), 
				GETDATE(),
				ABS(CHECKSUM(NewId())) % 10000 ,
				(ABS(CHECKSUM(NewId())) % @department_count + 1),
				'M',
				ABS(CHECKSUM(NewId()))
	);
	--Update Row
	update DB.Employee 
	set 
		Gender = 'F',
		Salary = ABS(CHECKSUM(NewId())) % 10000,
		Phonenumber = ABS(CHECKSUM(NewId())),
		Adminstration_ID = ABS(CHECKSUM(NewId())) % @department_count +1
	where (ID = @N+@i);

	set @i = @i + 1;	
End	
End
Go

drop procedure DB.TestFragmentation;

Go 

Execute DB.TestFragmentation 1100,4000; 

	
--This will query dm_db_index_physical_stats table to get Fragmentation statistices 
--Try it before and after execute above procedrue, and also after rebuild the index with the alter index statment below... 
SELECT
	SI.name						AS 'Index Name',
	SI.type_desc				AS 'Index Type',
	PS.index_level				AS 'Index Level (leaf 0)',
	PS.avg_fragmentation_in_percent	AS 'AVG Fragmentation %',
	PS.fragment_count			AS 'Fragment Count',
	PS.page_count				AS 'Total Pages',
	avg_fragment_size_in_pages  AS 'Pages/Frag'
FROM
	sys.dm_db_index_physical_stats(
			db_id(db_name()),
			OBJECT_ID(N'Correspondences_DB.DB.Employee'), 
			NULL,NULL , 'DETAILED') AS PS
	LEFT JOIN 
	sys.indexes  AS SI ON(PS.index_id = SI.index_id) 
WHERE (SI.object_id = PS.object_id);

--This will rebuild the index
ALTER INDEX ALL ON DB.Employee REBUILD
	 




