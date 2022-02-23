USE FunctionsForManipulatingData;
GO

/***Calculating the length of a string using LEN() FUNCTION***/
-- Calculate the length of each broad_bean_origin.
-- Order the results from the longest to shortest.
SELECT TOP 10
  company,
  broad_bean_origin,
  -- Calculate the length of the broad_bean_origin column
  LEN(broad_bean_origin) AS length
FROM ratings
-- Order the results based on the new column, descending
ORDER BY length DESC;

/***Looking for a string within a string using CHARINDEX() FUNCTION***/
-- you can use CHARINDEX() to check whether an expression exists within a string.
-- This function returns the position of the expression you are searching within the string.
-- CHARINDEX(expression_to_find, expression_to_search [, start_location])
/*
What you should remember about CHARINDEX() is that:
if a match is found, it returns the starting position of the first matching substring, counting from 1. 
If the substring cannot be found, CHARINDEX() returns 0.
*/

-- Restrict the query to select only the voters whose first name contains the expression "dan" and "z" in the last_name

SELECT 
	first_name,
	last_name,
	email 
FROM voters
-- Look for the "dan" expression in the first_name
WHERE CHARINDEX('dan', first_name) > 0 
    -- Look for last_names that contain the letter "z"
	AND CHARINDEX('z', last_name) > 0;

-- Restrict the query to select only the voters whose first name contains the expression "dan" and DO NOT have the letter "z" in the last_name

SELECT 
	first_name,
	last_name,
	email 
FROM voters
-- Look for the "dan" expression in the first_name
WHERE CHARINDEX('dan', first_name) > 0 
    -- Look for last_names that do not contain the letter "z"
	AND CHARINDEX('z', last_name) = 0 ;

/***Looking for a pattern within a string using PATINDEX()***/
-- PATINDEX() is to search for a pattern in a string
-- This function returns the starting position of the first occurrence of the pattern within the string.
-- The syntax is: PATINDEX('%pattern%', expression)

-- Write a query to select the voters whose first name contains the letters "rr".
SELECT
  first_name,
  last_name,
  email
FROM voters
-- Look for first names that contain "rr" in the middle
WHERE PATINDEX('%rr%', first_name) > 0;

-- Write a query to select the voters whose first name starts with "C" and has "r" as the third letter.
SELECT
  first_name,
  last_name,
  email
FROM voters
-- Look for first names that start with C and the 3rd letter is r
WHERE PATINDEX('%C%', first_name) = 1
AND PATINDEX('%r%', first_name) = 3;

-- Select the voters whose first name contains an "a" followed by other letters, then a "w", followed by other letters.
SELECT
  first_name,
  last_name,
  email
FROM voters
-- Look for first names that have an "a" followed by 0 or more letters and then have a "w"
WHERE PATINDEX('%a%w%', first_name) > 0;

-- Write a query to select the voters whose first name contains one of these letters: "x", "w" or "q".
SELECT
  first_name,
  last_name,
  email
FROM voters
-- Look for first names that contain one of the letters: "x", "w", "q"
WHERE PATINDEX('%[xwq]%', first_name) > 0;

/*****Changing to lowercase and uppercase*****/
-- UPPER(the expression)
-- LOWER(the expression)
SELECT 
	company,
	bean_type,
	broad_bean_origin,
    -- 'company' and 'broad_bean_origin' should be in uppercase
	'The company ' +  UPPER(company) + ' uses beans of type "' + bean_type + '", originating from ' + UPPER(broad_bean_origin) + '.'
FROM ratings
WHERE 
    -- The 'broad_bean_origin' should not be unknown
	LOWER(broad_bean_origin) NOT LIKE '%unknown%'
     -- The 'bean_type' should not be unknown
    AND LOWER(bean_type) NOT LIKE '%unknown%';

/***Using the beginning or end of a string***/
-- LEFT(the expression, number_of_characters)
-- RIGHT(the expression, number_of_characters)

SELECT
  first_name,
  last_name,
  country,
  -- Select only the first 3 characters from the first name
  LEFT(first_name, 3) AS part1,
  -- Select only the last 3 characters from the last name
  RIGHT(last_name, 3) AS part2,
  -- Select only the last 2 digits from the birth date
  RIGHT(birthdate, 2) AS part3,
  -- Create the alias for each voter
  LEFT(first_name, 3) + RIGHT(last_name, 3) + '_' + RIGHT(birthdate, 2) AS voter_alias
FROM voters;

/***Extracting a substring***/
-- SUBSTRING()
-- SUBSTRING(the expression, start, number_of_characters)
-- Returns part of a string
SELECT
  email,
  -- Extract 5 characters from email, starting at position 3
  SUBSTRING(email, 3, 5) AS some_letters
FROM voters;

-- Extract the fruit names from the following sentence: "Apples are neither oranges nor potatoes".
DECLARE @sentence nvarchar(200) = 'Apples are neither oranges nor potatoes.'
SELECT
  -- Extract the word "Apples" 
  SUBSTRING(@sentence, 1, 6) AS fruit1,
  -- Extract the word "oranges"
  SUBSTRING(@sentence, 20, 7) AS fruit2;

/***Replacing parts of a string***/
-- REPLACE() FUNCTION
-- REPLACE(the expression, the string to be found, the replacement string)

-- Add a new column in the query in which you replace the "yahoo.com" in all email addresses with "live.com"
SELECT
  first_name,
  last_name,
  email,
  -- Replace "yahoo.com" with "live.com"
  REPLACE(email, 'yahoo.com', 'live.com') AS new_email
FROM voters;

-- Replace the character "&" from the company name with "and".
SELECT 
	company AS initial_name,
    -- Replace '&' with 'and'
	REPLACE(company, '&', 'and') AS new_name 
