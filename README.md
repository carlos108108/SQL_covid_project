# SQL_covid_project 
(See below for the English version)


Výsledný kód se skládá z 5 tabulek vytvořených pomocí klauzule WITH a jednoho finálního SELECTu. Klíčový prvek pro finální SELECT spočívá v propojení tabulek covid19_basic_differences, která obsahuje odlišné názvy některých zemí (Czechia, US) s tabulkami lookup_table (Czechia, US) a countries (Czech Republic, United States) plus s tabulkou "covid19_tests". Toho bylo dosaženo pomocí proměnných country, iso3 a ISO. V případě tabulky "weather" toto možné nebylo, řešení popisuji níže. Jako základní tabulka jsem tedy zvolil covid19_basic_differences, což umožnilo mít výslednou tabulku se 190 státy pro každý den (od 22.1.2020). Každý den a každý stát tedy obsahuje proměnné "date", "confirmed", "binar_weekend" a "season". Ostatní proměnné jsou k jednotlivým dnům a státům připojovány ať už jsou k dispozici či nikoli. Všechny další tabulky byly k té základní postupně připojovány přes LEFT JOIN.

První tabulka - index_table - obsahuje hlavní vysvětlující proměnnou "index_conf_tested", která se skládá ze tří proměnných "tests_performed", "confirmed" a "population" (pozn. pro lektora: vůbec si nejsem jistý vzorcem pro výpočet této vysvětlující proměnné - zda má být použita přímá či nepřímá úměra). Kromě tohoto tam bylo ještě jedno problematické místo. Sloupec "covid19_tests.entity" obsahuje u některých států dvojí hodnotu (zda se tam započítávají či ne některé testy). Řešením bylo najít všechny dvojí hodnoty a vytvořit v klauzuli WHERE podmínky "b.entity !=..." kde se do této podmínky zvolila vždy menší hodnota tak, aby byly započítány všechny testy. Vyšší hodnota byla pro výpočet zvolena z toho důvodu, aby to odpovídalo ostatním zemím, které druhy testů nerozlišovaly. Zkoušel jsem to vyřešit i přes agregační funkci MAX(b.test_performed) a GROUP BY country, což je čistší řešení, ale časově mnohem náročnější.

Druhá tabulka je o proměnné "náboženství". Tam byl problém s tím, že by se nám počet řádků zvětšil osmi násobně, proto bylo nutné přepivotovat proměnné "religion" a získanou proměnnou "religion_ratio" do sloupců (pozn. pro lektora: uvědomuji si, že to řešení je asi trochu komplikovanější, ale mělo by fungovat). Pro výpočet "religion_ratio" jsem zvolil rok 2010, protože tato proměnná byla počítána pomocí proměnné "population" z tabulky "countries", kde musely být hodnoty dříve než v roce 2020 (což byl nejnovější rok v tabulce "religion"). Pokud se tedy zvolilo populační číslo z roku 2020, vycházelo procentní zastoupení jednotlivých náboženství někdy i přes 100% (pokud bylo v jedné zemí dominantní pouze jedno náboženství).

Třetí tabulka byla life_expectancy, tam žádný problém nebyl.

Čtvrtou tabulkou bylo eco_demo: Z tabulky "economies" jsem vybral pro výpočet rok 2015, protože je stále blízkou k současnosti a zároveň obsahuje početně nejvíc hodnot.

