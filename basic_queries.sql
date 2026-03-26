-- 1. Select all records
SELECT * FROM Employees;

-- 2. Second highest salary
SELECT MAX(salary) 
FROM Employees 
WHERE salary < (SELECT MAX(salary) FROM Employees);

-- 3. Department wise count
SELECT department, COUNT(*) 
FROM Employees 
GROUP BY department;

-- 4. Join example
SELECT e.name, d.department_name
FROM Employees e
JOIN Departments d 
ON e.department_id = d.department_id;

-- 5. Row number
SELECT name, salary,
ROW_NUMBER() OVER (ORDER BY salary DESC) AS rank
FROM Employees;
