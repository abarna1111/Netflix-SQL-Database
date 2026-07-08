create database netflix 
use netflix 
CREATE TABLE SubscriptionPlans ( SubscriptionID INT PRIMARY KEY, PlanName VARCHAR(50), Price DECIMAL(10,2), VideoQuality VARCHAR(20), DevicesAllowed INT );
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    Country VARCHAR(50),
    SubscriptionID INT,
    JoinDate DATE,
    FOREIGN KEY (SubscriptionID)
        REFERENCES SubscriptionPlans(SubscriptionID)
);
CREATE TABLE Profiles ( ProfileID INT PRIMARY KEY, UserID INT, ProfileName VARCHAR(50), AgeGroup VARCHAR(20), FOREIGN KEY (UserID) REFERENCES Users(UserID) );
CREATE TABLE Content ( ContentID INT PRIMARY KEY, Title VARCHAR(200), ContentType VARCHAR(20), ReleaseYear INT, Duration INT, LanguageID INT, RatingID INT );
CREATE TABLE Movies ( MovieID INT PRIMARY KEY, ContentID INT, BoxOffice VARCHAR(50), FOREIGN KEY (ContentID) REFERENCES Content(ContentID) );
CREATE TABLE Series ( SeriesID INT PRIMARY KEY, ContentID INT, TotalSeasons INT, FOREIGN KEY (ContentID) REFERENCES Content(ContentID) );
CREATE TABLE Seasons ( SeasonID INT PRIMARY KEY, SeriesID INT, SeasonNumber INT, FOREIGN KEY (SeriesID) REFERENCES Series(SeriesID) );
CREATE TABLE Episodes ( EpisodeID INT PRIMARY KEY, SeasonID INT, EpisodeNumber INT, EpisodeTitle VARCHAR(200), Duration INT, FOREIGN KEY (SeasonID) REFERENCES Seasons(SeasonID) );
CREATE TABLE Genres ( GenreID INT PRIMARY KEY, GenreName VARCHAR(50) );
CREATE TABLE ContentGenres ( ContentGenreID INT PRIMARY KEY, ContentID INT, GenreID INT, FOREIGN KEY (ContentID) REFERENCES Content(ContentID), FOREIGN KEY (GenreID) REFERENCES Genres(GenreID) );
CREATE TABLE Languages ( LanguageID INT PRIMARY KEY, LanguageName VARCHAR(50) );
CREATE TABLE Ratings ( RatingID INT PRIMARY KEY, RatingCode VARCHAR(10), Description VARCHAR(100) );
CREATE TABLE Actors ( ActorID INT PRIMARY KEY, ActorName VARCHAR(100), Country VARCHAR(50) );
CREATE TABLE ContentActors ( ContentActorID INT PRIMARY KEY, ContentID INT, ActorID INT, FOREIGN KEY (ContentID) REFERENCES Content(ContentID), FOREIGN KEY (ActorID) REFERENCES Actors(ActorID) );
CREATE TABLE Directors ( DirectorID INT PRIMARY KEY, DirectorName VARCHAR(100), Country VARCHAR(50) );
CREATE TABLE ContentDirectors ( ContentDirectorID INT PRIMARY KEY, ContentID INT, DirectorID INT, FOREIGN KEY (ContentID) REFERENCES Content(ContentID), FOREIGN KEY (DirectorID) REFERENCES Directors(DirectorID) );
CREATE TABLE WatchHistory ( WatchID INT PRIMARY KEY, ProfileID INT, ContentID INT, WatchDate DATETIME, WatchDuration INT, FOREIGN KEY (ProfileID) REFERENCES Profiles(ProfileID), FOREIGN KEY (ContentID) REFERENCES Content(ContentID) );
CREATE TABLE Reviews ( ReviewID INT PRIMARY KEY, ProfileID INT, ContentID INT, Rating INT, ReviewText TEXT, ReviewDate DATE, FOREIGN KEY (ProfileID) REFERENCES Profiles(ProfileID), FOREIGN KEY (ContentID) REFERENCES Content(ContentID) );
CREATE TABLE Payments ( PaymentID INT PRIMARY KEY, UserID INT, Amount DECIMAL(10,2), PaymentDate DATE, PaymentMethod VARCHAR(50), FOREIGN KEY (UserID) REFERENCES Users(UserID) );
CREATE TABLE Devices ( DeviceID INT PRIMARY KEY, UserID INT, DeviceName VARCHAR(100), DeviceType VARCHAR(50), LastLogin DATETIME, FOREIGN KEY (UserID) REFERENCES Users(UserID) );
INSERT INTO SubscriptionPlans VALUES
(1,'Basic',199.00,'HD',1),
(2,'Standard',499.00,'Full HD',2),
(3,'Premium',799.00,'Ultra HD',4);

