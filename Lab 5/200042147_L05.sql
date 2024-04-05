A --
CREATE SEQUENCE Serial_generation_seq
MINVALUE 10001
MAXVALUE 99999
START WITH 10001
INCREMENT BY 1
CACHE 20;

create or replace function
generate_accountID(name ACCOUNT.NAME%type,acc_code ACCOUNT.ACCCODE%type,opening_date ACCOUNT.OPENINGDATE%type)
return varchar
as
    account_id varchar(100);
    serial int;
begin
    SELECT Serial_generation_seq . NEXTVAL INTO serial
    FROM DUAL ;

    account_id:= acc_code||trim(both '/' from to_char(opening_date,'yyyy/mm/dd'))||'.'||substr(name,1,3)||'.'||serial;

    return account_id;
end;
/

B--
 drop table balance;
 drop table transaction;
 drop table account;
 drop table accountproperty;

 create table accountproperty(
 id int primary key ,
 name varchar(20),
 profitrate numeric(10,2),
 graceperiod int
 );

 create table account(
 id varchar(20) primary key,
 name varchar(50),
 acccode int,
 openingDate timestamp,
 lastdateinterest timestamp,
 foreign key (acccode) references accountproperty(id)
 );

 create table transaction(
 tid int primary key,
 accno varchar(20),
 amount numeric(10,2),
 transactionDate timestamp,
 foreign key (accno) references account(id)
 );


 create table balance(
 accno varchar(20) primary key ,
 principleamount numeric(10,4),
 profitamount numeric(10,4),
 foreign key (accno) references account(id)
 );

alter table account
drop column id cascade constraints;

alter table balance
drop column accno cascade constraints;

alter table transaction
drop column accno cascade constraints;

alter table account
add id varchar(100) primary key;

update table account
set id:=generate_accountID(name, acccode, openingdate);

alter table transaction
add accno varchar(100);

alter table transaction
add constraint fk_transaction foreign key (accno) references account(id);

alter table balance
add accno varchar(100) primary key;

alter table balance
add constraint fk_account foreign key (accno) references account(id);

C--
CREATE OR REPLACE
TRIGGER Assign_Account_ID
BEFORE INSERT ON account
FOR EACH ROW
DECLARE
    newid account.id%type;
BEGIN
    newid:=Assign_Account_ID(:new.name,:new.acccode,:new.openingdate);
    :new.id:=newid;
END ;
/

D--
CREATE OR REPLACE
TRIGGER New_Balance_Entry
AFTER INSERT ON account
FOR EACH ROW
BEGIN
    insert into balance values(:new.id,5000,0);
END ;
/

E--
CREATE OR REPLACE
TRIGGER Update_Principle_Amount
AFTER INSERT ON transaction
FOR EACH ROW
DECLARE
    amount transaction.amount%type;
    acc_id account.id%type;
BEGIN
    acc_id:=:new.accno;
    amount:=:new.amount;

    update balance
    set principleamount=principleamount+amount;
    where balance.accno=acc_id;

END ;
/