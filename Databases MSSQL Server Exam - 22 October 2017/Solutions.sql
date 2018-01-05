--01

	CREATE TABLE Users (
	Id INT PRIMARY KEY IDENTITY,
	Username NVARCHAR(30) NOT NULL UNIQUE,
	Password NVARCHAR(50) NOT NULL,
	Name NVARCHAR(50),
	Gender CHAR(1) CHECK (Gender IN ('M', 'F')),
	BirthDate DateTime,
	Age INT,
	Email NVARCHAR(50) NOT NULL
	)
	
	CREATE TABLE Departments (
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(50) NOT NULL
	)
	
	CREATE TABLE Employees(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(25),
	LastName NVARCHAR(25),
	Gender CHAR(1) CHECK (Gender IN ('M', 'F')),
	BirthDate DATETIME,
	Age INT, 
	DepartmentId INT FOREIGN KEY REFERENCES Departments(Id)
	)
	
	CREATE TABLE Categories (
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL,
	DepartmentId INT FOREIGN KEY REFERENCES Departments(Id)
	)
	
	create table [Status](
	Id INT PRIMARY KEY IDENTITY,
	Label VARCHAR(30) NOT NULL
	)

	CREATE TABLE Reports(
	Id INT PRIMARY KEY IDENTITY,
	CategoryId INT NOT NULL FOREIGN KEY REFERENCES Categories(Id),
	StatusId INT NOT NULL FOREIGN KEY REFERENCES Status(Id),
	OpenDate DATETIME NOT NULL,
	CloseDate DATETIME,
	Description VARCHAR(200),
	UserId INT NOT NULL FOREIGN KEY REFERENCES Users(Id),
	EmployeeId INT NOT NULL FOREIGN KEY REFERENCES Employees(Id)
	)

--02

	INSERT INTO Employees (FirstName,	LastName,	Gender,	Birthdate,	DepartmentId) VALUES 
	('Marlo',	'O’Malley',	'M','9/21/1958', (Select Id from Departments where [Name] = 'Infrastructure')),
	('Niki',	'Stanaghan','F','11/26/1969',(Select Id from Departments where [Name] = 'Emergency')),
	('Ayrton',	'Senna',	'M',	'03/21/1960', (Select Id from Departments where [Name] =	'Event Management')),
	('Ronnie',	'Peterson',	'M',	'02/14/1944',(Select Id from Departments where [Name] = 'Event Management' )),
	('Giovanna',	'Amati',	'F',	'07/20/1959',	(Select Id from Departments where [Name] = 'Roads Maintenance'))
	
	INSERT INTO Reports (CategoryId,	StatusId,	OpenDate,	CloseDate,	[Description],	UserId,	EmployeeId) VALUES
	((SELECT Id FROM Categories where [Name] = 'Snow Removal'),	 (SELECT Id From Status where Label = 'waiting'),	    '04/13/2017', NULL,	'Stuck Road on Str.133',	6,	2),
	((SELECT Id FROM Categories where [Name] = 'Sports Events'),	(SELECT Id From Status where Label ='completed'),	'09/05/2015',	'12/06/2015',	'Charity trail running',	3,	5),
	((SELECT Id FROM Categories where [Name] = 'Dangerous Building'),	(SELECT Id From Status where Label ='in progress'),	'09/07/2015', NULL,		'Falling bricks on Str.58',	5	,2),
	((SELECT Id FROM Categories where [Name] = 'Streetlight'),	(SELECT Id From Status where Label ='completed'),	'07/03/2017',	'07/06/2017',	'Cut off streetlight on Str.11',1,	1)

--03
	UPDATE Reports
	SET StatusId = 2
	where StatusId = 1 and CategoryId = 4
	
--04

	delete from reports 
	where StatusId = 4
	
--05

	select Username, Age from users
	ORDER BY Age, Username DESC
	
