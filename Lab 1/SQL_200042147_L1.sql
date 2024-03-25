a--
select F_name, count(C_id) as TotalCustomers
from Customer_Franchise
group by F_name;

b--
select R.Cuisine_id, avg(R.rating) as AverageRating
from Ratings R,Franchise_Menu FM
where R.Menu_id = FM.Menu_id and R.F_name = FM.F_name
group by F_name;

c--
select Cuisine_id as Popular_Items
from(select Cuisine_id, count(Order_id)
    from Order
    group by Cuisine_id
    order by DESC)
where ROWNUM <=5;

d--

select A.C_name, A.FCounts
from(select c.C_name, count(m.F_name) as FCounts
    from Preffered_Cuisine p, Menu m, Customer c
    where p.C_id = c.C_id and p.Cuisine_id = m.Cuisine_id
    group by c.C_name
    ) A 
where a.FCounts>=2;

e--
select C_id, C_name
from Customer

MINUS

select c.C_id, c.C_name
from Customer c, Order o
where c.C_id = o.C_id;