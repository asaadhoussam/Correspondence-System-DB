DROP TABLE DB.EmployeeMail;
DROP TABLE DB.InboxMail;
DROP TABLE DB.Attachment;
DROP TABLE DB.Correspondence;
DROP TABLE DB.Employee;
DROP TABLE DB.Adminstration;
DROP TABLE DB.EmployeeMailStatus;
DROP TABLE DB.AdminstrationMailStatus;

CREATE TABLE DB.Adminstration(
	ID					INT IDENTITY(1,1),
	Name				VARCHAR(50) not null,
	Summary				TEXT,
	Telephone			VARCHAR(15),
	Fax					VARCHAR(15),
	Address				VARCHAR(255),
	City				VARCHAR(50),
	Department  		INT
	
	CONSTRAINT FK_Department 
	  FOREIGN KEY REFERENCES DB.Adminstration(ID) , 
	  
	CONSTRAINT PK_Adminstration PRIMARY KEY (ID)			
) ON HW_FileGroup
GO
-------------------------------------------------------------------------
CREATE TABLE DB.Employee(
	ID					INT IDENTITY(1,1),
	FirstName			VARCHAR(50) not null,
	LastName			VARCHAR(50) not null,
	Birthday			DATE,
	Salary				INT,
	Gender				CHAR,
	Phonenumber			VARCHAR(15),
	Adminstration_ID	INT not null 

    CONSTRAINT FK_Adminstration_ID 
      FOREIGN KEY REFERENCES DB.Adminstration(ID) ON DELETE CASCADE  
	
    CONSTRAINT PK_Employee 
	  PRIMARY KEY (ID),

    CONSTRAINT CK_Gender_Employee 
	  CHECK (Gender in ('M','F')),
	  
	CONSTRAINT CH_SALARY
	  CHECK (Salary >= 0)
) ON HW_FileGroup

GO
-------------------------------------------------------------------------
CREATE TABLE DB.AdminstrationMailStatus(
	ID					INT IDENTITY(1,1),
	Status				VARCHAR(50) not null,
	
	CONSTRAINT PK_AdminstrationMailStatus 
	  PRIMARY KEY (ID)
) ON HW_FileGroup
GO
-------------------------------------------------------------------------

CREATE TABLE DB.Correspondence(
	ID				INT IDENTITY(1,1),
	Subject			VARCHAR(255) not null,
	Message			VARCHAR(max) not null,
	WriteDate		DATETIME not null,
	Sender_ID		INT not null 

	CONSTRAINT FK_Sender_ID 
	  FOREIGN KEY REFERENCES DB.Adminstration (ID) ON DELETE CASCADE,

	Status_ID			INT not null 

	CONSTRAINT FK_Corrs_Status_ID
	  FOREIGN KEY REFERENCES DB.AdminstrationMailStatus (ID) ON DELETE CASCADE

	CONSTRAINT PK_Correspondence 
	  PRIMARY KEY (ID)

) ON HW_FileGroup
GO
------------------------------------------------------------------------
CREATE TABLE DB.Attachment (
	ID					INT IDENTITY(1,1),
	AttachmentFile		VARBINARY,
	AttachmentType		VARCHAR(50),
	Correspondence_ID	INT not null 

    CONSTRAINT FK_Corr_ID 
	  FOREIGN KEY REFERENCES DB.Correspondence (ID) ON DELETE CASCADE
		
	CONSTRAINT PK_Attachment 
        PRIMARY KEY (ID)
) ON BigFiles_FileGroup
GO
------------------------------------------------------------------------
CREATE TABLE DB.InboxMail(
	ID				INT IDENTITY(1,1),
	Is_Note			BIT not null,
	ReadDate		DATETIME,
	
	Reciver_Adminstration_ID INT not null 

	CONSTRAINT FK_Reciver_ID 
	  FOREIGN KEY REFERENCES DB.Adminstration(ID) ON DELETE CASCADE,

	Status_ID				INT not null 

	CONSTRAINT FK_AInbox_Status_ID 
	  FOREIGN KEY REFERENCES DB.AdminstrationMailStatus(ID),

	Correspondence_ID		INT not null 

	CONSTRAINT FK_Correspondence_ID 
	  FOREIGN KEY REFERENCES DB.Correspondence(ID)
	
	CONSTRAINT PK_InboxMail 
	  PRIMARY KEY (ID)
)  ON HW_FileGroup
GO
------------------------------------------------------------------------
CREATE TABLE DB.EmployeeMailStatus(
	ID				INT IDENTITY(1,1),
	Status			VARCHAR(50) not null
	
	CONSTRAINT PK_EmployeeMailStatus 
	  PRIMARY KEY (ID)
)  ON HW_FileGroup
GO
------------------------------------------------------------------------
CREATE TABLE DB.EmployeeMail (
	ID						INT IDENTITY(1,1),
	ReadDate				DATETIME,
	Reciver_Employee_ID		INT not null 

	CONSTRAINT FK_Empolyee_ID 
	  FOREIGN KEY REFERENCES DB.Employee(ID) ON DELETE CASCADE,

	Inbox_ID			INT not null 

	CONSTRAINT FK_EInobx_ID 
	  foreign key references DB.InboxMail(ID),

	Status_ID			INT not null 

	CONSTRAINT FK_Status_ID 
	  FOREIGN KEY REFERENCES DB.EmployeeMailStatus(ID)
	  
	CONSTRAINT PK_EmployeeMail 
	  PRIMARY KEY (ID)
)  ON HW_FileGroup
GO
------------------------------------------------------------------------