FROM ratings
WHERE CHARINDEX('&', company) > 0;

-- Remove the string "(Valrhona)" from the company name "La Maison du Chocolat (Valrhona)".
SELECT 
	company AS old_company,
    -- Remove the text '(Valrhona)' from the name
	REPLACE(company, '(Valrhona)', '') AS new_company,
	bean_type,
	broad_bean_origin
FROM ratings
WHERE company = 'La Maison du Chocolat (Valrhona)';

/***Concatenating data***/
DECLARE @string1 NVARCHAR(100) = 'Chocolate with beans from';
DECLARE @string2 NVARCHAR(100) = 'has a cocoa percentage of';

SELECT 
	bean_type,
	bean_origin,
	cocoa_percent,
	-- Create a message by concatenating values with "+"
	@string1 + ' ' + bean_origin + ' ' + @string2 + ' ' + CAST(cocoa_percent AS nvarchar) AS message1,
	-- Create a message by concatenating values with "CONCAT()"
	CONCAT(@string1, ' ', bean_origin, ' ', @string2, ' ', cocoa_percent) AS message2,
	-- Create a message by concatenating values with "CONCAT_WS()"
	CONCAT_WS(' ', @string1, bean_origin, @string2, cocoa_percent) AS message3
FROM ratings
WHERE 
	company = 'Ambrosia' 
	AND bean_type <> 'Unknown';

/***Aggregating strings***/
/*Aggregating strings: concatenate values from multiple rows*/
-- The syntax is: STRING_AGG(expression, separator) [WITHIN GROUP (ORDER BY expression)]
/* Create a list with all the values found in the bean_origin column for the companies: 
      'Bar Au Chocolat', 'Chocolate Con Amor', 'East Van Roasters'. The values should be separated by commas (,).*/


-- Create a list with all bean origins, delimited by comma
SELECT
  -- Create a list with all bean origins, delimited by comma
  STRING_AGG(bean_origin, ',') AS bean_origins
FROM ratings
WHERE company IN ('Bar Au Chocolat', 'Chocolate Con Amor', 'East Van Roasters');


-- Add a column for each of the companies: 'Bar Au Chocolat', 'Chocolate Con Amor', 'East Van Roasters 
SELECT 
	company,
    -- Create a list with all bean origins
	STRING_AGG(bean_origin, ',') AS bean_origins
FROM ratings
WHERE company IN ('Bar Au Chocolat', 'Chocolate Con Amor', 'East Van Roasters')
-- Specify the columns used for grouping your data
GROUP BY company;


-- Arrange the values from the list in alphabetical order.
SELECT 
	company,
    -- Create a list with all bean origins ordered alphabetically
	STRING_AGG(bean_origin, ',') WITHIN GROUP (order by bean_origin ASC ) AS bean_origins
FROM ratings
WHERE company IN ('Bar Au Chocolat', 'Chocolate Con Amor', 'East Van Roasters')
-- Specify the columns used for grouping your data
GROUP BY company;

/***Splitting a string into pieces***/
/* STRING_SPLIT(string, separator)*/
/*This function splits the string into substrings based on the separator and returns a table, 
each row containing a part of the original string.
because the result of the function is a table, it cannot be used as a column in the SELECT clause; 
you can only use it in the FROM clause, just like a normal table.*/

-- Split the phrase declared in the variable @phrase into sentences (using the . separator).
DECLARE @phrase1 NVARCHAR(MAX) = 'In the morning I brush my teeth. In the afternoon I take a nap. In the evening I watch TV.'

SELECT *
FROM STRING_SPLIT(@phrase1, '.');

-- Split the phrase declared in the variable @phrase into individual words.
DECLARE @phrase2 NVARCHAR(MAX) = 'In the morning I brush my teeth. In the afternoon I take a nap. In the evening I watch TV.'

SELECT value
FROM STRING_SPLIT(@phrase2, ' ');

/***Applying various string functions on data***/
/*
Select only the voters whose first name has fewer than 5 characters and
email address meets these conditions in the same time: (1) starts with the
letter “j”, (2) the third letter is “a” and (3) is created at yahoo.com.
*/

SELECT
	first_name,
    last_name,
	birthdate,
	email,
	country
FROM voters
   -- Select only voters with a first name less than 5 characters
WHERE LEN(first_name) < 5
   -- Look for the desired pattern in the email address
    AND PATINDEX('%yahoo.com%', email) > 0
	AND PATINDEX('%j%', email) = 1
	AND PATINDEX('%a%', email) = 3;

/*
Concatenate the first name and last name in the same column and present it in this format: " *** Firstname LASTNAME *** ".
*/
SELECT
    -- Concatenate the first and last name
	CONCAT('***' , first_name, ' ', UPPER(last_name), '***') AS name,
    last_name,
	birthdate,
	email,
	country
FROM voters
   -- Select only voters with a first name less than 5 characters
WHERE LEN(first_name) < 5
   -- Look for this pattern in the email address: "j%[0-9]@yahoo.com"
	AND PATINDEX('j_a%@yahoo.com', email) > 0;   
/*
Mask the year part from the birthdate column, by replacing the last two digits with "XX" (1986-03-26 becomes 19XX-03-26).
*/

SELECT
    -- Concatenate the first and last name
	CONCAT('***' , first_name, ' ', UPPER(last_name), '***') AS name,
    -- Mask the last two digits of the year
    REPLACE(birthdate, SUBSTRING(CAST(birthdate AS varchar), 3, 2), 'XX') AS birthdate,
	email,
	country
FROM voters
   -- Select only voters with a first name less than 5 characters
WHERE LEN(first_name) < 5
   -- Look for this pattern in the email address: "j%[0-9]@yahoo.com"
	AND PATINDEX('j_a%@yahoo.com', email) > 0;