--06

	select [Description], OpenDate  from Reports
	where EmployeeId IS NULL
	order by OpenDate, Description
	
--07

	Select FirstName, LastName, r.Description,  CONVERT(char(10), r.OpenDate,126) as OpenDate from Employees as e 
	inner join Reports as r ON e.Id = r.EmployeeId
	Where r.EmployeeId IS NOT NULL
	ORDER BY EmployeeId, OpenDate, r.Id
	
--08

	select  [Name] as CategoryName, Count(r.CategoryId) as ReportsNumber from Categories as c INNER JOIN Reports as r
	ON c.Id = r.CategoryId
	group by [Name] 
	order by count(r.CategoryId) desc, CategoryName
	
--09

	select c.Name as CategoryName, d.[Employees Number] from Categories as c inner join (
	Select DepartmentId, Count(Id) as [Employees Number] from Employees
	GROUP BY DepartmentId) as d on  c.DepartmentId =  d.DepartmentId
	ORDER BY CategoryName
	
--10

	SELECT 
	Concat(e.FirstName, ' ', e.LastName) as Name,
	ISNULL(COUNT(r.UserId), 0) AS [Users Number]
	from Employees as e
	LEFT JOIN Reports AS r ON r.EmployeeId = e.Id
	GROUP BY CONCAT(e.FirstName, ' ', e.LastName)
	ORDER BY [Users Number] DESC, Name

--11

	Select OpenDate, Description, Email as [Reporter Email] from Users as u JOIN (
	select CategoryId, UserId, OpenDate, r.[Description] from Reports as r 
	Where CloseDate IS NULL 
	and LEN(r.[Description]) > 20  and CHARINDEX('str',r.[Description]) > 0) as d ON u.Id = d.UserId
	JOIN Categories as c on c.Id = d.CategoryId
	JOIN Departments as dep on dep.Id = c.DepartmentId
	WHERE dep.Name IN ('Infrastructure', 'Emergency', 'Roads Maintenance')
	ORDER BY OpenDate, [Reporter Email], u.Id
	
--12

	Select DISTINCT (c.Name) as [Category Name]  from Categories as c 
	INNER JOIN reports as r on r.CategoryId = c.Id
	inner Join users as u on r.UserId = u.Id
	WHERE DAY(u.BirthDate) = DAY(r.OpenDate) AND MONTH(u.BirthDate) = MONTH(r.OpenDate)
	ORDER BY [Category Name]
	
--13

	select DISTINCT Username from users
	JOIN Reports on users.Id = Reports.UserId
	WHERE ISNUMERIC(Left(Username,1)) = 1 and CAST(LEFT(Username,1) AS INT) = CAST(Reports.CategoryId as INT)
	OR ISNUMERIC(Right(Username,1)) = 1 and CAST(RIGHT(Username,1) AS INT) = CAST (Reports.CategoryId as  INT)
	order by Username
	
--14

	SELECT 
	CONCAT(e.FirstName, ' ', e.LastName) AS Name,

		CAST(COUNT(CASE
			WHEN YEAR(r.OpenDate) < 2016 AND YEAR(r.CloseDate) = 2016 THEN 1
			WHEN YEAR(r.OpenDate) = 2016 AND YEAR(r.CloseDate) = 2016 THEN 2
			END) AS VARCHAR(MAX))
			+ '/' +
			CAST(COUNT(CASE 
			WHEN YEAR(r.OpenDate) = 2016 AND r.CloseDate IS NULL THEN 1
			ELSE 0
			END) - 	COUNT(CASE
			WHEN YEAR(r.OpenDate) < 2016 AND YEAR(r.CloseDate) = 2016 THEN 1 END) AS VARCHAR(MAX))
	FROM Reports AS r
	JOIN Employees AS e ON e.Id = r.EmployeeId
		WHERE YEAR(r.OpenDate) = 2016 OR YEAR(r.CloseDate) = 2016
		GROUP BY CONCAT(e.FirstName, ' ', e.LastName), e.Id
		HAVING COUNT(CASE 
				WHEN YEAR(r.OpenDate) = 2016 AND r.CloseDate IS NULL THEN 1
				ELSE 0
		END) - 	COUNT(CASE
			WHEN YEAR(r.OpenDate) < 2016 AND YEAR(r.CloseDate) = 2016 THEN 1 END) > 0
	ORDER BY Name, e.Id

