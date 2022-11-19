-- Short plan for data analytics:
-- The central idea in this is to look at countries in central Europe and compare from what sources their
-- electricity production is from. Are countries with higher GDP also the highest CO2 emitters? What about
-- those that use the most renewables (including hydroelectricity production?) Ultimately, we want to
-- see if the country with the highest GDP (normalised for population) is also the most responsible
-- in its CO2 emissions and whether this is due to the use of nuclear or renewable electricity production.

-- We thus try to investigate several things:
-- 1. What is the GDP pP for Central European countries?
-- 2. What is the CO2 emissions pP for each Central European country?
-- 3. What is the percentage of oil, gas and coal electricity production in Central European countries in 2010?
-- 4. What is the total percentage of low-CO2 emission technologies for electricity production (i.e. nuclear, 
-- renewables and hydorelectric) and what percentage of each Central European country's electricity production 
-- do they consist of (in the year 2010?
-- 5. How do those numbers compare to the answers from the first two questions?
-- 6. Was the situation the same in 2000?

-- Q1
SELECT `Country Name`, GDP/population AS GDP_pP_in_USdol
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
-- we note that Switzerland has the highest GDP normalised to population and there is no data for Liechtenstein
-- Austria had a GDP of 42009 EUR pP (US dollars equivalent)

-- Q2
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
-- Hungary, Liechtenstein and Switzerland are the least CO2 emitters per person and Czechia and Germany are the worst


-- Q3
SELECT `Country Name`, oilgascoal 
FROM wdi_2010 
WHERE `Country Name` = 'Austria' 
OR `Country Name` = 'Hungary'
OR `Country Name` = 'Czechia'
OR `Country Name` = 'Slovak Republic'
OR `Country Name` = 'Germany'
OR `Country Name` = 'Liechtenstein'
OR `Country Name` = 'Switzerland'
OR `Country Name` = 'Slovenia'
ORDER BY oilgascoal DESC;
-- The highest percentage of electricity production from oil gas and coal sources
-- was in Germany and Hungary in the year 2010. We are quite surprised as they had
-- the lowest CO2 emissions per person

-- Q4
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

-- Q5
-- We can combine the above two table results into one by:
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

-- Q6
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

-- and we note that the situation was actually quite similar in the year 2000. 
-- Switzerland was on the top of the list with close to 97% of their electricity production
-- from low carbon technologies. Austria dropped from 2nd place in 2000 to 3rd place in 2010
-- We are also surprised to see that the the third highest GDP country (Germany) is at the bottom
-- of the list with close to 60% of their electricity production from oil, gas and coal sources.
-- We note there is no data on electricity production for Czechia and Liechtenstein.
-- Liechtenstein was also the country with the highest CO2 emissions per person both in 2000
-- and in 2010.

