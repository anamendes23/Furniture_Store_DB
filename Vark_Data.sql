--**** INSERT DATA ****

/******* ProductSupport.Hardware        DATA	 	********/

SET IDENTITY_INSERT ProductSupport.Hardware ON
INSERT ProductSupport.Hardware ([Hardware_ID], [Hardware_Name], [Hardware_Description], [Hardware_Qty], [Hardware_Price], [Hardware_ReorderPoint], [Hardware_UnitIssue]) VALUES (101, N'screw', N'for table', 10, CAST(20 As Decimal(18,0)), 10, 'pkg25')
INSERT ProductSupport.Hardware ([Hardware_ID], [Hardware_Name], [Hardware_Description], [Hardware_Qty], [Hardware_Price], [Hardware_ReorderPoint], [Hardware_UnitIssue]) VALUES (102, N'bolts', N'for chairs', 176, CAST(25 As Decimal(18, 0)), 50, 'pkg50')
INSERT ProductSupport.Hardware ([Hardware_ID], [Hardware_Name], [Hardware_Description], [Hardware_Qty], [Hardware_Price], [Hardware_ReorderPoint], [Hardware_UnitIssue]) VALUES (103, N'washer', N'table for screws', 244, CAST(15 As Decimal(18, 0)), 50, 'pkg50')
INSERT ProductSupport.Hardware ([Hardware_ID], [Hardware_Name], [Hardware_Description], [Hardware_Qty], [Hardware_Price], [Hardware_ReorderPoint], [Hardware_UnitIssue]) VALUES (104, N'lug nuts', N'bed frame', 63, CAST(18 As Decimal(18,0)), 50, 'pkg10')
INSERT ProductSupport.Hardware ([Hardware_ID], [Hardware_Name], [Hardware_Description], [Hardware_Qty], [Hardware_Price], [Hardware_ReorderPoint], [Hardware_UnitIssue]) VALUES (105, N'surface bed rail', N'bed ', 153, CAST(50 As Decimal(18, 0)), 120, 'dozen')
INSERT ProductSupport.Hardware ([Hardware_ID], [Hardware_Name], [Hardware_Description], [Hardware_Qty], [Hardware_Price], [Hardware_ReorderPoint], [Hardware_UnitIssue]) VALUES (106, N'headboard and footboard', N'bed ', 21, CAST(12 As Decimal(18,0)), 10, 'pair')
INSERT ProductSupport.Hardware ([Hardware_ID], [Hardware_Name], [Hardware_Description], [Hardware_Qty], [Hardware_Price], [Hardware_ReorderPoint], [Hardware_UnitIssue]) VALUES (107, N'heavy duty and wright steel', N'bed cover frame', 148, CAST(10 AS Decimal(18,0)), 25,'ea')
INSERT ProductSupport.Hardware ([Hardware_ID], [Hardware_Name], [Hardware_Description], [Hardware_Qty], [Hardware_Price], [Hardware_ReorderPoint], [Hardware_UnitIssue]) VALUES (108, N'center bed rail', N'for bed hitches', 425, CAST(35 AS Decimal(18,0)), 50, 'pkg10')
INSERT ProductSupport.Hardware ([Hardware_ID], [Hardware_Name], [Hardware_Description], [Hardware_Qty], [Hardware_Price], [Hardware_ReorderPoint], [Hardware_UnitIssue]) VALUES (109, N'center bed rail ', N'wooden bed cover', 24, CAST(25 AS Decimal(18,0)), 20, 'pkg10')
INSERT ProductSupport.Hardware ([Hardware_ID], [Hardware_Name], [Hardware_Description], [Hardware_Qty], [Hardware_Price], [Hardware_ReorderPoint], [Hardware_UnitIssue]) VALUES (110, N'bed rail connection ', N'steel bed', 146, CAST(15 As Decimal(18, 0)), 50, 'pair')
SET IDENTITY_INSERT ProductSupport.Hardware OFF

/******* ProductSupport.Parts       DATA	 	********/

