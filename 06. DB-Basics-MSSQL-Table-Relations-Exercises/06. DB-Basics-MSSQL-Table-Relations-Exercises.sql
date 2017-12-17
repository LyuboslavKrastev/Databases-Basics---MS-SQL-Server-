--Table Relations

--1

	CREATE TABLE Persons (
	 PersonID INT NOT NULL UNIQUE,
	 FirstName NVARCHAR(20) NOT NULL,
	 Salary DECIMAL(8,2) NOT NULL,
	 PassportID INT NOT NULL UNIQUE
	)

	CREATE TABLE Passports (
	 PassportID INT NOT NULL UNIQUE,
	 PassportNumber NVARCHAR(MAX) NOT NULL,
	)

	INSERT INTO Persons(PersonID, FirstName, Salary, PassportID) VALUES 
	(1, 'Roberto', 43300.00, 102),
	(2, 'Tom', 56100.00, 101),
	(3, 'Yana', 60200.00, 103)

	INSERT INTO Passports (PassportID, PassportNumber) VALUES 
	(101, 'N34FG21B'),
	(102, 'K65LO4R7'),
	(103, 'ZE657QP2')

	ALTER TABLE Persons
	ADD CONSTRAINT PK_PersonId PRIMARY KEY (PersonID)

	ALTER TABLE Passports
	ADD CONSTRAINT PK_PassnId PRIMARY KEY (PassportID)

	ALTER TABLE Persons
	ADD CONSTRAINT FK_Persons FOREIGN KEY (PassportID) REFERENCES Passports(PassportID)

--2

	CREATE TABLE Manufacturers (
	ManufacturerID INT PRIMARY KEY IDENTITY,
	Name VARCHAR(20) NOT NULL,
	EstablishedOn DATE 
	)

	CREATE TABLE Models (
	ModelID INT PRIMARY KEY IDENTITY (101,1),
	Name VARCHAR(20) NOT NULL,
	ManufacturerID INT FOREIGN KEY REFERENCES Manufacturers(ManufacturerID) 
	)

	INSERT INTO Manufacturers VALUES
	('BMW', '07/03/1916'),
	('Tesla', '01/01/2003'),
	('Lada', '01/05/1966')

	INSERT INTO Models VALUES 
	('X1', 1),
	('i6', 1),
	('Model S', 2),
	('Model X', 2),
	('Model 3', 2),
	('Nova', 3)

--3
	CREATE TABLE Students 
	(
	StudentID INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(20) NOT NULL
	)
	CREATE TABLE Exams 
	(
	ExamID INT PRIMARY KEY IDENTITY(101, 1),
	Name NVARCHAR(20) NOT NULL
	)
	CREATE TABLE StudentsExams 
	(
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID)  NOT NULL,
	ExamID INT FOREIGN KEY REFERENCES Exams(ExamID) NOT NULL,
	CONSTRAINT pk_Constraint PRIMARY KEY (StudentID, ExamID)
	)

	INSERT INTO Students VALUES ('Mila'), ('Toni'), ('Ron')
	INSERT INTO Exams VALUES ('SpringMVC'), ('Neo4j'), ('Oracle 11g')
	INSERT INTO StudentsExams VALUES (1, 101),(1, 102),(2, 101),(3, 103),(2, 102),(2, 103)

--4

	create TABLE Teachers (
	TeacherID INT IDENTITY(101,1),
	Name VARCHAR(20) NOT NULL,
	ManagerID INT,
	)

	INSERT INTO Teachers (Name, ManagerID) VALUES
	('John', null),
	('Maya', 106),
	('Silvia', 106),
	('Ted', 105),
	('Mark', 101),
	('Greta', 101)

	ALTER TABLE Teachers
	ADD CONSTRAINT PK_Teachers PRIMARY KEY(TeacherID),
	FOREIGN KEY (ManagerID) REFERENCES Teachers(TeacherID)

--5

	CREATE TABLE ItemTypes (
	ItemTypeID INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL
	)

	CREATE TABLE Cities(
	CityID INT PRIMARY KEY IDENTITY,
	Name varchar(50) NOT NULL
	)

	CREATE TABLE Items (
	ItemID INT PRIMARY KEY IDENTITY,
	Name VARCHAR (50) NOT NULL,
	ItemTypeID int FOREIGN KEY REFERENCES ItemTypes(ItemTypeID)
	)

	CREATE TABLE Customers (
	CustomerID INT PRIMARY KEY IDENTITY,
	Name VARCHAR (50) NOT NULL,
	Birthday date,
	CityID int FOREIGN KEY REFERENCES Cities(CityID)
	)

	CREATE TABLE Orders(
	OrderID INT PRIMARY KEY IDENTITY,
	CustomerID int FOREIGN KEY REFERENCES Customers(CustomerID)
	)

	CREATE TABLE OrderItems(
	OrderID INT,
	ItemID INT,
	CONSTRAINT PK_OI PRIMARY KEY (OrderID, ItemID),
	FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
	FOREIGN KEY (ItemID) REFERENCES Items(ItemID)
	)

--6

	CREATE TABLE Majors(
	MajorID INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL
	)

	CREATE TABLE Students (
	StudentID INT PRIMARY KEY IDENTITY,
	StudentNumber INT,
	StudentName VARCHAR(50),
	MajorID INT FOREIGN KEY REFERENCES Majors(MajorID)
	)

	Create TABLE Payments (
	PaymentID INT PRIMARY KEY IDENTITY,
	PaymentDate DATE,
	PaymentAmount Decimal(10,2),
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID)
	)

	CREATE TABLE Subjects(
	SubjectID INT PRIMARY KEY IDENTITY,
	SubjectName VARCHAR(50) NOT NULL
	)

	CREATE TABLE Agenda(
	StudentID INT,
	SubjectID Int,
	CONSTRAINT pk_Agenda PRIMARY KEY(StudentID, SubjectID),
	FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
	FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
	)

--9

	Select MountainRange, PeakName, Elevation from mountains as m
	 JOIN Peaks as p
	ON m.Id = p.MountainId
	Where MountainId = 17
	ORDER BY Elevation DESC