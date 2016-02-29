--To show exuction time and physical operations
	SET STATISTICS IO ON;
	SET STATISTICS TIME ON;
--To Clear Buffer and Cash
	DBCC DROPCLEANBUFFERS;
	DBCC FREEPROCCACHE;	
/*  
	Naming Convention for this Query
    ================================
	NCIX:	stand for Nonclusterd index.
	CLIX:	stand for Clusterd index. 
	COIX:	stand for Covering index.
*/	



--4.A Non Clustered Index:
------------------------- 

DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
--this is best use of statistics, else will print extra info 	
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
select Telephone from DB.Adminstration  where (Telephone like '34%') order by (Telephone);
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

--create index 
create nonclustered index NCIX_Adminstration_Telephone on DB.Adminstration(Telephone) with (fillfactor = 60);
drop index DB.Adminstration.NCIX_Adminstration_Telephone;

--use this to compare size of index with different fillfactror 
EXEC sp_spaceused 'DB.Adminstration'


--4.B Clustered Index:
----------------------

DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;


SET STATISTICS IO ON;
SET STATISTICS TIME ON;
select * from DB.Adminstration where (ID > 35 and ID < 100 and not (ID in (1,2,3) or ID in(73)));
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;


--Another query to show usage of Clustered Index
select * from DB.Adminstration where Telephone like '34%' and (Department = 10) and (ID > 35 and ID < 100 and not (ID in (1,2,3) or ID in(73)));

--create index
create clustered index CIX_ID on DB.Adminstration (ID);
drop index DB.Adminstration.CIX_ID;


--4.C Covering Index:
---------------------
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;


SET STATISTICS IO ON;
SET STATISTICS TIME ON;
select FirstName +' '+ LastName as 'Full Name',Salary as 'Employee Salary' from DB.Employee where FirstName like 'D%' and LastName like 'C%' and Salary > 5000 order by FirstName; 
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

create nonclustered index COIX_Name_Salary on DB.Employee(FirstName,lastName,Salary);	
drop index DB.Employee.COIX_Name_Salary;


--4.C Include Index:
--------------------
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
select FirstName,LastName,Salary from DB.Employee where Salary Between 5000 and 8000; 
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

create nonclustered index IIX_Name_Salary on DB.Employee(Salary) include(FirstName,LastName);
drop index DB.Employee.IIX_Name_Salary;


--4.D Filitred Index:
---------------------
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
select CONVERT(date,writeDate) as 'Write Date',Sender_ID as 'Sender ID'  from DB.Correspondence where  WriteDate > '2015-01-01';
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

create nonclustered index FIX_Coooespondence_Date on DB.Correspondence(WriteDate) include(Sender_ID) where (WriteDate > '2010-01-01') ;
drop index DB.Correspondence.FIX_Coooespondence_Date;
EXEC sp_spaceused 'DB.Correspondence'