SET IDENTITY_INSERT ProductSupport.Parts ON
INSERT ProductSupport.Parts ([part_ID], [part_name], [part_description], [part_price], [part_qty], [part_reorderpoint], [part_unitissue]) VALUES (51, N'bed frame', N'Width 60 cm, Height 6 cm, Length 206 cm', CAST(100 AS Decimal(18, 0)), 20, 10 , 'ea')
INSERT ProductSupport.Parts ([part_ID], [part_name], [part_description], [part_price], [part_qty], [part_reorderpoint], [part_unitissue]) VALUES (52, N'underbed storage box', N' Width 21 cm, Height 10 cm, Length 75 cm', CAST(15 AS Decimal(18, 0)), 2, 1, 'ea')
INSERT ProductSupport.Parts ([part_ID], [part_name], [part_description], [part_price], [part_qty], [part_reorderpoint], [part_unitissue]) VALUES (53, N'bed legs', N'Width 310 cm, Height 84 cm, Length 65 cm', CAST(25 AS Decimal(18, 0)), 52, 20, 'pair')
INSERT ProductSupport.Parts ([part_ID], [part_name], [part_description], [part_price], [part_qty], [part_reorderpoint], [part_unitissue]) VALUES (54, N'bed frame cover', N'Width 175 cm, Height 24 cm, Length 85 cm', CAST(253 AS Decimal(18, 0)), 32, 12, 'ea')
INSERT ProductSupport.Parts ([part_ID], [part_name], [part_description], [part_price], [part_qty], [part_reorderpoint], [part_unitissue]) VALUES (55, N'bed frame with storage', N'Width 31 cm, Height 14 cm, Length 25 cm', CAST(214 AS Decimal(18, 0)), 12, 5, 'ea')
INSERT ProductSupport.Parts ([part_ID], [part_name], [part_description], [part_price], [part_qty], [part_reorderpoint], [part_unitissue]) VALUES (56, N'side table for frame', N'Width 71 cm, Height 243 cm, Length 35 cm', CAST(35 AS Decimal(18, 0)), 57, 25, 'ea')
INSERT ProductSupport.Parts ([part_ID], [part_name], [part_description], [part_price], [part_qty], [part_reorderpoint], [part_unitissue]) VALUES (57, N'fixture for headboard', N'Width 42 cm, Height 140 cm, Length 65 cm', CAST(32 AS Decimal(18, 0)), 100, 30, 'ea')
INSERT ProductSupport.Parts ([part_ID], [part_name], [part_description], [part_price], [part_qty], [part_reorderpoint], [part_unitissue]) VALUES (58, N'headboard', N'Width 51 cm, Height 121 cm, Length 185 cm', CAST(21 AS Decimal(18, 0)), 79, 20, 'ea')
SET IDENTITY_INSERT ProductSupport.Parts OFF

/******* ProductSupport.Products       DATA	 	********/

