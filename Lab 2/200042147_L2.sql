1--
CREATE TABLESPACE tbs1
DATAFILE 'tbs1_data1.dbf' SIZE 1m,
'tbs1_data2.dbf' SIZE 1m;

CREATE TABLESPACE tbs2
DATAFILE 'tbs2_data1.dbf' SIZE 1m,
'tbs2_data2.dbf' SIZE 1m;

2--
ALTER USER s200042147 QUOTA 1m ON tbs1;

ALTER USER s200042147 QUOTA 1m ON tbs2;

3--
CREATE TABLE d_department
(d_name varchar2(20),
d_id number primary key)TABLESPACE tbs1;

CREATE TABLE s_student
(s_name varchar2(20),
s_id number primary key,
d_id number,
constraint fk foreign key(d_id) references d_department(d_id))TABLESPACE tbs1;

4--
CREATE TABLE c_course
(c_code number primary key,
c_name varchar2(20),
credit number,
offer_by number,
constraint fk1 foreign key(offer_by) references d_department(d_id))TABLESPACE tbs2;

5--

insert into d_department values('CSE', 1);
insert into d_department values('EEE', 2);
insert into d_department values('MPE', 3);

set serveroutput on size 1000000;

declare 
i number;
BEGIN
FOR i IN 1..200 LOOP
INSERT INTO s_student(s_name,s_id,d_id) VALUES('SHAKS', i, 1);
END LOOP;
END;
/


declare 
j number;
BEGIN
FOR J IN 1..200 LOOP
INSERT INTO c_course(c_code,c_name,credit,offer_by) VALUES(j, 'dbms', 3, 1);
END LOOP;
END;
/

6--

SELECT tablespace_name , bytes/1024/1024 MB
FROM dba_free_space
WHERE tablespace_name ='TBS1';

SELECT tablespace_name , bytes/1024/1024 MB
FROM dba_free_space
WHERE tablespace_name ='TBS2';

7--
ALTER TABLESPACE tbs1
ADD DATAFILE 'tbs1_data3.dbf' SIZE 1m;

8--
ALTER DATABASE
DATAFILE 'tbs2_data1.dbf' RESIZE 15m;

9--
SELECT tablespace_name, bytes/1024/1024 MB
FROM dba_data_files
WHERE tablespace_name ='TBS1' OR tablespace_name ='TBS2';

10--
DROP TABLESPACE TBS1
INCLUDING CONTENTS AND DATAFILES
CASCADE CONSTRAINTS;

11--
DROP TABLESPACE TBS2
INCLUDING CONTENTS KEEP DATAFILES
CASCADE CONSTRAINTS;


EXTRA TASK--
SELECT MAX(TABLE_NAME),TABLESPACE_NAME
FROM DBA_TABLES
GROUP BY TABLESPACE_NAME;

SELECT TABLE_NAME,TABLESPACE_NAME
FROM DBA_TABLES
GROUP BY TABLE_NAME='c_course';

