-- Objectives:
-- You are asked by a company to help them make more informed decisions on real estate investments. 
-- Start by analyzing the data on median estimated values of single family homes by zip codes from the past 
-- two decades.

/* I verify that I have written the code in this example myself */

-- 1. How many distinct zip codes are in this data set?

	SELECT COUNT(DISTINCT zip_code)
	FROM HVD;

-- 2. How many zip codes are from each state?

	Select state, count(DISTINCT zip_code)
	FROM HVD
	GROUP BY state;

-- 3. What range of years are represented in the data?

	SELECT MIN(SUBSTR(date, 1, 4)) AS Start_Year, MAX(SUBSTR(date, 1, 4)) AS End_Year
	FROM HVD;


-- 4. Using the most recent month of data available, what is the range of estimated home values across the nation?

	-- By State:
	
	SELECT State, MIN(value), MAX(value), date
	FROM HVD
	WHERE date = (SELECT MAX(date) FROM HVD)
	GROUP BY State;

	-- Nationwide:
	
	SELECT MIN(value), MAX(value), date
	FROM HVD
	WHERE date = (SELECT MAX(date) FROM HVD);
	
-- 5. Using the most recent month of data available, which states have the highest average homes?
--    How about the lowest?

	-- Highest Average Homes:
	SELECT state, ROUND(avg(value), 2) AS Average_Value, date
	FROM HVD
	WHERE date = (SELECT MAX(date) FROM HVD)
	GROUP BY state
	ORDER BY ROUND(avg(value), 2) DESC;
	
	-- Lowest Average Homes:
	SELECT state, ROUND(avg(value), 2) AS Average_Value, date
	FROM HVD
	WHERE date = (SELECT MAX(date) FROM HVD)
	GROUP BY state
	ORDER BY ROUND(avg(value), 2) ASC;

-- 6. Which states have the highest/lowest average home values for the year 2017? What about the year 2007? 2997?

	-- 2017
	SELECT substr(date, 1, 4), state, ROUND(AVG(value), 2) 'Avg_value'
	FROM HVD
	WHERE substr(date, 1, 4) = '2017'
	GROUP BY state
	ORDER BY ROUND(AVG(value), 2) DESC;

	-- 2007
	SELECT substr(date, 1, 4), state, ROUND(AVG(value), 2) 'Avg_value'
	FROM HVD
	WHERE substr(date, 1, 4) = '2007'
	GROUP BY state
	ORDER BY ROUND(AVG(value), 2) DESC;

	-- 1997
	SELECT substr(date, 1, 4), state, ROUND(AVG(value), 2) 'Avg_value'
	FROM HVD
	WHERE substr(date, 1, 4) = '1997'
	GROUP BY state
	ORDER BY ROUND(AVG(value), 2) DESC;

-- 7. What is the percent change in average home values from 2007 to 2017 by state? How about 1997 to 2017?

	-- 2007 to 2017
	WITH Old AS (
		SELECT state AS oldstate, avg(value) as oldvalue
		FROM HVD
		WHERE substr(date, 1, 4) = '2007'
		GROUP BY state),
		
		New AS (
		SELECT state AS newstate, avg(value) as newvalue
		FROM HVD
		WHERE substr(date, 1, 4) = '2017'
		GROUP BY state)
	SELECT oldstate, oldvalue, new.newvalue, ((new.newvalue - old.oldvalue)/old.oldvalue)*100 AS Percent_change
	FROM Old
	JOIN New ON New.newstate = Old.oldstate;

	-- 1997 to 2017
	WITH Old AS (
		SELECT state AS oldstate, avg(value) as oldvalue
		FROM HVD
		WHERE substr(date, 1, 4) = '1997'
		GROUP BY state),
		
		New AS (
		SELECT state AS newstate, avg(value) as newvalue
		FROM HVD
		WHERE substr(date, 1, 4) = '2017'
		GROUP BY state)
	SELECT oldstate, oldvalue, new.newvalue, ((new.newvalue - old.oldvalue)/old.oldvalue)*100 AS Percent_change
	FROM Old
	JOIN New ON New.newstate = Old.oldstate;



	