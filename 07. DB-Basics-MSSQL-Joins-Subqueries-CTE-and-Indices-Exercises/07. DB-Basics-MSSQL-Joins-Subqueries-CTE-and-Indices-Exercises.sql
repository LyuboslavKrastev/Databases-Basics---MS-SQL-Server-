--Joins, Subqueries, CTE and Indices

--1

	select top 5 employeeid, jobtitle, e.AddressID, AddressText from employees as e INNER JOIN Addresses as a
	ON a.AddressID = e.AddressID

--2

	select top 50 FirstName, LastName, t.Name, AddressText  FROM 
	Employees as e 
	INNER JOIN Addresses as a ON  e.AddressID = a.AddressID
	INNER JOIN Towns as t on a.TownID = t.TownID
	ORDER BY FirstName, LastName

--3

	select EmployeeId, FirstName, LastName, d.Name as DepartmentName FROM Employees as e  INNER JOIN Departments as d ON E.DepartmentID = d.DepartmentID
	WHERE d.Name = 'Sales'
	ORDER BY EmployeeID

--4

	select top 5 EmployeeId, FirstName,  Salary, d.Name as DepartmentName FROM Employees as e  INNER JOIN Departments as d ON E.DepartmentID = d.DepartmentID
	WHERE Salary>15000
	ORDER BY e.DepartmentID

--5

	SELECT top 3 e.EmployeeId, FirstName From Employees as e left  JOIN EmployeesProjects as p ON e.EmployeeID = p.EmployeeID
	where p.EmployeeID IS NULL
	ORDER by e.EmployeeID

--6

	Select FirstName, LastName, HireDate, d.Name as DeptName FROM Employees as e  INNER JOin Departments as d
	ON e.DepartmentID = d.DepartmentID
	where HireDate> '1.1.1999' AND d.Name IN ('Sales', 'Finance')
	ORDER BY HireDate

--7

	select top 5 e.EmployeeID, FirstName, p.Name as ProjectName from employees as e inner join EmployeesProjects as ep 
	ON e.EmployeeID = ep.EmployeeID
	INNER JOIN Projects  as p ON ep.ProjectID = p.ProjectID
	Where p.StartDate > '20020813' AND p.EndDate IS NULL
	ORDER BY e.EmployeeID

--8

	select e.EmployeeID, FirstName, 
	CASE 
	WHEN YEAR(StartDate) >= 2005 then NULL
	else
			p.Name
	END AS ProjectName from employees as e 
	 inner join EmployeesProjects as ep 
	ON e.EmployeeID = ep.EmployeeID
	INNER JOIN Projects  as p ON ep.ProjectID = p.ProjectID
	Where E.EmployeeID = 24 

--9

	select e1.EmployeeID, e1.FirstName, e1.ManagerID, e2.FirstName from Employees as e1
	INNER JOIN Employees as e2 ON e1.ManagerId = e2.EmployeeId
	where e1.ManagerID = 3 or e1.ManagerID = 7
	ORDER BY e1.EmployeeID

--10

	select top 50 e1.EmployeeID, e1.FirstName + ' ' + e1.LastName as EmployeeName
	,  e2.FirstName + ' ' + e2.LastName as ManagerName
	, d.Name as DepartmentName from Employees as e1
	INNER JOIN Employees as e2 ON e1.ManagerId = e2.EmployeeId
	INNER JOIN Departments as d ON e1.DepartmentID = d.DepartmentID
	ORDER BY e1.EmployeeID

--11

	SELECT MIN(a.averageSalary) as MinAverageSalary FROM 
	(select AVG(salary) as averageSalary from Employees
	GROUP BY DepartmentID) as a

--12

	select CountryCode, MountainRange, PeakName, Elevation from Mountains as m inner join peaks as p ON m.Id = p.MountainId
	INNER Join MountainsCountries as MC ON mc.MountainId = m.Id
	WHERE CountryCode = 'BG' AND Elevation > 2835
	ORDER BY Elevation DESC

--13

	SELECT CountryCode, Count(CountryCode) AS MountainRanges from MountainsCountries
	GROUP BY CountryCode
	HAVING CountryCode IN ('BG', 'RU', 'US')

--14

	select TOP 5 CountryName, RiverName from Countries as c 
	LEFT JOIN CountriesRivers as CR ON  c.CountryCode = cr.CountryCode
	LEFT Join Rivers as r ON cr.RiverId = r.Id
	WHERE c.ContinentCode = 'AF'
	ORDER BY CountryName

--15

	select b.ContinentCode, b.CurrencyCode, b.CurrencyUsage FROM
	(SELECT 
	a.ContinentCode, a.CurrencyCode, a.CurrencyUsage, DENSE_RANK() OVER (PARTITION BY(a.ContinentCode) 
	ORDER BY a.CurrencyUsage DESC ) as Rank FROM (
	select ContinentCode, CurrencyCode, count(CurrencyCode) as CurrencyUsage from countries
	GROUP BY ContinentCode, CurrencyCode
	having count(CurrencyCode) >1) as a) as b
	WHERE RANK = 1
	ORDER BY ContinentCode

--16

SELECT COUNT(a.Test) AS CountryCode FROM (
select c.CountryCode as TEST from countries as c LEFT JOIN MountainsCountries as mc ON c.CountryCode = mc.CountryCode
WHERE MountainId IS NULL) as a

--17

	SELECT top 5 a.CountryName, MAX(a.PeakElevation) as HighestPeakElevation, MAX(a.RiverLength) as LongestRiverLength FROM (
	select CountryName, R.Length as RiverLength, p.Elevation as PeakElevation FROM Countries as c INNER Join CountriesRivers as CR on c.CountryCode = cr.CountryCode
	INNER JOIN MountainsCountries as MC on c.CountryCode = mc.CountryCode
	INNER JOIN Rivers as R ON cr.RiverId = r.Id
	INNER JOIN Mountains as M ON MC.MountainId = M.Id
	INNER JOIN Peaks as P on m.Id = p.MountainId) as a
	GROUP BY a.CountryName
	ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC

--18

	select top 5 b.Country, b.[Highest Peak Name], b.[Highest Peak Elevation], b.Mountain from
	(select a.Country, a.[Highest Peak Name], a.[Highest Peak Elevation], a.Mountain, DENSE_RANK() OVER(PARTITION BY a.COUNTRY ORDER BY a.[Highest Peak Elevation] DESC) as [RANK] from 
	(select CountryName as Country,  
	CASE 
	 WHEN p.PeakName IS NULL THEN '(no highest peak)'
	 else
	  p.PeakName END AS [Highest Peak Name], 
	 CASE 
	 WHEN p.Elevation IS NULL THEN '0'
	 else
	  p.elevation END AS [Highest Peak Elevation], 
	  CASE 
	 WHEN m.MountainRange IS NULL THEN '(no mountain)'
	 else
	  m.MountainRange END AS [Mountain] from countries as C 
	LEFT JOIN MountainsCountries as MC ON c.CountryCode = Mc.CountryCode
	LEFT JOIN Mountains as M on Mc.MountainId = m.Id
	left JOIN Peaks AS P on m.Id = p.MountainId
	) as a) as b
	WHERE b.RANK=1
	ORDER BY b.Country, b.[Highest Peak Name]