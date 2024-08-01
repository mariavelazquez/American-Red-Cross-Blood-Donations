--Created for Data Warehousing Class 


--Create the Datamart BloodDonation DM

IF NOT EXISTS(SELECT name FROM master.dbo.sysdatabases			
	WHERE name = N'BloodDonationDM')
	
	CREATE DATABASE BloodDonationDM
GO

USE BloodDonationDM 
GO
--
--Drop the tables if exist
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'FactDonationMatch')

	DROP TABLE FactDonationMatch;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'DimRequest')

	DROP TABLE DimRequest;
-- 
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'DimDoner')

	DROP TABLE DimDoner;

--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'DimPatient')

	DROP TABLE DimPatient;

--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'DimDate')

	DROP TABLE DimDate;

-- 
CREATE TABLE DimDate
	(
	Date_SK				INT PRIMARY KEY, 
	Date				DATE,
	FullDate			NCHAR(10),-- Date in MM-dd-yyyy format
	DayOfMonth			INT, -- Field will hold day number of Month
	DayName				NVARCHAR(9), -- Contains name of the day, Sunday, Monday 
	DayOfWeek			INT,-- First Day Sunday=1 and Saturday=7
	DayOfWeekInMonth	INT, -- 1st Monday or 2nd Monday in Month
	DayOfWeekInYear		INT,
	DayOfQuarter		INT,
	DayOfYear			INT,
	WeekOfMonth			INT,-- Week Number of Month 
	WeekOfQuarter		INT, -- Week Number of the Quarter
	WeekOfYear			INT,-- Week Number of the Year
	Month				INT, -- Number of the Month 1 to 12{}
	MonthName			NVARCHAR(9),-- January, February etc
	MonthOfQuarter		INT,-- Month Number belongs to Quarter
	Quarter				NCHAR(2),
	QuarterName			NVARCHAR(9),-- First,Second..
	Year				INT,-- Year value of Date stored in Row
	YearName			CHAR(7), -- CY 2017,CY 2018
	MonthYear			CHAR(10), -- Jan-2018,Feb-2018
	MMYYYY				INT,
	FirstDayOfMonth		DATE,
	LastDayOfMonth		DATE,
	FirstDayOfQuarter	DATE,
	LastDayOfQuarter	DATE,
	FirstDayOfYear		DATE,
	LastDayOfYear		DATE,
	IsHoliday			BIT,-- Flag 1=National Holiday, 0-No National Holiday
	IsWeekday			BIT,-- 0=Week End ,1=Week Day
	Holiday				NVARCHAR(50),--Name of Holiday in US
	Season				NVARCHAR(10)--Name of Season
	);
--
CREATE TABLE DimRequest
	(
	Request_SK		INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
	Request_AK		INT NOT NULL,
	Request_Date	DATE NOT NULL,
	Request_Blood_Type NVARCHAR(5) NOT NULL,
	Hospital_Name	NVARCHAR(50) NOT NULL,
	Hospital_Zip_Code       INT NOT NULL,
	Blood_Bank_Name			NVARCHAR(50),
	Blood_Bank_Zip_Code		INT NOT NULL,
	Blood_Bank_Type_A_Storage	INT NOT NULL,
	Blood_Bank_Type_B_Storage	INT NOT NULL,
	Blood_Bank_Type_O_Storage	INT NOT NULL,
	Blood_Bank_Type_AB_Storage	INT NOT NULL,
	StartDate 					DATETIME NOT NULL,
	EndDate						DATETIME NULL
	);
--
CREATE TABLE DimDoner
	(
	Doner_SK			INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Doner_AK			INT NOT NULL,
	Gender				NVARCHAR(5) NOT NULL,
	Weight				INT NOT NULL,
	Age					INT NOT NULL,
	Doner_Blood_Type			NVARCHAR(5),
	Doner_Type			NVARCHAR(20)
	);
--
CREATE TABLE DimPatient
	(
	Patient_SK		INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Patient_AK		INT NOT NULL,
	Gender			NVARCHAR(5),
	Weight			INT NOT NULL,
	Height			DECIMAL(5,2),
	Diagonosis_Code NVARCHAR(10),
	Patient_Blood_Type NVARCHAR(5)
	);

--
CREATE TABLE FactDonationMatch
	(
	RequestID_DD		INT NOT NULL,
	Doner_SK			INT NOT NULL,
	Patient_SK			INT NOT NULL,
	Request_SK			INT NOT NULL,
	Date_SK				INT NOT NULL,
	Quantity_Requested	INT NOT NULL,
	CONSTRAINT pk_FactDonationMatch PRIMARY KEY (RequestID_DD,Doner_SK, Patient_SK, Request_SK, Date_SK),
	CONSTRAINT fk_FactDonationMatch_DimDate FOREIGN KEY (Date_SK) REFERENCES DimDate(Date_SK),
	CONSTRAINT fk_FactDonationMatch_DimDoner FOREIGN KEY (Doner_SK) REFERENCES DimDoner(Doner_SK),
	CONSTRAINT fk_FactDonationMatch_DimPatient FOREIGN KEY (Patient_SK) REFERENCES DimPatient(Patient_SK),
	CONSTRAINT fk_FactDonationMatch_DimRequest FOREIGN KEY (Request_SK) REFERENCES DimRequest(Request_SK)
	);


