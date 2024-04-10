2.a--
drop table Call_logs;
drop table Sim;
drop table Plan;
drop table Customer;

create table Customer
(
    c_id    varchar(20),
    name    varchar(50),
    dob     timestamp,
    address varchar(100),

    primary key(c_id)
);

create table Plan
(
    p_id            int,
    name            varchar(20),
    charge_per_min  number,

    primary key(p_id)
);

create table Sim
(
    mob_no varchar(11) unique,
    c_id   varchar(20),
    p_id   int,

    primary key(mob_no), 
    constraint fk_sim_customer foreign key (c_id) references Customer(c_id),
    constraint fk_sim_plan foreign key (p_id) references Plan(p_id)
);

create table Call_logs
(
    call_id    int,
    cl_from    varchar(11),
    cl_begin   timestamp,
    cl_end     timestamp,

    primary key(call_id),
    constraint fk_calllogs_sim foreign key (cl_from) references Sim(mob_no)
);


2.b--
create or replace function
Calculate_Charge (mbl_no varchar(11), begin timestamp, end timestamp)
return number
As
    charge Plan.charge_per_min%type;
    duration number;
    rnd_duration number;
begin
    select charge_per_min into charge
    from Sim natural join Plan
    where mob_no=mbl_no;

    duration:=(end - begin)/60;
    rnd_duration:=round(duration);

    if duration > rnd_duration then
       duration:=round(duration)+1;
    end if;

    charge:=charge*duration;
    return charge;
end;


2.c--
create or replace function
Generate_ID
return varchar
As
    maxID varchar(20);
    gen_date varchar(20);
    gen_num varchar(20);
begin
    select c_id into maxID
    from CUSTOMER
    where ROWNUM<=1;
    gen_date:=TO_CHAR(sysdate, 'yyyymmdd');
    if(maxID = null) then
      return gen_date||'.00000001';
    end if;
    
    gen_num:=to_number(substr(maxid,10,8))+1;
    return gen_date||'.'||to_char(LPAD(gen_num,8,'0'));
end;


CREATE OR REPLACE
TRIGGER new_c_id
before INSERT ON Customer
FOR EACH ROW
declare
    new_id Customer.c_id%type;
BEGIN
    new_id:=Generate_ID();
    :new.c_id:=new_id;
END ;


3--
create table student
(
    id   int primary key,
    name varchar(20),
    year varchar(20),
    program varchar(20),
    cgpa number
);

create table transaction
(
    id   int,
    time date,
    paid_amount number,

    foreign key (id) references student (id)
);

create table misconducts
(
    id          int,
    time        date,
    description varchar(100),

    foreign key (id) references student(id)
);


create or replace function
Total_scholarships(Ms_Amount number, PerSt_Amount number)
return varchar
As
    count number default 0;
    MSAmount number;
    idcount number;
  cursor c is
    select ID
    from student
    where student.program=4 and student.year=20 and cgpa>=3.5
    minus (select id from misconducts);
begin
    MSAmount:=Ms_Amount;
    select count(id) into idcount
    from student
    where student.program=4 and student.year=20 and cgpa>=3.5
    minus(select id from misconducts);

    for rows in c loop
     MSAmount:=MSAmount-PerSt_Amount;
     count:=count+1;
     exit when MSAmount<=0;
    end loop;
 return to_char(idcount-count)||to_char(count);
end;



