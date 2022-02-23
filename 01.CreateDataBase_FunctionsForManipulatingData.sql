CREATE DATABASE FunctionsForManipulatingData;
GO

USE FunctionsForManipulatingData;
GO

CREATE TABLE Voters (
  customer_id INT,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  birthdate DATE,
  gender VARCHAR(100),
  email VARCHAR(100),
  country VARCHAR(100),
  first_vote_date DATE,
  total_votes INT
);
GO

BULK INSERT Voters FROM 'D:\00-2022\08-sql\datacamp\FunctionsForManipulatingData\voters.csv' WITH(FIRSTROW = 2, FIELDTERMINATOR =',', ROWTERMINATOR = '\n');
GO


CREATE TABLE Ratings (
  company VARCHAR(100),
  bean_origin VARCHAR(100),
  cocoa_percent FLOAT,
  company_location VARCHAR(100),
  rating FLOAT,
  bean_type VARCHAR(100),
  broad_bean_origin VARCHAR(100)
);
GO

BULK INSERT Ratings FROM 'D:\00-2022\08-sql\datacamp\FunctionsForManipulatingData\ratings.csv' WITH(FIRSTROW = 2, FIELDTERMINATOR =',', ROWTERMINATOR = '\n');
GO