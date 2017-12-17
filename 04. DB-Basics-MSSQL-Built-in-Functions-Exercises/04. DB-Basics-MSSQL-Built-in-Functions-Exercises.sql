--Built-in Functions

--1

	Select FirstName, LastName From Employees
	Where FirstName Like 'Sa%'

--2

	Select FirstName, LastName From Employees
	Where LastName Like '%ei%'

--3

	Select FirstName From Employees
	Where (DepartmentID = 3 OR DepartmentID = 10) 
	AND HireDate BETWEEN '1994' AND  '2006'

--4

	SELECT FirstName, LastName FROM Employees 
	WHERE  JobTitle NOT LIKE '%Engineer%'

--5

	SELECT Name FROM Towns 
	WHERE  LEN(Name) IN (5,6)
	ORDER BY Name

--6

	SELECT TownId, Name FROM Towns 
	WHERE  Name LIKE 'M%' OR
	NAME LIKE 'K%'OR
	NAME LIKE  'B%' OR
	NAME LIKE 'E%'
	ORDER BY Name

--7

	SELECT TownId, Name FROM Towns 
	WHERE  Name NOT LIKE 'R%' AND
	NAME NOT LIKE 'B%' AND
	NAME NOT LIKE  'D%' 
	ORDER BY Name

--8 

	CREATE VIEW V_EmployeesHiredAfter2000  AS 
	SELECT FirstName, LastName FROM Employees
	WHERE HireDate> '12/31/2000'

--9

	SELECT FirstName, LastName FROM Employees
	WHERE LEN(LastName)=5

--10

	SELECT CountryName, IsoCode FROM Countries 
	WHERE CountryName LIKE '%A%A%A%'
	ORDER BY IsoCode

--11

	SELECT PeakName, RiverName, CONCAT (LOWER (PeakName), SUBSTRING(LOWER(RiverName),2, LEN(RiverName))) AS Mix  FROM Peaks, Rivers 
	WHERE RIGHT(PeakName, 1) = LEFT(RiverName, 1)
	ORDER BY Mix

--12

	Select TOP 50 Name, convert(varchar(10), Start, 120) AS Start FROM Games
	WHERE  Start > '2011' AND Start < '2013'
	ORDER BY Start, Name

--13

	SELECT Username, SUBSTRING(Email, CHARINDEX('@', Email, 1)+1, LEN(Email)) AS [Email Provider] FROM Users
	ORDER BY [Email Provider], Username

--14

	SELECT Username, IpAddress FROM Users
	WHERE IpAddress LIKE '___.1_%._%.___'
	ORDER BY Username

--15

	SELECT Name as Game, 
	CASE 
	  WHEN datepart(hour, Start) >= 0 and datepart(hour, Start) < 12 THEN 'Morning'
		WHEN datepart(hour, Start)  >= 12 and  datepart(hour, Start)< 18 THEN 'Afternoon'
		WHEN datepart(hour, Start)  >= 18 and  datepart(hour, Start)< 24 THEN 'Evening'
	  END AS [Part of the Day],
	CASE 
	  WHEN Duration<=3 THEN 'Extra Short'
		WHEN Duration>=4 and Duration<=6 THEN 'Short'
	  WHEN Duration>6 THEN 'Long'
	  ELSE 'Extra Long'
	  END AS [Duration]
	FROM Games
	Order By Name, Duration

--16

	Select ProductName,OrderDate, DATEADD (DAY , 3 , OrderDate) AS  [Pay Due],  DATEADD (MONTH , 1 , OrderDate)
	 AS  [Deliver  Due]   from Orders