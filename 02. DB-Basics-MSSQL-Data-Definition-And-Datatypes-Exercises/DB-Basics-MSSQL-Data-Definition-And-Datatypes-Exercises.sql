--Data Definition and Datatypes

--4

	INSERT INTO Towns (Id, Name) VALUES
	(1, 'Sofia'),
	(2, 'Plovdiv'),
	(3, 'Varna')

	INSERT INTO Minions (Id, Name, Age, TownId) VALUES
	(1, 'Kevin', 22, 1),
	(2, 'Bob', 15, 3),
	(3, 'Steward', null, 2)

--7

		Create TABLE People (
	Id INT PRIMARY KEY IDENTITY,
		Name NVARCHAR(200) not null,
		Picture VARBINARY(MAX) CHECK (DATALENGTH(PICTURE) <= 2097152),
		Height DECIMAL(8, 2),
		Weight DECIMAL(8, 2),
		Gender NVARCHAR(1) check (Gender in ('m', 'f')) not null,
		Birthdate DATE not null,
		Biography NVARCHAR(MAX) 
	)

	INSERT INTO People (Name, Picture, Height, Weight, Gender, Birthdate, Biography) VALUES
	('Joro', null, 60,23, 'f', '19920405', 'someTextHere'),
    ('Zoro', null, 60,23, 'f', '19920405', 'someTextHere'),
    ('Toro', null, 60,23, 'f', '19920405', 'someTextHere'),
    ('Boro', null, 60,23, 'f', '19920405', 'someTextHere'),
    ('Goro', null, 60,23, 'f', '19920405', 'someTextHere')
--8
	Create TABLE Users (
	Id BIGINT PRIMARY KEY IDENTITY,
		Name VARCHAR(30) not null,
		Password VARCHAR(26) not null,
		ProfilePicture  VARBINARY(MAX) CHECK (DATALENGTH(ProfilePicture) <= 900*1024),
		LastLoginTime DATETIME,
		IsDeleted  BIT
	)

	INSERT INTO Users (Name, Password, ProfilePicture, LastLoginTime, IsDeleted) VALUES
	('Joro',  'asdasds', null, '19920405', 0),
	('Zoro', 'asdasds', null, '19920405', 0),
	('Toro', 'asdasds', null, '19920405', 0),
	('Boro', 'asdasds', null, '19920405', 0),
	('Goro', 'asdasds', null, '19920405', 0)

--13

	CREATE TABLE Directors(
	Id INT  PRIMARY KEY IDENTITY,
	DirectorName NVARCHAR(MAX) NOT NULL,
	Notes NVARCHAR(MAX) 
	)

	INSERT INTO Directors (DirectorName, Notes) VALUES
	('ZORO', 'notes1'),
	('JORO', 'notes2'),
	('RORO', 'notes3'),
	('TORO', 'notes4'),
	('GORO', 'notes5')

	CREATE TABLE Genres(
	Id INT  PRIMARY KEY IDENTITY,
	GenreName NVARCHAR(MAX) NOT NULL,
	Notes NVARCHAR(MAX) 
	)

	INSERT INTO Genres  (GenreName, Notes) VALUES
	('ZORO', 'notes1'),
	('JORO', 'notes2'),
	('RORO', 'notes3'),
	('TORO', 'notes4'),
	('GORO', 'notes5')

	CREATE TABLE Categories (
	Id INT  PRIMARY KEY IDENTITY,
	Categories NVARCHAR(MAX) NOT NULL,
	Notes NVARCHAR(MAX) 
	)

	INSERT INTO Categories  (Categories, Notes) VALUES
	('ZORO', 'notes1'),
	('JORO', 'notes2'),
	('RORO', 'notes3'),
	('TORO', 'notes4'),
	('GORO', 'notes5')

	CREATE TABLE Movies  (
	Id INT  PRIMARY KEY IDENTITY,
	Title NVARCHAR(MAX) NOT NULL,
	DirectorId INT REFERENCES Directors(Id) NOT NULL,
	CopyrightYear DATE,
	Length DECIMAL(8,2),
	GenreId INT REFERENCES Genres(Id) NOT NULL,
	CategoryId INT REFERENCES Categories(Id) NOT NULL,
	Rating DECIMAL(8,2),
	Notes NVARCHAR(MAX)
	)

	INSERT INTO Movies  (Title, DirectorId, CopyrightYear, Length, GenreId, CategoryId,Rating,Notes) VALUES
	('ZORO', 2, null, 12,4,  1, null,  'notes1'),
	('JORO', 2, null, 12,4,  1, null,  'notes2'),
	('RORO', 2, null, 12,4,  1, null,  'notes3'),
	('TORO', 2, null, 12,4,  1, null,  'notes4'),
	('GORO', 2, null, 12,4,  1, null,  'notes5')

