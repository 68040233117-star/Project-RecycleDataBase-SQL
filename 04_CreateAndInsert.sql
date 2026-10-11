-- 1. สลับไป master และบังคับตัดการเชื่อมต่อเพื่อลบฐานข้อมูลเดิมทิ้ง
USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'Recycle')
BEGIN
    ALTER DATABASE Recycle SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Recycle;
END
GO

-- 2. สร้างฐานข้อมูลใหม่
CREATE DATABASE Recycle;
GO

USE Recycle;
GO

-- 3. สร้างตาราง Employees
CREATE TABLE Employees (
    EmployeeID      INT             NOT NULL,
    FirstName       NVARCHAR(20)    NOT NULL,
    LastName        NVARCHAR(20)    NOT NULL,
    TitleOfCourtesy NVARCHAR(10)    NULL,
    Title           NVARCHAR(30)    NULL,
    BirthDate       DATETIME        NULL,
    HireDate        DATETIME        NULL,
    Country         NVARCHAR(15)    NULL,
    Phone           NVARCHAR(24)    NULL,
    CONSTRAINT PK_Employees PRIMARY KEY (EmployeeID)
);

-- ตาราง Categories
CREATE TABLE Categories (
    CategoryID      INT             NOT NULL,
    CategoryName    NVARCHAR(15)    NOT NULL,
    CONSTRAINT PK_Categories PRIMARY KEY (CategoryID)
);

-- ตาราง Sellers
CREATE TABLE Sellers (
    SellerID        INT             NOT NULL,
    SellerName      NVARCHAR(50)    NOT NULL,
    Phone           NVARCHAR(24)    NULL,
    CONSTRAINT PK_Sellers PRIMARY KEY (SellerID)
);

-- ตาราง Materials
CREATE TABLE Materials (
    MaterialsID         NVARCHAR(5)     NOT NULL,
    CategoryID          INT             NOT NULL,
    MaterialsName       NVARCHAR(20)    NOT NULL,
    Unit                NVARCHAR(10)    NOT NULL,
    CurrentPricePerUnit INT             NOT NULL,
    CONSTRAINT PK_Materials PRIMARY KEY (MaterialsID),
    CONSTRAINT FK_Materials_Categories FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    CONSTRAINT CHK_Materials_Price CHECK (CurrentPricePerUnit > 0)
);

-- ตาราง Purchases
CREATE TABLE Purchases (
    PurchaseID      INT             NOT NULL,
    SellerID        INT             NOT NULL,
    EmployeeID      INT             NOT NULL,
    PurchaseDate    DATETIME        NOT NULL,
    TotalAmount     INT             NOT NULL,
    CONSTRAINT PK_Purchases PRIMARY KEY (PurchaseID),
    CONSTRAINT FK_Purchases_Sellers FOREIGN KEY (SellerID) REFERENCES Sellers(SellerID),
    CONSTRAINT FK_Purchases_Employees FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    CONSTRAINT CHK_Purchases_TotalAmount CHECK (TotalAmount >= 0)
);

-- ตาราง PurchaseDetails
CREATE TABLE PurchaseDetails (
    PurchaseID      INT             NOT NULL,
    MaterialsID     NVARCHAR(5)     NOT NULL,
    [Weight]        DECIMAL(9, 2)   NOT NULL,
    PricePerUnit    INT             NOT NULL,
    SubTotal        INT             NOT NULL,
    CONSTRAINT PK_PurchaseDetails PRIMARY KEY (PurchaseID, MaterialsID),
    CONSTRAINT FK_PurchaseDetails_Purchases FOREIGN KEY (PurchaseID) REFERENCES Purchases(PurchaseID),
    CONSTRAINT FK_PurchaseDetails_Materials FOREIGN KEY (MaterialsID) REFERENCES Materials(MaterialsID),
    CONSTRAINT CHK_PurchaseDetails_Weight CHECK ([Weight] > 0),
    CONSTRAINT CHK_PurchaseDetails_Price CHECK (PricePerUnit > 0)
);
GO

-- 4. นำเข้าข้อมูล
INSERT INTO Employees (EmployeeID, FirstName, LastName, TitleOfCourtesy, Title, BirthDate, HireDate, Country, Phone)
VALUES
    (1, 'Karn', 'Upachai', 'Mr.', 'Manager', '1997-03-11', '2025-10-02', 'Thailand', '089-999-9867'),
    (2, 'First', 'Rojanathon', 'Mr.', 'Service', '1998-06-03', '2025-10-03', 'Thailand', '067-667-4567'),
    (3, 'Tevit', 'Kugimiya', 'Mr.', 'Service', '2000-08-11', '2025-10-08', 'Thailand', '093-225-2567'),
    (4, 'Nancy', 'Jostar', 'Mrs.', 'Service', '1987-08-24', '2025-11-03', 'England', '063-449-4967'),
    (5, 'Muhemmed', 'Porkshop', 'Mr.', 'Service', '1995-03-03', '2025-10-12', 'Egypt', '080-897-0967');

