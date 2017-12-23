--Functions and Procedures

--01

	create PRoc usp_GetEmployeesSalaryAbove35000 as (
	select FirstName, LastName from Employees
	where Salary > 35000
	)

--02

	create proc usp_GetEmployeesSalaryAboveNumber  @number decimal (18,4) as 
	(
		  select FirstName, LastName from Employees
		  where salary>=@number
	) 

--03

	create proc usp_GetTownsStartingWith @name varchar(55) as
	(
	select Name from Towns
	where name like @name + '%'
	)

--04

	create proc usp_GetEmployeesFromTown @townName varchar(max) as
	(
	select FirstName, LastName from Employees inner join Addresses on Employees.AddressID = Addresses.AddressID
	inner join towns on Addresses.TownID = towns.TownID
	where towns.Name = @townName

)

--05

	create function ufn_GetSalaryLevel (@salary DECIMAL(18,4)) 
	returns varchar(50)
	as
	BEGIN
	 declare @level varchar(50)

	 if @salary < 30000
	 BEGIN 
	 SET @level = 'Low'
	 END
	 ELSE IF @salary BETWEEN 30000 AND 50000
	 BEGIN
	 SET @level = 'Average'
	 END
	 else	
	 begin
	 set @level = 'High'
	 end	
	 return  @level
	END

--06 

	create proc usp_EmployeesBySalaryLevel @salaryLevel varchar(50) as
	(
	  Select FirstName as [First Name], lastname as [Last Name] from (
	  select firstname, lastname, dbo.ufn_GetSalaryLevel(Salary) as SalaryLevel from Employees) as a
	  where SalaryLevel = @salaryLevel
	)

--07

	create function ufn_IsWordComprised(@setOfLetters varchar(50), @word varchar(50)) 
	returns bit
	as
	begin
	declare @result bit = 1
	declare @index int = 1
	declare @currChar char

	while @index<=LEN(@word)
	begin
	set @currChar = SUBSTRING(@word, @index, 1)
	if @setOfLetters not like '%' + @currChar + '%'
	begin
	set @result = 0
	break
	end
	set @index+=1
	end

	return @result
	end

--08

	create  proc usp_DeleteEmployeesFromDepartment  (@departmentID int)
	AS 
	BEGIN
	DELETE FrOM EmployeesProjects WHERE EmployeeID IN (SELECT EmployeeID FROM Employees WHERE DepartmentID = @departmentID)
	
	ALTER TABLE Departments
	aLter Column managerID INT NULL;
	
	UPDATE Departments
	 SET ManagerID = NULL
	 WHERE ManagerID IN (SELECT EmployeeID FROM Employees WHERE DepartmentID = @departmentID) 
	
	 ALTER TABLE Employees
	 aLter Column managerID INT NULL;
	
	UPDATE Employees
	 SET ManagerID = NULL
	 WHERE ManagerID IN (SELECT EmployeeID FROM Employees WHERE DepartmentID = @departmentID)
	
	 DELETE FROM Employees
	 WHERE DepartmentID = @departmentID
	
	 DELETE FROM Departments
	 WHERE DepartmentID = @departmentID
	END
	
	select count(EmployeeID) from Employees where DepartmentID=@departmentID

--9

	create proc usp_GetHoldersFullName as (

	select FirstName + ' ' + LastName as [Full Name] from AccountHolders)

--10

	create proc usp_GetHoldersWithBalanceHigherThan (@num money) as
	(select FirstName as [First Name], LastName as [Last Name]
	from AccountHolders INNER JOIN Accounts on AccountHolders.Id = Accounts.AccountHolderId
	group by firstname, LastName
	having sum(balance)>@num)

--11

	create function ufn_CalculateFutureValue (@sum decimal(15,2), @YearlyInterestRate float, @NumberOfYears int)
	RETURNS decimal(8,4)
	as
	BEGIN 
	declare @result decimal(8,4)
	set @result = @sum * (POWER(1+@yearlyInterestRate, @NumberOfYears) )
	return @result
	END

--12

	create proc usp_CalculateFutureValueForAccount (@accountId int, @InterestRate Float )
	as
	begin 
	select a.Id as [Account Id], FirstName as [First Name], LastName as [Last Name], Balance as [Current Balance], 
	dbo.ufn_CalculateFutureValue(Balance, @InterestRate, 5) as [Balance in 5 years]
	from AccountHolders as a inner join Accounts as acc on a.Id = acc.Id
	WHERE a.Id = @accountId
	end


--13 
	create function ufn_CashInUsersGames (@gameName NVARCHAR(MAX))
	RETURNS TABLE 
	AS   
	RETURN	select sum(cashList.cash) as SumCash from (
			select Cash, Row_Number() OVER(ORDER BY Cash DESC) as RowNum FROM UsersGames ug 
			JOIN Games g on ug.GameId = g.Id
			WHERE g.Name = @gameName) as cashList
		    where RowNum%2 <> 0