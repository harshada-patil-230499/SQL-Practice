-- Create Employees table
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    salary INT,
    department_id INT
);

-- Create Departments table
CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

-- Insert data into Departments
INSERT INTO Departments VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Finance');

-- Insert data into Employees
INSERT INTO Employees VALUES
(1, 'Amit', 50000, 2),
(2, 'Neha', 60000, 1),
(3, 'Raj', 70000, 2),
(4, 'Simran', 80000, 3),
(5, 'Karan', 55000, 1);

-- 1. Select all records
SELECT * FROM Employees;

-- 2. Second highest salary
SELECT MAX(salary) 
FROM Employees 
WHERE salary < (SELECT MAX(salary) FROM Employees);

-- 3. Department wise count
SELECT department_id, COUNT(*) 
FROM Employees 
GROUP BY department_id;

-- 4. Join example
SELECT e.name, d.department_name
FROM Employees e
JOIN Departments d 
ON e.department_id = d.department_id;

-- 5. Row number ranking
SELECT name, salary,
ROW_NUMBER() OVER (ORDER BY salary DESC) AS rank
FROM Employees;
