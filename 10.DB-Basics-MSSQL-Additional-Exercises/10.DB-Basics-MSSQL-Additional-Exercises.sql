--Additional Exercises

--01

	select SUBSTRING(Email,  CHARINDEX('@', Email) + 1, LEN(Email)) as [Email Provider], count(users.Id) as 
	[Number Of Users] from users
	group by SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email))
	order by [number of users] desc, [Email Provider]

--02

	select g.Name as [Game], gt.Name as [Game Type], Username, Level, Cash, c.Name as Character from users as usr 
	inner join usersgames as ug on usr.Id = ug.UserId
	inner join games as g on ug.GameId = g.Id
	inner join GameTypes as gt on g.GameTypeId = gt.Id 
	inner join Characters as c on c.Id = ug.CharacterId
	ORDER BY Level DESC, Username, Game

--03

	select Username, g.Name as [Game], count(items.Price) as [Items Count], Sum(Price) as 
	[Items Price] from users as usr 
	inner join usersgames as ug on usr.Id = ug.UserId
	inner join games as g on ug.GameId = g.Id
	inner join UserGameItems as ui on ui.UserGameId = ug.Id
	inner join Items on ui.ItemId = items.Id
	Group by usr.Username, g.Name
	HAVING Count(items.Id) >= 10 
	ORDER BY [Items Count] desc, [Items Price] desc, Username

--04

	select 
		u.Username, 
		g.name as Game, 
		MAX(c.name) as Character,
		SUM(its.strength) + MAX(gts.strength) + MAX(cs.strength) as Strength,
		SUM(its.defence) + MAX(gts.defence) + MAX(cs.defence) as Defence,
		SUM(its.speed) + MAX(gts.speed) + MAX(cs.speed) as Speed,
		SUM(its.mind) + MAX(gts.mind) + MAX(cs.mind) as Mind,
		SUM(its.luck) + MAX(gts.luck) + MAX(cs.luck) as Luck
	from users u
	join UsersGames as ug on ug.UserId = u.id
	join games as g on ug.GameId = g.id
	join GameTypes as gt on gt.id = g.GameTypeId
	join [Statistics] as gts on gts.id = gt.BonusStatsId
	join characters as c on ug.CharacterId = c.id
	join [Statistics] as cs on cs.id = c.StatisticId
	join UserGameItems as ugi on ugi.UserGameId = ug.id
	join items i on i.id = ugi.ItemId
	join [Statistics] as its on its.id = i.StatisticId
	group by u.Username, g.name
	order by strength desc, defence desc, speed desc, mind desc, luck desc

--05

	select items.Name as Name,  items.Price, items.MinLevel as MinLevel, Strength, Defence, Speed,
	Luck, Mind  from items 
	inner join [Statistics] on items.StatisticId = [Statistics].Id
	WHERE  Mind > (select avg(Mind) from [Statistics])
	and Luck  > (select avg(Luck) from [Statistics])
	and Speed  > (select avg(Speed) from [Statistics])
	order by items.Name

--06

	select DISTINCT i.Name as Item, i.Price, i.MinLevel, gt.Name as [Forbidden Game Type] from items as i 
	LEFT JOIN GameTypeForbiddenItems as gti on i.Id = gti.ItemId
	LEFT join GameTypes as gt on gt.Id = gti.GameTypeId
	LEFt join GameTypeForbiddenItems as gtfi on i.Id = gtfi.ItemId
	order by gt.Name desc, i.Name

--07

	begin tran
	declare @alexCash decimal(15,2) = (select Cash from UsersGames where UserId = 5 and GameId = 221)
	declare @blackGuardPrice decimal (15,2)= (select Price from Items where Name = 'Blackguard')
	declare @botPot decimal (15,2)= (select Price from Items where Name = 'Bottomless Potion of Amplification')
	declare @EyePrice decimal (15,2)= (select Price from Items where Name = 'Eye of Etlich (Diablo III)')
	declare @GemPrice decimal (15,2)= (select Price from Items where Name = 'Gem of Efficacious Toxin')
	declare @GoldenPrice decimal (15,2)= (select Price from Items where Name = 'Golden Gorget of Leoric')
	declare @HellfirePrice decimal (15,2)= (select Price from Items where Name = 'Hellfire Amulet')
	declare @total DECIMAL (15,2) = @blackGuardPrice + @botPot + @EyePrice + @GemPrice + @GoldenPrice + @HellfirePrice
	if @alexCash < @total
	begin
	rollback
	end
	else
	begin
	update UsersGames
	SET Cash -= @total
	where UserId = 5 and GameId = 221
	insert into UserGameItems (ItemId, UserGameId) values
	(51, 235),
	(71, 235),
	(157, 235),
	(184, 235),
	(197, 235),
	(223, 235)
	end

	select Username, g.Name, ug.Cash, i.Name from users as u 
	inner join usersgames as ug on u.Id = ug.UserId
	inner join Games as g on ug.GameId = g.Id
	inner join UserGameItems as ugi on ug.Id = ugi.UserGameId
	inner join items as i on ugi.ItemId = i.Id
	where g.Name = 'Edinburgh'
	order by i.Name

