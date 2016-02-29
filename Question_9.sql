--Before do the test drop all the indexs(By delete all) and create indexs below...

--those index for first Query
create nonclustered index NCIX_Date_Corrspondence on DB.Correspondence(Sender_ID) include(Message,WriteDate);
create nonclustered index NCIX_Address_Adminstration on DB.Adminstration(Address) include(Name);

--this index for second Query
create nonclustered index NCIX_Employee on DB.Employee(Adminstration_ID) include (FirstName,LastName,Salary,Gender);

--this index for thired Query 
create nonclustered index NCIX_Inbox_Correspondence on DB.InboxMail(Correspondence_ID) include (Status_ID,Reciver_Adminstration_ID); 

--Plus all the PK index

Go

create procedure DB.TestIndex(@N int) as 
Begin

declare @i int;
set @i = 0;

while(@i < @N)
Begin
	
	--First Query from Question 5+6
	select a.Name as 'Sender Name',a.Address as 'Sender Address',c.WriteDate as 'Send Date',c.Message as 'Correspondence Message' from DB.Adminstration as a join DB.Correspondence as c 
	on (a.ID = c.Sender_ID)
	where (Address = 'Address of Adminstration #4' and WriteDate > '2005-01-01') option (fast 3);	
	
	--Second Query from 7+8 Question (Nested Loop Join)
	
	select FirstName + ' ' + LastName, A.Name  from DB.Adminstration as A join DB.Employee as E on (A.ID = E.Adminstration_ID ) where 
	(A.Department = 61 and Salary > 5000 and E.Gender = 'M');
	
	
	
	--Thired Query from 7+8 Question (Merge Join)
	select  C.Subject as 'Title', C.Message as 'Message',IM.Reciver_Adminstration_ID as 'Aminstration ID'
	from DB.Correspondence as C 
	join DB.InboxMail  as IM on (C.ID = IM.Correspondence_ID) 
	join DB.AdminstrationMailStatus as AMS on (IM.Status_ID = AMS.ID);
	
	
	--Forth Query from 7+8 Question (Hash Join)
	select C.Subject,C.Message,AMS.Status from DB.AdminstrationMailStatus as  AMS join DB.Correspondence as C
	on (AMS.ID = C.Status_ID) where (Year(C.WriteDate) = '2007' );
	
	set @i = @i + 1;
End
End
Go 
--1000 is to big, 100 is enough
Execute DB.TestIndex 1000; 



--This Query will show the index information... Must execute after TestIndex has finish...
SELECT   OBJECT_NAME(S.[OBJECT_ID]) AS [OBJECT NAME], 
         I.[NAME] AS [INDEX NAME], 
         I.[TYPE_DESC] AS [INDEX TYPE],
         USER_SEEKS, 
         USER_SCANS, 
         USER_LOOKUPS, 
         USER_UPDATES,
         (USER_SEEKS + USER_SCANS + USER_LOOKUPS) as INDEX_Reads
         
FROM     SYS.DM_DB_INDEX_USAGE_STATS AS S 
         INNER JOIN SYS.INDEXES AS I 
           ON I.[OBJECT_ID] = S.[OBJECT_ID] 
              AND I.INDEX_ID = S.INDEX_ID 
WHERE    OBJECTPROPERTY(S.[OBJECT_ID],'IsUserTable') = 1 