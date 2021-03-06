# SQL_covid_project 

This project consists of 5 'pre-tables' and 1 final SELECT. The key element in the final SELECT consists in the basic join of the table "covid19_basic_differences" which contains different names for some states (e.g. Czechia, US) with tables "countries" and "lookup_table". It was done via country, iso3 and ISO columns. However it wasn't possible to do it in case of weather table and I describe it later. Covid19_basic_differences was chosen as a base table regarding number of countries (189) plus cruise ship Diamond Princess and dates (from 2020-01-22). So every day and every state has its values "date", "confirmed", "binar_weekend" and "season". Other variables were joined according to their occurrences. And other tables were joined via LEFT JOIN.

So, the first one - index_table - contains the main explanatory variable which is expected to be "index_conf_tested". This explanatory variable consists of three values - tests_performed, confirmed and population. (comment for the lector: I'm not sure how the formula should be written - direct or inverse proportion...?) 
Besides that there was another problematic place: in case of double value at column covid19_tests.entity the solution is at clause WHERE and condition "b.entity !=... ". Condition "b.entity !=..." could be replaced with aggregate function MAX(b.test_performed) and with clause GROUP BY base.country but it is really slow so I decided to choose the first option.

![Project_index_table_png](https://user-images.githubusercontent.com/75171974/122763210-5f45ae80-d29e-11eb-976a-add25115f5ba.png)

The second table is the religion table. There was a problem which could result in more rows (eight times) because the number of different religions is 8. So I pivoted each religion row in column as well as religion_ratio. (comments for the lector: the solution might be a bit complicated but I hope it works). In terms of religion_table I choose the year 2010 because "population" column in "countries" table was counted before 2020 - some percentage calculation (religion_ratio) returned over 100%.

![Project_religion_table](https://user-images.githubusercontent.com/75171974/122786499-a9d22580-d2b4-11eb-80a5-cab8d6deef12.png)

The third life_expectancy table: there was nothing special about this table, everything was clear.

The fourth eco_demo table: I chose year 2015 because this year isn't too far from present time and simultaneously the economies table has in 2015 one of the highest number of values. 

![Project_lf_eco](https://user-images.githubusercontent.com/75171974/122787935-1f8ac100-d2b6-11eb-862d-461b4adb4b12.png)

The last weather_table was the most problematic. Firstly, because of this table I had to use IGNORE command at the beginning of the script. Common SELECT returned table without any problem but when I tried to create table there was a mistake: "truncated incorrect double value". Many times I tried to use CAST order but every time I got "truncated incorrect double value" and I wasn't able to fix it. Secondly, it was unclear how to count "average daily temperature" - it wasn't possible to use so-called "Mannheim's clock" (T(7) + T(14) + 2T(21))/4 so I counted average temperature from values at 6, 9, 12, 15, 18 and 21 hours. Last but not least there was unable to join this table with others via country or iso3 or ISO columns so the only possibility I found was connection via "city" (weather) and "capital_city" (countries). For this reason the number of countries with counted these values is rather restricted.

Regarding column "season": I noticed too late that it was possible to use table "seasons" from engeto_databaze2 but I had created my own algorithm before.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

V??sledn?? k??d se skl??d?? z 5 tabulek vytvo??en??ch pomoc?? klauzule WITH a jednoho fin??ln??ho SELECTu. Kl????ov?? prvek pro fin??ln?? SELECT spo????v?? v propojen?? tabulek covid19_basic_differences, kter?? obsahuje odli??n?? n??zvy n??kter??ch zem?? (Czechia, US) s tabulkami lookup_table (Czechia, US) a countries (Czech Republic, United States) plus s tabulkou "covid19_tests". Toho bylo dosa??eno pomoc?? prom??nn??ch country, iso3 a ISO. V p????pad?? tabulky "weather" toto mo??n?? nebylo, ??e??en?? popisuji n????e. Jako z??kladn?? tabulku jsem tedy zvolil covid19_basic_differences, co?? umo??nilo m??t v??slednou tabulku se 189 st??ty + v??letn?? lod?? Diamond Princess pro ka??d?? den (od 22.1.2020). Ka??d?? den a ka??d?? st??t tedy obsahuje prom??nn?? "date", "confirmed", "binar_weekend" a "season". Ostatn?? prom??nn?? jsou k jednotliv??m dn??m a st??t??m p??ipojov??ny a?? u?? jsou k dispozici ??i nikoli. V??echny dal???? tabulky byly k t?? z??kladn?? postupn?? p??ipojov??ny p??es LEFT JOIN.

Prvn?? tabulka - index_table - obsahuje hlavn?? vysv??tluj??c?? prom??nnou "index_conf_tested", kter?? se skl??d?? ze t???? prom??nn??ch "tests_performed", "confirmed" a "population" (pozn. pro lektora: v??bec si nejsem jist?? vzorcem pro v??po??et t??to vysv??tluj??c?? prom??nn?? - zda m?? b??t pou??ita p????m?? ??i nep????m?? ??m??ra). Krom?? tohoto tam bylo je??t?? jedno problematick?? m??sto. Sloupec "covid19_tests.entity" obsahuje u n??kter??ch st??t?? dvoj?? hodnotu (zda se tam zapo????t??vaj?? ??i ne n??kter?? testy). ??e??en??m bylo naj??t v??echny dvoj?? hodnoty a vytvo??it v klauzuli WHERE podm??nky "b.entity !=..." kde se do t??to podm??nky zvolila v??dy men???? hodnota tak, aby byly zapo????t??ny v??echny testy. Vy?????? hodnota byla pro v??po??et zvolena z toho d??vodu, aby to odpov??dalo ostatn??m zem??m, kter?? druhy test?? nerozli??ovaly. Zkou??el jsem to vy??e??it i p??es agrega??n?? funkci MAX(b.test_performed) a GROUP BY country, co?? je ??ist???? ??e??en??, ale ??asov?? mnohem n??ro??n??j????.

![Project_index_table_png](https://user-images.githubusercontent.com/75171974/122763149-4c32de80-d29e-11eb-9751-2d7549d9b709.png)

Druh?? tabulka je o prom??nn?? "n??bo??enstv??". Tam byl probl??m s t??m, ??e by se n??m po??et ????dk?? zv??t??il osmi n??sobn??, proto bylo nutn?? p??epivotovat prom??nn?? "religion" a z??skanou prom??nnou "religion_ratio" do sloupc?? (pozn. pro lektora: uv??domuji si, ??e to ??e??en?? je asi trochu komplikovan??j????, ale m??lo by fungovat). Pro v??po??et "religion_ratio" jsem zvolil rok 2010, proto??e tato prom??nn?? byla po????t??na pomoc?? prom??nn?? "population" z tabulky "countries", kde musely b??t hodnoty d????ve ne?? v roce 2020 (co?? byl nejnov??j???? rok v tabulce "religion"). Pokud se tedy zvolilo popula??n?? ????slo z roku 2020, vych??zelo procentn?? zastoupen?? jednotliv??ch n??bo??enstv?? n??kdy i p??es 100% (pokud bylo v jedn?? zem?? dominantn?? pouze jedno n??bo??enstv??).

![Project_religion_table](https://user-images.githubusercontent.com/75171974/122786472-a343ae00-d2b4-11eb-9417-7888c80afe7a.png)

T??et?? tabulka byla life_expectancy, tam ????dn?? probl??m nebyl.

??tvrtou tabulkou bylo eco_demo: Z tabulky "economies" jsem vybral pro v??po??et rok 2015, proto??e je st??le bl??zko k sou??asnosti a z??rove?? obsahuje po??etn?? nejv??c hodnot.

![Project_lf_eco](https://user-images.githubusercontent.com/75171974/122787902-1699ef80-d2b6-11eb-8fc9-b76462aa5d6a.png)

Posledn?? tabulkou je weather_table, kter?? byla nejproblemati??t??j????. Za prv?? jsem musel ve v??sledn??m k??du pou????t p????kaz IGNORE, proto??e a??koli p??i b????n??m spu??t??n?? SELECT prob??hal v??po??et bez probl??m??, p??i pou??it?? CREATE TABLE to neust??le hl??silo "truncated incorrect double value". Samoz??ejm?? jsem se to sna??il googlit, pou????vat CAST na v??echny mo??n?? hodnoty (??lo hlavn?? o "temp"), ale ani po 3 dnech jsem nebyl schopen p??ij??t na jin?? ??e??en??, ne?? pou????t IGNORE - na co?? jsem p??i googlen?? narazil a?? ten t??et?? den :) A za druh?? nebylo ??pln?? jasn??, jak vypo????tat pr??m??rnou denn?? (nikoli no??n??) teplotu. Pou????t v??po??et podle tzv. mannheimsk??ch hodin (T(7) + T(14) + 2T(21))/4 nebylo mo??n??, tak??e jsem zvolil prost?? pr??m??r z hodnot mimo p??lnoc a t??et?? hodinu rann??. V neposledn?? ??ad?? tu nastal probl??m s p??ipojen??m t??to tabulky, ??lo to jen p??es "city" ve "weather" a "capital_city" v "countries". Z toho d??vodu je po??et st??t??, pro kter?? byly tyto hodnoty po????t??ny, pon??kud omezen.

Pokud jde o v??po??et hodnoty "season": ??lo pou????t tabulku "seasons", ale zjistil jsem to pozd??, tak jsem tam nechal vlastn?? algoritmus.