--14

	CREATE TABLE Categories (
	Id INT PRIMARY KEY IDENTITY not null,
	CategoryName NVARCHAR(MAX) NOT NULL,
	DailyRate DECIMAL(8,2) NOT NULL,
	WeeklyRate DECIMAL(8,2) NOT NULL,
	MonthlyRate DECIMAL(8,2) NOT NULL,
	WeekendRate DECIMAL(8,2) NOT NULL,
	)


	INSERT INTO Categories (CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate) VALUES
	('Joro',  60,23, 150.24, 166.42),
	 ('Zoro', 60,23, 150.24, 166.42),
	 ('Toro', 60,23, 150.24, 166.42)
 

	CREATE TABLE Cars(
	Id INT PRIMARY KEY IDENTITY not null,
	PlateNumber NVARCHAR(MAX) NOT NULL,
	Manufacturer VARCHAR(MAX) NOT NULL,
	Model VARCHAR(MAX) NOT NULL,
	CarYear DATE NOT NULL,
	CategoryId INT REFERENCES Categories(Id) NOT NULL,
	Doors INT,
	Picture BINARY,
	Condition NVARCHAR(MAX),
	Available BIT NOT NULL
	)
	INSERT INTO Cars(PlateNumber, Manufacturer, Model, CarYear, CategoryId, Doors, Picture, Condition,Available ) VALUES
	('A1231123D', 'NISSAN','350z', '19940201', 2, 3, null, 'GOOD', 1),
	('A1231123D', 'NISSAN','Skyline', '19940201', 2, 3, null, 'GOOD', 1),
	('A1231123D', 'NISSAN','GTR', '19940201', 2, 3, null, 'GOOD', 1)


	CREATE TABLE Employees (
	Id INT PRIMARY KEY IDENTITY not null,
	FirstName NVARCHAR(MAX) NOT NULL,
	LastName NVARCHAR(MAX) NOT NULL,
	Title NVARCHAR(MAX) NOT NULL,
	Notes NVARCHAR(MAX)
	)

	INSERT INTO Employees(FirstName, LastName, Title, Notes) values
	('Pesho', 'Pesho', 'Mr.', null),
	('Resho', 'Fesho', 'Mr.', null),
	('Tesho', 'Besho', 'Mr.', null)


	CREATE TABLE Customers (
	Id INT PRIMARY KEY IDENTITY not null,
	DriverLicenceNumber NVARCHAR(MAX) NOT NULL,
	FullName NVARCHAR(MAX) NOT NULL,
	Address NVARCHAR(MAX) NOT NULL,
	City NVARCHAR(MAX)NOT NULL,
	ZIPCode INT NOT NULL,
	Notes NVARCHAR(MAX)
	)

	INSERT INTO Customers(DriverLicenceNumber, FullName, Address, City, ZIPCode, Notes) VALUES
	('A1212DD', 'Pesho Geshov', 'The Adress of pesho', 'Sofia', '1234', null),
	('A12D12DD', 'Gesho Geshov', 'The Adress of Fesho', 'Moscow', '1234', null),
	('A12A12DD', 'Resho Geshov', 'The Adress of Besho', 'Tokyo', '1234', null)

	CREATE TABLE RentalOrders(
	Id INT PRIMARY KEY IDENTITY not null,
	EmployeeId INT REFERENCES Employees(Id) NOT NULL,
	CustomerId INT REFERENCES Customers(Id) NOT NULL,
	CarId INT REFERENCES Cars(Id) NOT NULL,
	TankLevel INT NOT NULL,
	KilometrageStart INT NOT NULL,
	KilometrageEnd INT NOT NULL,
	TotalKilometrage INT NOT NULL,
	StartDate DATE NOT NULL,
	EndDate DATE NOT NULL,
	TotalDays INT,
	RateApplied BIT NOT NULL,
	TaxRate DECIMAL(8,2),
	OrderStatus BIT NOT NULL,
	Notes NVARCHAR(MAX)
	)

	INSERT INTO RentalOrders(EmployeeId, CustomerId, CarId, TankLevel, KilometrageStart, KilometrageEnd, TotalKilometrage, StartDate, EndDate, TotalDays, RateApplied, TaxRate,OrderStatus, Notes) VALUES
	(1, 3, 1, 55, 65, 78, 190, '20070805', '20081106', 300, 1, 65.45, 0, NULL),
	(1, 3, 1, 55, 65, 78, 190, '20070605', '20081106', 300, 1, 65.45, 0, NULL),
	(1, 3, 1, 55, 65, 78, 190, '20070505', '20081106', 300, 1, 65.45, 0, NULL)

