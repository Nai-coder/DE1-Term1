-- create new analytical layer from the previous operational layer loaded

DROP PROCEDURE IF EXISTS CreateWDI2000table;

DELIMITER //

CREATE PROCEDURE CreateWDI2000table()
BEGIN

	DROP TABLE IF EXISTS wdi_2000;

	CREATE TABLE wdi_2000 AS
	SELECT 
	   pop.`Country Name`, 
       pop.`Country Code`, 
       pop.y2000 AS population, 
       gdp.y2000 AS GDP,
       co2.y2000 AS CO2_emissions,
       hyd.y2000 AS hydroel,
       nucl.y2000 AS nuclear,
       ogc.y2000 AS oilgascoal,
       ren.y2000 AS renewables
	FROM wdi_pop as pop
	LEFT JOIN wdi_gdp AS gdp
    ON pop.`Country Name` = gdp.`Country Name`
    LEFT JOIN wdi_co2_emissions AS co2
    ON pop.`Country Name` = co2.`Country Name`
    LEFT JOIN wdi_hydroelec AS hyd
    ON pop.`Country Name` = hyd.`Country Name`
    LEFT JOIN wdi_nuclear AS nucl
    ON pop.`Country Name` = nucl.`Country Name`
    LEFT JOIN wdi_oilgascoal AS ogc
    ON pop.`Country Name` = ogc.`Country Name`
    LEFT JOIN wdi_renewables AS ren
    ON pop.`Country Name` = ren.`Country Name`
	GROUP BY `Country Name`;

END //
DELIMITER ;


CALL CreateWDI2000table();

DROP PROCEDURE IF EXISTS CreateWDI2010table;

DELIMITER //

CREATE PROCEDURE CreateWDI2010table()
BEGIN

	DROP TABLE IF EXISTS wdi_2010;

	CREATE TABLE wdi_2010 AS
	SELECT 
	   pop.`Country Name`, 
       pop.`Country Code`, 
       pop.y2010 AS population, 
       gdp.y2010 AS GDP,
       co2.y2010 AS CO2_emissions,
       hyd.y2010 AS hydroel,
       nucl.y2010 AS nuclear,
       ogc.y2010 AS oilgascoal,
       ren.y2010 AS renewables
	FROM wdi_pop as pop
	LEFT JOIN wdi_gdp AS gdp
    ON pop.`Country Name` = gdp.`Country Name`
    LEFT JOIN wdi_co2_emissions AS co2
    ON pop.`Country Name` = co2.`Country Name`
    LEFT JOIN wdi_hydroelec AS hyd
    ON pop.`Country Name` = hyd.`Country Name`
    LEFT JOIN wdi_nuclear AS nucl
    ON pop.`Country Name` = nucl.`Country Name`
    LEFT JOIN wdi_oilgascoal AS ogc
    ON pop.`Country Name` = ogc.`Country Name`
    LEFT JOIN wdi_renewables AS ren
    ON pop.`Country Name` = ren.`Country Name`
	GROUP BY `Country Name`;

END //
DELIMITER ;

CALL CreateWDI2010table();