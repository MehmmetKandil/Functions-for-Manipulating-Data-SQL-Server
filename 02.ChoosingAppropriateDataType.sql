--This data set contains:
--The ratings table: information about chocolate bars: the origin of the beans, percentage of cocoa and the rating of each bar.
--The voters table: details about the people who participate in the voting process, 
--It contains personal information of a voter: first and last name, email address, gender, country, the first time they voted and the total number of votes.

USE FunctionsForManipulatingData;
GO

--Select information from the **ratings table** for the Belgian companies that received a rating higher than 3.5
SELECT
  company,
  company_location,
  bean_origin,
  cocoa_percent,
  rating
FROM ratings
-- Location should be Belgium and the rating should exceed 3.5
WHERE company_location = 'Belgium'
AND rating > 3.5;

--Query the **voters table** where birthdate is greater than '1990-01-01' and the total_votes is between 100 and 200.

SELECT
  first_name,
  last_name,
  birthdate,
  gender,
  email,
  country,
  total_votes
FROM voters
-- Birthdate > 1990-01-01, total_votes > 100 but < 200
WHERE Birthdate > '01/01/1990'
AND total_votes > 100
AND total_votes < 200;

-- Or you can use BETWEEN
SELECT
  first_name,
  last_name,
  birthdate,
  gender,
  email,
  country,
  total_votes
FROM voters
-- Birthdate > 1990-01-01, total_votes > 100 but < 200
WHERE Birthdate > '01/01/1990'
AND total_votes > 100
AND total_votes < 200;

--CASTing data
--CASTing data by using CAST()
SELECT
  -- Transform the year part from the birthdate to a string
  first_name + ' ' + last_name + ' was born in ' + CAST(YEAR(birthdate) AS nvarchar) + '.'
FROM voters;

--Divide the total votes by 5.5 and then Transform the result to an integer.
SELECT
  --Divide the total votes by 5.5
  (total_votes / 5.5) AS DividedVotes,
  --Transform the result to an integer.
  CAST((total_votes / 5.5) AS int) AS DividedVotes
FROM voters;

--Select the voters whose total number of votes starts with 5
SELECT
  first_name,
  last_name,
  total_votes
FROM voters
-- Transform the total_votes to char of length 10
WHERE CAST(total_votes AS varchar(5)) LIKE '5%';

--CONVERTing data
--CONVERTing data by using CONVERT()
--CAST() & CONVERT() are very similar in functionality
--with CONVERT() you can use a style parameter for changing the aspect of a date
--CONVERT() is SQL Server specific, so its performance is slightly better than CAST()


--Retrieve the birth date from voters, in this format: Mon dd,yyyy
SELECT
  email,
  birthdate,
  -- Convert birthdate to varchar show it like: "Mon dd,yyyy" 
  CONVERT(varchar, birthdate, 107) AS birth_date
FROM voters;

--Select the company, bean origin and the rating from the ratings table. The rating should be converted to a whole number.
SELECT
  company,
  bean_origin,
  rating,
  -- Convert the rating column to an integer
  CONVERT(int, rating) AS whole_rating
FROM ratings;

--Select the company, bean origin and the rating from the ratings table where the whole part of the rating equals 3.
SELECT 
	company,
    bean_origin,
    rating,
	CONVERT(int, rating) AS whole_rating
FROM ratings
-- Convert the rating to an integer before comparison
WHERE CONVERT(int, rating) = 3;

--Working with the correct data types
SELECT
	first_name,
    last_name,
	-- Convert birthdate to varchar(10) to show it as yy/mm/dd
	CONVERT(varchar(10), birthdate, 11) AS birthdate,
    gender,
    country,
    -- Convert the total_votes number to nvarchar
    'Voted ' + CAST(total_votes AS varchar) + ' times.' AS comments
FROM voters
WHERE country = 'Belgium'
    -- Select only the female voters
	AND gender = 'F'
    -- Select only people who voted more than 20 times
    AND total_votes > 20;


