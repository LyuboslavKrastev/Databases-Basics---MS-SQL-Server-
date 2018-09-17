--1 

	Select COUNT(*) FROM WizzardDeposits

--2

	SELECT MAX(MagicWandSize) AS LongestMagicWand FROM WizzardDeposits

--3

	SELECT DepositGroup, MAX(MagicWandSize) AS LongestMagicWand FROM WizzardDeposits
	GROUP BY DepositGroup

--4

	SELECT TOP 2 DepositGroup From WizzardDeposits
	GROUP BY DepositGroup
	ORDER BY AVG(MagicWandSize)
	
	--other variant, which returns dynamically
	
	SELECT TOP 1 WITH TIES DepositGroup From WizzardDeposits
	GROUP BY DepositGroup
	ORDER BY AVG(MagicWandSize)

--5

	SELECT DepositGroup, Sum(DepositAmount) From WizzardDeposits
	GROUP BY DepositGroup

--6

	SELECT DepositGroup, Sum(DepositAmount) From WizzardDeposits
	WHERE MagicWandCreator = 'Ollivander family'
	GROUP BY DepositGroup

--7

	SELECT DepositGroup, Sum(DepositAmount) AS TotalSum From WizzardDeposits
	WHERE MagicWandCreator = 'Ollivander family'
	GROUP BY DepositGroup
	HAVING SUM(DepositAmount) < '150000'
	ORDER BY TotalSum DESC

--8

	SELECT DepositGroup, MagicWandCreator, Min(DepositCharge) FROM WizzardDeposits
	GROUP BY DepositGroup, MagicWandCreator
	ORDER BY MagicWandCreator, DepositGroup

--9

	Select  
	CASE 
	WHEN Age Between 0 AND 10 THEN '[0-10]'
	WHEN Age Between 11 AND 20 THEN '[11-20]'
	WHEN Age Between 21 AND 30 THEN '[21-30]'
	WHEN Age Between 31 AND 40 THEN '[31-40]'
	WHEN Age Between 41 AND 50 THEN '[41-50]'
	WHEN Age Between 51 AND 60 THEN '[51-60]'
	WHEN AGE >= 61 THEN '[61+]'
	END AS AgeGroup, COUNT(Age)
	From WizzardDeposits
	GROUP BY  
	CASE 
	WHEN Age Between 0 AND 10 THEN '[0-10]'
	WHEN Age Between 11 AND 20 THEN '[11-20]'
	WHEN Age Between 21 AND 30 THEN '[21-30]'
	WHEN Age Between 31 AND 40 THEN '[31-40]'
	WHEN Age Between 41 AND 50 THEN '[41-50]'
	WHEN Age Between 51 AND 60 THEN '[51-60]'
	WHEN AGE >= 61 THEN '[61+]'
	END 
	
	-- other variant, using a subquerry
	
	SELECT ageGroups.AgeGroup, COUNT(*) FROM
	(
	SELECT
	CASE 
	WHEN Age Between 0 AND 10 THEN '[0-10]'
	WHEN Age Between 11 AND 20 THEN '[11-20]'
	WHEN Age Between 21 AND 30 THEN '[21-30]'
	WHEN Age Between 31 AND 40 THEN '[31-40]'
	WHEN Age Between 41 AND 50 THEN '[41-50]'
	WHEN Age Between 51 AND 60 THEN '[51-60]'
	WHEN AGE >= 61 THEN '[61+]'
	END AS AgeGroup
	FROM WizzardDeposits
	) AS ageGroups
	GROUP BY ageGroups.AgeGroup

--10

	Select LEFT(FirstName,1) AS FirstLetter FROM WizzardDeposits
	WHERE DepositGroup = 'Troll Chest'
	GROUP BY LEFT(FirstName,1)

--11

	Select DepositGroup, IsDepositExpired, AVG(DepositInterest) AS AverageInterest FROM WizzardDeposits
	WHERE DepositStartDate > '01/01/1985'
	GROUP BY DepositGroup, IsDepositExpired
	ORDER BY DepositGroup DESC, IsDepositExpired

--12

	SELECT SUM(Difference) AS SumDifference FROM(
	SELECT HostAmount - GuestAmount AS Difference FROM (
	select FirstName, DepositAmount as HostAmount,
	LEAD (DepositAmount) OVER (ORDER BY Id) AS GuestAmount
	 from WizzardDeposits) AS DIFF) as Difff
	 
	 -- other variant, using a cursor
	 
	 DECLARE @currentDeposit DECIMAL(8,2)
	 DECLARE @previousDeposit DECIMAL(8,2)
	 DECLARE @totalSum DECIMAL(8,2) = 0	 
	 
	 DECLARE wizardCursor CURSOR FOR SELECT DepositAmount FROM WizzardDeposits
	 OPEN wizardCursor
	 FETCH NEXT FROM wizardCursor INTO @currentDeposit
	 
	 WHILE (@@FETCH_STATUS = 0) -- returns 0 when the cursor has data and 1 when empty
	 BEGIN
	 IF (@previousDeposit IS NOT NULL) -- so that we dont get (NULL - @currentDeposit) which will result in totalSum being NULL aswell
	 BEGIN
	 SET @totalSum += (@previousDeposit - @currentDeposit)
	 END
	 SET @previousDeposit = @currentDeposit
	 FETCH NEXT FROM wizardCursor INTO @currentDeposit
	 END
	 CLOSE wizardCursor
	 DEALLOCATE wizardCursor -- dispose of the cursor
	 
	 SELECT @totalSum
--13

	SELECT DepartmentID, SUM(Salary)  FROM Employees
	GROUP BY DepartmentID
	Order BY DepartmentID

--14

	SELECT DepartmentID, Min(Salary)  FROM Employees
	WHERE DepartmentID IN (2, 5, 7) AND HireDate > '01/01/2000'
	GROUP BY DepartmentID

--15

	SELECT * 
	INTO NewTable 
	FROM Employees
	Where Salary>30000 

	DELETE FROM NewTable
	WHERE ManagerID = 42

	UPDATE NewTable 
	SET Salary+=5000
	WHERE DepartmentID =1

	SELECT DepartmentId, AVG(Salary) FROM NewTable
	GROUP BY DepartmentID

--16

	SELECT DepartmentID, MAX(Salary) AS MaxSalary FROM Employees
	GROUP BY DepartmentID
	HAVING MAX(Salary) NOT BETWEEN 30000 and 70000

--17

	SELECT COUNT(EmployeeID) FROM Employees
	WHERE ManagerID IS NULL

--18

	SELECT DepartmentId, Salary FROM 
	(SELECT DepartmentId,
	 Salary AS Salary, DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) as Rank
	FROM Employees
	GROUP BY DepartmentID, Salary) AS PART
	WHERE Rank = 3

--19

	select top 10 e.FirstName, e.LastName, e.DepartmentID
	from (select e.*, avg(salary) over (partition by DepartmentId) as avgsalary
		  from employees e
		 ) e
	where e.salary > e.avgsalary;
