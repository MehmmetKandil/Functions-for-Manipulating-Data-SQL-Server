USE FunctionsForManipulatingData;
GO

--Get the Current System Date and Time
SELECT SYSDATETIME()  AS SYSDATETIME --local time
    ,SYSDATETIMEOFFSET()  AS SYSDATETIMEOFFSET --local + Offset of UTC
    ,SYSUTCDATETIME() AS UTC_HighPrecision --UTC
    ,CURRENT_TIMESTAMP AS 'CURRENT_TIMESTAMP' --local time WITH TIME ZONE INFORMATION
    ,GETDATE()  AS GETDATE --local time
    ,GETUTCDATE() AS UTC_LowPrecision -- UTC;  
/* Returned:  
SYSDATETIME()      2022-02-23 10:52:13.4962753 
SYSDATETIMEOFFSET()2022-02-23 10:52:13.4962753 +02:00  
SYSUTCDATETIME()   2022-02-23 08:52:13.4962753  
CURRENT_TIMESTAMP  2022-02-23 10:52:13.493
GETDATE()          2022-02-23 10:52:13.493  
GETUTCDATE()       2022-02-23 08:52:13.493
*/

--Get the Current System Date
SELECT
  CONVERT(date, SYSDATETIME()) AS Date,
  CONVERT(date, SYSDATETIMEOFFSET()) AS Date,
  CONVERT(date, SYSUTCDATETIME()) AS Date,
  CONVERT(date, CURRENT_TIMESTAMP) AS Date,
  CONVERT(date, GETDATE()) AS Date,
  CONVERT(date, GETUTCDATE()) AS Date;
/* Returned   
SYSDATETIME()      2022-02-23  
SYSDATETIMEOFFSET()2022-02-23  
SYSUTCDATETIME()   2022-02-23  
CURRENT_TIMESTAMP  2022-02-23  
GETDATE()          2022-02-23  
GETUTCDATE()       2022-02-23  
*/  

--Get the Current System Time
SELECT
  CONVERT(time, SYSDATETIME()) AS local_time,
  CONVERT(time, SYSDATETIMEOFFSET()) AS local_time,
  CONVERT(time, SYSUTCDATETIME()) AS UTC_time,
  CONVERT(time, CURRENT_TIMESTAMP) AS local_time,
  CONVERT(time, GETDATE()) AS local_time,
  CONVERT(time, GETUTCDATE()) AS UTC_time;  
  
/* Returned  
SYSDATETIME()      11:03:57.0464404
SYSDATETIMEOFFSET()11:03:57.0464404  
SYSUTCDATETIME()   09:03:57.0464404  
CURRENT_TIMESTAMP  11:03:57.0433333  
GETDATE()          11:03:57.0433333  
GETUTCDATE()       09:03:57.0433333  
*/  

--Use two functions to query the system's local date, without timezone information. Show the dates in different formats.
SELECT 
	CONVERT(VARCHAR(24), SYSDATETIME(), 107) AS HighPrecision,
	CONVERT(VARCHAR(24), GETDATE(), 102) AS LowPrecision;

--Use two functions to retrieve the current time, in Universal Time Coordinate.
SELECT 
	CAST(SYSUTCDATETIME() AS time) AS HighPrecision,
	CAST(GETUTCDATE() AS time) AS LowPrecision;

--***Extracting parts from a date***
--Extract the year, month and day of the first vote.
SELECT
  first_name,
  last_name,
  -- Extract the year of the first vote
  YEAR(first_vote_date) AS first_vote_year,
  -- Extract the month of the first vote
  MONTH(first_vote_date) AS first_vote_month,
  -- Extract the day of the first vote
  DAY(first_vote_date) AS first_vote_day
FROM voters;

-- Restrict the query to show only the voters who started to vote after 2015.
SELECT
  first_name,
  last_name,
  -- Extract the year of the first vote
  YEAR(first_vote_date) AS first_vote_year, -- returns a year
  -- Extract the month of the first vote
  MONTH(first_vote_date) AS first_vote_month, -- returns an integer
  -- Extract the day of the first vote
  DAY(first_vote_date) AS first_vote_day  -- returns an integer
