-- Active: 1673115933658@@127.0.0.1@3306@bank
USE BANK;
SELECT * FROM customer;
SELECT * FROM `account`;
SELECT cu.firstname, cu.`nationalID`, ac.`AccountID`, ac.balance
FROM customer AS cu JOIN `account` AS ac ON cu.`nationalID` = ac.`AccountID`;

SELECT cu.`nationalID` AS `ID`, cu.firstname AS `name`, ac.`AccountID` AS accID, ac.balance AS `$`
FROM customer AS cu, `account` AS ac
WHERE cu.`nationalID` = ac.`nationalID`

SELECT *
FROM customer AS cu JOIN `account` AS ac ON cu.`nationalID` = ac.`AccountID`;

SELECT cu.`nationalID` AS user_id, cu.firstname AS user_name, hl.securityLevel AS Security_Level, sb.`safeboxID`
FROM customer AS cu, contract AS cn, safebox AS sb, Hall AS hl
WHERE cu.`nationalID` = cn.`nationalID` AND cn.`safeboxID` = sb.`safeboxID` AND sb.`HallID` = hl.`HallID`;

select tp.duration as MONTH,
    hl.`SecurityLevel` as SecurityLevel,
    tp.`discountPercent`,
    (case hl.`PriceClass`
    when 'low'      then 10*tp.duration*(100-tp.`discountPercent`)/100
    when 'standard' then 20*tp.duration*(100-tp.`discountPercent`)/100
    when 'high'     then 30*tp.duration*(100-tp.`discountPercent`)/100
    end) as Price
from hall as hl, safebox as sb, contract as cn, timeplan as tp
where sb.`HallID` = hl.`HallID` and  cn.`safeboxID` = sb.`safeboxID` and cn.timeplanID = tp.timeplanID;


-- from_level 2
-- to_level 3
select hall.`SecurityLevel` as SecurityLevel, employee.`Salary` as Salary
from hall, employee
where hall.`employeeID` = employee.`employeeID` AND
hall.`SecurityLevel` BETWEEN 2 and 3;  


-- max_price = 20000
-- level = 2 
-- max_price is based on level in our design
select safebox.`safeboxID` as safeboxID, safebox.`maximumValue` as maximumValue, safebox.`HallID` as HallID
from safebox, hall
where safebox.`safeboxID` not in(select safeboxID from contract)
and safebox.`HallID` = hall.`HallID`
and hall.`SecurityLevel` = 2
and safebox.`maximumValue` = 20000;







insert into damagereport (damageReportID, damageLevel, damageDescription, date_of_damageReport, safeboxID, EmployeeID) VALUES
(10, 1, 'bad', CURRENT_DATE(), 100, 1),
(20, 3, 'horrible', CURRENT_DATE(), 301, 2);

INSERT INTO contract(contractID, safeboxID, nationalID, timeplanID, optionalServiceID, startDate) VALUES
(104, 202, 2020959951, 1, 1, '2002-08-01'),
(200, 302, 3333333333, 1, 1, '2002-08-01');

create view v1(firstname, lastname, nationalID, safeboxID) as
select customer.firstname as firstname, customer.lastname as lastname,
    customer.`nationalID` as nationalID, contract.`safeboxID` as safeboxID
from contract, customer
where contract.`nationalID` = customer.`nationalID`
and customer.`nationalID` in (select nationalID from damagereport, safebox, contract
    where contract.`safeboxID` = safebox.`safeboxID` and
    contract.`safeboxID`= damagereport.`safeboxID`)
and contract.`safeboxID` not in (select safeboxID from damagereport);

SELECT  hl.`HallID`as`HallID`,bp.`businessPlanID`,AVG(TIMESTAMPDIFF(year, date_of_birth, CURRENT_DATE)) as average_age

FROM BusinessCustomer AS bcu , Customer as cu, contract AS cn, safebox AS sb, Hall AS hl, BusinessPlan AS bp

WHERE cu.`nationalID`=bcu.`nationalID` AND cu.`nationalID` = cn.`nationalID` AND cn.`safeboxID` = sb.`safeboxID` AND sb.`HallID` = hl.`HallID` And bp.`businessPlanID` = bcu.`businessPlanID`

AND hl.`HallID`=2 AND bp.`businessPlanID`=5

GROUP BY `HallID`;




SELECT cu.`nationalID` AS user_id, cu.firstname AS user_name, sb.`safeboxID`,cn.`startDate` as startdate,cn.`timeplanID` as contractTP,timeplan.duration as duration,DATE_ADD( cn.`startDate` , INTERVAL duration MONTH) as endtime

FROM customer AS cu, contract AS cn, safebox AS sb,timeplan as timeplan

WHERE cu.`nationalID` = cn.`nationalID` AND cn.`safeboxID` = sb.`safeboxID` AND cn.`timeplanID`=timeplan.`timeplanID` AND CURRENT_DATE>DATE_ADD( cn.`startDate` , INTERVAL duration MONTH) AND CURRENT_DATE>`endDate` ;