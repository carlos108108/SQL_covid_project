# SQL_covid_project

This project consists of 5 'pre-tables' and 1 final SELECT. 

The first one - index_table - contains the main explanatory variable which is expected to be "index_conf_tested" (comment for the lector: I'm not sure how the formula should be written - direct or inverse proportion...?)
There were several problematic places: in case of double value at column covid19_tests.entity the solution is at clause WHERE and condition "b.entity !=... "
condition "b.entity !=..." is possible to replace with aggregate function MAX(b.test_performed) and with clause GROUP BY base.country but it is really slow
