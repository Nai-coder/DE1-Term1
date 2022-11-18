-- Short plan for data analytics:
-- We will try to investigate several things:
-- 1. What is the GDP pP for Austria versus its neighbours?
-- 2. Do we have nuclear electricity production in Austria versus its neighbours in 2010? 
-- 3. What is the percentage of oil, gas and coal electricity production in Austria vs. Hungary in 2000?
-- 4. whether nuclear electricity production has been changing (increasing or decreasing) in Hungary in 2010 versus 2000?
-- 5. whether renewable (including hydroelectric) electricity production has been changing in Austria (increasing or decreasing) in 2010 versus 2000?
-- 6. Which country (Austria or Hungary) has the higher CO2 emission rate pP? Did this change between 2000 and 2010?

-- Q1
SELECT `Country Name`, GDP/population AS GDP_pP_in_EUR
FROM wdi_2000 
WHERE `Country Name` = 'Austria' 
OR `Country Name` = 'Hungary'
OR `Country Name` = 'Czechia'
OR `Country Name` = 'Slovak Republic'
OR `Country Name` = 'Germany'
OR `Country Name` = 'Liechtenstein'
OR `Country Name` = 'Switzerland'
OR `Country Name` = 'Slovenia'
ORDER BY `Country Name`;
-- we note that Switzerland has the highest GDP pP and there is no data for Liechtenstein
-- Austria had a GDP of 29376.02 EUR pP (one can check the accompanying metadata for the loaded tables for units)

-- Q2
SELECT `Country Name`, nuclear 
FROM wdi_2010
WHERE `Country Name` = 'Austria' 
OR `Country Name` = 'Hungary'
OR `Country Name` = 'Slovak Republic'
OR `Country Name` = 'Czechia'
OR `Country Name` = 'Germany'
OR `Country Name` = 'Liechtenstein'
OR `Country Name` = 'Switzerland'
OR `Country Name` = 'Slovenia'
ORDER BY `Country Name`;
-- 0% of the total electricity production from nuclear for Austria in 2010

-- Q3
SELECT `Country Name`, oilgascoal FROM wdi_2000 WHERE `Country Name` = 'Austria' OR `Country Name` = 'Hungary';
-- in Austria it is 27.21% and Hungary more than double that amount at 58.85%

-- Q4
SELECT wdi_2000.`Country Name`, wdi_2000.nuclear AS nuclear2000, wdi_2010.nuclear AS nuclear2010
FROM wdi_2000
INNER JOIN wdi_2010
ON wdi_2000.`Country Name` = wdi_2010.`Country Name`
WHERE wdi_2000.`Country Name` = 'Hungary';
-- and we note that there was a slight increase in the percentage of total electricity 
-- production from nuclear in Hungary from 2000 to 2010 (from 40.29 to 42.17%)

-- Q5
SELECT wdi_2000.`Country Name`,
SUM(wdi_2000.renewables + wdi_2000.hydroel) AS total_ren_2000,
SUM(wdi_2010.renewables + wdi_2010.hydroel) AS total_ren_2010
FROM wdi_2000
INNER JOIN wdi_2010
ON wdi_2000.`Country Name` = wdi_2010.`Country Name`
WHERE wdi_2000.`Country Name` = 'Austria';
-- And we are surprised to see that the total percentage of renewables electricity production
-- in Austria has gone down from 2000 to 2010 (72.54 versus 66.21%).

-- Q6
SELECT wdi_2000.`Country Name`, 
wdi_2000.CO2_emissions AS CO2_2000, 
wdi_2010.CO2_emissions AS CO2_2010,
((wdi_2000.CO2_emissions)/(wdi_2000.population)) AS tot_2000_co2_pP,
((wdi_2010.CO2_emissions)/(wdi_2010.population)) AS tot_2010_co2_pP
FROM wdi_2000
INNER JOIN wdi_2010
ON wdi_2000.`Country Name` = wdi_2010.`Country Name`
WHERE wdi_2000.`Country Name` = 'Austria' 
OR wdi_2000.`Country Name` = 'Hungary';
-- we see from the output that Hungary has about 30% less CO2 emissions, and when compared to
-- population numbers, it has an even smaller CO2 pP emission rate. The total CO2 emission amound
-- went down in Hungary whereas it increase in Austria when comparing years 2000 and 2010.
-- We conclude that Hungary has a much more climate friendly CO2 emissions status than Austria,
-- especially when normalised by total population (in both 2000 and 2010).