SET IDENTITY_INSERT ProductSupport.[Products] ON
INSERT ProductSupport.[Products] ([product_ID], [product_name], [product_price], [product_qty], [product_reorderpoint], [product_unitissue]) VALUES (2, N'Bedroom Sets', CAST(100 AS Decimal(10, 0)), 10, 5, 'ea')
INSERT ProductSupport.[Products] ([product_ID], [product_name], [product_price], [product_qty], [product_reorderpoint], [product_unitissue]) VALUES (3, N'HeadBoard & FootBoards', CAST(200 AS Decimal(10, 0)), 10, 5, 'pair')
INSERT ProductSupport.[Products] ([product_ID], [product_name], [product_price], [product_qty], [product_reorderpoint], [product_unitissue]) VALUES (4, N'Dressers', CAST(150 AS Decimal(10, 0)), 30, 12, 'ea')
INSERT ProductSupport.[Products] ([product_ID], [product_name], [product_price], [product_qty], [product_reorderpoint], [product_unitissue]) VALUES (5, N'Chests', CAST(230 AS Decimal(10, 0)), 60, 25, 'ea')
INSERT ProductSupport.[Products] ([product_ID], [product_name], [product_price], [product_qty], [product_reorderpoint], [product_unitissue]) VALUES (6, N'Nightstands', CAST(367 AS Decimal(10, 0)), 34, 14, 'pair')
INSERT ProductSupport.[Products] ([product_ID], [product_name], [product_price], [product_qty], [product_reorderpoint], [product_unitissue]) VALUES (7, N'Bedroom Benches', CAST(145 AS Decimal(10, 0)), 20, 5, 'ea')
INSERT ProductSupport.[Products] ([product_ID], [product_name], [product_price], [product_qty], [product_reorderpoint], [product_unitissue]) VALUES (8, N'Daybeds', CAST(165 AS Decimal(10, 0)), 56, 20, 'ea')
INSERT ProductSupport.[Products] ([product_ID], [product_name], [product_price], [product_qty], [product_reorderpoint], [product_unitissue]) VALUES (9, N'Bed Frames', CAST(179 AS Decimal(10, 0)), 78, 35, 'ea')
INSERT ProductSupport.[Products] ([product_ID], [product_name], [product_price], [product_qty], [product_reorderpoint], [product_unitissue]) VALUES (10, N'Vanities', CAST(68 AS Decimal(10, 0)), 12, 5, 'ea')
INSERT ProductSupport.[Products] ([product_ID], [product_name], [product_price], [product_qty], [product_reorderpoint], [product_unitissue]) VALUES (11, N'beds', CAST(78 AS Decimal(10, 0)), 62, 20, 'ea')
INSERT ProductSupport.[Products] ([product_ID], [product_name], [product_price], [product_qty], [product_reorderpoint], [product_unitissue]) VALUES (18, N'testing', CAST(69 AS Decimal(10, 0)), 18, 8, 'ea')
INSERT ProductSupport.[Products] ([product_ID], [product_name], [product_price], [product_qty], [product_reorderpoint], [product_unitissue]) VALUES (19, N'testing', CAST(10 AS Decimal(10, 0)), 10, 5, 'dozen')
INSERT ProductSupport.[Products] ([product_ID], [product_name], [product_price], [product_qty], [product_reorderpoint], [product_unitissue]) VALUES (20, N'not', CAST(1 AS Decimal(10, 0)), 5, 2, 'ea')
INSERT ProductSupport.[Products] ([product_ID], [product_name], [product_price], [product_qty], [product_reorderpoint], [product_unitissue]) VALUES (21, N'testinsert', CAST(10 AS Decimal(10, 0)), 10, 4, 'ea')
INSERT ProductSupport.[Products] ([product_ID], [product_name], [product_price], [product_qty], [product_reorderpoint], [product_unitissue]) VALUES (22, N'testinsert', CAST(10 AS Decimal(10, 0)), 10, 4, 'ea')
INSERT ProductSupport.[Products] ([product_ID], [product_name], [product_price], [product_qty], [product_reorderpoint], [product_unitissue]) VALUES (23, N'testinsert', CAST(10 AS Decimal(10, 0)), 10, 4, 'ea')
SET IDENTITY_INSERT ProductSupport.[Products] OFF

/******* ProductSupport.Partlist        DATA	 	********/

SET IDENTITY_INSERT ProductSupport.[Partlist] ON
INSERT ProductSupport.[Partlist] ([partlist_ID], [product_ID], [hardware_ID], [part_ID], [partlist_qty], [hardwarelist_qty]) VALUES (2, 2, 101, 51, 1, 10)
INSERT ProductSupport.[Partlist] ([partlist_ID], [product_ID], [hardware_ID], [part_ID], [partlist_qty], [hardwarelist_qty]) VALUES (3, 2, 102, 51, 2, 10)
INSERT ProductSupport.[Partlist] ([partlist_ID], [product_ID], [hardware_ID], [part_ID], [partlist_qty], [hardwarelist_qty]) VALUES (4, 2, 102, 53, 1, 10)
INSERT ProductSupport.[Partlist] ([partlist_ID], [product_ID], [hardware_ID], [part_ID], [partlist_qty], [hardwarelist_qty]) VALUES (5, 3, 101, 53, 4, NULL)
INSERT ProductSupport.[Partlist] ([partlist_ID], [product_ID], [hardware_ID], [part_ID], [partlist_qty], [hardwarelist_qty]) VALUES (6, 3, 110, 54, 15, NULL)
INSERT ProductSupport.[Partlist] ([partlist_ID], [product_ID], [hardware_ID], [part_ID], [partlist_qty], [hardwarelist_qty]) VALUES (8, 5, 102, 53, 5, NULL)
INSERT ProductSupport.[Partlist] ([partlist_ID], [product_ID], [hardware_ID], [part_ID], [partlist_qty], [hardwarelist_qty]) VALUES (9, 9, 104, 55, 9, NULL)
INSERT ProductSupport.[Partlist] ([partlist_ID], [product_ID], [hardware_ID], [part_ID], [partlist_qty], [hardwarelist_qty]) VALUES (12, 4, 104, 57, 5, NULL)
INSERT ProductSupport.[Partlist] ([partlist_ID], [product_ID], [hardware_ID], [part_ID], [partlist_qty], [hardwarelist_qty]) VALUES (13, 5, 105, 55, 5, NULL)
SET IDENTITY_INSERT ProductSupport.[Partlist] OFF

