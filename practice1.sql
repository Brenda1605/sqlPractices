-- Query that lists the schools in alphabetical order along with the teachers orderes by 1st name A - Z
SELECT school, first_name
FROM teachers
ORDER BY school ASC, first_name ASC

-- Find one teacher whose first name starts with letter S and earns more than 40000
SELECT first_name, last_name, salary
FROM teachers
WHERE first_name LIKE 'S%' and salary > 40000

-- Rank teacher hired since January 1, 2010, ordered by highest paid to lowestALTER
SELECT first_name, last_name, hire_date, salary
FROM teachers
WHERE hire_date >= '2010-01-01'
ORDER BY salary DESC
