-- First we will create a view of the western Balkan countries which have 
-- hydroelectric electricity and another for nuclear el. production:
USE wdi;

-- For Q1: What is the GDP pP for Central European countries?
DROP VIEW IF EXISTS Central_Europe_GDP_perPop_2010;

CREATE VIEW `Central_Europe_GDP_perPop_2010` AS 
	SELECT `Country Name`, GDP/population AS `GDP normalised for population in US dollar equivalent`
	FROM wdi_2010 
	WHERE `Country Name` = 'Austria' 
	OR `Country Name` = 'Hungary'
	OR `Country Name` = 'Czechia'
	OR `Country Name` = 'Slovak Republic'
	OR `Country Name` = 'Germany'
	OR `Country Name` = 'Liechtenstein'
	OR `Country Name` = 'Switzerland'
	OR `Country Name` = 'Slovenia'
	ORDER BY GDP/population DESC;

SELECT * FROM Central_Europe_GDP_perPop_2010;


-- For Q2: What is the CO2 emissions pP for each Central European country?
DROP VIEW IF EXISTS Central_Europe_CO2_2010;

CREATE VIEW `Central_Europe_CO2_2010` AS 
	SELECT `Country Name`, CO2_emissions AS `CO2 emissions (metric tons per capita)`
	FROM wdi_2010 
	WHERE `Country Name` = 'Austria' 
	OR `Country Name` = 'Hungary'
	OR `Country Name` = 'Czechia'
	OR `Country Name` = 'Slovak Republic'
	OR `Country Name` = 'Germany'
	OR `Country Name` = 'Liechtenstein'
	OR `Country Name` = 'Switzerland'
	OR `Country Name` = 'Slovenia'
	ORDER BY CO2_emissions DESC;

SELECT * FROM Central_Europe_CO2_2010;
-- here we see Germany and Austria are the highest CO2 emitter per capita (in 2010)


-- For Q3: What is the percentage of oil, gas and coal electricity production in Central European countries in 2010?
DROP VIEW IF EXISTS Central_Europe_oilgascoal_2010;

CREATE VIEW `Central_Europe_oilgascoal_2010` AS
	SELECT `Country Name`,  
    oilgascoal AS `Electricity production from oil, gas and coal (% of total)` 
    FROM wdi_2010 
    WHERE `Country Name` = 'Austria' 
    OR `Country Name` = 'Czechia'
    OR `Country Name` = 'Hungary' 
    OR `Country Name` = 'Slovenia' 
    OR `Country Name` = 'Germany' 
    OR `Country Name` = 'Liechtenstein' 
    OR `Country Name` = 'Switzerland' 
    OR `Country Name` = 'Slovakia' 
    ORDER BY oilgascoal DESC;

SELECT * FROM Central_Europe_oilgascoal_2010;
-- Here we see Germany and Hungary have the highest percentage of electricity production from oil,
-- gas and coal sources in year 2010 for Central European countries

-- For Q4: What is the total percentage of low-CO2 emission technologies for electricity production (i.e. nuclear, 
-- renewables and hydorelectric) and what percentage of each Central European country's electricity production 
-- do they consist of (in the year 2010?
DROP VIEW IF EXISTS Central_Europe_green_2010;

CREATE VIEW `Central_Europe_green_2010` AS
	SELECT `Country Name`, SUM(hydroel + nuclear + renewables) AS `El. production from low carbon tech. in % from total` 
	FROM wdi_2010 
	WHERE `Country Name` = 'Austria' 
	OR `Country Name` = 'Hungary'
	OR `Country Name` = 'Czechia'
	OR `Country Name` = 'Slovak Republic'
	OR `Country Name` = 'Germany'
	OR `Country Name` = 'Liechtenstein'
	OR `Country Name` = 'Switzerland'
	OR `Country Name` = 'Slovenia'
	GROUP BY `Country Name`
	ORDER BY SUM(hydroel + nuclear + renewables) DESC;

SELECT * FROM Central_Europe_green_2010;
-- we see that Switzerland and Slovak Republic had the highest percentage of electricty production
-- from green (low carbon) sources in the year 2010.

-- For Q5 we are looking for a way to view all the data from the previous views in one go in order to answer:
-- How do those numbers compare to the answers from the first two questions?
DROP VIEW IF EXISTS Central_Europe_comparison_2010;

CREATE VIEW `Central_Europe_comparison_2010` AS
	SELECT `Country Name`,
	oilgascoal AS `El. production from oil, gas and coal sources (% of total)`, 
	SUM(hydroel + nuclear + renewables) AS `El. production from low carbon tech. in % from total`,
	CO2_emissions AS `CO2 emissions (metric tons per capita)`,
	GDP/population AS GDP_pP
	FROM wdi_2010 
	WHERE `Country Name` = 'Austria' 
	OR `Country Name` = 'Hungary'
	OR `Country Name` = 'Czechia'
	OR `Country Name` = 'Slovak Republic'
	OR `Country Name` = 'Germany'
	OR `Country Name` = 'Liechtenstein'
	OR `Country Name` = 'Switzerland'
	OR `Country Name` = 'Slovenia'
	GROUP BY `Country Name`, oilgascoal, CO2_emissions, GDP/population
	ORDER BY SUM(hydroel + nuclear + renewables) DESC;

SELECT * FROM Central_Europe_comparison_2010;
-- here we see Switzerland was the country with the highest GDP per person and the lowest CO2 emissions
-- where they had the highest percentage of electricity production from low carbon technologies


-- For Q6: Was the situation the same in 2000? We have the above code modified for year 2000:
DROP VIEW IF EXISTS Central_Europe_comparison_2000;

CREATE VIEW `Central_Europe_comparison_2000` AS
	SELECT `Country Name`,
	oilgascoal AS `El. production from oil, gas and coal sources (% of total)`, 
	SUM(hydroel + nuclear + renewables) AS `El. production from low carbon tech. in % from total`,
	CO2_emissions AS `CO2 emissions (metric tons per capita)`,
	GDP/population AS GDP_pP
	FROM wdi_2000 
	WHERE `Country Name` = 'Austria' 
	OR `Country Name` = 'Hungary'
	OR `Country Name` = 'Czechia'
	OR `Country Name` = 'Slovak Republic'
	OR `Country Name` = 'Germany'
	OR `Country Name` = 'Liechtenstein'
	OR `Country Name` = 'Switzerland'
	OR `Country Name` = 'Slovenia'
	GROUP BY `Country Name`, oilgascoal, CO2_emissions, GDP/population
	ORDER BY SUM(hydroel + nuclear + renewables) DESC;

SELECT * FROM Central_Europe_comparison_2000;
-- We see again that Switzerland is on top of the list in year 2000.alter

-- To see what the electricty production of Switzerland consisted of, we can run the 
-- stored procedure from part 4 (4_ETL_triggs_stored_pro.sql):
CALL Get2010DataByCountry('Switzerland');

-- and in year 2000 this was:
CALL Get2000DataByCountry('Switzerland');

-- in both years, nuclear and hydroelectric electricity production made up the highest percentage 
-- of Switzerland's electricity production and thus the lowest CO2 emitter from the Central European
-- countries.