FROM voters
-- The year of the first vote should be greater than 2015
WHERE YEAR(first_vote_date) > 2015;

-- Restrict the query to show only the voters did not vote on the first day of the month.
SELECT
  first_name,
  last_name,
  -- Extract the year of the first vote
  YEAR(first_vote_date) AS first_vote_year,
  -- Extract the month of the first vote
  MONTH(first_vote_date) AS first_vote_month,
  -- Extract the day of the first vote
  DAY(first_vote_date) AS first_vote_day
FROM voters
-- The year of the first vote should be greater than 2015
WHERE YEAR(first_vote_date) > 2015
-- The day should not be the first day of the month
AND DAY(first_vote_date) <> 1;

-- Generating descriptive date parts using DATENAME()
-- DATENAME() returns a string value with a description of the date part you are interested in.
-- DATENAME() returns a date in a more understandable manner (i.e. January instead of 1)
SELECT
  first_name,
  last_name,
  first_vote_date,
  -- Select the name of the month of the first vote
  MONTH(first_vote_date) AS first_vote_month,
  -- Select the name of the month name of the first vote
  DATENAME(MONTH, first_vote_date) AS first_vote_month_name,
  -- Select the number of the day within the year
  DATENAME(DAYOFYEAR, first_vote_date) AS first_vote_dayofyear,
  -- Select day of the week from the first vote date
  DATENAME(WEEKDAY, first_vote_date) AS first_vote_dayofweek
FROM voters;

-- Presenting parts of a date using DATEPART()
/*DATENAME() and DATEPART() are two similar functions. 
The difference between them is that while the former understandably shows some date parts, as strings of characters, 
the latter returns only integer values.*/

SELECT
  first_name,
  last_name,
  first_vote_date,
  -- Extract the month number of the first vote
  DATEPART(MONTH, first_vote_date) AS first_vote_month_no,
  -- Extract the month name of the first vote
  DATENAME(MONTH, first_vote_date) AS first_vote_month_name,
  -- Extract the weekday number of the first vote
  DATEPART(WEEKDAY, first_vote_date) AS first_vote_weekday_no,
  -- Extract the weekday name of the first vote
  DATENAME(WEEKDAY, first_vote_date) AS first_vote_weekday_mame
FROM voters;

-- Creating a date from parts using DATEFROMPARTS()
/*
DATEFROMPARTS() does exactly the opposite: it creates a date from three numbers, representing the year, month and the day.
The syntax is: DATEFROMPARTS(year, month, day)
You can also use expressions that return numeric values as parameters for this function, like this:
DATEFROMPARTS(YEAR(date_expression), MONTH(date_expression), 2)
*/
SELECT
  first_name,
  last_name,
  -- Select the year of the first vote
  YEAR(first_vote_date) AS first_vote_year,
  -- Select the month of the first vote
  MONTH(first_vote_date) AS first_vote_month,
  -- Create a date as the start of the month of the first vote
  DATEFROMPARTS(YEAR(first_vote_date), MONTH(first_vote_date), 1) AS first_vote_starting_month
FROM voters;

/*
Performing arithmetic operations on dates
1- using DATEADD()
2- Calculating the difference between dates using DATEDIFF()
*/
--1.DATEADD()
-- Retrieve the date when each voter had their 18th birthday.
-- Add five days to the first_vote_date, to calculate the date when the vote was processed.
SELECT
  first_name,
  birthdate,
  -- Add 18 years to the birthdate
  DATEADD(YEAR, 18, birthdate) AS eighteenth_birthday,
  -- Add 5 days to the first voting date
  DATEADD(DAY, 5, first_vote_date) AS processing_vote_date
FROM voters;


-- Calculate what day it was 476 days ago.
SELECT
  -- Subtract 476 days from the current date
  DATEADD(DAY, -476, GETDATE()) AS date_476days_ago;


-- 2.DATEDIFF() for retrieving the number of time units between two dates
-- Calculating the difference between dates
-- Calculate the number of years since a participant celebrated their 18th birthday until the first time they voted.
SELECT
  first_name,
  birthdate,
  -- eighteenth_birthday
  DATEADD(YEAR, 18, birthdate) AS eighteenth_birthday,
  first_vote_date,
  -- Select the diff between the 18th birthday and first vote
  DATEDIFF(YEAR, DATEADD(YEAR, 18, birthdate), first_vote_date) AS adult_years_until_vote
