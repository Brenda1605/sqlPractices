-- Import practice
-- General syntax

COPY table_name
FROM 'C:\YourDirectory\your_file.csv'
WITH (FORMAT CSV, HEADER);
-----------------------------------------------------------------------------------------------------
-- 1. IMPORTING DATA
-- 1.1 CREATE TABLE us_countries
CREATE TABLE us_counties_pop_est_2019 (
    state_fips text,                         -- State FIPS code
    county_fips text,                        -- County FIPS code
    region smallint,                         -- Region
    state_name text,                         -- State name	
    county_name text,                        -- County name
    area_land bigint,                        -- Area (Land) in square meters
    area_water bigint,                       -- Area (Water) in square meters
    internal_point_lat numeric(10,7),        -- Internal point (latitude)
    internal_point_lon numeric(10,7),        -- Internal point (longitude)
    pop_est_2018 integer,                    -- 2018-07-01 resident total population estimate
    pop_est_2019 integer,                    -- 2019-07-01 resident total population estimate
    births_2019 integer,                     -- Births from 2018-07-01 to 2019-06-30
    deaths_2019 integer,                     -- Deaths from 2018-07-01 to 2019-06-30
    international_migr_2019 integer,         -- Net international migration from 2018-07-01 to 2019-06-30
    domestic_migr_2019 integer,              -- Net domestic migration from 2018-07-01 to 2019-06-30
    residual_2019 integer,                   -- Residual for 2018-07-01 to 2019-06-30
    CONSTRAINT counties_2019_key PRIMARY KEY (state_fips, county_fips)	
);

-- 1.2 MAKE FILE available for pgadmin user
-- cp us_counties_pop_est_2019.csv  /tmp/ -> tmp is a folder available for all the users

SELECT * FROM us_counties_pop_est_2019;

-- 1.3 COPY INFORMATION to table us_countries
COPY us_counties_pop_est_2019
FROM '/tmp/us_counties_pop_est_2019.csv'
WITH (FORMAT CSV, HEADER);

SELECT * FROM us_counties_pop_est_2019;

-- 1.4 MAKE QUERIES
SELECT county_name, state_name, area_land
FROM us_counties_pop_est_2019
ORDER BY area_land DESC
LIMIT 3;

SELECT county_name, state_name, internal_point_lat, internal_point_lon
FROM us_counties_pop_est_2019
ORDER BY internal_point_lon DESC
LIMIT 5;
-----------------------------------------------------------------------------------------------
-- 2. IMPORTING DATA INDICATING COPY COLUMNS

-- 2.1 CREATE TABLE supervisor_salaries
CREATE TABLE supervisor_salaries (
    id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    town text,
    county text,
    supervisor text,
    start_date text,
    salary numeric(10,2),
    benefits numeric(10,2)
);

-- 2.2 IMPORT DATA to supervisor_salaries, selecting which columns we want to import
COPY supervisor_salaries (town, supervisor, salary)
FROM '/tmp/supervisor_salaries.csv'
WITH (FORMAT CSV, HEADER);

-- 2.3 MAKE QUERIES
SELECT * FROM supervisor_salaries ORDER BY id LIMIT 2;

-- 2.4 DELETE ALL the table supervisor_salaries
DELETE FROM supervisor_salaries;

--2.5 IMPORT DATA to supervisor_salaries WHERE town = 'New Brillig'
COPY supervisor_salaries (town, supervisor, salary)
FROM '/tmp/supervisor_salaries.csv'
WITH (FORMAT CSV, HEADER)
WHERE town = 'New Brillig';

SELECT * FROM supervisor_salaries;
------------------------------------------------------------------------------------------------
-- 3. CREATE TEMPORARY TABLE

-- 3.1 DELETE DATA from table
DELETE FROM supervisor_salaries;

-- 3.2 CREATING TEMPORARY table supervisor_salaries_temp
CREATE TEMPORARY TABLE supervisor_salaries_temp 
    (LIKE supervisor_salaries INCLUDING ALL);

-- 3.3 IMPORT DATA to supervisor_salaries_temp table
COPY supervisor_salaries_temp (town, supervisor, salary)
FROM '/tmp/supervisor_salaries.csv'
WITH (FORMAT CSV, HEADER);

-- 3.4 COPY DATA from supervisor_salaries_temp to supervisor_salaries
INSERT INTO supervisor_salaries (town, county, supervisor, salary)
SELECT town, 'Mills', supervisor, salary
FROM supervisor_salaries_temp;

-- 3.5 DELETE TEMPORARY table
DROP TABLE supervisor_salaries_temp;

-- 3.6 CHECK DATA of supervisor_salaries table
SELECT * FROM supervisor_salaries ORDER BY id LIMIT 2;
----------------------------------------------------------------------------------------------------
-- 4. COPY DATA from table to txt file

-- 4.1 COPY ALL THE TABLE to txt
COPY us_counties_pop_est_2019
TO '/tmp/us_counties_export.txt'
WITH (FORMAT CSV, HEADER, DELIMITER '|');

-- 4.2 COPY SPECIFIC COLUMNS of table to txt
COPY us_counties_pop_est_2019 
    (county_name, internal_point_lat, internal_point_lon)
TO '/tmp/us_counties_latlon_export.txt'
WITH (FORMAT CSV, HEADER, DELIMITER '|');

-- 4.3 COPY QUERY to txt
COPY (
    SELECT county_name, state_name
    FROM us_counties_pop_est_2019
    WHERE county_name ILIKE '%mill%'
     )
TO '/tmp/us_counties_mill_export.csv'
WITH (FORMAT CSV, HEADER);

-- 4.4 COPY FILES FROM TMP TO CHAPTER_05 
-- cp /tmp/us_counties_export.txt .
-- cp /tmp/us_counties_lalton_export.txt .
-- cp /tmp/us_counties_mill_export.csv .

