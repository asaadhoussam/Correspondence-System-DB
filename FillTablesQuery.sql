/*This procedure MUST create and execure after tables are created...*/
IF OBJECT_ID('rand_helper') IS NOT NULL
   DROP VIEW DB.rand_helper;
GO
CREATE VIEW DB.rand_helper AS SELECT RND=RAND();
GO
IF OBJECT_ID('random_string') IS NOT NULL
   DROP FUNCTION DB.random_string;
GO
CREATE FUNCTION DB.random_string (@maxlen int)
   RETURNS VARCHAR(255)
AS BEGIN
   DECLARE @rv VARCHAR(255)
   DECLARE @loop int
   DECLARE @len int

   SET @len = (SELECT CAST(rnd * (@maxlen-3) AS INT) + 3 FROM rand_helper)
   SET @rv = ''
   SET @loop = 0

   WHILE @loop < @len BEGIN
      SET @rv = @rv + CHAR(CAST((SELECT rnd * 26
                             FROM rand_helper) AS INT )+97)
      IF @loop = 0 BEGIN
          SET @rv = UPPER(@rv)
      END
      SET @loop = @loop +1;
   END

   RETURN @rv
END
GO


create procedure DB.AdminstrationFill(@adminstrations_count int,@department_count int) as
	Begin
		/*Variables decleration*/
		declare @i int
		set @i = 1;
		while(@i <= @adminstrations_count)
		Begin
				insert into DB.Adminstration (Name,Summary,Department,Fax,Telephone,Address,City) 
					values (
							'Adminstration '+ cast (@i as varchar),
							'This is Adminstraion #'+cast (@i as varchar),
							null,
							ABS(CHECKSUM(NewId())),
							ABS(CHECKSUM(NewId())),
							'Address of Adminstration #' + cast (@i as varchar),
							'City of Adminstration #' + cast (@i as varchar)
							);		
			/*Loop increment*/
			set @i= @i + 1;
		End
		
		set @i = 1;
		while(@i <= @department_count)
		Begin 
			insert into DB.Adminstration (Name,Summary,Department,Fax,Telephone,Address,City) 
					values (
							'Department '+ cast (@i as varchar),
							'This is Department #'+cast (@i as varchar), 
							ABS(CHECKSUM(NewId())) % @adminstrations_count,
							ABS(CHECKSUM(NewId())),
							ABS(CHECKSUM(NewId())),
							'Address of Department #' + cast (@i as varchar),
							'City of Department #' + cast (@i as varchar)
							);
			/*Loop increment*/
			set @i= @i + 1;
		End	
	End
GO

create procedure DB.EmployeeFill(@employee_count int,@department_count int) as 
	Begin
		/* Varibales decleration */
		declare @i int,@j int
		declare @FromDate date = '1950-01-01'
		declare @ToDate date   = '2000-12-31'
		
		set @i = 1;
		while(@i <= @employee_count)
		Begin
			insert into DB.Employee (FirstName,LastName,Birthday,Salary,Adminstration_ID,Gender,Phonenumber)
				values (
						DB.random_string(7), /*Employee First Name*/
						DB.random_string(8), /*Employee Last  Name*/
						dateadd(day, rand(checksum(newid()))*(1+datediff(day, @FromDate, @ToDate)), @FromDate), /*Employee Birthday*/
						ABS(CHECKSUM(NewId())) % 10000 , /*Employee Salary*/
						(ABS(CHECKSUM(NewId())) % @department_count + 1) /*Employee Adminstration ID*/,
						'M',
						ABS(CHECKSUM(NewId()))
						);
		
			/*Loop increment (i by 1) and (j by 1 every 10 Employee)*/
			set @i = @i + 1;
		End
	End
GO

