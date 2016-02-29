--Loop Nested Join

create nonclustered index NCIX_Employee on DB.Employee(Adminstration_ID) include (FirstName,LastName,Salary,Gender);
drop index DB.Employee.NCIX_Employee;

DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
select FirstName + ' ' + LastName, A.Name  from DB.Adminstration as A join DB.Employee as E on (A.ID = E.Adminstration_ID ) where 
(A.Department = 61 and Salary > 5000 and E.Gender = 'M');
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;


Go

--Hash Join
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
select C.Subject,C.Message,AMS.Status from DB.AdminstrationMailStatus as  AMS join DB.Correspondence as C
		on (AMS.ID = C.Status_ID) where (Year(C.WriteDate) = '2007' );
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

GO
		
--Merge Join
create nonclustered index NCIX_Inbox_Correspondence on DB.InboxMail(Correspondence_ID) include (Status_ID,Reciver_Adminstration_ID); 
drop index DB.InboxMail.NCIX_Inbox_Correspondence;

DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
select  C.Subject as 'Title', C.Message as 'Message',IM.Reciver_Adminstration_ID as 'Aminstration ID'
from DB.Correspondence as C 
	join DB.InboxMail  as IM on (C.ID = IM.Correspondence_ID) 
	join DB.AdminstrationMailStatus as AMS on (IM.Status_ID = AMS.ID);
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