--15

	select d.Name as [Department Name], 
	CAST (ISNULL(CAST (AVG(datediff(day,  OpenDate, CloseDate)) as varchar(50)), 'no info') as varchar(50))
	as [Average Duration]
	from Reports r
	inner join categories c on r.CategoryId = c.Id
	inner join Departments d on d.Id = c.DepartmentId
	group by d.Name
	order by [Department Name]

--16

	select d.Name, c.Name, CAST(ROUND(CAST(COUNT(c.Name) AS DECIMAL(10, 2))/ SUM(COUNT(d.Name)) OVER(PARTITION BY d.Name) * 100, 0) as INT)
		FROM Departments as d
		JOIN Categories as c on c.DepartmentId = d.Id
		JOIN Reports as r on r.CategoryId = c.Id
		GROUP BY d.Name, c.Name
	ORDER BY d.Name, c.Name

--17

	create function udf_GetReportsCount(@employeeId INT, @statusId INT)
	RETURNS INT
	as
	BEGIN
		DECLARE @RESULT INT = (select COUNT(Id) as ReportsCount 
		from Reports where EmployeeId = @employeeId)
		return @RESULT
	END

--18

	CREATE PROC usp_AssignEmployeeToReport(@employeeId INT, @reportId INT)
	AS
    Begin Tran
	declare @firstDepId INT = (select DepartmentId From Employees where @employeeId = employees.Id)
	declare @secDepId INT  = (select DepartmentId From Categories c
	inner join reports as r on r.CategoryId = c.Id where r.Id = @reportId)

    IF  @firstDepId  = @secDepId
	 BEGIN 
	 UPDATE REPORTS 
	 set reports.EmployeeId = @employeeId
	 where reports.Id = @reportId
	 COMMIT
	 END
	ELSE	
	 begin
	 rollback
	 RAISERROR ('Employee doesn''t belong to the appropriate department!',16,1)
	 end

--19

	create trigger tr_Completed ON REPORTS
	AFTER UPDATE
	as
	UPDATE Reports
	set StatusId = (Select Id FROM Status where status.Label = 'completed') 
	where EmployeeId IN (select EmployeeId from inserted where CloseDate IS NOT NULL) 

--20

	SELECT 
		c.Name, (select COUNT(Id)
		FROM Reports
		where StatusId IN (1, 2) and CategoryId = (select Id from Categories where Name = c.Name)),
		CASE
			WHEN (SELECT COUNT(Id)
			FROM Reports
			WHERE StatusId = 1 AND CategoryId = (SELECT Id FROM Categories WHERE Name = c.Name)) > (SELECT COUNT(Id)
				FROM Reports
				WHERE StatusId = 2 AND CategoryId = (SELECT Id FROM Categories WHERE Name = c.Name))
			THEN 'waiting'
			WHEN (SELECT COUNT(Id)
			FROM Reports
			WHERE StatusId = 1 AND CategoryId = (SELECT Id FROM Categories WHERE Name = c.Name)) < (SELECT COUNT(Id)
				FROM Reports
				WHERE StatusId = 2 AND CategoryId = (SELECT Id FROM Categories WHERE Name = c.Name))
			THEN 'in progress'
			ELSE 'equal'
		END
	FROM Categories AS c
	JOIN Reports AS r ON r.CategoryId = c.Id
	JOIN Status AS s ON s.Id = r.StatusId
	WHERE s.Label IN ('waiting', 'in progress')
	GROUP BY c.Name
ORDER BY c.Name

