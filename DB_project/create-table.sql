CREATE DATABASE BANK;
USE bank;
-------------------------------------------------------------------------------------------
CREATE TABLE Employee (
    EmployeeID INT UNSIGNED PRIMARY KEY NOT NULL,
    Salary INT NOT NULL,
    password VARCHAR (20) NOT NULL,
    username VARCHAR (20) NOT NULL,
    gender CHAR (6) NOT NULL CHECK (gender = 'Male' OR gender = 'Female'),
    name VARCHAR (20) NOT NULL,
    address VARCHAR (30),
    date_of_birth DATE NOT NULL
);
--DROP TABLE employee;
CREATE TABLE InChargeEmployee (
	employeeID INT UNSIGNED NOT NULL PRIMARY KEY,
	FOREIGN KEY (employeeID) REFERENCES Employee (employeeID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE NormalEmployee (
  EmployeeID INT UNSIGNED NOT NULL PRIMARY KEY,
  FOREIGN KEY (EmployeeID ) REFERENCES Employee (EmployeeID ) ON UPDATE CASCADE ON DELETE CASCADE
);
-------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------
CREATE TABLE Customer (
    nationalID INT UNSIGNED PRIMARY KEY NOT NULL,
    lastname VARCHAR (20) NOT NULL,
    firstname VARCHAR (20) NOT NULL,
    gender CHAR (6) NOT NULL CHECK (gender = 'Male' OR gender = 'Female'),
    address VARCHAR (30),
    date_of_birth DATE NOT NULL
);
--DROP TABLE Customer;
CREATE TABLE Account (
  AccountID INT UNSIGNED NOT NULL,
  nationalID INT UNSIGNED NOT NULL,
  balance BIGINT NOT NULL,
  FOREIGN KEY (nationalID) REFERENCES Customer(nationalID) ON UPDATE CASCADE ON DELETE CASCADE,
  PRIMARY KEY (AccountID, nationalID)
);
--DROP TABLE Account;
CREATE TABLE NormalCustomer (
  nationalID INT UNSIGNED NOT NULL PRIMARY KEY,
  FOREIGN KEY (nationalID) REFERENCES Customer (nationalID) ON UPDATE CASCADE ON DELETE CASCADE
);
--DROP TABLE normalcustomer;

CREATE TABLE BusinessPlan (
     businessPlanID INT UNSIGNED PRIMARY KEY NOT NULL,
     discountPercent SMALLINT NOT NULL CHECK (discountPercent BETWEEN 0 AND 100)
);
CREATE TABLE BusinessCustomer (
  nationalID INT UNSIGNED PRIMARY KEY NOT NULL,
  businessPlanID INT UNSIGNED,
  FOREIGN KEY (nationalID) REFERENCES Customer (nationalID) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (businessPlanID) REFERENCES businessPlan (businessPlanID) ON UPDATE CASCADE ON DELETE CASCADE
);
--DROP TABLE BusinessCustomer;

--------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------
CREATE TABLE Hall (
	HallID INT UNSIGNED NOT NULL PRIMARY KEY,
    employeeID INT UNSIGNED NOT NULL UNIQUE, -- means that an employee can be only in charge of one hall
	PriceClass VARCHAR (20) NOT NULL CHECK(PriceClass IS NOT NULL AND (PriceClass = 'low' OR PriceClass = 'standard' OR PriceClass = 'high')),
	CameraCount INT UNSIGNED NOT NULL CHECK(cameracount <= 25),
	SafeboxCount INT UNSIGNED NOT NULL CHECK (SafeboxCount <= 100),
	WallMaterial VARCHAR (31) NOT NULL CHECK(wallmaterial = 'iron' OR wallmaterial = 'concrete' OR wallmaterial = 'brick'),
    SecurityLevel INT UNSIGNED,
    FOREIGN KEY (employeeID) REFERENCES InChargeEmployee(employeeID) ON UPDATE CASCADE ON DELETE CASCADE
);
--DROP TABLE Hall;

--------------------------------------------------------------------------------------
CREATE TABLE OptionalServices(
    optionalServicesID INT UNSIGNED PRIMARY KEY NOT NULL,
    price INT UNSIGNED NOT NULL
);

CREATE TABLE Insurance (
  OptionalServicesID INT UNSIGNED PRIMARY KEY NOT NULL,
  FOREIGN KEY (optionalServicesID) REFERENCES OptionalServices (optionalServicesID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE guide (
  OptionalServicesID INT UNSIGNED PRIMARY KEY NOT NULL,
  FOREIGN KEY (optionalServicesID) REFERENCES OptionalServices (optionalServicesID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE TimePlan (
	timeplanID INT UNSIGNED PRIMARY KEY NOT NULL,
	duration INT NOT NULL,
	discountPercent INT UNSIGNED CHECK (discountPercent BETWEEN 0 AND 100)
);
-- DROP TABLE TimePlan;
--------------------------------------------------------------------------------------
--TODO: we have to have a trigger to calculate the maximum value with its hall security level
CREATE TABLE Safebox(
	safeboxID INT UNSIGNED PRIMARY KEY NOT NULL,
	maximumValue INT UNSIGNED, 
	HallID INT UNSIGNED NOT NULL,
    isOccupied BOOLEAN DEFAULT FALSE,
	FOREIGN KEY (HallID) REFERENCES Hall (HallID) ON UPDATE CASCADE ON DELETE CASCADE
);
--DROP TABLE Safebox

CREATE TABLE Contract(
	contractID INT UNSIGNED NOT NULL PRIMARY KEY,
	startDate DATE NOT NULL,
	safeboxID INT UNSIGNED NOT NULL,
	timeplanID INT UNSIGNED NOT NULL,
	nationalID INT UNSIGNED NOT NULL,
    optionalServiceID INT UNSIGNED,
    endDate DATE,
    isContractActive BOOLEAN DEFAULT TRUE,
	FOREIGN KEY (safeboxID) REFERENCES Safebox(safeboxID) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (timeplanID) REFERENCES TimePlan(timeplanID) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (nationalID) REFERENCES Customer(nationalID) ON UPDATE CASCADE ON DELETE CASCADE
);
--------------------------------------------------------------------------------------

CREATE TABLE DamageReport (
	damageReportID INT UNSIGNED PRIMARY KEY NOT NULL,
	damageLevel INT UNSIGNED NOT NULL CHECK (DamageLevel <= 3),
	damageDescription VARCHAR(255),
	date_of_damageReport DATE,
	safeboxID INT UNSIGNED NOT NULL,
	EmployeeID INT UNSIGNED NOT NULL,
	FOREIGN KEY (safeboxID) REFERENCES Safebox(safeboxID) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (EmployeeID) REFERENCES InChargeEmployee(EmployeeID) ON UPDATE CASCADE ON DELETE CASCADE
);


 --TODO: Check that if this is needed REDUNDANCY!!!!!!!!
CREATE TABLE EvacuationReport (
	evacuationReportID INT UNSIGNED PRIMARY KEY NOT NULL,
    evacuationDate DATE,
    toEvacuateDate DATE,
	transactionFee INT,
    transactionStatus CHAR(10) CHECK (transactionStatus = 'Successful' OR transactionStatus = 'Fail'),
	contractID INT UNSIGNED NOT NULL,
	employeeID INT UNSIGNED NOT NULL,
	FOREIGN KEY(contractID) REFERENCES Contract(contractID) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(employeeID) REFERENCES InChargeEmployee(employeeID) ON UPDATE CASCADE ON DELETE CASCADE
);
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
DELIMITER $$
    CREATE TRIGGER check_date_of_birth_employee
    BEFORE INSERT ON employee FOR EACH ROW
        BEGIN
            DECLARE ERROR_MESSAGE VARCHAR(128);
            DECLARE age INT;
            SET age = TIMESTAMPDIFF(year, NEW.date_of_birth, CURRENT_DATE);
            SET ERROR_MESSAGE = CONCAT('the age: ', CAST(age as CHAR), ' is not valid!');
            IF age NOT BETWEEN 18 AND 120 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = ERROR_MESSAGE;
            END IF; 
        END; $$ 
DELIMITER;
--DROP TABLE check_date_of_birth_employee;

DELIMITER $$
    CREATE TRIGGER check_date_of_birth_customer
    BEFORE INSERT ON customer FOR EACH ROW
        BEGIN
            DECLARE ERROR_MESSAGE VARCHAR(128);
            DECLARE age INT;
            SET age = TIMESTAMPDIFF(year, NEW.date_of_birth, CURRENT_DATE);
            SET ERROR_MESSAGE = CONCAT('the age: ', CAST(age as CHAR), ' is not valid!');
            IF age NOT BETWEEN 18 AND 120 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = ERROR_MESSAGE;
            END IF; 
        END; $$ 
DELIMITER;
--DROP TRIGGER check_date_of_birth_customer;

DELIMITER $$
    CREATE TRIGGER setHallSecurityLevel
    BEFORE INSERT ON Hall FOR EACH ROW
        BEGIN
            IF (NEW.cameraCount BETWEEN 5 AND 10) AND 
               (NEW.safeBoxCount > 25) AND 
               (NEW.wallMaterial = 'concrete' OR NEW.wallMaterial = 'brick') THEN
                SET NEW.securityLevel = 2;
            ELSEIF (NEW.cameraCount > 10) AND 
                   (NEW.safeBoxCount < 25) AND 
                   (NEW.wallMaterial = 'iron' OR NEW.wallMaterial = 'concrete') THEN
                SET NEW.securityLevel = 3;
            ELSE 
                SET NEW.securityLevel = 1;
            END IF; 
        END; $$ 
DELIMITER;
--DROP TRIGGER setHallSecurityLevel;

DELIMITER $$
    CREATE TRIGGER setTimePlanDiscount
    BEFORE INSERT ON TimePlan FOR EACH ROW
        BEGIN
            IF (NEW.duration BETWEEN 1 AND 3) THEN
                SET NEW.discountPercent = 10;
            ELSEIF (NEW.duration BETWEEN 4 AND 12) THEN
                SET NEW.discountPercent = 20;
            ELSE 
                SET NEW.discountPercent = 30;
            END IF;
        END; $$ 
DELIMITER;
--DROP TRIGGER setTimePlanDiscount;
-----------------------------------------------------------------------


DELIMITER $$
    CREATE TRIGGER setContractAttributes
    BEFORE INSERT ON Contract FOR EACH ROW
        BEGIN
            DECLARE contractTimePlanDuration INT UNSIGNED;
            SET contractTimePlanDuration = (SELECT tp.duration FROM timeplan AS tp 
                                            WHERE NEW.timeplanID = tp.timeplanID LIMIT 1);
            SET NEW.endDate = DATE_ADD(NEW.startDate, INTERVAL contractTimePlanDuration MONTH);
        END; $$
DELIMITER;