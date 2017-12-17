--2

	select * from departments

--3

select Name from departments

--4

	SELECT FirstName, Lastname, Salary FROM Employees

--5

	SELECT FirstName, MiddleName, Lastname FROM Employees

--6

	SELECT FirstName + '.' + LastName + '@softuni.bg' FROM Employees  AS [Full Email Address]

--7

	SELECT DISTINCT Salary FROM Employees 

--8

	SELECT * FROM Employees 
	WHERE JobTitle = 'Sales Representative'

--9

	SELECT FirstName, LastName, JobTitle FROM Employees 
	WHERE Salary >= 20000 AND Salary<=30000 

--10

	SELECT FirstName + ' ' + MiddleName  + ' ' + LastName FROM Employees AS [Full Name]
	WHERE (Salary = 25000  OR Salary=14000 OR Salary=12500  OR Salary=23600) AND 
	FirstName IS NOT NULL AND MiddleNAme IS NOT NULL AND LastName IS NOT NULL

--11

	SELECT FirstName, LastName FROM Employees 
	WHERE ManagerId IS NULL

--12

	SELECT  FirstName, LastName, Salary FROM Employees 
	WHERE Salary>50000 
	ORDER BY Salary DESC

--13

	SELECT TOP 5  FirstName, LastName FROM Employees 
	WHERE Salary>50000 
	ORDER BY Salary DESC

--14

	SELECT FirstName, LastName FROM Employees 
	WHERE NOT DepartmentID = 4

--15 

	SELECT * FROM Employees 
	ORDER BY Salary DESC,
	FirstName ASC, LastName Desc, MiddleName ASC

--16

	CREATE VIEW V_EmployeesSalaries AS
	SELECT FirstName, LastName, Salary FROM Employees 

--17

	CREATE VIEW V_EmployeeNameJobTitle  AS
	SELECT FirstName + ' ' + ISNULL (MiddleName, '') + ' ' + LastName  AS [Full Name], JobTitle FROM Employees
	WHERE FirstName IS NOT NULL AND LastName IS NOT NULL

--18

	SELECT DISTINCT JOBTITLE FROM Employees

--19

	SELECT TOP 10 ProjectId AS ID, Name, Description, StartDate, EndDate FROM Projects
	order BY STARTDATE, Name

--20

	SELECT TOP 7 FirstName, LastName, HireDate FROM Employees
	ORDER BY HireDate DESC

--21

	UPDATE Employees 
	SET SALARY = SALARY + SALARY*12/100
	where DepartmentID IN (1, 2, 4, 11)
	SELECT Salary From Employees

--22

	Select PeakName from Peaks ORDER BY PeakName

--23

	SELECT TOP 30 CountryName, Population FROM Countries
	WHERE ContinentCode = 'EU' 
	ORDER BY Population Desc, CountryName

--24 
	SELECT CountryName, CountryCode,   
	CASE 
	WHEN CurrencyCode = 'EUR' THEN 'Euro'
	ELSE 'Not Euro'
	END AS Currency
	FROM Countries
	ORDER BY CountryName

--25
	Select Name From Characters
	ORDER BY Name