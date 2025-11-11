
-- Lab Experiment – Implementation of Triggers in SQL

DROP DATABASE IF EXISTS SchoolDB;
-- 1	14	21:08:41	DROP DATABASE IF EXISTS SchoolDB	0 row(s) affected, 1 warning(s):
-- 1008 Can't drop database 'schooldb'; database doesn't exist	0.032 sec

CREATE DATABASE SchoolDB;
-- 3	15	21:09:14	CREATE DATABASE SchoolDB	1 row(s) affected	0.016 sec
USE SchoolDB;
-- 3	16	21:09:55	USE SchoolDB	0 row(s) affected	0.000 sec

CREATE TABLE Students (
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    StudentName VARCHAR(50),
    Age INT,
    Marks DECIMAL(5,2)
);
-- 3	17	21:10:31	CREATE TABLE Students (
-- StudentID INT PRIMARY KEY AUTO_INCREMENT,
-- StudentName VARCHAR(50),
-- Age INT,
-- Marks DECIMAL(5,2)
-- )	0 row(s) affected	0.094 sec


CREATE TABLE StudentLogs (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    ActionType VARCHAR(50),
    ActionDate DATETIME,
    Description VARCHAR(200)
);
-- 3	18	21:11:33	CREATE TABLE StudentLogs (
-- LogID INT PRIMARY KEY AUTO_INCREMENT,
-- ActionType VARCHAR(50),
-- ActionDate DATETIME,
-- Description VARCHAR(200)
-- )	0 row(s) affected	0.062 sec

DESC Students;
-- 3	19	21:12:18	DESC Students	4 row(s) returned	0.016 sec / 0.000 sec
DESC StudentLogs;
-- 3	20	21:12:34	DESC StudentLogs	4 row(s) returned	0.015 sec / 0.000 sec

DELIMITER $$

CREATE TRIGGER before_insert_marks
BEFORE INSERT ON Students
FOR EACH ROW
BEGIN
    IF NEW.Marks > 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Marks cannot exceed 100!';
    END IF;
END $$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER after_insert_student
AFTER INSERT ON Students
FOR EACH ROW
BEGIN
    INSERT INTO StudentLogs (ActionType, ActionDate, Description)
    VALUES ('INSERT', NOW(), CONCAT('New student added: ', NEW.StudentName));
END $$

DELIMITER ;

-- Test
INSERT INTO Students (StudentName, Age, Marks)
VALUES ('Rahul', 21, 85);
-- 3	22	21:14:06	INSERT INTO Students (StudentName, Age, Marks)
-- VALUES ('Rahul', 21, 85)	1 row(s) affected	0.032 sec

SELECT * FROM StudentLogs;
-- 3	23	21:14:46	SELECT * FROM StudentLogs
-- LIMIT 0, 1000	0 row(s) returned	0.016 sec / 0.000 sec


DELIMITER $$

CREATE TRIGGER after_update_marks
AFTER UPDATE ON Students
FOR EACH ROW
BEGIN
    IF NEW.Marks <> OLD.Marks THEN
        INSERT INTO StudentLogs (ActionType, ActionDate, Description)
        VALUES ('UPDATE', NOW(),
        CONCAT('Marks updated for StudentID ', OLD.StudentID,
               ' from ', OLD.Marks, ' to ', NEW.Marks));
    END IF;
END $$

DELIMITER ;


UPDATE Students
SET Marks = 90
WHERE StudentID = 1;
-- 3	24	21:16:03	UPDATE Students
 -- SET Marks = 90
-- WHERE StudentID = 1	1 row(s) affected
-- Rows matched: 1  Changed: 1  Warnings: 0	0.031 sec

SELECT * FROM StudentLogs;
-- 3	25	21:17:51	SELECT * FROM StudentLogs
-- LIMIT 0, 1000	0 row(s) returned	0.000 sec / 0.000 sec


DELIMITER $$

CREATE TRIGGER after_delete_student
AFTER DELETE ON Students
FOR EACH ROW
BEGIN
    INSERT INTO StudentLogs (ActionType, ActionDate, Description)
    VALUES ('DELETE', NOW(), CONCAT('Student deleted: ', OLD.StudentName));
END $$

DELIMITER ;

DELETE FROM Students
WHERE StudentID = 1;
-- 3	26	21:18:54	DELETE FROM Students
-- WHERE StudentID = 1	1 row(s) affected	0.031 sec

SELECT * FROM StudentLogs;
-- 3	27	21:19:33	SELECT * FROM StudentLogs
-- LIMIT 0, 1000	0 row(s) returned	0.000 sec / 0.000 sec
