-- Stored Procedures
USE wdi;

-- A basic stored procedure
-- Creating the stored procedure

DROP PROCEDURE IF EXISTS Get2000DataByCountry;

DELIMITER //

CREATE PROCEDURE Get2000DataByCountry(
	IN country VARCHAR(255)
)
BEGIN
	SELECT * 
 		FROM wdi_2000
			WHERE `Country Name` = country;
END //
DELIMITER ;

-- Execute this stored procedure:
CALL Get2000DataByCountry('Hungary');
CALL Get2000DataByCountry('Austria');
-- France is the highest nuclear el. producer in Europe:
CALL Get2000DataByCountry('France');


-- For the second part:
-- DATA MART: Create Views as data marts.

-- Events to schedule ETL jobs
-- Event engine runs scheduled jobs/tasks. We can us it for scheduling ETL processes.
-- Basics on how to check the state of the scheduler. Check if scheduler is running:

SHOW VARIABLES LIKE "event_scheduler";
-- Turn it on if not
SET GLOBAL event_scheduler = ON;

-- create a check messages table (we are creating a table to see the steps
-- for stored procedures executed, etc.)
CREATE TABLE IF NOT EXISTS messages (message varchar(100) NOT NULL);

-- Event which is calling CreateDataCheckAustria() every 1 minute in the next 1 hour.
-- This is where we are setting up the scheduler, and calling stored procedures

-- first empty the messages table
TRUNCATE messages;

DROP EVENT IF EXISTS CreateDataCheckAustria;

DELIMITER $$

CREATE EVENT CreateDataCheckAustria
ON SCHEDULE EVERY 1 MINUTE
STARTS CURRENT_TIMESTAMP
ENDS CURRENT_TIMESTAMP + INTERVAL 1 HOUR
DO
	BEGIN
		INSERT INTO messages SELECT CONCAT('event:', NOW());
    		CALL Get2000DataByCountry('Austria');
	END$$
DELIMITER ;

-- Listing all events stored in the schema
SHOW EVENTS;

SELECT * FROM messages;

-- Trigger as ETL
-- for monitoring source table wdi_pop, and if there is a change, 
-- it will be propagated to wdi_2000 table:

-- first we can truncate the messages table
TRUNCATE messages;

DROP TRIGGER IF EXISTS after_insert;
DELIMITER $$
CREATE TRIGGER after_insert 
AFTER INSERT ON wdi_pop 
FOR EACH ROW
BEGIN    
    -- log the order number of the newley inserted order
	INSERT INTO messages
    SELECT CONCAT('new Country row: ', NEW.`Country Name`);
    -- archive the order and assosiated table entries to wdi_2000
    INSERT INTO wdi_2000 (`Country Name`)
    SELECT `Country Name`
    FROM   wdi_pop
	WHERE `Country Name` = NEW.`Country Name`;
END $$
DELIMITER ;

-- Activating the trigger
-- Listing the current state of the wdi_pop. 
-- Please note that, there is no country named Fantasia, nor Narnia nor Middle Earth.
SELECT COUNT(*) FROM wdi_pop;
SELECT COUNT(*) FROM wdi_2000;
SELECT * FROM wdi_pop ORDER BY `Country Name`;

-- Now will activate the trigger by inserting into wdi_pop:
INSERT INTO wdi_pop VALUES("Fantasia", "FNT", NULL, NULL, 
0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,
0,0);

INSERT INTO wdi_pop VALUES("Narnia", "NRN", NULL, NULL, 
0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,
0,0);
INSERT INTO wdi_pop VALUES("Middle Earth", "MEA", NULL, NULL, 
0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,
0,0);

SELECT COUNT(*) FROM wdi_pop;
SELECT COUNT(*) FROM wdi_2000;
-- now we see we added 3 more into wdi_pop and wdi_2000

-- check messages
SELECT * FROM messages;

-- check that this is reflected in wdi_pop and wdi_2000 tables:
SELECT * FROM wdi_pop WHERE `Country Name` = 'Fantasia';
SELECT * FROM wdi_pop WHERE `Country Name` = 'Narnia';
SELECT * FROM wdi_pop WHERE `Country Name` = 'Middle Earth';
SELECT * FROM wdi_2000 WHERE `Country Name` = 'Fantasia';
SELECT * FROM wdi_2000 WHERE `Country Name` = 'Narnia';
SELECT * FROM wdi_2000 WHERE `Country Name` = 'Middle Earth';

DELETE FROM wdi_pop WHERE `Country Name` = "Fantasia";
DELETE FROM wdi_pop WHERE `Country Name` = "Narnia";
DELETE FROM wdi_pop WHERE `Country Name` = "Middle Earth";

-- check deleted
SELECT * FROM wdi_pop WHERE `Country Name` = 'Narnia';

-- we copy the above for the second table wdi_2010
DROP TRIGGER IF EXISTS after_insert2;
DELIMITER $$
CREATE TRIGGER after_insert2
AFTER INSERT ON wdi_pop 
FOR EACH ROW
BEGIN    
    -- log the order number of the newley inserted order
	INSERT INTO messages
    SELECT CONCAT('new Country row: ', NEW.`Country Name`);
    -- archive the order and assosiated table entries to wdi_2000
    INSERT INTO wdi_2010 (`Country Name`)
    SELECT `Country Name`
    FROM   wdi_pop
	WHERE `Country Name` = NEW.`Country Name`;
END $$
DELIMITER ;