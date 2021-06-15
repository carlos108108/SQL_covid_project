CREATE TABLE t_karel_novak_projekt_SQL_final
IGNORE WITH index_table AS (
SELECT
	base.`date` ,
	base.country ,
	a.iso3 ,
	base.confirmed ,
	b.tests_performed ,
	ROUND(base.confirmed / (b.tests_performed / a.population * 100000), 2) index_conf_tested,
	ROUND(base.confirmed / a.population * 100000, 2) conf_per_one_hundred_thousand,
	ROUND(b.tests_performed / a.population * 100000, 2) tested_per_one_hundred_thousand,
	ROUND(base.confirmed / b.tests_performed * 100, 2) daily_percent_conf_test
	--a.population - not necessary - it is used as divisor
	--b.cumulative - not necessary because we don't know if tested people are still the same
FROM covid19_basic_differences base
LEFT JOIN lookup_table a
	ON 1=1
	AND base.country = a.country
LEFT JOIN covid19_tests b
	ON a.iso3 = b.ISO
	AND base.`date` = b.`date`
WHERE 1=1
	AND b.entity != 'units unclear (incl. non-PCR)' -- related to US
	AND b.entity != 'people tested' -- related to France, India, Italy, Poland
	AND a.province IS NULL
	AND b.tests_performed IS NOT NULL
),
religion_table AS (
WITH tmp_religion_table AS(
SELECT DISTINCT
a.country, AVG(a.Islam) Islam, AVG(a.Christianity) Christianity, AVG(a.Unaffiliated_Religions) Unaffiliated_Religions,
AVG(a.Hinduism) Hinduism, AVG(a.Buddhism) Buddhism, AVG(a.Folk_Religions) Folk_Religions,
AVG(a.Other_Religions) Other_Religions, AVG(a.Judaism) Judaism
FROM (
	SELECT
		country, religion , population ,
		IF(religion = 'Islam', population, NULL) Islam,
		IF(religion = 'Christianity', population, NULL) Christianity,
		IF (religion = 'Unaffiliated Religions', population, NULL) Unaffiliated_Religions,
		IF(religion = 'Hinduism', population, NULL) Hinduism,
		IF(religion = 'Buddhism', population, NULL) Buddhism,
		IF(religion = 'Folk Religions', population, NULL) Folk_Religions,
		IF(religion = 'Other Religions', population, NULL) Other_Religions,
		IF (religion = 'Judaism', population, NULL) Judaism
	FROM religions
	WHERE `year` = 2010
) a
JOIN (
SELECT
	country, religion , population ,
	IF(religion = 'Islam', population, NULL) Islam,
	IF(religion = 'Christianity', population, NULL) Christianity,
	IF (religion = 'Unaffiliated Religions', population, NULL) Unaffiliated_Religions,
	IF(religion = 'Hinduism', population, NULL) Hinduism,
	IF(religion = 'Buddhism', population, NULL) Buddhism,
	IF(religion = 'Folk Religions', population, NULL) Folk_Religions,
	IF(religion = 'Other Religions', population, NULL) Other_Religions,
	IF (religion = 'Judaism', population, NULL) Judaism
FROM religions
WHERE `year` = 2010
) b
ON a.country = b.country
GROUP BY a.country
)
SELECT
	c.iso3 ,
	r.*,
	ROUND(r.Islam/c.population*100, 2) Islam_ratio ,
	ROUND(r.Christianity/c.population*100, 2) Christianity_ratio,
	ROUND(r.Unaffiliated_Religions/c.population*100, 2) Unaffiliated_Religions_ratio,
	ROUND(r.Hinduism/c.population*100, 2) Hinduism_ratio,
	ROUND(r.Buddhism/c.population*100, 2) Buddhism_ratio,
	ROUND(r.Folk_Religions/c.population*100, 2) Folk_Religions_ratio,
	ROUND(r.Other_Religions/c.population*100, 2) Other_Religions_ratio,
	ROUND(r.Judaism/c.population*100, 2) Judaism_ratio,
	c.population
FROM tmp_religion_table r
JOIN countries c
	ON c.country = r.country
),
life_expectancy_table AS (
SELECT a.country,
		a.iso3,
		round( b.life_exp_2015 - a.life_exp_1965, 2 ) as life_exp_diff
FROM (
    SELECT le.country , le.iso3, le.life_expectancy as life_exp_1965
    FROM life_expectancy le
    WHERE year = 1965
    	AND le.iso3 IS NOT NULL
    ) a
    JOIN (
    SELECT le.country , le.iso3 , le.life_expectancy as life_exp_2015
    FROM life_expectancy le
    WHERE year = 2015
    ) b
    ON a.country = b.country
),
eco_demo_table AS (
SELECT
	c.country ,
	c.iso3 ,
	c.population_density ,
	c.population ,
	c.median_age_2018,
	e.gini ,
	e.GDP ,
	e.mortaliy_under5
FROM countries c
JOIN economies e
	ON c.country = e.country
WHERE e.`year` = 2015
),
weather_table AS (
WITH temp AS (
SELECT
	CAST(`date` AS date) `date` ,
	city,
	ROUND(AVG(temp), 1) avg_daily_temp
FROM weather w WHERE `time` IN('00:00', '03:00') AND city IS NOT NULL
GROUP BY `date` , city
),
temp2 AS(
SELECT
	CAST(`date` AS date) `date` ,
	city,
	COUNT(*) * 3 rainy_hours
FROM weather w WHERE rain != 0 AND city IS NOT NULL
GROUP BY `date` , city
)
SELECT
	CAST(w.`date` AS date) `date` ,
	w.city,
	MAX(CAST(w.gust AS FLOAT)) gust_maximum,
	t.avg_daily_temp,
	COALESCE (t2.rainy_hours,0) rainy_hours
FROM weather w
LEFT JOIN temp t
	ON w.`date` = t.date
	AND w.city = t.city
LEFT JOIN temp2 t2
	ON w.`date` = t2.date
	AND w.city = t2.city
WHERE w.city IS NOT NULL
GROUP BY w.`date` , w.city
)
SELECT
	base.`date` ,
	base.country,
	IF(weekday(base.`date`) IN (5, 6), 1, 0) binar_weekend,
	CASE WHEN (MONTH(base.`date`) IN (1, 2) OR (MONTH (base.`date`) = 3 AND DAY (base.`date`) <20)
			OR (MONTH(base.`date`)=12 AND DAY(base.`date`)>= 21)) THEN 3
		WHEN (MONTH(base.`date`) IN (4, 5) OR (MONTH (base.`date`) = 3 AND DAY (base.`date`) >=20)
			OR (MONTH(base.`date`)=6 AND DAY(base.`date`)<= 20)) THEN 0
		WHEN (MONTH(base.`date`) IN (7, 8) OR (MONTH (base.`date`) = 6 AND DAY (base.`date`) >=21)
			OR (MONTH(base.`date`)=9 AND DAY(base.`date`)<= 22)) THEN 1
		WHEN (MONTH(base.`date`) IN (10, 11) OR (MONTH (base.`date`) = 9 AND DAY (base.`date`) >=23)
			OR (MONTH(base.`date`)=12 AND DAY(base.`date`)<= 20)) THEN 2
	END season, # (0 = spring, 1 = summer, 2 = fall, 3 = winter)
	base.confirmed ,
	i.index_conf_tested,
	i.conf_per_one_hundred_thousand,
	i.tested_per_one_hundred_thousand,
	i.daily_percent_conf_test,
	r.Christianity,
	r.Christianity_ratio,
	r.Buddhism,
	r.Buddhism_ratio,
	r.Hinduism,
	r.Hinduism_ratio,
	r.Judaism,
	r.Judaism_ratio,
	r.Islam,
	r.Islam_ratio,
	r.Unaffiliated_Religions,
	r.Unaffiliated_Religions_ratio,
	r.Folk_Religions,
	r.Folk_Religions_ratio,
	r.Other_Religions,
	r.Other_Religions_ratio,
	le.life_exp_diff,
	ed.population_density,
	ed.median_age_2018,
	ed.gini ,
	ed.GDP ,
	ed.mortaliy_under5,
	wt.gust_maximum,
	wt.avg_daily_temp,
	wt.rainy_hours
FROM covid19_basic_differences base
JOIN lookup_table lt
	ON base.country = lt.country
LEFT JOIN countries c
	ON lt.iso3 = c.iso3
LEFT JOIN index_table i
	ON lt.iso3 = i.iso3
	AND base.`date` = i.date
LEFT JOIN religion_table r
	ON lt.iso3 = r.iso3
LEFT JOIN life_expectancy_table le
	ON lt.iso3 = le.iso3
LEFT JOIN eco_demo_table ed
	ON lt.iso3 = ed.iso3
LEFT JOIN weather_table wt
	ON base.`date` = wt.date
	AND c.capital_city = wt.city
WHERE lt.province IS NULL
ORDER BY base.`date` , base.country
