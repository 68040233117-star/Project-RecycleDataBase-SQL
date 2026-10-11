select * from Employees
select * from Categories
select * from Materials
select * from Sellers
select * from Purchases
select * from PurchaseDetails

--Test--
--ข้อ 1.แสดงรหัสบิล วันที่รับซื้อ ชื่อลูกค้าที่ และยอดเงินรวม เฉพาะบิลของ Jimmy
select 
	p.PurchaseID,
	p.PurchaseDate,
	s.SellerName,
	p.TotalAmount
from Purchases as p
		join Sellers as s on p.SellerID = s.SellerID
where s.SellerName = 'Jimmy'
order by p.TotalAmount


--ข้อ 2.แสดงชื่อพนักงาน นามสกุล และผลรวมยอดเงินบิลทั้งหมดที่พนักงานคนนั้นเป็นคนรับซื้อ
select 
    e.FirstName,
    e.LastName,
    sum(p.TotalAmount) as TotalSpent
from Employees as e
        join Purchases as p on e.EmployeeID = p.EmployeeID
group by
    e.FirstName, 
    e.LastName


--ข้อ 3.แสดงชื่อหมวดหมู่ ผลรวมน้ำหนักทั้งหมด และผลรวมเงินที่จ่ายไปแต่ละรายการ เฉพาะหมวดหมู่ paper
select 
    c.CategoryName, 
    sum(pd.[Weight]) as TotalWeight, 
    sum(pd.SubTotal) as TotalSpent
from Categories as c
    join Materials as m on c.CategoryID = m.CategoryID
    join PurchaseDetails as pd on m.MaterialsID = pd.MaterialsID
where c.CategoryName = 'Paper'
group by c.CategoryName