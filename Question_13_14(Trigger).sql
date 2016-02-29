--First Trigger 
CREATE TRIGGER PrintTrigger ON  DB.Attachment AFTER INSERT,UPDATE,DELETE AS 
BEGIN
SET NOCOUNT ON;
declare @affected_rows_count int;
IF (EXISTS(SELECT * FROM INSERTED) AND EXISTS(SELECT * FROM DELETED))
	Begin
		select @affected_rows_count = count(*) from inserted;
		print cast(@affected_rows_count as varchar) +
			' has been updated in Employee table'
	End
Else
IF EXISTS(SELECT * FROM INSERTED)
	Begin
		select @affected_rows_count = count(*) from inserted;
		print cast(@affected_rows_count as varchar) + 
			' has been inserted into Employee table'
	End
Else
IF  EXISTS(SELECT * FROM DELETED)
	Begin
		select @affected_rows_count = count(*) from deleted;
		print cast(@affected_rows_count as varchar) + 
			' has been deleted from Employee table'   
	End
END
GO
drop trigger DB.PrintTrigger;

--Test the trigger on attachment table...
insert into DB.Attachment (AttachmentFile,AttachmentType,Correspondence_ID) values (null,null,1);
delete from DB.Attachment;
update DB.Attachment set Correspondence_ID = 33 where ID = 53
select * from DB.Attachment;
GO

--Second Trigger
Create Trigger TR_EmpolyeeSalary_IN ON DB.Employee INSTEAD OF INSERT AS
Begin
		insert into DB.Employee 
			(FirstName,
			LastName,
			Birthday,
			Salary,
			Gender,
			PhoneNumber,
			Adminstration_ID)
			 
		(select 
			FirstName,
			LastName,
			Birthday,
			case  
				when (Salary > 0) then Salary * -1
				when (Salary < 0) then Salary 
			end,
			Gender,
			PhoneNumber,
			Adminstration_ID
		 from inserted );
End	
GO

drop trigger DB.TR_EmpolyeeSalary_IN;
GO

--More detiles on this trigger in the report...
Create Trigger TR_EmpoyeeSalary_UP on DB.Employee INSTEAD OF UPDATE AS
Begin

		update E set 
		E.Salary	=  case 
							when I.Salary > 0 then I.Salary * -1
							when I.Salary < 0 then I.Salary 
						end,
		E.FirstName	= I.FirstName,
		E.LastName	= I.LastName,
		E.BirthDay	= I.BirthDay,
		E.Gender	= I.Gender,
		E.PhoneNumber = I.PhoneNumber,
		E.Adminstration_ID = I.Adminstration_ID
		from DB.Employee as E inner join inserted as I 
			on (E.ID = I.ID)
			where (UPDATE(Salary)) 
	
		update E set 
		E.Salary	= I.Salary,
		E.FirstName	= I.FirstName,
		E.LastName	= I.LastName,
		E.BirthDay	= I.BirthDay,
		E.Gender	= I.Gender,
		E.PhoneNumber = I.PhoneNumber,
		E.Adminstration_ID = I.Adminstration_ID
		from DB.Employee as E inner join inserted as I 
			on (E.ID = I.ID)
			where (not UPDATE(Salary)) 			 
End
GO
drop trigger DB.TR_EmpoyeeSalary_UP;

--Test the Trigger with this statment
insert into DB.Employee(FirstName,LastName,Birthday,Salary,Gender,PhoneNumber,Adminstration_ID)
		values ('f','l',GETDATE(),234,'M',234234,1);
		
		
insert into DB.Employee(FirstName,LastName,Birthday,Salary,Gender,PhoneNumber,Adminstration_ID)
		values ('f','l',GETDATE(),1000,'M',234234,1);
		
insert into DB.Employee select * from DB.Employee;		
select * from DB.Employee order by Salary;

update DB.Employee set Salary = -150 ,FirstName= 'Fuck' where ID > 8000