create procedure DB.StatusFill as 
Begin 
		/*Employee Mail Status*/
		insert into DB.EmployeeMailStatus (Status) values ('Deleted');
		insert into DB.EmployeeMailStatus (Status) values ('Archived')
	
		
		
		/*Inbox Mail Status*/
		insert into DB.AdminstrationMailStatus (Status) values ('Checking');
		insert into DB.AdminstrationMailStatus (Status) values ('Accepted');
		insert into DB.AdminstrationMailStatus (Status) values ('Editing' );
		insert into DB.AdminstrationMailStatus (Status) values ('Deleted' );
		insert into DB.AdminstrationMailStatus (Status) values ('Archived');
 	
End
Go

create procedure DB.CorrespondenceFill(@Correspondence_count int,@Adminstration_count int) as 
Begin
		declare @i int;
		set @i = 1;
		
		declare @FromDate date = '2000-01-01'
		declare @ToDate date   = '2015-12-31'
		
		While(@i <= @Correspondence_count)
		Begin
			insert into Correspondence (Subject,Message,WriteDate,Sender_ID,Status_ID) 
				values (
						'Correspondence #' + cast( @i  as varchar) + 'Title',
						'Correspondence #' + cast( @i  as varchar) + 'Message',
						dateadd(day, rand(checksum(newid()))*(1+datediff(day, @FromDate, @ToDate)), @FromDate),
						((ABS(CHECKSUM(NewId())) % @Adminstration_count) + 1),
						((ABS(CHECKSUM(NewId())) % 5) + 1)
						);
			set @i = @i + 1;
		End
		
		
End
Go

create procedure DB.InboxMailFill(@InboxMailFill_count int,@Adminstration_count int,@Correspondence_count int) as
Begin
	declare @i int;
		set @i = 1;
		
		declare @FromDate date = '2000-01-01'
		declare @ToDate date   = '2015-12-31'
		
		While(@i <= @InboxMailFill_count)
		Begin
			insert into DB.InboxMail(ReadDate,Reciver_Adminstration_ID,Status_ID,Is_Note,Correspondence_ID) 
				values (
						dateadd(day, rand(checksum(newid()))*(1+datediff(day, @FromDate, @ToDate)), @FromDate),
						((ABS(CHECKSUM(NewId())) % @Adminstration_count) + 1),
						((ABS(CHECKSUM(NewId())) % 5) + 1),
						CAST(ROUND(RAND(),0) AS BIT),
						((ABS(CHECKSUM(NewId())) % @Correspondence_count) + 1)
						);
			set @i = @i + 1;
		End
End
Go

create procedure DB.EmployeeMailFill(@EmployeeMail_count int,@Employee_count int,@InboxMail_count int) as
Begin
	declare @i int;
		set @i = 1;
		
		declare @FromDate date = '2000-01-01'
		declare @ToDate date   = '2015-12-31'
		
		While(@i <= @EmployeeMail_count)
		Begin
			insert into DB.EmployeeMail(Reciver_Employee_ID,Inbox_ID,ReadDate,Status_ID) 
				values (
						((ABS(CHECKSUM(NewId())) % @Employee_count) + 1),
						((ABS(CHECKSUM(NewId())) % @InboxMail_count) + 1),
						dateadd(day, rand(checksum(newid()))*(1+datediff(day, @FromDate, @ToDate)), @FromDate),
						((ABS(CHECKSUM(NewId())) % 2) + 1)
						);
			set @i = @i + 1;
		End
End
Go
Execute DB.AdminstrationFill 100,1000;
Execute DB.EmployeeFill 4000,1100;
Execute DB.StatusFill;
Execute DB.CorrespondenceFill 2000,1100;
Execute DB.InboxMailFill 3000,1100,2000;
Execute DB.EmployeeMailFill 6000,4000,3000;

/*Delete Procedrues*/
drop procedure DB.AdminstrationFill;
drop procedure DB.EmployeeFill;
drop procedure DB.StatusFill;
drop procedure DB.CorrespondenceFill;
drop procedure DB.InboxMailFill;
drop procedure DB.EmployeeMailFill;

print getDate();
