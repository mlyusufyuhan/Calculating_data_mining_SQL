USE `classicmodels`;


DELIMITER $$
CREATE PROCEDURE GetCustomerOrders(IN customerNumber INT)
BEGIN
    SELECT *
    FROM orders
    WHERE customerNumber = customerNumber;
END$$
DELIMITER ;

CALL GetCustomerOrders(100);


DELIMITER $$
CREATE PROCEDURE GetCustomerOrderAmount(IN customerNumber INT, OUT orderAmount DECIMAL(10, 2))
BEGIN
    SELECT SUM(amount)
    INTO orderAmount
    FROM payments
    WHERE customerNumber = customerNumber;
END$$
DELIMITER ;

CALL GetCustomerOrderAmount(103, @amount);
SELECT CONCAT('Total Order Amount: $', FORMAT(@amount, 2)) AS 'Order Amount';

  
DELIMITER $$
CREATE PROCEDURE GetMaxCreditLimit(INOUT creditLimit DECIMAL(10, 2))
BEGIN
    SELECT MAX(creditLimit) INTO creditLimit FROM customers;
END$$
DELIMITER ;

SET @limit = 0;
CALL GetMaxCreditLimit(@limit);
SELECT CONCAT('Max Credit Limit: $', FORMAT(@limit, 2)) AS 'Credit Limit';


DELIMITER $$
CREATE FUNCTION CalculateTotalPayments(customerNumber INT) RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE totalAmount DECIMAL(10, 2);
    SELECT SUM(amount) INTO totalAmount
    FROM payments
    WHERE customerNumber = customerNumber;
    RETURN totalAmount;
END$$
DELIMITER ;

 
SELECT CalculateTotalPayments(215) AS 'Total Amount Paid';


SELECT customerNumber, CalculateTotalPayments(customerNumber) AS 'Total Amount Paid'
FROM customers;

 
DELIMITER $$
CREATE FUNCTION GetTotalReports(employeeNumber INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE totalReports INT;
    SELECT COUNT(*) INTO totalReports
    FROM employees
    WHERE reportsTo = employeeNumber;
    RETURN totalReports;
END$$
DELIMITER ;

SET @amount := 0;
CALL GetCustomerOrderAmount(103, @amount);
SELECT @amount AS 'Order Amount';