# SQL_covid_project

This project consists of 5 'pre-tables' and 1 final SELECT. The key element in the final SELECT consists in the basic join of the table covid19_basic_differences which contains different names for some states (e.g. Czechia, US) compare to other tables. It was done via country, iso3 and ISO columns. However it wasn't possible to do it in case of weather table and I describe it later. Covid19_basic_differences was chosen as a base table regarding number of countries and dates.

So, the first one - index_table - contains the main explanatory variable which is expected to be "index_conf_tested". This explanatory variable consists of three values - tests_performed, confirmed and population. (comment for the lector: I'm not sure how the formula should be written - direct or inverse proportion...?) 
Besides that there was another problematic place: in case of double value at column covid19_tests.entity the solution is at clause WHERE and condition "b.entity !=... ". Condition "b.entity !=..." is possible to replace with aggregate function MAX(b.test_performed) and with clause GROUP BY base.country but it is really slow so I decided to choose the first option.

The second table is the religion table. There was a problem which could result in more rows (eight times) because the number of different religions is 8. So I pivoted each religion row in column as well as religion_ratio. (comments for the lector: the solution might be a bit complicated but I hope it works). In terms of religion_table I choose the year 2010 because "population" column in "countries" table was counted before 2020 - some percentage calculation (religion_ratio) returned over 100%.

The third life_expectancy table: there was nothing special about this table, everything was clear.

The fourth eco_demo table: I chose year 2015 because this year isn't too far from present time and simultaneously the economies table has in 2015 one of the highest number of values. 

The last weathe_table was the most problematic. Firstly, because of this table I had to use IGNORE command at the beginning of the script. Common SELECT returned table without any problem but when I tried to create table there was a mistake: "truncated incorrect double value". Many times I tried to use CAST order but every time I got "truncated incorrect double value" and I wasn't able to fix it. Secondly, it was unclear how to count "average daily temperature" - it wasn't possible to use so-called "Mannheim's clock" (T(7) + T(14) + 2T(21))/4 so I counted average temperature from values at 6, 9, 12, 15, 18 and 21 hours.

Regarding column "season": I noticed too late that it was possible to use table "seasons" from engeto_databaze2 so I had to create my own algorithm.

Finally I'd like to say that in the beginning it was really complicated task but in the end it helps me to be more oriented within SQL language and the structure of SQL querries.


