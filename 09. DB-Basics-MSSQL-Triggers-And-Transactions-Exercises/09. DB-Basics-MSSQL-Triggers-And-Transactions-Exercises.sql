--Triggers and Transactions

--01

	 CREATE TRIGGER Insert_Into_Logs ON 
	  Accounts
	  after Update
	  AS
		begin
		   INSERT INTO Logs(AccountId, OldSum, NewSum)
		   select i.Id, d.Balance, i.Balance from inserted as i
		   inner join deleted as d on d.Id = i.Id
		end

--02

	create TRIGGER EmailTrigger ON Logs 
	AFTER INSERT
	AS 
	BEGIN
	 declare @oldSum DECIMAL(15,2) = (select OldSum from inserted)
	 declare @newSum DECIMAL(15,2) = (select NewSum from inserted)
	 declare @accountID INT = (select AccountId from inserted)
	 declare @date  VARCHAR(50) = CONVERT(varchar, GETDate(), 100)
	 declare @test VARCHAR(max) = 
	 CONCAT('On ', @date, ' your balance was changed from ', @oldSum, ' to ',@newSum, '.')
	 declare @subject VARCHAR(max) = CONCAT('Balance change for account: ',  (select  AccountId from inserted))
	 INSERT INTO NotificationEmails(Recipient, Subject, Body) VALUES
	  (@accountID, @subject, @test)
	END

--03

	create proc usp_DepositMoney (@AccountId INT, @MoneyAmount DECIMAL(15,4))
	as
	BEGIN
	 UPDATE Accounts
	 set Balance += @MoneyAmount
	 where Id = @AccountId
	END

--04

	create proc usp_WithdrawMoney  (@AccountId INT, @MoneyAmount DECIMAL(15,4))
	as
	BEGIN
	 UPDATE Accounts
	 set Balance -= @MoneyAmount
	 where Id = @AccountId
	END

--05

	CREATE PROC usp_TransferMoney(@SenderId INT, @ReceiverId INT, @Amount DECIMAL(15,4)) 
	AS
	 Begin Try
		Begin Tran
		EXEC usp_WithdrawMoney @SenderId, @Amount
	 EXEC usp_depositmoney @ReceiverId, @Amount
		Commit Tran
	End Try

	Begin Catch
		If ( @@TranCount > 0 )
			Rollback Tran
	End Catch

--07

	declare @userId INT = (select Id from users where Username = 'Stamat')
	declare @gameID INT = (SELECT Id from Games where games.Name = 'Safflower')
	declare @usergameID INT = (select id from UsersGames where UserId = @userId AND GameId = @gameID)
	begin try 
	begin tran
	 update UsersGames set Cash -= (select sum(Price) From ITEMS Where MinLevel IN (11,12) )
	 where Id = @usergameID

	 declare @userBalance decimal(15,4) = (select cash from UsersGames where Id = @usergameID)
	 if @userBalance < 0
	 begin
		ROLLBACK 
		return
	 end

	 insert into usergameitems
	  select Id, @usergameID From ITEMS Where MinLevel IN (11,12) 
	  commit
	  end try 
	begin catch
	rollback
	end catch
	begin try
	  begin tran
	 update UsersGames set Cash -= (select sum(Price) From ITEMS Where MinLevel BETWEEN 19 and 21)
	 where Id = @usergameID

	 SET @userBalance  = (select cash from UsersGames where Id = @usergameID)
	 if @userBalance < 0
	 begin
		ROLLBACK 
		return
	 end

	 insert into usergameitems
	  select Id, @usergameID From ITEMS Where MinLevel IN (19,20,21) 
	  commit
	end try
	begin catch
	rollback
	end catch

	select  i.Name as [Item Name] from Items as i
	JOIN UserGameItems as u on i.Id = u.ItemId
	where u.UserGameId = @usergameID
	order by [Item Name]

--08

	CREATE PROC usp_AssignProject(@emloyeeId INT, @projectID INT)
	AS
	 Begin tran
	 declare @projectCount INT =
	 (select Count(ProjectID) as ProjectCount from EmployeesProjects
	 group  by EmployeeID
	 having EmployeeID = @emloyeeId)
	 if @projectCount >= 3
	 begin
	 RAISERROR('The employee has too many projects!', 16, 1)
	 ROLLBACK
	 end
	 else
	 begin
	 INSERT INTO EmployeesProjects VALUES (@emloyeeId, @projectID)
	 commit
	 end

--09

	CREATE TRIGGER tr_Deleted_Employees ON Employees
	AFTER Delete
	AS
	BEGIN
		 INSERT INTO Deleted_Employees (FirstName, LastName, MiddleName, JobTitle, DepartmentID, Salary)
		 select FirstName, LastName, MiddleName, JobTitle, DepartmentID, Salary
		 from deleted
	 
	END