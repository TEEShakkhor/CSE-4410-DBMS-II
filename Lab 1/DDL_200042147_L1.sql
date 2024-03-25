create table Franchise(
    F_name varchar2(30),

    primary key (F_name)
);

create table Branch(
    B_id number,
    B_name varchar2(30),
    F_name varchar2(30),

    primary key (B_id),
    foreign key (F_name) references Franchise(F_name)
);

create table Customer(
    C_id number,
    C_name varchar2(30),

    primary key (C_id)
);


create table Menu(
    Menu_id number,
    Menu_name varchar2(30),
    
    primary key (Menu_id)
);


create or replace type ingredient as VARRAY (20) of VARCHAR2 (30) ;
create table Cuisine(
    Cuisine_id number,
    Cuisine_name varchar2(30),
    Menu_id number,
    main_ingredients ingredient,
    calorie int,
    price int,

    primary key (Cuisine_id),
    foreign key (Menu_id) references Menu(Menu_id)
);

create table Chef(
    Chef_id number,
    B_id number,
    Cuisine_id number,

    primary key (Chef_id),
    foreign key (B_id) references Branch(B_id),
    foreign key (Cuisine_id) references Cuisine(Cuisine_id)
);

create table Ratings(
    C_id number,
    Cuisine_id number,
    F_name varchar2(30),
    Menu_id number,
    rating number,

    primary key (C_id,Cuisine_id,F_name,Menu_id),
    foreign key (C_id) references Customer(C_id),
    foreign key (Cuisine_id) references Cuisine(Cuisine_id),
    foreign key (Menu_id) references Menu(Menu_id),
    foreign key (F_name) references Franchise(F_name)

);


create table Preffered_Cuisine(
    C_id number,
    Cuisine_id number,

    primary key (C_id,Cuisine_id),
    foreign key (C_id) references Customer(C_id),
    foreign key (Cuisine_id) references Cuisine(Cuisine_id)
);


create table Order(
    Order_id number,
    C_id number,
    Menu_id number,
    Cuisine_id number,
    F_name varchar2(30),

    primary key (Order_id),
    foreign key (C_id) references Customer(C_id),
    foreign key (Cuisine_id) references Cuisine(Cuisine_id),
    foreign key (Menu_id) references Menu(Menu_id),
    foreign key (F_name) references Franchise(F_name)
);

CREATE SEQUENCE Number_of_menu_SQ
MINVALUE 1
MAXVALUE 5
START WITH 1
INCREMENT BY 1
CACHE 5;

CREATE OR REPLACE
TRIGGER Number_of_menu_TRG
BEFORE INSERT ON Chef_Menu
FOR EACH ROW
BEGIN
    :NEW.Number_of_menu := Number_of_menu_SQ . NEXTVAL ;
END ;
/
create table Chef_Menu(
    Chef_id number,
    Menu_id number,
    Number_of_menu int not null check (Number_of_menu <= 5),

    primary key (Chef_id,Menu_id),
    foreign key (Chef_id) references Chef(Chef_id),
    foreign key (Menu_id) references Menu(Menu_id)
);

create table Customer_Franchise(
    C_id number,
    F_name varchar2(30)

    primary key (C_id,F_name),
    foreign key (F_name) references Franchise(F_name),
    foreign key (C_id) references Customer(C_id)
);

create table Franchise_Menu(
    F_name varchar2(30),
    Menu_id varchar2(30),
    

    primary key (F_name,Menu_id),
    foreign key (F_name) references Franchise(F_name),
    foreign key (Menu_id) references Menu(Menu_id)
);