INSERT INTO Genres VALUES
(1,'Action'),
(2,'Drama'),
(3,'Comedy'),
(4,'Sci-Fi'),
(5,'Thriller'),
(6,'Romance'),
(7,'Adventure'),
(8,'Crime'),
(9,'Fantasy'),
(10,'Horror');
-- Users Table 
-- Display all users
select * from Users
-- Show UserID, FullName, Email from Users.
select UserID,FullName,Email from Users
-- Find users from India.
select * from Users where Country='India'
-- Count total users.
select count(*) from Users
-- Display users joined after '2024-01-15'.
select * from Users where  JoinDate > '2024-01-15'
-- Subscription Plans (Simple)
-- Display all subscription plans.
select * from SubscriptionPlans
-- Find the most expensive plan.
select PlanName,Price from SubscriptionPlans order by Price desc limit 1
-- Find the cheapest plan.
select PlanName,Price from SubscriptionPlans order by Price limit 1
-- Show plans with HD quality.
select * from SubscriptionPlans where VideoQuality ='HD'
-- Count total subscription plans.
select count(*) from SubscriptionPlans
-- Profiles (Simple)
-- Display all profiles.
select * from Profiles
-- Find all Child profiles.
select * from Profiles where AgeGroup ='Child'
-- Count Adult profiles.
select count(*) from Profiles Where AgeGroup='Adult'
-- Show profile names only.
select ProfileName from Profiles
-- Find profiles belonging to UserID 101.
select * from Profiles where UserID = 101
-- Content (Intermediate)
-- Display all movies.
select * from Content where ContentType ='Movie'
-- Display all series.
select * from Content where ContentType='Series'
-- Find content released after 2020.
select * from Content where ReleaseYear > 2020
-- Show content longer than 120 minutes.
select * from Content where Duration > 120
-- Count total movies and series.
select count(*) from Content
-- Genres (Intermediate)
-- Display all genres.
select * from genres
select * from content
select * from contentgenres
SELECT c.Title,g.genrename
FROM Content c
JOIN ContentGenres cg
ON c.ContentID = cg.ContentID
JOIN Genres g
ON cg.GenreID = g.GenreID;
-- Find content in Drama genre.
show index from content
select c.title, 
from Content c
join ContentGenres cg
on c.ContentID=cg.ContentID
join Genres g
on cg.GenreID = g.GenreID
Where g.GenreName='Drama';
select * from Genres
-- Count content per genre.
select g.GenreName,count(cg.ContentID) as totalcontent
from Genres g
left join ContentGenres cg
on g.GenreID=cg.GenreID
group by g.GenreName;
-- Show genre-wise content list.
select g.GenreName,c.Title 
from Genres g
join ContentGenres cg
on g.GenreID = cg.GenreID
join Content c 
on cg.ContentID = c.ContentID ;
-- Actors (Intermediate)
-- Display all actors.
select * from Actors
-- Find actors from India.
select * from Actors where Country = 'India'
-- Count actors country-wise.
select Country, count(*) as totalactors from Actors group by Country
-- Show actors for a specific content.
select c.Title,a.ActorName 
from Content c
join ContentActors ca
on c.ContentID=ca.ContentID
join Actors a
on ca.ActorID=a.ActorID 
where c.Title='Carry On';
-- Find content featuring a specific actor.
select a.ActorName,c.Title
from Actors a
join ContentActors ca
on a.ActorID=ca.ActorID
join Content c
on ca.ContentID=c.ContentID;
-- Directors (Intermediate)
--  Display all directors.
select * from Directors
-- Find directors from USA.
select * from Directors where Country='USA'
-- Count directors by country.
select country ,count(*) as totaldirectors from Directors group by Country
-- Show content directed by a specific director.
select d.DirectorName,c.Title
from Directors d
join ContentDirectors cd
on d.DirectorID=cd.DirectorID
join Content c
on cd.ContentID=c.ContentID 
where d.DirectorName='Ridley Scott'
-- Find directors with multiple contents.
select d.DirectorName,count(*) as totalcontent
from Directors d
join ContentDirectors cd
on d.DirectorID=cd.DirectorID
join Content c
on cd.ContentID=c.ContentID group by d.DirectorName having totalcontent >1
-- Movies & Series (Intermediate)
-- Display all movies with box office.
select c.Title,m.BoxOffice 
from Movies m
join Content c
on c.ContentID=m.ContentID;
-- Find movie with highest box office.
select c.Title,m.BoxOffice 
from Movies m
join Content c
on c.ContentID=m.ContentID 
order by m.BoxOffice desc limit 1;
-- Show all series with total seasons.
select c.Title,s.TotalSeasons 
from Series s
join Content c
on s.ContentID=c.ContentID;
select * from Series
-- Find series having more than 5 seasons.
select c.Title,s.TotalSeasons
from Series s
join Content c
on s.ContentID=c.ContentID 
where s.TotalSeasons > 5;
-- Count total movies and series.
select count(ContentID) from Content
-- Episodes (Intermediate)
-- Display all episodes.
select * from Episodes
-- Find episodes of Season 601. 
select * from Episodes where SeasonID=601
-- Count episodes per season.
select SeasonID, count(EpisodeNumber) as numberofepisode from Episodes group by SeasonID
select * from Episodes
-- Show longest episode.
select * from Episodes order by Duration desc limit 1
-- Show shortest episode.
select * from Episodes order by Duration  limit 1

