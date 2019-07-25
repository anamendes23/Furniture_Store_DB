CREATE DATABASE VarkFinishedFurniture
GO

USE VarkFinishedFurniture
GO

/****** Object:  Schemas    Script Date: 3/6/2019 ******/

CREATE SCHEMA Sales
GO

CREATE SCHEMA ProductSupport
GO

CREATE SCHEMA RecordsLog
GO

/****** Object:  Table ProductSupport.Product    Script Date: 3/11/2019 4:37:52 PM ******/

CREATE TABLE ProductSupport.Products
(
	product_ID int IDENTITY(1,1) NOT NULL,
	product_name varchar(50) NOT NULL,
	product_price decimal(8, 2) NOT NULL,
	product_qty int NULL,
	product_reorderpoint int NULL,
	product_unitissue varChar(25) NULL,
	CONSTRAINT PK_product PRIMARY KEY (product_id)
)
GO

CREATE TABLE RecordsLog.ProductsHistory
(
	record_id int IDENTITY(1,1) NOT NULL,
	product_ID int NOT NULL,
	product_name varchar(50) NULL,
	product_price decimal(8, 2)) NULL,
	product_qty int NULL,
	product_reorderpoint int NULL,
	product_unitissue varChar(25) NULL,
	deleteTime datetime DEFAULT(GETDATE()) NOT NULL,
	CONSTRAINT PK_product PRIMARY KEY (record_id)
)
GO

/****** Object:  Table ProductSupport.Part    Script Date: 3/11/2019 4:36:28 PM ******/

CREATE TABLE ProductSupport.Parts
(
	part_id int IDENTITY(50,1) NOT NULL,
	part_name varchar(50) NOT NULL,
	part_description varchar(50) NULL,
	part_price decimal(8, 2) NULL,
	part_qty int NULL,
	part_reorderpoint int NULL,
	part_unitissue varChar(25) NULL,
	CONSTRAINT PK_part PRIMARY KEY (part_id)
)
GO

CREATE TABLE RecordsLog.PartsHistory
(
	record_id int IDENTITY(1,1) NOT NULL,
	part_id int NOT NULL,
	part_name varchar(50) NULL,
	part_description varchar(50) NULL,
	part_price decimal(8, 2) NULL,
	part_qty int NULL,
	part_reorderpoint int NULL,
	part_unitissue varChar(25) NULL,
	deleteTime datetime DEFAULT(GETDATE()) NOT NULL,
	CONSTRAINT PK_part PRIMARY KEY (record_id)
)
GO

/****** Object:  Table ProductSupport.Hardware    Script Date: 3/11/2019 4:32:22 PM ******/

CREATE TABLE ProductSupport.Hardware
(
	hardware_id int IDENTITY(100,1) NOT NULL,
	hardware_name varchar(50) NOT NULL,
	hardware_description varchar(100) NOT NULL,
	hardware_price decimal(8, 2) NULL,
	hardware_qty int NOT NULL,
	hardware_reorderpoint int NULL,
	hardware_unitissue varChar(25) NULL,
	CONSTRAINT PK_hardware PRIMARY KEY (hardware_id)
)
GO

CREATE TABLE RecordsLog.HardwareHistory
(
	record_id int IDENTITY(1,1) NOT NULL,
	hardware_id int NOT NULL,
	hardware_name varchar(50) NULL,
	hardware_description varchar(100) NULL,
	hardware_price decimal(8, 2) NULL,
	hardware_qty int NULL,
	hardware_reorderpoint int NULL,
	hardware_unitissue varChar(25) NULL,
	deleteTime datetime DEFAULT(GETDATE()) NOT NULL,
	CONSTRAINT PK_hardware PRIMARY KEY (record_id)
)
GO

/****** Object:  Table ProductSupport.Partlist    Script Date: 3/11/2019 4:40:24 PM ******/

CREATE TABLE ProductSupport.Partlist
(
	partlist_id int IDENTITY(1,1) NOT NULL,
	product_id int NULL,
	hardware_id int NULL,
	part_id int NULL,
	partlist_qty int NULL,
	hardwarelist_qty int NULL,
	CONSTRAINT PK_partlist PRIMARY KEY (partlist_id),
	CONSTRAINT FK_partlistHardware FOREIGN KEY (hardware_id) REFERENCES ProductSupport.Hardware(hardware_id),
	CONSTRAINT FK_partlistPart FOREIGN KEY (part_id) REFERENCES ProductSupport.Parts(part_id),
	CONSTRAINT FK_partlistProduct FOREIGN KEY (product_id) REFERENCES ProductSupport.Products(product_id)
)
GO

CREATE TABLE RecordsLog.PartlistHistory
(
	record_id int IDENTITY(1,1) NOT NULL,
	partlist_id int NOT NULL,
	product_id int NULL,
	hardware_id int NULL,
	part_id int NULL,
	partlist_qty int NULL,
	hardwarelist_qty int NULL,
	deleteTime datetime DEFAULT(GETDATE()) NOT NULL,
	CONSTRAINT PK_partlist PRIMARY KEY (record_id)
)
GO

/****** Object:  Table Sales.Departments    Script Date: 3/11/2019 ******/

--DEPARTMENTS TABLE
CREATE TABLE Sales.Departments
(
	department_id int IDENTITY(1, 1) NOT NULL,
	department_name varchar(20) NOT NULL,
	num_of_employees int NULL,
	manager_id int NULL,
	CONSTRAINT PK_departments PRIMARY KEY (department_id)
)
GO