Poslední tabulkou je weather_table, která byla nejproblematičtější. Za prvé jsem musel ve výsledném kódu použít příkaz IGNORE, protože ačkoli při běžném spuštění SELECT probíhal výpočet bez problémů, při použití CREATE TABLE to neustále hlásilo "truncated incorrect double value". Samozřejmě jsem se to snažil googlit, použávat CAST na všechny možné hodnoty (šlo hlavně o "temp"), ale ani po 3 dnech jsem nebyl schopen přijít na jiné řešení, než použít IGNORE - na což jsem při googlení narazil až ten třetí den :) A za druhé nebylo úplně jasné, jak vypočítat průměrnou denní (nikoli noční) teplotu. Použít výpočet podle tzv. mannheimských hodin (T(7) + T(14) + 2T(21))/4 nebylo možné, takže jsem zvolil prostý průměr z hodnot mimo půlnoc a třetí hodinu ranní. V neposlední řadě tu nastal problém s připojeném této tabulky, šlo to jen přes "city" ve "weather" a "capital_city" v "countries". Z toho důvodu je počet států, pro které byly tyto hodnoty počítány, poněkud omezen.

Pokud jde o výpočet hodnoty "season": šlo použít tabulku "seasons", ale zjistil jsem to pozdě, tak jsem tam nechal vlastní algoritmus.

Závěrem bych chtěl říct, že ze začátku jsem dlouho nemohl přijít na princip, jak k výpočtu přistoupit, ale nakonec mi to pomohlo při pochopení stuktury a principů SQL dotazů, SQL syntaxe a hlavně alespoň částečnému porozumění spojování tabulek.


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



This project consists of 5 'pre-tables' and 1 final SELECT. The key element in the final SELECT consists in the basic join of the table "covid19_basic_differences" which contains different names for some states (e.g. Czechia, US) with tables "countries" and "lookup_table". It was done via country, iso3 and ISO columns. However it wasn't possible to do it in case of weather table and I describe it later. Covid19_basic_differences was chosen as a base table regarding number of countries (190) and dates (from 2020-01-22). So every day and every state has its values "date", "confirmed", "binar_weekend" and "season". Other variables were joined according to their occurrences. And other tables were joined via LEFT JOIN.

So, the first one - index_table - contains the main explanatory variable which is expected to be "index_conf_tested". This explanatory variable consists of three values - tests_performed, confirmed and population. (comment for the lector: I'm not sure how the formula should be written - direct or inverse proportion...?) 
Besides that there was another problematic place: in case of double value at column covid19_tests.entity the solution is at clause WHERE and condition "b.entity !=... ". Condition "b.entity !=..." could be replaced with aggregate function MAX(b.test_performed) and with clause GROUP BY base.country but it is really slow so I decided to choose the first option.

The second table is the religion table. There was a problem which could result in more rows (eight times) because the number of different religions is 8. So I pivoted each religion row in column as well as religion_ratio. (comments for the lector: the solution might be a bit complicated but I hope it works). In terms of religion_table I choose the year 2010 because "population" column in "countries" table was counted before 2020 - some percentage calculation (religion_ratio) returned over 100%.

The third life_expectancy table: there was nothing special about this table, everything was clear.

The fourth eco_demo table: I chose year 2015 because this year isn't too far from present time and simultaneously the economies table has in 2015 one of the highest number of values. 

The last weather_table was the most problematic. Firstly, because of this table I had to use IGNORE command at the beginning of the script. Common SELECT returned table without any problem but when I tried to create table there was a mistake: "truncated incorrect double value". Many times I tried to use CAST order but every time I got "truncated incorrect double value" and I wasn't able to fix it. Secondly, it was unclear how to count "average daily temperature" - it wasn't possible to use so-called "Mannheim's clock" (T(7) + T(14) + 2T(21))/4 so I counted average temperature from values at 6, 9, 12, 15, 18 and 21 hours. Last but not least there was unable to join this table with others via country or iso3 or ISO columns so the only possibility I found was connection via "city" (weather) and "capital_city" (countries). For this reason the number of countries with counted these values is rather restricted.

Regarding column "season": I noticed too late that it was possible to use table "seasons" from engeto_databaze2 but I had created my own algorithm before.

In conclusion, I'd like to say that in the beginning it was really complicated task but in the end it helps me to be more oriented within SQL language, to uderstand the structure of SQL querries and mainly to be slightly acquainted with JOIN command.


