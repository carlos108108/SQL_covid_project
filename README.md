# SQL_covid_project

This project consists of 5 'pre-tables' and 1 final SELECT. 

The first one - index_table - contains the main explanatory variable which is expected to be "index_conf_tested" (comment for the lector: I'm not sure how the formula should be written - direct or inverse proportion...?)
Besides that there was another problematic place: in case of double value at column covid19_tests.entity the solution is at clause WHERE and condition "b.entity !=... ". Condition "b.entity !=..." is possible to replace with aggregate function MAX(b.test_performed) and with clause GROUP BY base.country but it is really slow so I decided to choose the first option.

The second table is the religion table. There was a problem which could result in more rows (eight times) because the number of different religions is 8. So I pivoted each religion row in column as well as religion_ratio. (comments for the lector: the whole operation might be a bit complicated but it runs). In terms of religion_table I choose the year 2010 because "population" column in "countries" table was counted before 2020 - some percentage calculation (religion_ratio) gave over 100%.
