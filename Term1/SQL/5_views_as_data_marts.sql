-- First we will create a view of the western Balkan countries which have 
-- hydroelectric electricity and another for nuclear el. production:
USE wdi;

DROP VIEW IF EXISTS Central_Europe_hydro_2010;

CREATE VIEW `Central_Europe_hydro_2010` AS
	SELECT wdi_2010.`Country Name`, wdi_2010.`Country Code`, wdi_2010.hydroel AS `Hydroelectric (% of total elctricity production)` FROM wdi_2010 WHERE wdi_2010.hydroel > 0 
    AND (`Country Name` = 'Austria' 
    OR `Country Name` = 'Czechia'
    OR `Country Name` = 'Hungary' 
    OR `Country Name` = 'Slovenia' 
    OR `Country Name` = 'Germany' 
    OR `Country Name` = 'Poland' 
    OR `Country Name` = 'Switzerland' 
    OR `Country Name` = 'Slovakia' )
    ORDER BY `Country Name`;

SELECT * FROM Central_Europe_hydro_2010;
-- here we see all central European countries had hydroelectric power production (in 2010)

DROP VIEW IF EXISTS Central_Europe_nuclear_2010;

CREATE VIEW `Central_Europe_nuclear_2010` AS
	SELECT wdi_2010.`Country Name`, wdi_2010.`Country Code`, wdi_2010.nuclear AS `Electricity production from nuclear (% of total)` FROM wdi_2010 WHERE wdi_2010.nuclear > 0 
    AND (`Country Name` = 'Austria' 
    OR `Country Name` = 'Czechia'
    OR `Country Name` = 'Hungary' 
    OR `Country Name` = 'Slovenia' 
    OR `Country Name` = 'Germany' 
    OR `Country Name` = 'Poland' 
    OR `Country Name` = 'Switzerland' 
    OR `Country Name` = 'Slovakia' )
    ORDER BY `Country Name`;

SELECT * FROM Central_Europe_nuclear_2010;
-- here we see only 5 countries had nuclear in 2010

DROP VIEW IF EXISTS West_Balkans_nuclear_2010;

CREATE VIEW `West_Balkans_nuclear_2010` AS
	SELECT wdi_2010.`Country Name`, wdi_2010.`Country Code`, wdi_2010.nuclear AS `Electricity production from nuclear (% of total)`FROM wdi_2010 WHERE wdi_2010.nuclear > 0
    AND (`Country Name` = 'Bosnia and Herzegovina' 
    OR `Country Name` = 'Croatia'
    OR `Country Name` = 'North Macedonia'
    OR `Country Name` = 'Slovenia' 
    OR `Country Name` = 'Serbia' );
SELECT * FROM West_Balkans_nuclear_2010;
-- we see that only Slovenia had nuclear power in 2010

-- We can create another view for hydroelectric power in 2010 for the West Balkans:
DROP VIEW IF EXISTS West_Balkans_hydro_2010;

CREATE VIEW `West_Balkans_hydro_2010` AS
	SELECT wdi_2010.`Country Name`, wdi_2010.`Country Code`, wdi_2010.hydroel AS `Hydroelectric production (% of total)` FROM wdi_2010 WHERE wdi_2010.hydroel > 0
    AND (`Country Name` = 'Bosnia and Herzegovina' 
    OR `Country Name` = 'Croatia'
    OR `Country Name` = 'North Macedonia' 
    OR `Country Name` = 'Slovenia' 
    OR `Country Name` = 'Serbia' );

SELECT * FROM West_Balkans_hydro_2010;
-- here we see all western Balkan countries had hydroelectric power production (in 2010)
