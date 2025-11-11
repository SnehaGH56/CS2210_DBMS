
-- Lab Experiment – Implementation of Procedures in SQL

-- Step 1: Create Database
DROP DATABASE IF EXISTS CompanyDB;
-- #	Time	Action	Message	Duration / Fetch
-- 1	1	22:49:09	DROP DATABASE IF EXISTS CompanyDB	0 row(s) affected, 1 warning(s):
 -- 1008 Can't drop database 'companydb'; database doesn't exist	0.015 sec
 
CREATE DATABASE CompanyDB;
-- 3	2	22:49:41	CREATE DATABASE CompanyDB	1 row(s) affected	0.047 sec
USE CompanyDB;
-- 3	3	22:50:02	USE CompanyDB	0 row(s) affected	0.000 sec

-- Step 2: Create Table
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY AUTO_INCREMENT,
    EmpName VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2)
);
-- 3	4	22:50:16	CREATE TABLE Employees (
-- EmpID INT PRIMARY KEY AUTO_INCREMENT,
-- EmpName VARCHAR(50),
-- Department VARCHAR(50),
-- Salary DECIMAL(10,2)
-- )	0 row(s) affected	0.094 sec


-- OUTPUT (Verify structure)
DESC Employees3;
-- 3	5	22:50:50	DESC Employees	4 row(s) returned	0.031 sec / 0.000 sec

-- Step 3: Insert Sample Data
INSERT INTO Employees (EmpName, Department, Salary) VALUES
('John', 'IT', 55000),
('Alice', 'HR', 48000),
('Bob', 'Finance', 60000);
-- 3	7	23:03:22	INSERT INTO Employees (EmpName, Department, Salary) VALUES
-- ('John', 'IT', 55000),
-- ('Alice', 'HR', 48000),
-- ('Bob', 'Finance', 60000)	3 row(s) affected
-- Records: 3  Duplicates: 0  Warnings: 0	0.016 sec


-- OUTPUT (Verify data)
SELECT * FROM Employees;
-- 3	8	23:04:28	SELECT * FROM Employees
-- LIMIT 0, 1000	3 row(s) returned	0.000 sec / 0.000 sec

DELIMITER $$
CREATE PROCEDURE DisplayEmployees()
BEGIN
    SELECT * FROM Employees;
END $$
DELIMITER ;
-- 3	9	23:04:47	CREATE PROCEDURE DisplayEmployees()
-- BEGIN
   --  SELECT * FROM Employees;
-- END	0 row(s) affected	0.062 sec


-- CALL procedure
CALL DisplayEmployees();
-- 3	10	23:05:18	CALL DisplayEmployees()	3 row(s) returned	0.016 sec / 0.000 sec


DELIMITER $$
CREATE PROCEDURE AddEmployee(
    IN p_name VARCHAR(50),
    IN p_dept VARCHAR(50),
    IN p_salary DECIMAL(10,2)
)
BEGIN
    INSERT INTO Employees(EmpName, Department, Salary)
    VALUES(p_name, p_dept, p_salary);
END $$
DELIMITER ;
-- 3	11	23:05:46	CREATE PROCEDURE AddEmployee(
-- IN p_name VARCHAR(50),
-- IN p_dept VARCHAR(50),
-- IN p_salary DECIMAL(10,2)
-- )
-- BEGIN
-- INSERT INTO Employees(EmpName, Department, Salary)
-- VALUES(p_name, p_dept, p_salary);
-- END	0 row(s) affected	0.032 sec

-- CALL procedure
CALL AddEmployee('David', 'Marketing', 52000);
-- 3	12	23:06:45	CALL AddEmployee('David', 'Marketing', 52000)	1 row(s) affected	0.031 sec

-- OUTPUT (Verify insertion)
SELECT * FROM Employees;
-- 3	13	23:07:07	SELECT * FROM Employees
-- LIMIT 0, 1000	4 row(s) returned	0.000 sec / 0.000 sec



DELIMITER $$
CREATE PROCEDURE UpdateSalary(
    IN p_empid INT,
    IN p_salary DECIMAL(10,2)
)
BEGIN
    UPDATE Employees
    SET Salary = p_salary
    WHERE EmpID = p_empid;
END $$
DELIMITER ;
-- 3	18	23:08:45	CREATE PROCEDURE UpdateSalary(
-- IN p_empid INT,
-- IN p_salary DECIMAL(10,2)
-- )
-- BEGIN
-- UPDATE Employees
-- SET Salary = p_salary
-- WHERE EmpID = p_empid;
-- END	0 row(s) affected	0.031 sec



-- CALL procedure
CALL UpdateSalary(2, 50000);
-- 3	19	23:10:13	CALL UpdateSalary(2, 50000)	1 row(s) affected	0.031 sec

-- OUTPUT (Verify update)
SELECT * FROM Employees;
-- 3	20	23:10:31	SELECT * FROM Employees
-- LIMIT 0, 1000	4 row(s) returned	0.000 sec / 0.000 sec



DELIMITER $$
CREATE PROCEDURE RemoveEmployee(
    IN p_empid INT
)
BEGIN
    DELETE FROM Employees
    WHERE EmpID = p_empid;
END $$
DELIMITER ;
-- 3	17	23:08:01	CREATE PROCEDURE RemoveEmployee(
-- IN p_empid INT
-- )
-- BEGIN
-- DELETE FROM Employees
-- WHERE EmpID = p_empid;
-- END	0 row(s) affected	0.031 sec


-- CALL procedure
CALL RemoveEmployee(3);

-- OUTPUT (Verify deletion)
SELECT * FROM Employees;
-- 3	15	23:07:34	SELECT * FROM Employees
-- LIMIT 0, 1000	4 row(s) returned	0.000 sec / 0.000 sec

