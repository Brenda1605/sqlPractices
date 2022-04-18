-- MATH OPERATIONS 

-- 1. BASIC MATH OPERATIONS
SELECT 2 + 2;    -- addition
SELECT 9 - 1;    -- subtraction
SELECT 3 * 4;    -- multiplication

SELECT 11 / 6;   -- integer division
SELECT 11 % 6;   -- modulo division
SELECT 11.0 / 6; -- decimal division
SELECT CAST(11 AS numeric(3,1)) / 6;

SELECT 3 ^ 4;         -- exponentiation
SELECT |/ 10;         -- square root (operator)
SELECT sqrt(10);      -- square root (function)
SELECT ||/ 10;        -- cube root
SELECT factorial(4);  -- factorial (function)
SELECT 4 !;           -- factorial (operator; PostgreSQL 13 and earlier only)

SELECT 7 + 8 * 9; 	-- answer: 79
SELECT (7 + 8) * 9;	-- answer: 135

SELECT 3 ^ 3 - 1;   -- answer: 26
SELECT 3 ^ (3 - 1); -- answer: 9

-- 2. MAKE OPERATIONS TO SUBSTRACT 2 COLUMNS
SELECT county_name AS county,
       state_name AS state,
       births_2019 AS births,
       deaths_2019 AS deaths,
       births_2019 - deaths_2019 AS natural_increase
FROM us_counties_pop_est_2019
ORDER BY state_name, county_name;

-- 3. CALCULATE PERCENT CHANGE
CREATE TABLE percent_change (
    department text,
    spend_2019 numeric(10,2),
    spend_2022 numeric(10,2)
);

INSERT INTO percent_change
VALUES
    ('Assessor', 178556, 179500),
    ('Building', 250000, 289000),
    ('Clerk', 451980, 650000),
    ('Library', 87777, 90001),
    ('Parks', 250000, 223000),
    ('Water', 199000, 195000);
    
-- Math to calculate percent change
SELECT department,
       spend_2019,
       spend_2022,
       round( (spend_2022 - spend_2019) /
                    spend_2019 * 100, 1) AS pct_change
FROM percent_change;

-- 4. SUM AND AVG FUNCTIONS
SELECT sum(pop_est_2019) AS county_sum,
       round(avg(pop_est_2019), 0) AS county_average
FROM us_counties_pop_est_2019;

-- 5. PERCENTILE FUNCTION
CREATE TABLE percentile_test (
    numbers integer
);

INSERT INTO percentile_test (numbers) VALUES
    (1), (2), (3), (4), (5), (6);
    
SELECT
    percentile_cont(.5)
    WITHIN GROUP (ORDER BY numbers),
    percentile_disc(.5)
    WITHIN GROUP (ORDER BY numbers)
FROM percentile_test;