/******* Sales.Departments        DATA	 	********/

SET IDENTITY_INSERT Sales.Departments ON;
INSERT INTO Sales.Departments(department_id,department_name) VALUES (1,'Administration');
INSERT INTO Sales.Departments(department_id,department_name) VALUES (2,'Marketing');
INSERT INTO Sales.Departments(department_id,department_name) VALUES (3,'Purchasing');
INSERT INTO Sales.Departments(department_id,department_name) VALUES (4,'Human Resources');
INSERT INTO Sales.Departments(department_id,department_name) VALUES (5,'Shipping');
INSERT INTO Sales.Departments(department_id,department_name) VALUES (6,'IT');
INSERT INTO Sales.Departments(department_id,department_name) VALUES (7,'Public Relations');
INSERT INTO Sales.Departments(department_id,department_name) VALUES (8,'Sales');
INSERT INTO Sales.Departments(department_id,department_name) VALUES (9,'Executive');
INSERT INTO Sales.Departments(department_id,department_name) VALUES (10,'Finance');
INSERT INTO Sales.Departments(department_id,department_name) VALUES (11,'Accounting');
SET IDENTITY_INSERT Sales.Departments OFF;

/******* Sales.Employees      DATA	 	********/

SET IDENTITY_INSERT Sales.Employees ON;
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (100,'Steven','King','steven.king@sqltutorial.org','515.123.4567','1987-06-17',24000.00,NULL,9);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (101,'Neena','Kochhar','neena.kochhar@sqltutorial.org','515.123.4568','1989-09-21',17000.00,100,9);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (102,'Lex','De Haan','lex.de haan@sqltutorial.org','515.123.4569','1993-01-13',17000.00,100,9);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (103,'Alexander','Hunold','alexander.hunold@sqltutorial.org','590.423.4567','1990-01-03',9000.00,102,6);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (104,'Bruce','Ernst','bruce.ernst@sqltutorial.org','590.423.4568','1991-05-21',6000.00,103,6);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (105,'David','Austin','david.austin@sqltutorial.org','590.423.4569','1997-06-25',4800.00,103,6);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (106,'Valli','Pataballa','valli.pataballa@sqltutorial.org','590.423.4560','1998-02-05',4800.00,103,6);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (107,'Diana','Lorentz','diana.lorentz@sqltutorial.org','590.423.5567','1999-02-07',4200.00,103,6);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (108,'Nancy','Greenberg','nancy.greenberg@sqltutorial.org','515.124.4569','1994-08-17',12000.00,NULL,10);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (109,'Daniel','Faviet','daniel.faviet@sqltutorial.org','515.124.4169','1994-08-16',9000.00,108,10);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (110,'John','Chen','john.chen@sqltutorial.org','515.124.4269','1997-09-28',8200.00,108,10);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (111,'Ismael','Sciarra','ismael.sciarra@sqltutorial.org','515.124.4369','1997-09-30',7700.00,108,10);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (112,'Jose Manuel','Urman','jose manuel.urman@sqltutorial.org','515.124.4469','1998-03-07',7800.00,108,10);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (113,'Luis','Popp','luis.popp@sqltutorial.org','515.124.4567','1999-12-07',6900.00,108,10);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (114,'Den','Raphaely','den.raphaely@sqltutorial.org','515.127.4561','1994-12-07',11000.00,100,3);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (115,'Alexander','Khoo','alexander.khoo@sqltutorial.org','515.127.4562','1995-05-18',3100.00,114,3);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (116,'Shelli','Baida','shelli.baida@sqltutorial.org','515.127.4563','1997-12-24',2900.00,114,3);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (117,'Sigal','Tobias','sigal.tobias@sqltutorial.org','515.127.4564','1997-07-24',2800.00,114,3);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (118,'Guy','Himuro','guy.himuro@sqltutorial.org','515.127.4565','1998-11-15',2600.00,114,3);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (119,'Karen','Colmenares','karen.colmenares@sqltutorial.org','515.127.4566','1999-08-10',2500.00,114,3);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (120,'Matthew','Weiss','matthew.weiss@sqltutorial.org','650.123.1234','1996-07-18',8000.00,100,5);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (121,'Adam','Fripp','adam.fripp@sqltutorial.org','650.123.2234','1997-04-10',8200.00,100,5);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (122,'Payam','Kaufling','payam.kaufling@sqltutorial.org','650.123.3234','1995-05-01',7900.00,100,5);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (123,'Shanta','Vollman','shanta.vollman@sqltutorial.org','650.123.4234','1997-10-10',6500.00,100,5);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (126,'Irene','Mikkilineni','irene.mikkilineni@sqltutorial.org','650.124.1224','1998-09-28',2700.00,120,5);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (145,'John','Russell','john.russell@sqltutorial.org',NULL,'1996-10-01',14000.00,100,8);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (146,'Karen','Partners','karen.partners@sqltutorial.org',NULL,'1997-01-05',13500.00,100,8);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (176,'Jonathon','Taylor','jonathon.taylor@sqltutorial.org',NULL,'1998-03-24',8600.00,100,8);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (177,'Jack','Livingston','jack.livingston@sqltutorial.org',NULL,'1998-04-23',8400.00,100,8);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (178,'Kimberely','Grant','kimberely.grant@sqltutorial.org',NULL,'1999-05-24',7000.00,100,8);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (179,'Charles','Johnson','charles.johnson@sqltutorial.org',NULL,'2000-01-04',6200.00,100,8);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (192,'Sarah','Bell','sarah.bell@sqltutorial.org','650.501.1876','1996-02-04',4000.00,123,5);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (193,'Britney','Everett','britney.everett@sqltutorial.org','650.501.2876','1997-03-03',3900.00,123,5);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (200,'Jennifer','Whalen','jennifer.whalen@sqltutorial.org','515.123.4444','1987-09-17',4400.00,101,1);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (201,'Michael','Hartstein','michael.hartstein@sqltutorial.org','515.123.5555','1996-02-17',13000.00,100,2);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (202,'Pat','Fay','pat.fay@sqltutorial.org','603.123.6666','1997-08-17',6000.00,201,2);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (203,'Susan','Mavris','susan.mavris@sqltutorial.org','515.123.7777','1994-06-07',6500.00,101,4);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (204,'Hermann','Baer','hermann.baer@sqltutorial.org','515.123.8888','1994-06-07',10000.00,101,7);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (205,'Shelley','Higgins','shelley.higgins@sqltutorial.org','515.123.8080','1994-06-07',12000.00,102,11);
INSERT INTO Sales.Employees(employee_id,first_name,last_name,email,phone_num,hire_date,salary,manager_id,department_id) VALUES (206,'William','Gietz','william.gietz@sqltutorial.org','515.123.8181','1994-06-07',8300.00,205,11);
SET IDENTITY_INSERT Sales.Employees OFF;


/******* Sales.Discounts      DATA	 	********/
SET IDENTITY_INSERT Sales.Discounts ON;
INSERT INTO Sales.Discounts(discount_id, disc_description, amount) VALUES (1, 'Employee discount', 15);
INSERT INTO Sales.Discounts(discount_id, disc_description, amount) VALUES (2, 'Sale discount. Changes based on product', 10);
INSERT INTO Sales.Discounts(discount_id, disc_description, amount) VALUES (3, 'Purchase over $100', 10);
INSERT INTO Sales.Discounts(discount_id, disc_description, amount) VALUES (4, 'Discontinued product', 60);
SET IDENTITY_INSERT Sales.Discounts OFF;