-- Watch History (Intermediate)
-- Display watch history.
select * from WatchHistory
select * from Users
-- Find most watched content.
select count( w.WatchID) as watchcount,c.Title
from WatchHistory w 
join Content c
on w.ContentID=c.ContentID 
group by c.Title  order by watchcount desc limit 1;
-- Show watch history of ProfileID 1001.
select * from WatchHistory where ProfileID=1001
-- Count total watch records.
select count(*) from WatchHistory
-- Find average watch duration.
select avg(WatchDuration) from WatchHistory
-- Reviews (Intermediate)
-- Display all reviews.
select * from Reviews
-- Find reviews with rating 5.
select * from Reviews where Rating=5
-- Show average rating.
select avg(Rating) from Reviews
-- Find highest-rated content.
select avg(r.Rating) as avgrating, c.Title 
from Reviews r
join Content c
on r.ContentID=c.ContentID group by c.Title order by avgrating desc limit 1 ;
-- Count reviews per content.
select count(r.ReviewID),c.Title 
from Reviews r
join Content c
on r.ContentID=c.ContentID
group by c.Title
-- Payments (Intermediate)
-- Display all payments.
select * from Payments
-- Calculate total revenue.
select sum(Amount) as totalrevenue from Payments
-- Find highest payment.
select max(Amount) as highestpayment from Payments
-- Count payments by method.
select PaymentMethod,count(PaymentID) from Payments group by PaymentMethod;
-- Show monthly revenue.
select Monthname(PaymentDate),sum(Amount) as monthlyrevenue from Payments group by Monthname(PaymentDate);
--  Devices (Intermediate)
-- Display all devices.
select * from Devices
-- Count devices by type.
select DeviceType, count(DeviceID) from Devices group by DeviceType;	
-- Show devices used by UserID 101.
select UserID,DeviceType from Devices where UserID=101	
-- Find latest login.
select  max(LastLogin) from Devices
-- Count total registered devices.
select count(*) as totalregister from Devices
-- Joins (Advanced)
-- Show user name and subscription plan.
select u.FullName,sp.PlanName
from Users u 
join SubscriptionPlans sp
on u.SubscriptionID=sp.SubscriptionID;
--  Show profile name with user name.
select p.ProfileName,u.FullName 
from Profiles p
join Users u
on u.UserID=p.UserID;
-- Show content title with genre.
select g.GenreName,c.Title 
from Genres g
join ContentGenres cg
on g.GenreID=cg.GenreID
join Content c
on cg.ContentID=c.ContentID;
-- Show content title with actor name.
select c.Title,a.ActorName 
from Actors a
join ContentActors ca
on a.ActorID=ca.ActorID
join Content c
on ca.ContentID = c.ContentID
-- Show content title with director name.
select * from Directors
select * from ContentDirectors
select c.Title,d.DirectorName from Directors d
join ContentDirectors cd
on d.DirectorID=cd.DirectorID
join Content c
on cd.ContentID=c.ContentID
-- Aggregate Functions (Advanced)
-- Find average content duration.
select avg(Duration) from Content
-- Find total revenue.
select sum(Amount) as totalrevenue from Payments
-- Find highest-rated content.
SELECT c.Title,
       AVG(r.Rating) AS AvgRating