CREATE TABLE RecordsLog.DepartmentsHistory
(
	record_id int IDENTITY(1,1) NOT NULL,
	department_id int NOT NULL,
	department_name varchar(20) NULL,
	num_of_employees int NULL,
	manager_id int NULL,
	deleteTime datetime DEFAULT(GETDATE()) NOT NULL,
	CONSTRAINT PK_departments PRIMARY KEY (record_id)
)
GO

/****** Object:  Table Sales.Employees    Script Date: 3/11/2019 ******/

CREATE TABLE Sales.Employees
(
	employee_id int IDENTITY(100, 1) NOT NULL,
	first_name varchar(20) NOT NULL,
	last_name varchar(25) NOT NULL,
	email varchar(100) NOT NULL, 
	phone_num varchar(20) DEFAULT NULL,
	hire_date DATE NOT NULL,
	salary Decimal(8, 2) NOT NULL,
	manager_id int DEFAULT NULL,
	department_id int DEFAULT NULL,
	CONSTRAINT PK_employees PRIMARY KEY (employee_id),	
	CONSTRAINT FK_departmentidEmployee FOREIGN KEY (department_id) REFERENCES Sales.Departments(department_id),
	CONSTRAINT FK_manageridEmployee FOREIGN KEY (manager_id) REFERENCES Sales.Employees(employee_id)
)
GO

ALTER TABLE Sales.Departments
WITH CHECK ADD CONSTRAINT FK_departmentsManagerid FOREIGN KEY(manager_id)
REFERENCES Sales.Employees (employee_id)
GO

CREATE TABLE RecordsLog.EmployeesHistory
(
	record_id int IDENTITY(1,1) NOT NULL,
	employee_id int NOT NULL,
	first_name varchar(20) NULL,
	last_name varchar(20) NULL,
	email varchar(100) NOT NULL, 
	phone_num varchar(20) NULL,
	hire_date DATE NULL,
	salary Decimal(8, 2) NULL,
	manager_id int NULL,
	department_id int NULL,
	deleteTime datetime DEFAULT(GETDATE()) NOT NULL,
	CONSTRAINT PK_employees PRIMARY KEY (record_id)
)
GO

/****** Object:  Table Sales.Orders    Script Date: 3/6/2019 ******/

CREATE TABLE Sales.Orders
(
	order_id int IDENTITY(1,1) NOT NULL,
	order_date datetime DEFAULT(GETDATE()) NOT NULL,
	employee_id int NULL,
	CONSTRAINT PK_orders PRIMARY KEY (order_id),
	CONSTRAINT FK_employeeidOrders FOREIGN KEY (employee_id) REFERENCES Sales.Employees(employee_id)
)
GO

CREATE TABLE RecordsLog.OrdersHistory
(
	record_id int IDENTITY(1,1) NOT NULL,
	order_id int NOT NULL,
	order_date datetime NULL,
	employee_id int NULL,
	deleteTime datetime DEFAULT(GETDATE()) NOT NULL,
	CONSTRAINT PK_deletedOrders PRIMARY KEY (record_id)
)
GO

/****** Object:  Table Sales.Discounts    Script Date: 3/6/2019 ******/

CREATE TABLE Sales.Discounts
(
	discount_id int IDENTITY(1,1) NOT NULL,
	disc_description varchar(50) NOT NULL,
	amount decimal(4, 2) NOT NULL
	CONSTRAINT PK_discounts PRIMARY KEY (discount_id)
)
GO

CREATE TABLE RecordsLog.DiscountsHistory
(
	record_id int IDENTITY(1,1) NOT NULL,
	discount_id int NOT NULL,
	disc_description varchar(50) NULL,
	amount decimal(4, 2) NULL,
	deleteTime datetime DEFAULT(GETDATE()) NOT NULL,
	CONSTRAINT PK_deletedDiscount PRIMARY KEY (record_id)
)
GO

/****** Object:  Table Sales.OrderDetails    Script Date: 3/6/2019 ******/

CREATE TABLE Sales.OrderDetails
(
	item_id int IDENTITY(1,1) NOT NULL,
	order_id int NOT NULL,
	product_id int NOT NULL,
	quantity int NOT NULL,
	list_price decimal(10, 2) NOT NULL,
	discount_id int NULL,
	CONSTRAINT PK_orderDetails PRIMARY KEY (item_id), 
	CONSTRAINT FK_orderidOrderdetails FOREIGN KEY (order_id) REFERENCES Sales.Orders(order_id),
	CONSTRAINT FK_productidOrderdetails FOREIGN KEY (product_id) REFERENCES ProductSupport.Products(product_id),
	CONSTRAINT FK_discountidOrderdetails FOREIGN KEY (discount_id) REFERENCES Sales.Discounts(discount_id)
)
GO

CREATE TABLE RecordsLog.OrderDetailsHistory
(
	record_id int IDENTITY(1,1) NOT NULL,
	item_id int NOT NULL,
	order_id int NOT NULL,	
	product_id int NULL,
	quantity int NULL,
	list_price decimal(10, 2) NULL,
	discount_id int NULL,
	deleteTime datetime DEFAULT(GETDATE()) NOT NULL,
	CONSTRAINT PK_deletedOrderDetails PRIMARY KEY (record_id)
)
GO

--Create Views for customers

--View of Products table
CREATE VIEW ProductsView AS
SELECT product_ID, product_name, product_qty, product_price
FROM ProductSupport.Products
GO

--View of Hardware table
CREATE VIEW HardwareView AS
SELECT hardware_id, hardware_name, hardware_qty, hardware_price, hardware_description
FROM ProductSupport.Hardware
GO

--View of Partlists table
CREATE VIEW PartsView AS
SELECT part_id, part_name, part_qty, part_price, part_description
FROM ProductSupport.Parts
GO