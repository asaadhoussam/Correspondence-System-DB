DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
select a.Name as 'Sender Name',a.Address as 'Sender Address',c.WriteDate as 'Send Date',c.Message as 'Correspondence Message' from DB.Adminstration as a join DB.Correspondence as c 
	on (a.ID = c.Sender_ID)
	where (Address = 'Address of Adminstration #4' and WriteDate > '2005-01-01') option (fast 3);	
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

create nonclustered index NCIX_Date_Corrspondence on DB.Correspondence(Sender_ID) include(Message,WriteDate);
create nonclustered index NCIX_Address_Adminstration on DB.Adminstration(Address) include(Name);

drop index DB.Correspondence.NCIX_Date_Corrspondence;
drop index DB.Adminstration.NCIX_Address_Adminstration;


--Same Query once without option and once with it
select a.Name as 'Sender Name',a.Address as 'Sender Address',c.WriteDate as 'Send Date',c.Message as 'Correspondence Message' from DB.Adminstration as a join DB.Correspondence as c 
on (a.ID = c.Sender_ID)
where (Address = 'Address of Adminstration #4' and WriteDate > '2005-01-01')


select a.Name as 'Sender Name',a.Address as 'Sender Address',c.WriteDate as 'Send Date',c.Message as 'Correspondence Message' from DB.Adminstration as a join DB.Correspondence as c 
on (a.ID = c.Sender_ID)
where (Address = 'Address of Adminstration #4' and WriteDate > '2005-01-01') option (fast 3);