FROM Reviews r
JOIN Content c
ON r.ContentID = c.ContentID
GROUP BY c.Title
ORDER BY AvgRating DESC
LIMIT 1;
-- Count content by language.
select count(c.Title),l.LanguageName from Languages l
join Content c
on c.LanguageID=l.LanguageID 
group by LanguageName
-- Count users by country
select count(UserID),Country from Users
group by Country
--  Group By (Advanced)
-- Count content per genre.
select g.GenreName,count(c.ContentID) 
from Genres g
join ContentGenres cg
on g.GenreID=cg.GenreID
join Content c
on cg.ContentID=c.ContentID
group by g.GenreName
-- Count users per subscription plan.
select count(u.UserID),s.PlanName 
from SubscriptionPlans s
join Users u
on u.SubscriptionID=s.SubscriptionID
group by s.PlanName
-- Count reviews per content.
select c.Title,count(r.ReviewID) 
from Content c
join Reviews r
on c.ContentID=r.ContentID
group by c.Title
-- Count devices per user.
select count(d.DeviceType),u.UserID
from Devices d
join Users u
on u.UserID=D.UserID
group by u.UserID
-- Count watch history per profile.
select count(w.WatchID),p.ProfileID 
from WatchHistory w
join Profiles p
on w.ProfileID=p.ProfileID
group by p.ProfileID
--  Subqueries (Advanced)
-- Find the most expensive subscription plan.
select PlanName,Price 
from subscriptionPlans
where Price =(select max(Price) as maxprice from SubscriptionPlans)
-- Find the cheapest subscription plan.
select PlanName,Price
from SubscriptionPlans 
where Price in 
(select min(Price) from SubscriptionPlans)
-- Find users with the Premium subscription plan.
select u.FullName,s.PlanName from SubscriptionPlans s
join Users u
on s.SubscriptionID=u.SubscriptionID   where PlanName in
(select PlanName  from SubscriptionPlans 
where PlanName= 'Premium')
-- Find the longest content.
select Title,Duration from Content 
where Duration in (select max(Duration) from Content);
-- Find the shortest content.
select Title,Duration from Content 
where Duration in (select min(Duration) from Content);
-- Find content with above-average duration.
select Title,Duration from Content where Duration > (select avg(Duration) from Content)
-- Find the highest-rated review.
select ReviewID,Rating from Reviews where Rating =(select max(Rating) from Reviews)
-- Find the lowest-rated review.
select ReviewID,Rating from Reviews where Rating =(select min(Rating) from Reviews)
-- Find the highest payment.
select PaymentID,Amount from Payments where Amount = (select max(Amount) from Payments)
-- Find users who paid the highest amount.
select u.FullName,p.Amount 
from Payments p
join Users u
on u.UserID=p.UserID
-- Find the latest joined user.
select * from Users
select FullName,JoinDate from Users where JoinDate in (select max(JoinDate) from Users)
-- Find content released in the latest year.
select Title,ReleaseYear from Content where ReleaseYear in (select max(ReleaseYear) from Content)
-- Find content released in the earliest year.
select Title,ReleaseYear from Content where ReleaseYear in (select min(ReleaseYear) from Content)
-- Find the actor with the smallest ActorID.
select ActorName,ActorID from Actors where ActorID = (select min(ActorID) from Actors)
-- Find the director with the highest DirectorID.
select DirectorName,DirectorID from Directors where DirectorID in (select max(DirectorID) from Directors)
-- Find content with above-average rating.
SELECT c.Title,
       AVG(r.Rating) AS AvgRating
FROM Reviews r
JOIN Content c
ON r.ContentID = c.ContentID
GROUP BY c.ContentID, c.Title
HAVING AVG(r.Rating) >
(
    SELECT AVG(Rating)
    FROM Reviews
);
-- Find users paying more than average.
select u.Fullname,p.Amount from Payments p
join Users u
on u.UserID=p.UserID
where p.Amount > (select avg(Amount) from Payments)
-- Find longest movie.
select Title,Duration from Content where ContentType='Movie' and
 Duration = (select max(Duration) from Content where ContentType='Movie')
-- Find most watched content.
select c.Title,count(w.WatchID) 
from WatchHistory w
join Content c
on w.ContentID = c.ContentID
group by c.Title order by count(w.WatchID) Desc  limit 1
-- Find highest revenue plan.
select * from Payments
select * from SubscriptionPlans
select s.PlanName,sum(p.Amount) as total from Payments p
join Users u
on p.UserID=u.UserID
join SubscriptionPlans s
on u.SubscriptionID = s.SubscriptionID
group by s.PlanName having total = (select max(total) from (select sum(p1.Amount) as total from Payments p1 join Users u1
on p1.UserID=u1.UserID
join SubscriptionPlans s1
on u1.SubscriptionID = s1.SubscriptionID group by s1.PlanName) as x)