FROM voters;

-- How many weeks have passed since the beginning of 2019 until now?
SELECT
  -- Get the difference in weeks from 2019-01-01 until now
  DATEDIFF(WEEK, '2019-01-01', GETDATE()) AS weeks_passed;

--It's time to combine your knowledge on date functions!
SELECT
  first_name,
  last_name,
  birthdate,
  first_vote_date,
  -- Find out on which day of the week each participant voted 
  DATENAME(WEEKDAY, first_vote_date) AS first_vote_weekday,
  -- Find out the year of the first vote
  YEAR(first_vote_date) AS first_vote_year,
  -- Discover the participants' age when they joined the contest
  DATEDIFF(YEAR, birthdate, first_vote_date) AS age_at_first_vote,
  -- Calculate the current age of each voter
  DATEDIFF(YEAR, birthdate, GETDATE()) AS current_age
FROM voters;


/*
Validating if an expression is a date:
--ISDATE() FUNCTION returns 1 for valid date, 0 for invalid date or datetime2
--SET DATEFORMAT
--SET LANGUAGE
*/

--Set the correct date format so that the variable @date1 is interpreted as a valid date.
DECLARE @date1 nvarchar(20) = '2018-30-12'; --ydm

--Set the date format and check if the variable is a date
SET DATEFORMAT ydm;
SELECT
  ISDATE(@date1) AS result;

--Set the correct date format so that the variable @date1 is interpreted as a valid date.
DECLARE @date2 nvarchar(20) = '15/2019/4'; --dym

--Set the date format and check if the variable is a date
SET DATEFORMAT dym;
SELECT
  ISDATE(@date2) AS result;

--Set the correct date format so that the variable @date1 is interpreted as a valid date.
DECLARE @date3 NVARCHAR(20) = '10.13.2019'; --mdy

-- Set the date format and check if the variable is a date
SET DATEFORMAT mdy;
SELECT isdate(@date3) AS result;

--Set the correct date format so that the variable @date1 is interpreted as a valid date.
DECLARE @date4 nvarchar(20) = '18.4.2019'; --dmy

-- Set the date format and check if the variable is a date
SET DATEFORMAT dmy;
SELECT
  ISDATE(@date4) AS result;

--Changing the default language
--Changing the language automatically updates the date format
--English --> mdy, Croatian --> ymd, Dutch --> dmy

--Change the language, so that '30.03.2019' is considered a valid date. Select the name of the month.
DECLARE @date_1 NVARCHAR(20) = '30.03.2019'; --dmy

-- Set the correct language
SET LANGUAGE Dutch;
SELECT
	@date_1 AS initial_date,
    -- Check that the date is valid
	ISDATE(@date_1) AS is_valid,
    -- Select the number of the month
	month(@date_1) AS month_no,
	 -- Select the name of the month
	datename(month,@date_1) AS month_name;

--Change the language, so that '32/12/13' is interpreted as a valid date. Select the name of the month. Select the year.
DECLARE @date_2 NVARCHAR(20) = '32/12/13'; --ymd

-- Set the correct language
SET LANGUAGE Croatian;
SELECT
	@date_2 AS initial_date,
    -- Check that the date is valid
	ISDATE(@date_2) AS is_valid,
    -- Select the name of the month
	datename(month,@date_2 ) AS month_name,
	-- Extract the year from the date
	year(@date_2) AS year_name;

--Change the language, so that '12/18/55' is interpreted as a valid date. Select the day of week. Select the year.
DECLARE @date_3 NVARCHAR(20) = '12/18/55'; --mdy

-- Set the correct language
SET LANGUAGE English;
SELECT
	@date_3 AS initial_date,
    -- Check that the date is valid
	ISDATE(@date_3) AS is_valid,
    -- Select the week day name
	datename(WEEKDAY,@date_3) AS week_day,
	-- Extract the year from the date
	YEAR(@date_3) AS year_name;