INSERT INTO Categories (CategoryID, CategoryName)
VALUES
    (1, 'Paper'),
    (2, 'Plastic'),
    (3, 'Metal'),
    (4, 'Glass');

INSERT INTO Materials (MaterialsID, CategoryID, MaterialsName, Unit, CurrentPricePerUnit)
VALUES
    ('001', 1, 'กระดาษลัง', 'กิโลกรัม', 4),
    ('002', 2, 'ขวดพลาสติกใส', 'กิโลกรัม', 12),
    ('003', 3, 'กระป๋องอลูมิเนียม', 'กิโลกรัม', 35),
    ('004', 3, 'เหล็กหนา', 'กิโลกรัม', 8),
    ('005', 1, 'กระดาษแผ่น', 'กิโลกรัม', 3),
    ('006', 4, 'ขวดแก้ว', 'กิโลกรัม', 2);

INSERT INTO Sellers (SellerID, SellerName, Phone)
VALUES
    (1, 'Jimmy', '+44 39-3678-4567'),
    (2, 'Mark Rober', '+44 20-1234-4567'),
    (3, 'คิม ไข่ใหญ่', '067-983-5670'),
    (4, 'ธนภูมิ ประทุมชัย', '093-357-5567'),
    (5, 'Elon Musk', '+44 34-3430-9592'),
    (6, 'ไหมไทย', '080-945-5532'),
    (7, 'เขียว', '099-345-5767');

INSERT INTO Purchases (PurchaseID, SellerID, EmployeeID, PurchaseDate, TotalAmount)
VALUES
    (1, 1, 1, '2026-01-01', 150),
    (2, 2, 1, '2026-01-04', 320),
    (3, 3, 2, '2026-01-11', 100),
    (4, 4, 2, '2026-03-05', 470),
    (5, 3, 5, '2026-09-17', 414),
    (6, 7, 3, '2026-09-29', 290),
    (7, 5, 3, '2026-02-02', 55),
    (8, 1, 5, '2026-07-30', 750),
    (9, 1, 2, '2026-04-11', 160),
    (10, 4, 5, '2026-06-28', 80),
    (11, 2, 5, '2026-02-03', 270),
    (12, 6, 2, '2026-03-25', 660),
    (13, 1, 3, '2026-12-28', 449),
    (14, 2, 5, '2026-01-13', 250),
    (15, 6, 3, '2026-01-06', 290),
    (16, 3, 4, '2026-12-16', 450);

INSERT INTO PurchaseDetails (PurchaseID, MaterialsID, [Weight], PricePerUnit, SubTotal)
VALUES
    (1, '003', 2.00, 35, 70),
    (1, '004', 10.00, 8, 80),
    (2, '002', 10.00, 12, 120),
    (2, '004', 25.00, 8, 200),
    (3, '001', 25.00, 4, 100),
    (4, '003', 10.00, 35, 350),
    (4, '002', 10.00, 12, 120),
    (5, '006', 17.00, 2, 34),
    (5, '004', 47.50, 8, 380),
    (6, '002', 10.00, 12, 120),
    (6, '003', 2.00, 35, 70),
    (6, '001', 25.00, 4, 100),
    (7, '003', 1.00, 35, 35),
    (7, '001', 5.00, 4, 20),
    (8, '004', 50.00, 8, 400),
    (8, '003', 10.00, 35, 350),
    (9, '004', 20.00, 8, 160),
    (10, '001', 20.00, 4, 80),
    (11, '003', 6.00, 35, 210),
    (11, '002', 5.00, 12, 60),
    (12, '002', 20.00, 12, 240),
    (12, '003', 12.00, 35, 420),
    (13, '003', 5.00, 35, 175),
    (13, '001', 68.50, 4, 274),
    (14, '002', 10.00, 12, 120),
    (14, '004', 16.25, 8, 130),
    (15, '004', 30.00, 8, 240),
    (15, '001', 12.50, 4, 50),
    (16, '003', 10.00, 35, 350),
    (16, '001', 25.00, 4, 100);
GO

select * from Employees
select * from Categories
select * from Materials
select * from Sellers
select * from Purchases
select * from PurchaseDetails