--15

		--•	Employees (Id, FirstName, LastName, Title, Notes)
	CREATE TABLE Employees (
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(MAX) NOT NULL,
	LastName NVARCHAR(MAX) NOT NULL,
	Title NVARCHAR(MAX) NOT NULL,
	NOTES NVARCHAR(MAX)
	)
	INSERT INTO Employees (FirstName, LastName, Title, NOTES) VALUES
	('Zoro', 'Zorov', 'Mr.', 'someNotes'),
	('Doro', 'Torov', 'Mr.', 'someNotes'),
	('Foro', 'Gorov', 'Mr.', 'someNotes')

	--Customers (AccountNumber, FirstName, LastName, PhoneNumber, 
	--EmergencyName, EmergencyNumber, Notes)

	CREATE TABLE Customers(
	AccountNumber INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(MAX) NOT NULL,
	LastName NVARCHAR(MAX) NOT NULL,
	PhoneNumber BIGINT NOT NULL,
	EmergencyName NVARCHAR(MAX) NOT NULL,
	EmergencyNumber BIGINT NOT NULL,
	Notes NVARCHAR(MAX)
	)

	INSERT INTO Customers (FirstName, LastName, PhoneNumber, EmergencyName, EmergencyNumber, Notes) VALUES
	('Zoro', 'Boro', 08123123, 'Soro', 09123123, 'notes'),
	('Voro', 'Foro', 08123123, 'Soro', 09123123, 'notes'),
	('Noro', 'Soro', 08123123, 'Soro', 09123123, 'notes')

	create table RoomStatus (
	RoomStatus INT PRIMARY KEY  NOT NULL,
	Notes NVARCHAR(MAX) NOT NULL
	)
	INSERT INTO RoomStatus (RoomStatus, Notes) VALUES
	(1, 'GREAT'),
	(2, 'BAD'),
	(3, 'COOL')

	CREATE TABLE RoomTypes (
	RoomType INT PRIMARY KEY  NOT NULL,
	Notes NVARCHAR(MAX) NOT NULL
	)
	insert into RoomTypes(RoomType, Notes) VALUES
	(1, 'GOOD ROOM'),
	(2, 'COOL ROOM'),
	(3, 'BAD ROOM')

	create table BedTypes  (
	BedType INT PRIMARY KEY NOT NULL,
	Notes NVARCHAR(MAX)
	)
	INSERT INTO BedTypes (BedType, Notes) VALUES
	(1,'SOMEBED'),
	(2,'ANOTHERBED'),
	(3, 'LASTBED')

	CREATE TABLE Rooms (
	RoomNumber INT PRIMARY KEY NOT NULL,
	RoomType INT REFERENCES RoomTypes(RoomType) NOT NULL,
	BedType INT REFERENCES BedTypes(BedType) NOT NULL,
	Rate DECIMAL(8,2) NOT NULL,
	RoomStatus INT REFERENCES RoomStatus(RoomStatus) NOT NULL,
	Notes NVARCHAR(MAX)
	)
	INSERT INTO Rooms (RoomNumber, RoomType, BedType, Rate, RoomStatus, Notes) VALUES
	(1, 2, 1, 12.45, 2, 'COOLNOTES'),
	(2, 2, 1, 12.45, 2, 'COOLNOTES'),
	(3, 2, 1, 12.45, 2, 'COOLNOTES')

	--•	Payments (Id, EmployeeId, PaymentDate, 
	--AccountNumber, FirstDateOccupied, 
	--LastDateOccupied, TotalDays, AmountCharged, 
	--TaxRate, TaxAmount, PaymentTotal, Notes)

	CREATE TABLE Payments (
	Id INT PRIMARY KEY IDENTITY,
	EmployeeId INT REFERENCES Employees(Id) not null,
	PaymentDate DATE not null,
	AccountNumber INT REFERENCES Customers(AccountNumber) NOT NULL,
	FirstDateOccupied DATE NOT NULL,
	LastDateOccupied DATE NOT NULL,
	TotalDays INT NOT NULL,
	AmountCharged DECIMAL (8,2) NOT NULL, 
	TaxRate DECIMAL (8,2) NOT NULL,
	TaxAmount DECIMAL(8,2) NOT NULL,
	PaymentTotal DECIMAL(8,2) NOT NULL,
	Notes NVARCHAR(MAX)
	)
	INSERT INTO Payments (EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, 
	LastDateOccupied, TotalDays, AmountCharged, TaxRate, TaxAmount, PaymentTotal, Notes) VALUES
	(1, '20150213', 1, '20150314', '20150415', 65, 65.25, 55, 45.25, 1500, 'NOTED'),
	(2, '20150213', 2, '20150314', '20150415', 65, 65.25, 55, 45.25, 1500, 'NOTED'),
	(3, '20150213', 3, '20150314', '20150415', 65, 65.25, 55, 45.25, 1500, 'NOTED')

	CREATE TABLE Occupancies (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	EmployeeId INT REFERENCES Employees(Id) NOT NULL,
	DateOccupied DATE NOT NULL,
	AccountNumber INT REFERENCES Customers(AccountNumber) NOT NULL,
	RoomNumber INT REFERENCES Rooms(RoomNumber) NOT NULL,
	RateApplied DECIMAL(8,2) NOT NULL,
	PhoneCharge DECIMAL(8,2) NOT NULL,
	Notes NVARCHAR(MAX)
	)

	INSERT INTO Occupancies (EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied, PhoneCharge, Notes) VALUES
	(1, '20170306', 1, 2, 15, 14, 'NOTE'),
	(3, '20170306', 2, 2, 15, 14, 'NOTE'),
	(2, '20170306', 3, 2, 15, 14, 'NOTE')

--19
	SELECT * FROM Towns
	SELECT * FROM Departments
	SELECT * FROM Employees 

--20

	SELECT * FROM Towns ORDER BY Name
	SELECT * FROM Departments ORDER BY Name
	SELECT * FROM Employees ORDER BY Salary DESC 

--21

	SELECT Name FROM Towns ORDER BY Name
	SELECT Name From Departments ORDER BY Name
	Select FirstName, LastName, JobTitle, Salary FROM Employees ORDER BY Salary DESC 

--22

	UPDATE Employees
	SET Salary = Salary + ((Salary * 10) /100)
	SELECT SALARY FROM Employees

--23

	UPDATE Payments
	SET TaxRate = TaxRate - ((TaxRate * 3)/100)
	select TaxRate FROM Payments

--24

	TRUNCATE TABLE Occupancies 
