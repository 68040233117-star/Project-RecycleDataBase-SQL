--สร้าง DataBase Recycle
Create Database Recycle

--สร้างตาราง Employees
Create Table Employees(
	EmployeeID int Primary Key,
	FirstName nvarchar(20) not null,
	LastName nvarchar(20) not null,
	TitleOfCourtesy nvarchar(10),
	Title nvarchar(30),
	BrithDate datetime,
	HireDate datetime,
	Country nvarchar(15),
	Phone nvarchar(24)
)


--สร้างตาราง Categories
Create Table Categories(
	CategoryID int Primary Key,
	CategoryName nvarchar(15) not null
)


--สร้างตาราง Materials
Create Table Materials(
	MaterialsID nvarchar(5) Primary Key,
	CategoryID int not null REFERENCES Categories(CategoryID),
	MaterialsName nvarchar(20) not null,
	Unit nvarchar(10) not null,
	CurrentPricePerUnit int not null
)


--สร้างตาราง Sellers
Create Table Sellers(
	SellerID int Primary Key,
	SellerName nvarchar(50) not null,
	Phone nvarchar(24)
)


--สร้างตาราง Purchases
Create Table Purchases (
    PurchaseID int Primary Key,
    SellerID int not null References Sellers(SellerID),
    EmployeeID int not null References Employees(EmployeeID),
    PurchaseDate datetime not null,
    TotalAmount int not null
)


--สร้างตาราง PurchaseDetails
Create Table PurchaseDetails (
    PurchaseID int not null,
    MaterialsID nvarchar(5) not null,
    [Weight] decimal(9,2) not null,
    PricePerUnit int not null,
    SubTotal int not null,
    Primary Key (PurchaseID, MaterialsID),
    Foreign Key (PurchaseID) References Purchases(PurchaseID),
    Foreign Key (MaterialsID) References Materials(MaterialsID)
)


-------------------------------------------