--08 

	select PeakName, MountainRange as Mountain, Elevation from mountains as m inner join peaks as p on m.Id = p.MountainId
	order by Elevation Desc

--09

	select PeakName, MountainRange  as Mountain, c.CountryName, cont.ContinentName from mountains as m 
	inner join peaks as p on m.Id = p.MountainId
	inner join MountainsCountries as mc on mc.MountainId = m.Id
	inner join Countries as c on mc.CountryCode = c.CountryCode
	inner join Continents as cont on c.ContinentCode = cont.ContinentCode
	ORDER BY PeakName, CountryName

--10

	select CountryName, ContinentName, Count(r.Id) as RiversCount, ISNULL(sum(r.Length), 0) as TotalLength from Countries as c 
	inner join Continents as cont on c.ContinentCode = cont.ContinentCode
	LEFT join CountriesRivers as cr on cr.CountryCode = c.CountryCode
	LEFT join Rivers as r on cr.RiverId = r.Id
	group by CountryName, ContinentName
	order by RiversCount DESC, TotalLength DESC, CountryName

--11

	select curr.CurrencyCode as CurrencyCode, curr.Description as Currency , COUNT(CountryName) as NumberOfCountries 
		from countries cntr 
		right join Currencies as curr on curr.CurrencyCode = cntr.CurrencyCode
		Group by curr.CurrencyCode, curr.Description
		order by NumberOfCountries desc, Currency

--12

	select cnt.ContinentName, SUM(AreaInSqKm) as CountriesArea, sum(CAST (Population  AS bigint)) as Population from Continents as
	 cnt inner join 
	Countries as cntr on cnt.ContinentCode = cntr.ContinentCode
	group by cntr.ContinentCode, cnt.ContinentName
	ORDER BY Population DESC

--13

	create table Monasteries(
	Id INT PRIMARY KEY IDENTITY, 
	Name VARCHAR(50) NOT NULL, 
	CountryCode CHAR(2) FOREIGN KEY REFERENCES Countries(CountryCode))

	INSERT INTO Monasteries(Name, CountryCode) VALUES
	('Rila Monastery “St. Ivan of Rila”', 'BG'), 
	('Bachkovo Monastery “Virgin Mary”', 'BG'),
	('Troyan Monastery “Holy Mother''s Assumption”', 'BG'),
	('Kopan Monastery', 'NP'),
	('Thrangu Tashi Yangtse Monastery', 'NP'),
	('Shechen Tennyi Dargyeling Monastery', 'NP'),
	('Benchen Monastery', 'NP'),
	('Southern Shaolin Monastery', 'CN'),
	('Dabei Monastery', 'CN'),
	('Wa Sau Toi', 'CN'),
	('Lhunshigyia Monastery', 'CN'),
	('Rakya Monastery', 'CN'),
	('Monasteries of Meteora', 'GR'),
	('The Holy Monastery of Stavronikita', 'GR'),
	('Taung Kalat Monastery', 'MM'),
	('Pa-Auk Forest Monastery', 'MM'),
	('Taktsang Palphug Monastery', 'BT'),
	('Sümela Monastery', 'TR')

	UPDATE Countries SET Isdeleted=1 WHERE CountryCode IN (select CountryCode from  CountriesRivers 
	group by CountryCode
	HAVING count(riverid)>3)

	select NAME as Monasery, Countries.CountryName  
	from Monasteries inner join Countries on Monasteries.CountryCode = Countries.CountryCode
	where Countries.Isdeleted = 0
	order by Monasteries.Name

--14
	update countries 
	set CountryName = 'Burma'
	where CountryName = 'Myanmar'

	INSERT INTO Monasteries VALUES ('Hanga Abbey',  (select CountryCode from Countries where CountryName = 'Tanzania'))
	INSERT INTO Monasteries Values ('Myin-Tin-Daik', (select CountryCode from Countries where CountryName = 'Myanmar'))
	select cont.ContinentName, c.CountryName, count(m.name) as MonasteriesCount from monasteries as m
	RIGHT JOIN Countries as c on c.CountryCode = m.CountryCode
	INNER JOIN Continents as cont on c.ContinentCode = cont.ContinentCode
	group by C.CountryName, cont.ContinentName, c.isdeleted
	having c.isdeleted = 0
	ORDER BY MonasteriesCount DESC, c.CountryName