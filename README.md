# SQL_covid_project

This project consists of 5 'pre-tables' and 1 final SELECT. The key element in the final SELECT consists in the basic join of the table covid19_basic_differences which contains different names for some states (e.g. Czechia, US) compare to other tables. It was done via country, iso3 and ISO columns. However it wasn't possible to do it in case of weather table and I describe it later. Covid19_basic_differences was chosen as a base table regarding number of countries and dates.

So, the first one - index_table - contains the main explanatory variable which is expected to be "index_conf_tested" (comment for the lector: I'm not sure how the formula should be written - direct or inverse proportion...?)
Besides that there was another problematic place: in case of double value at column covid19_tests.entity the solution is at clause WHERE and condition "b.entity !=... ". Condition "b.entity !=..." is possible to replace with aggregate function MAX(b.test_performed) and with clause GROUP BY base.country but it is really slow so I decided to choose the first option.

The second table is the religion table. There was a problem which could result in more rows (eight times) because the number of different religions is 8. So I pivoted each religion row in column as well as religion_ratio. (comments for the lector: the solution might be a bit complicated but I hope it works). In terms of religion_table I choose the year 2010 because "population" column in "countries" table was counted before 2020 - some percentage calculation (religion_ratio) returned over 100%.

The third life_expectancy table: there was nothing special about this table, everything was clear.

The fourth eco_demo table: I chose year 2015 because this year isn't too far from present time and simultaneously the economies table has in 2015 one of the highest number of values. 




