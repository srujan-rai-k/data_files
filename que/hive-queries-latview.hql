create table stugrades (stuname string, stuid int, stuexam string, stumarks array<int>) row format delimited fields terminated by '\t' collection items terminated by '|' lines terminated by '\n';

set hive.cli.print.header=true;

DESCRIBE stugrades;

load data local inpath '/home/<your_login_id>/latviewtestdata.txt' into table stugrades;

select explode(stumarks) from stugrades;

select stuid, stuname, stuexam, explode(stumarks) from stugrades; -- Does not work

select stuid, stuname, stuexam, indvmarks from stugrades
LATERAL VIEW explode(stumarks) markstbl AS indvmarks;

select stuid, stuname, stuexam, markstbl.indvmarks from stugrades
LATERAL VIEW explode(stumarks) markstbl AS indvmarks;

select stuid, stuname, stuexam, markstbl.indvmarks from stugrades
LATERAL VIEW explode(stumarks) markstbl AS indvmarks order by stuexam, stuname;

select stuname, stuexam, max(markstbl.indvmarks) from stugrades
LATERAL VIEW explode(stumarks) markstbl AS indvmarks GROUP BY stuname, stuexam;

select stuname, stuexam, min(markstbl.indvmarks) from stugrades
LATERAL VIEW explode(stumarks) markstbl AS indvmarks GROUP BY stuname, stuexam;

select stuname, stuexam, avg(markstbl.indvmarks) as average from stugrades
LATERAL VIEW explode(stumarks) markstbl AS indvmarks GROUP BY stuname, stuexam;

select stuname, stuexam, sum(markstbl.indvmarks) as totalmarks from stugrades
LATERAL VIEW explode(stumarks) markstbl AS indvmarks GROUP BY stuname, stuexam;
===============================================================================

CREATE EXTERNAL TABLE IF NOT EXISTS ssg1
(stuname string, stuid int, stuexam string, subjectmarks array<struct<subject: string, marks: int>>)
row format delimited fields terminated by '\t' collection items terminated by '|' MAP KEYS TERMINATED BY '#' lines terminated by '\n'
location '/user/<your-login-id>/ssg1';

load data local inpath '/home/<your_login_id>/studentsubjectsandgrades.txt' into table ssg1;

select * from ssg1;

select explode(subjectmarks) from ssg1;

SELECT
   stuname, stuid, stuexam,
   subject_and_marks as subandmarks
FROM 
   ssg1 
   LATERAL VIEW explode(subjectmarks) exploded_table as subject_and_marks;

SELECT
   stuname, stuid, stuexam,
   subject_and_marks.subject as subject,
   subject_and_marks.marks as marks
FROM 
   ssg1 
   LATERAL VIEW explode(subjectmarks) exploded_table as subject_and_marks;

SELECT
   stuname, stuid, stuexam,
   exploded_table.subject_and_marks.subject as subject,
   exploded_table.subject_and_marks.marks as marks
FROM 
   ssg1 
   LATERAL VIEW explode(subjectmarks) exploded_table as subject_and_marks;


========================
Default field delimiters:
------------------------

CREATE EXTERNAL TABLE IF NOT EXISTS ssg3
(stuname string, stuid int, stuexam string, subjectmarks array<struct<subject: string, marks: int>>)
row format delimited
location '/user/<your-login-id>/ssg3';

insert into ssg3 select * from ssg1;

SELECT
   stuname, stuid, stuexam,
   exploded_table.subject_and_marks.subject as subject,
   exploded_table.subject_and_marks.marks as marks
FROM 
   ssg3 
   LATERAL VIEW explode(subjectmarks) exploded_table as subject_and_marks;

$ hadoop fs -ls /user/bigdataboot1/
$ hadoop fs -ls /user/bigdataboot1/ssg3
$ hadoop fs -get /user/bigdataboot1/ssg3/000000_0
$ cat 000000_0
$ cat -vt 000000_0
