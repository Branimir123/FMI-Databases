--Some example code
USE NORTHWND
GO

--CREATE TRIGGER tr_instead_of_delete_employee
--ON Employees
--INSTEAD OF DELETE
--AS
--BEGIN
--	UPDATE Employees
--	SET deleted = 1
--	WHERE EmployeeID IN (...)
--END;

---------------------------

--CREATE TRIGGER t_update
--ON t
--AFTER UPDATE
--AS
--BEGIN
	




USE FLIGHTS
GO

--1. �������� ���� ������ num_pass ��� ��������� Flights, ����� �� ������� ���� ��
--   ���������, ���������� ���������� �� ���������� �����.

ALTER TABLE FLIGHTS
ADD num_pass INT NOT NULL
GO

--2. �������� ���� ������ num_book ��� ��������� Agencies, ����� �� ������� ���� ��
--  ������������ ��� ����������� �������.

ALTER TABLE AGENCIES
ADD num_book INT
GO

--3. �������� ������ �� ��������� Bookings, ����� �� �� ��������� ��� �������� ��
--   ���������� � ��������� � �� ��������� � ������� ���� �� ���������, ����������
--   ���������� �� ��������� Flights, ����� � ���� �� ������������ ��� ����������� �������.

CREATE TRIGGER increment
ON BOOKINGS
AFTER INSERT AS
BEGIN
	UPDATE f 
	SET num_pass = num_pass + 1
	FROM FLIGHTS AS f
	INNER JOIN inserted AS i
	ON f.FNUMBER = i.FLIGHT_NUMBER
	WHERE f.FNUMBER = i.FLIGHT_NUMBER
	AND STATUS = 1
	UPDATE a
	SET num_book = num_book + 1
	FROM AGENCIES a
	INNER JOIN inserted AS i
	ON a.NAME = i.AGENCY
	WHERE a.NAME = i.AGENCY
	AND STATUS = 1
END
GO

--Dropping the trigger several times here because fucking up
DROP TRIGGER increment

--Use to instert some data
INSERT INTO BOOKINGS
VALUES ('YA2986', 'Travel One', 'FB', 'TK1038', 2, '2013-12-18', '2013-12-25', 300, 1)
GO


--4. �������� ������ �� ��������� Bookings, ����� �� �� ��������� ��� ��������� ��
--   ���������� � ��������� � �� �������� � ������� ���� �� ���������, ����������
--   ���������� �� ��������� Flights, ����� � ���� �� ������������ ��� ����������� �������

CREATE TRIGGER decrement
ON BOOKINGS
AFTER DELETE AS
BEGIN
	UPDATE f 
	SET num_pass = num_pass - 1
	FROM FLIGHTS AS f
	INNER JOIN deleted AS i
	ON f.FNUMBER = i.FLIGHT_NUMBER
	WHERE f.FNUMBER = i.FLIGHT_NUMBER
	AND STATUS = 1
	UPDATE a
	SET num_book = num_book - 1
	FROM AGENCIES a
	INNER JOIN deleted AS i
	ON a.NAME = i.AGENCY
	WHERE a.NAME = i.AGENCY
	AND STATUS = 1
END
GO

--Use to drop trigger
DROP TRIGGER decrement

DELETE BOOKINGS
WHERE CODE = 'YA2986'

--Helper queries
SELECT * 
FROM BOOKINGS
GO

UPDATE FLIGHTS
SET num_pass = 0
WHERE num_pass IS NULL

SELECT * 
FROM FLIGHTS
GO

UPDATE AGENCIES
SET num_book = 0 
WHERE num_book IS NULL

SELECT * 
FROM AGENCIES
GO