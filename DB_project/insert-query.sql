-- Active: 1673115933658@@127.0.0.1@3306@bank
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
ELECT * FROM bank.customer;
--------------------------------------------------------------------------------------
INSERT INTO customer (`nationalID`, firstname, lastname, gender, date_of_birth, address) VALUES
    (0430171560, 'Ali', 'Rahimi', 'Male', '2002-08-23', NULL),
    (0025120073, 'Amirhosein', 'Khoshbakht', 'Male', '2001-08-23', NULL),
    (2020959951, 'Mehrshad', 'Barzamini', 'Male', '2002-12-19', "Akbari Ave, Teymoori"),
    (0041065635, 'Amirmahdi', 'Daraei', 'Male', '2002-09-19', NULL),
    (2283281903, 'Farhad', 'Esmaeilzade', 'Male', '2001-10-29', NULL),
    (1010563244, 'Mohammad', 'Barzamini', 'Male', '1996-04-12', NULL),
    (1111111111, 'Madison', 'Clark', 'Female', '1987-02-01', "225, 53 Ave, Georgia"),
    (2222222222, 'Alicia', 'Patt', 'Female', '1990-10-21', "124, 21 Ave, California"),
    (3333333333, 'Scarlette', 'Sparrow', 'Female', '1976-03-05', "324, 1st Ave, Texas");
INSERT INTO normalcustomer (`nationalID`) VALUES
    (2020959951), (0041065635), (2283281903), (1010563244);
INSERT INTO businessplan (`businessPlanID`, `discountPercent`) VALUES
    (1, 5), (2, 10), (3, 15), (4, 20), (5, 25), (6, 30), (7, 35), (8, 40), (9, 45), (10, 50), (11, 55), (12, 60), (13, 65), (14, 70);
INSERT INTO businesscustomer (`nationalID`, `businessPlanID`) VALUES
    (1111111111, 10), (2222222222, 5), (3333333333, 2),
    (0430171560, 10), (2020959951, 5), (1010563244, 2),
    (0025120073, 10), (0041065635, 5), (2283281903, 2);
INSERT INTO `account` (`AccountID`, `nationalID`, balance) VALUES
    (20005, 2020959951, 1000), (20006, 2020959951, 2000), (20007, 2020959951, 100),
    (20000, 0041065635, 5000), (20001, 0041065635, 345),
    (20002, 2283281903, 10000), (20003, 2283281903, 55450), (20004, 2283281903, 30000),

    (10000, 1111111111, 500000), (10001, 1111111111, 200000000), (10002, 1111111111, 250000000),
    (10003, 2222222222, 100000), (10004, 2222222222, 500000000), (10005, 2222222222, 1000000), (10006, 2222222222, 3000000), (10007, 2222222222, 1000000),
    (10008, 3333333333, 200000), (10009, 3333333333, 200000000), (10010, 3333333333, 300000000), (10011, 3333333333, 3527000);
--------------------------------------------------------------------------------------
INSERT INTO timeplan (`timeplanID`, duration) VALUES
    (1, 3),
    (2, 7),
    (3, 1),
    (4, 12),
    (5, 15);

--------------------------------------------------------------------------------------
INSERT INTO optionalservices (`optionalServicesID`, price) VALUES
    (1, 200), (2, 1000), (3, 200), (4, 800), (5, 1000), (6, 800), (7, 800);
INSERT INTO guide (`optionalServicesID`) VALUES
    (1), (2), (3), (5);
INSERT INTO insurance (`optionalServicesID`) VALUES
    (2), (4), (5), (6), (7);
--------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------
INSERT INTO employee (`EmployeeID`, `Salary`, `name`, username, gender, date_of_birth, `password`, `address`) VALUES
    (1 ,1000, 'Ali', 'Ali', 'Male', '2002-08-01', '12345', 'Baghdad'),
    (2 ,2000, 'Mamad', 'Mamad12', 'Male', '2001-04-01', '12345', 'Kabol'),
    (3 ,5000, 'Bahdad', 'Bahdad56', 'Male', '2003-08-11', '56789', 'Tehran'),
    (4 ,3000, 'Amir', 'Amir', 'Male', '1998-08-01', '65353', 'LA'),
    (5 ,5000, 'Sara', 'Sara343', 'Female', '2002-04-07', '3587', 'NY'),
    (6 ,7600, 'Mobina', 'Mm345', 'Female', '1992-04-09', '3587', 'LA');
INSERT INTO inchargeemployee (`employeeID`) VALUES
    (1), (2), (3), (4);
INSERT INTO normalemployee (`employeeID`) VALUES
    (5), (6);
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------    
INSERT INTO hall (`HallID`, `employeeID`, `PriceClass`, `CameraCount`, `SafeboxCount`, `WallMaterial`) VALUES
    (1, 1, 'low', 3, 30, 'brick'), --Security Level: 1
    (2, 2, 'standard', 8, 26, 'concrete'), --Security Level: 2
    (3, 3, 'high', 25, 20, 'iron'); --Security Level: 3

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
INSERT INTO safebox(safeboxID, HallID, maximumValue) VALUES
    (100, 1 ,10000),
    (101, 1 ,10000),
    (102, 1 ,10000),
    (103, 1 ,10000),
    (200, 2 ,20000),
    (201, 2 ,20000),
    (202, 2 ,20000),
    (300, 3 ,30000),
    (301, 3 ,30000),
    (302, 3 ,30000);


-------------------------------------------------------------------------------------- *hatman ino moghe tahvil neshoon bede
INSERT INTO contract(contractID, safeboxID, nationalID, timeplanID, optionalServiceID, startDate) VALUES 
(1, 100, 2020959951, 2, 4, CURRENT_DATE()), -- 7 months, insurance service $800
(2, 202, 2222222222, 4, 2, CURRENT_DATE()), -- 12 months, all service $1000
(3, 301, 3333333333, 5, 3, CURRENT_DATE()); -- 15 months, guide service $200
(104, 202, 2020959951, 1, 1, '2002-08-01'),
(200, 302, 3333333333, 1, 1, '2002-08-01');



INSERT INTO contract (`contractID`,`startDate`,`safeboxID`,`timeplanID`,`nationalID`,`optionalServiceID`,`endDate`) VALUES

     (101,'2002-08-01',101,1,0430171560,1,NULL),

     (102,'2002-08-01',102,1,0025120073,1,NULL),



     (105,'2002-08-01',300,1,0041065635,1,'2023-01-01'),

     (106,'2002-08-01',201,1,0041065635,1,NULL);