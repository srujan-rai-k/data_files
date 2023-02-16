We can use Hive's builtin function json_tuple for parsing JSON format data alongwith LATERAL VIEW.
However this can be a little cumbersome as the JSON dataset gets complicated with nested JSONs and Arrays.
Hive now gives us the option of specifying that a file is in JSON format at the time of table creation and use JSON SerDe.
This option is a simpler approach to work with JSON data in Hive.
The following examples show how to use STORED AS JSONFILE which in turn uses JSON SerDe.
===========================================================================================================================

use <your-login-database>;
set hive.cli.print.current.db=true;
set hive.cli.print.header=true;

--------------------------------------------------------------
Using STORED AS JSONFILE in CREATE TABLE - Simple JSON dataset
--------------------------------------------------------------
Sample input record:
{"author": "Chinua Achebe", "country": "Nigeria", "imageLink": "images/things-fall-apart.jpg", "language": "English", "link": "https://en.wikipedia.org/wiki/Things_Fall_Apart\n", "pages": 209, "title": "Things Fall Apart", "year": 1958}

CREATE EXTERNAL TABLE json1(author string, country string, imageLink string, language string, link string, pages int, title string, year int) STORED AS JSONFILE location '/userbigdataboot1/json1';

-- The above syntax works with Hive 4.x and above. In the previous versions we need to specify the JsonSerDe library to be used in the create table statement as below.
-- Ref: https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL

-- Now to load data - From Linux prompt, put the file testdoc.json to the above HDFS directory (/user/<your login>/json1)
-- Or from Hive use "load data local inpath" command to load the above file into this table.
-- $ hadoop fs -put testdoc.json json1
-- hive> load data local inpath '<dir/subdir>/testdoc.json' into table json1;

select * from json1;
select author, title from json1;
========================================

show create table <tablename>;

The above gives the create table statement with complete syntax.
================================================================
