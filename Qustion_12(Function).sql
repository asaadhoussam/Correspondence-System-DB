DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
select FirstName + + LastName as 'Full Name',Status as 'Inbox Status',Subject as 'Inobx Subject' from DB.Employee as E  
						join DB.EmployeeMail as EM on (E.ID = EM.Reciver_Employee_ID) 
						join DB.InboxMail as IM on (EM.Inbox_ID = IM.ID)
						join DB.Correspondence as C on(C.ID = IM.Correspondence_ID)
						join DB.EmployeeMailStatus as EMS on (EMS.ID = EM.Status_ID);
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO


--this function will be used instead of inner join 
Create Function DB.Get_Correspondense_ID(@Inbox_Mail_ID int) returns int as
Begin
	return (select Correspondence_ID from DB.InboxMail where (InboxMail.ID = @Inbox_Mail_ID) )
End
GO

Create Function DB.Get_Employee_Name(@Employee_ID int) returns varchar(30) as
Begin
	return (select FirstName +' '+ LastName from DB.Employee where (Employee.ID = @Employee_ID));
End
Go

Create Function DB.Get_Status(@Status_ID int) returns varchar(30) as
Begin
	return (select AdminstrationMailStatus.Status from DB.AdminstrationMailStatus where (AdminstrationMailStatus.ID = @Status_ID));
End
Go

Create Function DB.GetCorrespondenceSubject(@Corrsepondence_ID int) returns varchar(255) as
Begin
	return (select Correspondence.Subject from DB.Correspondence where (Correspondence.ID = @Corrsepondence_ID));
End
Go

DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;	
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
select
		DB.Get_Employee_Name(EmployeeMail.Reciver_Employee_ID) as 'Full Name',
		DB.Get_Status(EmployeeMail.Status_ID) as 'Status Name',
		DB.GetCorrespondenceSubject(DB.Get_Correspondense_ID(EmployeeMail.Inbox_ID)) as 'Corresponcence Subject'
	from DB.EmployeeMail ;
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
