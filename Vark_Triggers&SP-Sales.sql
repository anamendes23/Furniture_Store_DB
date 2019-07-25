USE VarkFinishedFurniture
GO

/******* Table Sales.Employees        Stored Procedures	 	********/

--Verify if employee exists
CREATE OR ALTER PROCEDURE CheckEmployeeExists(@employee_id int, @result int output)
AS
BEGIN
BEGIN TRY
	IF EXISTS(SELECT employee_id FROM Sales.Employees WHERE employee_id = @employee_id)
		SET @result = 1
	ELSE
		SET @result = 0
END TRY
BEGIN CATCH
	SET @result = 0
END CATCH
END
GO

--Insertion of new employee
CREATE OR ALTER PROCEDURE InsertNewEmp
(
@fname varchar(20), @lname varchar(25), @email varchar(100), 
@phone_num varchar(20), @hire_date DATE, @salary Decimal(8, 2), @manager_id int, @department_id int
)
AS
BEGIN
BEGIN TRY
	INSERT INTO Sales.Employees (first_name, last_name, email, phone_num, hire_date, salary, manager_id, department_id)
	VALUES (@fname, @lname, @email, @phone_num, @hire_date, @salary, @manager_id, @department_id)
END TRY
BEGIN CATCH
	IF @@ERROR = 544
		PRINT 'table Employees IDENTITY_INSERT is set to OFF.'
	ELSE
		PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')
END CATCH
END
GO

CREATE OR ALTER PROCEDURE RemoveEmployeeFromDepartment(@employee_id int)
AS
DECLARE @result int
BEGIN
EXEC CheckEmployeeExists @employee_id, @result output
IF(@result = 1)
BEGIN
	IF EXISTS(SELECT manager_id FROM Sales.Departments WHERE manager_id = @employee_id)
	BEGIN
		-- change manager to null
		UPDATE Sales.Departments
		SET manager_id = NULL
		WHERE manager_id = @employee_id
	END
END
ELSE
	PRINT 'Enter a valid employee_id'
END
GO

CREATE OR ALTER PROCEDURE RemoveManagerFromEmployee(@manager_id int)
AS
DECLARE @result int, @MyCursor CURSOR, @employee_id int
BEGIN
EXEC CheckEmployeeExists @manager_id, @result output
IF(@result = 1)
BEGIN
	IF EXISTS(SELECT employee_id FROM Sales.Employees WHERE manager_id = @manager_id)
	BEGIN
		SET @MyCursor = CURSOR FOR
		SELECT TOP 1000 employee_id FROM Sales.Employees
		WHERE manager_id = @manager_id

		OPEN @MyCursor 
		FETCH NEXT FROM @MyCursor 
		INTO @employee_id

		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- change manager to null
			UPDATE Sales.Employees
			SET manager_id = NULL
			WHERE employee_id = @employee_id

		  FETCH NEXT FROM @MyCursor 
		  INTO @employee_id
		END

		CLOSE @MyCursor
		DEALLOCATE @MyCursor
	END
END
ELSE
	PRINT 'Enter a valid manager_id'
END
GO

--Deletion of employee
CREATE OR ALTER PROCEDURE DeleteEmployee(@employee_id int)
AS
DECLARE  @first_name_old varchar(20), @last_name_old varchar(25), @email_old varchar(100), @phone_old varchar(20), 
@hire_date_old date, @salary_old decimal(8,2), @manager_old int, @department_old int, @result int
BEGIN
BEGIN TRY
	EXEC CheckEmployeeExists @employee_id, @result output
	IF(@result = 1)
	BEGIN
		-- add deleted record to records
		SELECT @first_name_old = first_name, @last_name_old = last_name, @email_old = email, @phone_old = phone_num, 
		@hire_date_old = hire_date, @salary_old = salary, @manager_old = manager_id, @department_old = department_id
		FROM Sales.Employees WHERE employee_id = @employee_id
		BEGIN TRY
			--update deparment manager
			EXEC RemoveEmployeeFromDepartment @employee_id
			--update employee manager
			EXEC RemoveManagerFromEmployee @employee_id
			-- delete record from table
			DELETE FROM Sales.Employees
			WHERE employee_id = @employee_id

			INSERT INTO RecordsLog.EmployeesHistory (employee_id, first_name, last_name, email, phone_num, hire_date, salary, manager_id, department_id)
			VALUES (@employee_id, @first_name_old, @last_name_old, @email_old, @phone_old, @hire_date_old, @salary_old, @manager_old, @department_old)
			PRINT 'Employee deleted'
		END TRY
		BEGIN CATCH
			PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')
		END CATCH
	END
	ELSE
		PRINT 'Enter a valid employee_id'
END TRY
BEGIN CATCH
	PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')		
END CATCH
END
GO

--Update of current employee
CREATE OR ALTER PROCEDURE UpdateEmployee (@employee_id int, @first_name varchar(20), @last_name varchar(25), 
@email varchar(100), @phone varchar(20), @hire_date date, @salary decimal(8,2), @manager_id int, @department int)
AS
DECLARE @first_name_old varchar(20), @last_name_old varchar(25), @email_old varchar(100), @phone_old varchar(20), 
@hire_date_old date, @salary_old decimal(8,2), @manager_old int, @department_old int, @result int
BEGIN
BEGIN TRY
EXEC CheckEmployeeExists @employee_id, @result output
IF(@result = 1)
BEGIN --check if enter is NULL. if yes, use old value
	SELECT @first_name_old = first_name, @last_name_old = last_name, @email_old = email, @phone_old = phone_num, 
	@hire_date_old = hire_date, @salary_old = salary, @manager_old = manager_id, @department_old = department_id
	FROM Sales.Employees WHERE employee_id = @employee_id
	
	IF(@first_name IS NULL)
	BEGIN
		SET @first_name = @first_name_old
	END
	IF(@last_name IS NULL)
	BEGIN 
		SET @last_name = @last_name_old
	END
	IF(@email IS NULL)
	BEGIN
		SET @email = @email_old
	END
	IF(@phone IS NULL)
	BEGIN
		SET @phone = @phone_old
	END
	IF(@hire_date IS NULL)
	BEGIN
		SET @hire_date = @hire_date_old
	END
	IF(@salary IS NULL)
	BEGIN 
		SET @salary = @salary_old
	END
	IF(@manager_id IS NULL)
	BEGIN
		SET @manager_id = @manager_old
	END
	IF(@department IS NULL)
	BEGIN
		SET @department = @department_old
	END
	--execute update
	UPDATE Sales.Employees
	SET first_name = @first_name, last_name = @last_name, email = @email, phone_num = @phone,
	hire_date = @hire_date, salary = @salary, manager_id = @manager_id, department_id = @department
	WHERE employee_id = @employee_id

	INSERT INTO RecordsLog.EmployeesHistory (employee_id, first_name, last_name, email, phone_num, hire_date, salary, manager_id, department_id)
	VALUES (@employee_id, @first_name_old, @last_name_old, @email_old, @phone_old, @hire_date_old, @salary_old, @manager_old, @department_old)	
END
ELSE
		PRINT 'Enter a valid employee_id'
END TRY
BEGIN CATCH
	PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')		
END CATCH
END
GO

--Check employees getting 5% raise for one year of service
CREATE OR ALTER PROCEDURE CheckRaiseEligible(@employee_id int, @input_date date)
AS
DECLARE @hire_date date, @day_num int, @result int
BEGIN
BEGIN TRY
EXEC CheckEmployeeExists @employee_id, @result output
IF(@result = 1)
BEGIN
	SELECT @hire_date = hire_date
	FROM Sales.Employees WHERE employee_id = @employee_id
	SET @day_num = DATEDIFF(day, @hire_date, @input_date)
	IF(@day_num > 364)
		PRINT 'Employee is eligible for a raise'
	ELSE
		Print 'Employee is not eligible for a raise'
END
ELSE
	PRINT 'Enter a valid employee_id'
END TRY
BEGIN CATCH
	PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')		
END CATCH
END
GO

--Count employees with salary greater than input_salary
CREATE OR ALTER PROCEDURE CheckGreaterSalary(@salary_input decimal(8,2))
AS
DECLARE @emp_count int
BEGIN
BEGIN TRY
	SET @emp_count = (
		SELECT COUNT(employee_id)
		FROM Sales.Employees
		WHERE salary > @salary_input)
	PRINT 'There are ' + CONVERT(varchar(10), @emp_count) + ' employees with salary greater than ' + CONVERT(varchar(20), @salary_input)
END TRY
BEGIN CATCH
	PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')		
END CATCH
END
GO

/******* Table Sales.Departments        Stored Procedures	 	********/

--Verify if employee exists
CREATE OR ALTER PROCEDURE CheckDepartmentExists(@department_id int, @result int output)
AS
BEGIN
BEGIN TRY
	IF EXISTS(SELECT department_id FROM Sales.Departments WHERE department_id = @department_id)
		SET @result = 1
	ELSE
		SET @result = 0
END TRY
BEGIN CATCH
	SET @result = 0
END CATCH
END
GO

CREATE OR ALTER PROCEDURE InsertNewDepartment(@department_name varchar(20), @manager_id int)
AS
BEGIN
BEGIN TRY
	INSERT INTO Sales.Departments (department_name, manager_id)
	VALUES  (@department_name, @manager_id)
	PRINT 'New Department inserted'
END TRY
BEGIN CATCH
	IF @@ERROR = 544
		PRINT 'table Departments IDENTITY_INSERT is set to OFF.'
	ELSE
		PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')
END CATCH
END
GO

CREATE OR ALTER PROCEDURE RemoveDepartmentFromEmployee(@department_id int)
AS
DECLARE @result int, @MyCursor CURSOR, @employee_id int
BEGIN
IF EXISTS(SELECT employee_id FROM Sales.Employees WHERE department_id = @department_id)
BEGIN
	SET @MyCursor = CURSOR FOR
	SELECT TOP 1000 employee_id FROM Sales.Employees
	WHERE department_id = @department_id

	OPEN @MyCursor 
	FETCH NEXT FROM @MyCursor 
	INTO @employee_id

	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- change manager to null
		UPDATE Sales.Employees
		SET department_id = NULL
		WHERE employee_id = @employee_id

		FETCH NEXT FROM @MyCursor 
		INTO @employee_id
	END

	CLOSE @MyCursor
	DEALLOCATE @MyCursor
END
END
GO

CREATE OR ALTER PROCEDURE DeleteDepartment(@department_id int)
AS
DECLARE @department_name varchar(20), @num_of_employees int, @manager_id int, @result int
BEGIN
BEGIN TRY
EXEC CheckDepartmentExists @department_id, @result output
IF (@result = 1)
BEGIN
	-- add deleted record to records
	SELECT @department_name = department_name, @num_of_employees = num_of_employees, @manager_id = manager_id
	FROM Sales.Departments WHERE department_id = @department_id
	BEGIN TRY
		--update department to null in employee
		EXEC RemoveDepartmentFromEmployee @department_id
		-- delete record from table
		DELETE FROM Sales.Departments
		WHERE department_id = @department_id

		INSERT INTO RecordsLog.DepartmentsHistory (department_id, department_name, num_of_employees, manager_id)
		VALUES (@department_id, @department_name, @num_of_employees, @manager_id)
		PRINT 'Department deleted'
	END TRY
	BEGIN CATCH
		PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')
	END CATCH
END
ELSE
	PRINT 'Enter a valid department_id'
END TRY
BEGIN CATCH
	PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')		
END CATCH
END
GO

CREATE OR ALTER PROCEDURE UpdateDepartment (@department_id int, @department_name varchar(20), @manager_id int)
AS
DECLARE @department_name_old varchar(20), @num_of_employees int, @manager_id_old int, @result int
BEGIN
BEGIN TRY
	EXEC CheckDepartmentExists @department_id, @result output
	IF(@result = 1)
	BEGIN --check if enter is NULL. if yes, use old value
		EXEC CheckEmployeeExists @manager_id, @result output
		IF(@result = 1)
		BEGIN
			SELECT @department_name_old = department_name, @num_of_employees = num_of_employees, @manager_id_old = manager_id
			FROM Sales.Departments WHERE department_id = @department_id
			IF(@department_name IS NULL)
			BEGIN
				SET @department_name = @department_name_old
			END
			IF(@manager_id IS NULL)
			BEGIN
				SET @manager_id = @manager_id_old
			END
			--execute update
			UPDATE Sales.Departments
			SET department_name = @department_name, manager_id = @manager_id
			WHERE department_id = @department_id
			--enter log
			INSERT INTO RecordsLog.DepartmentsHistory (department_id, department_name, num_of_employees, manager_id)
			VALUES (@department_id, @department_name_old, @num_of_employees, @manager_id_old)
		END
		ELSE
			PRINT 'Enter a valid manager_id'
	END
	ELSE
		PRINT 'Enter a valid department_id'
END TRY
BEGIN CATCH
	PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')		
END CATCH
END
GO

--Update number of employees
CREATE OR ALTER PROCEDURE UpdateDepartmentEmpNum(@department_id int)
AS
DECLARE @emp_count int, @department_name varchar(20), @num_of_employees int, @manager_id int, @result int
BEGIN
BEGIN TRY
EXEC CheckDepartmentExists @department_id, @result output
IF(@result = 1)
BEGIN
	SET @emp_count = (
		SELECT COUNT(employee_id) 
		FROM Sales.Employees
		WHERE department_id = @department_id)
	BEGIN --update
		--get old data
		SELECT @department_name = department_name, @num_of_employees = num_of_employees, @manager_id = manager_id
		FROM Sales.Departments WHERE department_id = @department_id
		--update
		BEGIN TRY
			UPDATE Sales.Departments
			SET num_of_employees = @emp_count
			WHERE department_id = @department_id
			--log
			INSERT INTO RecordsLog.DepartmentsHistory (department_id, department_name, num_of_employees, manager_id)
			VALUES (@department_id, @department_name, @num_of_employees, @manager_id)
		END TRY
		BEGIN CATCH
			PRINT 'Error on update of number of employees in department'
		END CATCH
	END
END
ELSE
	PRINT 'Enter a valid department_id'
END TRY
BEGIN CATCH
	PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')		
END CATCH
END
GO

/*******		Table Sales.Employees       Triggers		 	********/
--Update department in employee -> call SP update number of employees
CREATE OR ALTER TRIGGER UpdateDepInEmployeeTrigger on Sales.Employees
AFTER UPDATE
AS
BEGIN
	DECLARE @department_id_del int, @department_id_ins int, @department_id_new int
	SELECT @department_id_del = department_id FROM deleted
	SELECT @department_id_ins = department_id FROM inserted
	--if ids are the same, that means department wasn't updated
	IF(@department_id_del != @department_id_ins)
	BEGIN
		SET @department_id_new = @department_id_ins
		EXEC UpdateDepartmentEmpNum @department_id_new
	END
END
GO

--Check which department has more employees
CREATE OR ALTER PROCEDURE MostEmployees
AS
DECLARE @Most_Emps int, @department_name varchar(20)
BEGIN
SET @Most_Emps = (SELECT department_id
	FROM Sales.Departments
	WHERE num_of_employees = 
		(SELECT MAX(num_of_employees)
		 FROM Sales.Departments))
SELECT @department_name = department_name
FROM Sales.Departments WHERE department_id = @Most_Emps
Print 'The department #' + CONVERT(varchar(5), @Most_Emps) + ' ' + @department_name + ' had the most employees'
END
GO

--Update employees manager when updated in department table
CREATE OR ALTER PROCEDURE UpdateEmployeeManager(@employee_id int, @department_id int)
AS
DECLARE @new_manager int, @result int
BEGIN
BEGIN TRY
EXEC CheckEmployeeExists @employee_id, @result output
IF (@result = 1)
BEGIN
	EXEC CheckDepartmentExists @department_id, @result output
	IF(@result = 1)
	BEGIN
		SET @new_manager = 
			(SELECT manager_id
			FROM Sales.Departments
			WHERE @department_id = department_id)
		EXEC UpdateEmployee @employee_id, NULL, NULL, NULL, NULL, NULL, NULL, @new_manager, NULL
		--update department
		UPDATE Sales.Employees
		SET department_id = @department_id
		WHERE employee_id = @employee_id
	END
	ELSE
		PRINT 'Enter a valid department_id'
END
ELSE
	PRINT 'Enter a valid employee_id'
END TRY
BEGIN CATCH
	PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')		
END CATCH
END
GO

--Check if department has already a manager
CREATE OR ALTER PROCEDURE CheckManagerExists(@department_id int, @result int output)
AS
DECLARE @manager_id int
BEGIN
BEGIN TRY
SELECT @manager_id = manager_id FROM Sales.Departments WHERE department_id = @department_id
	IF (@manager_id IS NOT NULL)
		SET @result = 1
	ELSE
		SET @result = 0
END TRY
BEGIN CATCH
	SET @result = 0
END CATCH
END
GO

--Update the manager id of the employees in a department when manager is updated
CREATE OR ALTER PROCEDURE UpdateManagerInDepartment(@department_id int, @manager_id int)
AS
DECLARE @result int
BEGIN
BEGIN TRY
EXEC CheckDepartmentExists @department_id, @result output
IF(@result = 1)
BEGIN
	--update department
	PRINT 'department exists'
	EXEC UpdateDepartment @department_id, NULL, @manager_id
	PRINT 'executed fucking update'
	UPDATE Sales.Employees
	SET manager_id = @manager_id
	WHERE department_id = @department_id	
END
ELSE
	PRINT 'Enter a valid department_id'
END TRY
BEGIN CATCH
	PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')		
END CATCH
END
GO

/*******		Table Sales.Departments        Triggers		 	********/
--Update manager -> calls update managers in employees table
CREATE OR ALTER TRIGGER UpdateManagerTrigger on Sales.Departments
AFTER UPDATE
AS
BEGIN
	DECLARE @manager_id_del int, @manager_id_ins int, @manager_id_new int, @department_id int
	SELECT @manager_id_del = manager_id, @department_id = department_id FROM deleted
	SELECT @manager_id_ins = manager_id FROM inserted
	--if ids are the same, that means department wasn't updated
	IF(@manager_id_del != @manager_id_ins)
	BEGIN
		SET @manager_id_new = @manager_id_ins
		EXEC UpdateManagerInDepartment @department_id, @manager_id_new
	END
END
GO

/*******		Table Sales.Orders        Triggers		 	********/

/******* Table Sales.Orders        Stored Procedures	 	********/
CREATE OR ALTER PROCEDURE CheckOrderExists(@order_id int, @result int output)
AS
BEGIN
BEGIN TRY
	IF EXISTS(SELECT order_id FROM Sales.Orders WHERE order_id = @order_id)
		SET @result = 1
	ELSE
		SET @result = 0
END TRY
BEGIN CATCH
	SET @result = 0
END CATCH
END
GO

CREATE OR ALTER PROCEDURE InsertOrder(@order_date datetime, @employee_id int)
AS
BEGIN
BEGIN TRY
	INSERT INTO Sales.Orders (order_date, employee_id)
	VALUES  (@order_date, @employee_id)
	PRINT 'New Order inserted'
END TRY
BEGIN CATCH
	IF @@ERROR = 544
		PRINT 'table Orders IDENTITY_INSERT is set to OFF.'
	ELSE
		PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')
END CATCH
END
GO

CREATE OR ALTER PROCEDURE UpdateOrder(@order_id int, @order_date datetime, @employee_id int)
AS
DECLARE @order_date_old datetime, @employee_id_old int, @result int
BEGIN
BEGIN TRY
EXEC CheckOrderExists @order_id, @result output
IF (@result = 1)
BEGIN
	SELECT @order_date_old = order_date, @employee_id_old = employee_id
	FROM Sales.Orders WHERE order_id = @order_id
	--check what's being changed
	IF(@order_date IS NULL)
	BEGIN
		IF(@employee_id IS NULL)
			PRINT 'Enter information to update Orders table'
		ELSE
			--save record before changing
			INSERT INTO RecordsLog.OrdersHistory (order_id, order_date, employee_id)
			VALUES (@order_id, @order_date_old, @employee_id_old)
			--update employee_id
			UPDATE Sales.Orders 
			SET employee_id = @employee_id
			WHERE order_id = @order_id
			PRINT 'Order updated'
	END
	ELSE --
	BEGIN
		IF(@employee_id IS NULL)
		BEGIN
			--save record before changing
			INSERT INTO RecordsLog.OrdersHistory (order_id, order_date, employee_id)
			VALUES (@order_id, @order_date_old, @employee_id_old)
			--update employee_id
			UPDATE Sales.Orders 
			SET order_date = @order_date
			WHERE order_id = @order_id
			PRINT 'Order updated'
		END
		ELSE
		BEGIN
			--save record before changing
			INSERT INTO RecordsLog.OrdersHistory (order_id, order_date, employee_id)
			VALUES (@order_id, @order_date_old, @employee_id_old)
			--update employee_id
			UPDATE Sales.Orders 
			SET employee_id = @employee_id, order_date = @order_date
			WHERE order_id = @order_id
			PRINT 'Order updated'
		END
	END
END
ELSE --order id not found
	PRINT 'Enter a valid order_id'
END TRY
BEGIN CATCH
	PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')		
END CATCH
END
GO

CREATE OR ALTER PROCEDURE CascadeDeleteOrderDetailsByOrder(@order_id int)
AS
DECLARE @result int, @MyCursor CURSOR, @item_id int
BEGIN
IF EXISTS(SELECT item_id FROM Sales.OrderDetails WHERE order_id = @order_id)
BEGIN
	SET @MyCursor = CURSOR FOR
	SELECT TOP 1000 item_id FROM Sales.OrderDetails
	WHERE order_id = @order_id

	OPEN @MyCursor 
	FETCH NEXT FROM @MyCursor 
	INTO @item_id

	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- delete order detail record
		EXEC DeleteOrderDetail @item_id

		FETCH NEXT FROM @MyCursor 
		INTO @item_id
	END

	CLOSE @MyCursor
	DEALLOCATE @MyCursor
END
END
GO

CREATE OR ALTER PROCEDURE DeleteOrder(@order_id int)
AS
DECLARE @order_date date, @employee_id int, @result int
BEGIN
BEGIN TRY
EXEC CheckOrderExists @order_id, @result output
IF (@result = 1)
BEGIN
	-- add deleted record to records
	SELECT @order_date = order_date FROM Sales.Orders WHERE order_id = @order_id
	SELECT @employee_id = employee_id FROM Sales.Orders WHERE order_id = @order_id
	BEGIN TRY
		EXEC CascadeDeleteOrderDetailsByOrder @order_id
		-- delete record from table
		DELETE FROM Sales.Orders
		WHERE order_id = @order_id
		INSERT INTO RecordsLog.OrdersHistory (order_id, order_date, employee_id)
		VALUES (@order_id, @order_date, @employee_id)
		PRINT 'Order deleted'
	END TRY
	BEGIN CATCH
		PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')
	END CATCH
END
ELSE
	PRINT 'Enter a valid order_id'
END TRY
BEGIN CATCH
	PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')		
END CATCH
END
GO

CREATE OR ALTER PROCEDURE OrderSummary(@order_id int)
AS
BEGIN
BEGIN TRY
DECLARE @result int, @MyCursor CURSOR, @item_id int, @order_summary varchar(1000)
DECLARE @order_date datetime, @employee_id int
DECLARE @product_id int, @quantity int, @list_price decimal(10, 2), @discount_id int, @disc_amount int
DECLARE @subtotal decimal(10, 2), @total decimal(10, 2)
EXEC CheckOrderExists @order_id, @result output
IF (@result = 1)
BEGIN
	SET @total = 0

	SELECT @order_date = order_date, @employee_id = employee_id
	FROM Sales.Orders WHERE order_id = @order_id
	SET @order_summary = 'Summary Order #' + CONVERT(varchar(10), @order_id) + ', ' + CONVERT(varchar(20), @order_date) + ', employee: ' + CONVERT(varchar(10),@employee_id)

	SET @MyCursor = CURSOR FOR
	SELECT TOP 1000 item_id FROM Sales.OrderDetails
	WHERE order_id = @order_id

	OPEN @MyCursor 
    FETCH NEXT FROM @MyCursor 
    INTO @item_id

	SET @order_summary = @order_summary + CHAR(13) + 'Order Detail: Line ID QTY Price Disc Sub'

	WHILE @@FETCH_STATUS = 0
    BEGIN
	  SELECT @product_id = product_id, @quantity = quantity, @list_price = list_price, @discount_id = discount_id
	  FROM Sales.OrderDetails WHERE item_id = @item_id;

	  SELECT @disc_amount = amount FROM Sales.Discounts WHERE discount_id = @discount_id;

	  SET @subtotal = @list_price * (100 - @disc_amount) * @quantity / 100
	  SET @total = @total + @subtotal

      SET @order_summary = @order_summary + CHAR(13) + 'Order Detail: ' + CONVERT(varchar(10),@item_id) + ' - ' + 
	  CONVERT(varchar(10),@product_id) + ' - ' + CONVERT(varchar(5),@quantity) + ' - $' + 
	  CONVERT(varchar(20),@list_price) + ' - ' + CONVERT(varchar(5),@disc_amount) + '%' + ' - ' + CONVERT(varchar(10),@subtotal)

      FETCH NEXT FROM @MyCursor 
      INTO @item_id
    END
    CLOSE @MyCursor
    DEALLOCATE @MyCursor

	SET @order_summary = @order_summary + CHAR(13) + 'TOTAL: $' + CONVERT(varchar(20),@total)

	PRINT @order_summary
END
ELSE
	PRINT 'Enter a valid order_id'
END TRY
BEGIN CATCH
	IF @@ERROR = 544
		PRINT 'table Orders IDENTITY_INSERT is set to OFF.'
	ELSE
		PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')
END CATCH
END
GO

CREATE OR ALTER PROCEDURE UpdateProductQuantity(@product_id int, @quantity int)
AS
BEGIN
DECLARE @quantity_old int
BEGIN TRY
	IF (@product_id < 50)
	BEGIN
		--SET @result = 0 -- produtcs table
		SELECT @quantity_old = product_qty FROM ProductSupport.Products WHERE product_ID = @product_id
		UPDATE ProductSupport.Products
		SET product_qty = @quantity_old - @quantity
		WHERE product_ID = @product_id
		--get records into records log
		INSERT INTO RecordsLog.ProductsHistory (product_ID, product_name, product_price, product_qty, product_reorderpoint, product_unitissue)
		VALUES (@product_id, NULL, NULL, @quantity_old, NULL, NULL)
	END		
	ELSE
	BEGIN
		IF(@product_id < 100) 
		BEGIN
			--SET @result = 1 -- parts table
			SELECT @quantity_old = part_qty FROM ProductSupport.Parts WHERE part_ID = @product_id
			UPDATE ProductSupport.Parts
			SET part_qty = @quantity_old - @quantity
			WHERE part_ID = @product_id
			--get records into records log
			INSERT INTO RecordsLog.PartsHistory (part_id, part_name, part_description, part_price, part_qty, part_reorderpoint, part_unitissue)
			VALUES (@product_id, NULL, NULL, NULL, @quantity_old, NULL, NULL)
		END
		ELSE
		BEGIN
			--SET @result = 2 --hardware table
			SELECT @quantity_old = hardware_qty FROM ProductSupport.Hardware WHERE hardware_id = @product_id
			UPDATE ProductSupport.Hardware
			SET hardware_qty = @quantity_old - @quantity
			WHERE hardware_id = @product_id
			--get records into records log
			INSERT INTO RecordsLog.HardwareHistory (hardware_id, hardware_name, hardware_description, hardware_price, hardware_qty,
			hardware_reorderpoint, hardware_unitissue)
			VALUES (@product_id, NULL, NULL, NULL, @quantity_old, NULL, NULL)
		END
	END
END TRY
BEGIN CATCH
	--SET @result = -1 --not found
	PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')
END CATCH
END
GO

CREATE OR ALTER PROCEDURE ProcessOrder(@order_id int)
AS
BEGIN
BEGIN TRY
DECLARE @MyCursor CURSOR, @item_id int, @result int
DECLARE @product_id int, @quantity int
EXEC CheckOrderExists @order_id, @result output
IF (@result = 1)
BEGIN
	EXEC OrderSummary @order_id	

	SET @MyCursor = CURSOR FOR
	SELECT TOP 1000 item_id FROM Sales.OrderDetails
	WHERE order_id = @order_id

	OPEN @MyCursor 
    FETCH NEXT FROM @MyCursor 
    INTO @item_id

	WHILE @@FETCH_STATUS = 0
    BEGIN
	  SELECT @product_id = product_id, @quantity = quantity
	  FROM Sales.OrderDetails WHERE item_id = @item_id;

	  EXEC UpdateProductQuantity @product_id, @quantity

      FETCH NEXT FROM @MyCursor 
      INTO @item_id
    END
    CLOSE @MyCursor
    DEALLOCATE @MyCursor

END
ELSE
	PRINT 'Enter a valid order_id'
END TRY
BEGIN CATCH
	PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')
END CATCH
END
GO

/*******		Table Sales.Discounts        Triggers		 	********/

/******* Table Sales.Discounts        Stored Procedures	 	********/

CREATE OR ALTER PROCEDURE CheckDiscountExists(@discount_id int, @result int output)
AS
BEGIN
BEGIN TRY
	IF EXISTS(SELECT discount_id FROM Sales.Discounts WHERE discount_id = @discount_id)
		SET @result = 1
	ELSE
		SET @result = 0
END TRY
BEGIN CATCH
	SET @result = 0
END CATCH
END
GO

CREATE OR ALTER PROCEDURE InsertDiscount(@disc_description varchar(50), @amount decimal(4, 2))
AS
BEGIN
BEGIN TRY
	INSERT INTO Sales.Discounts (disc_description, amount)
	VALUES (@disc_description, @amount)
	PRINT 'New Discount inserted'
END TRY
BEGIN CATCH
	IF @@ERROR = 544
		PRINT 'table Discounts IDENTITY_INSERT is set to OFF.'
	ELSE
		PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')
END CATCH
END
GO

CREATE OR ALTER PROCEDURE UpdateDiscount(@discount_id int, @disc_description varchar(50), @amount decimal(4, 2))
AS
DECLARE @disc_description_old varchar(50), @amount_old decimal(4, 2), @result int
BEGIN
BEGIN TRY
EXEC CheckDiscountExists @discount_id, @result output
IF (@result = 1)
BEGIN
	SELECT @disc_description_old = disc_description, @amount_old = amount
	FROM Sales.Discounts WHERE discount_id = @discount_id
	--check what's being changed
	IF(@disc_description IS NULL)
	BEGIN
		IF(@amount IS NULL)
			PRINT 'Enter information to update Discount table'
		ELSE
		BEGIN
			IF(@amount >= 20 AND @discount_id != 4)
				PRINT 'Discount is too high'
			ELSE
			BEGIN
				BEGIN TRY
					--update employee_id
					UPDATE Sales.Discounts 
					SET amount = @amount
					WHERE discount_id = @discount_id
					--save record before changing
					INSERT INTO RecordsLog.DiscountsHistory (discount_id, disc_description, amount)
					VALUES (@discount_id, @disc_description_old, @amount_old)
					PRINT 'Discount updated'
				END TRY
				BEGIN CATCH
					PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')
				END CATCH
			END
		END
	END
	ELSE --
	BEGIN
		IF(@amount IS NULL)
		BEGIN
			BEGIN TRY
				--update employee_id
				UPDATE Sales.Discounts
				SET disc_description = @disc_description
				WHERE discount_id = @discount_id
				--save record before changing
				INSERT INTO RecordsLog.DiscountsHistory(discount_id, disc_description, amount)
				VALUES (@discount_id, @disc_description_old, @amount_old)
				PRINT 'Discount updated'
			END TRY
			BEGIN CATCH
				PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')
			END CATCH			
		END
		ELSE
		BEGIN
			IF(@amount >= 20 AND @discount_id != 4)
				PRINT 'Discount is too high'
			ELSE
			BEGIN
				BEGIN TRY
					--update employee_id
					UPDATE Sales.Discounts
					SET amount = @amount, disc_description = @disc_description
					WHERE discount_id = @discount_id
					--save record before changing
					INSERT INTO RecordsLog.DiscountsHistory (discount_id, disc_description, amount)
					VALUES (@discount_id, @disc_description_old, @amount_old)
					PRINT 'Discount updated'
				END TRY
				BEGIN CATCH
					PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')
				END CATCH				
			END
		END
	END
END
ELSE
	PRINT 'Enter a valid discount_id'
END TRY
BEGIN CATCH
	PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')		
END CATCH
END
GO

CREATE OR ALTER PROCEDURE RemoveDiscountFromOrderDetails(@discount_id int)
AS
DECLARE @result int, @MyCursor CURSOR, @item_id int
BEGIN
IF EXISTS(SELECT item_id FROM Sales.OrderDetails WHERE discount_id = @discount_id)
BEGIN
	SET @MyCursor = CURSOR FOR
	SELECT TOP 1000 item_id FROM Sales.OrderDetails
	WHERE discount_id = @discount_id

	OPEN @MyCursor 
	FETCH NEXT FROM @MyCursor 
	INTO @item_id

	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- change discount to null
		UPDATE Sales.OrderDetails
		SET discount_id = NULL
		WHERE item_id = @item_id

		FETCH NEXT FROM @MyCursor 
		INTO @item_id
	END

	CLOSE @MyCursor
	DEALLOCATE @MyCursor
END
END
GO

CREATE OR ALTER PROCEDURE DeleteDiscount(@discount_id int)
AS
DECLARE @disc_description varchar(50), @amount decimal(4, 2), @result int
BEGIN
BEGIN TRY
EXEC CheckDiscountExists @discount_id, @result output
IF (@result = 1)
BEGIN
	SELECT @disc_description = disc_description FROM Sales.Discounts WHERE discount_id = @discount_id
	SELECT @amount = amount FROM Sales.Discounts WHERE discount_id = @discount_id
	BEGIN TRY
		EXEC RemoveDiscountFromOrderDetails @discount_id
		-- delete record from table
		DELETE FROM Sales.Discounts
		WHERE discount_id = @discount_id
		-- add deleted record to records	
		INSERT INTO RecordsLog.DiscountsHistory (discount_id, disc_description, amount)
		VALUES (@discount_id, @disc_description, @amount)
		PRINT 'Discount deleted'
	END TRY
	BEGIN CATCH
		PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')
	END CATCH
END
ELSE
	PRINT 'Enter a valid discount_id'
END TRY
BEGIN CATCH
	PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')		
END CATCH
END
GO

/*******		Table Sales.OrderDetails        Triggers		********/

/******* Table Sales.OrderDetails       Stored Procedures	 	********/
CREATE OR ALTER PROCEDURE CheckOrderDetailsExists(@item_id int, @result int output)
AS
BEGIN
BEGIN TRY
	IF EXISTS(SELECT item_id FROM Sales.OrderDetails WHERE item_id = @item_id)
		SET @result = 1
	ELSE
		SET @result = 0
END TRY
BEGIN CATCH
	SET @result = 0
END CATCH
END
GO

CREATE OR ALTER PROCEDURE InsertOrderDetail
(
@order_id int, @product_id int,
@quantity int, @list_price decimal(10, 2), @discount_id int
)
AS
BEGIN
DECLARE @result int
EXEC CheckOrderExists @order_id, @result output
IF(@result = 1)
BEGIN
	BEGIN TRY
		INSERT INTO Sales.OrderDetails (order_id, product_id, quantity, list_price, discount_id)
		VALUES (@order_id, @product_id, @quantity, @list_price, @discount_id)
		PRINT 'New Order Detail inserted'
	END TRY
	BEGIN CATCH
		IF @@ERROR = 544
			PRINT 'table OrderDetails IDENTITY_INSERT is set to OFF.'
		ELSE
			PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')
	END CATCH
END
ELSE
	PRINT 'Enter a valid order_id'
END
GO

CREATE OR ALTER PROCEDURE UpdateOrderDetail
(
@item_id int, @order_id int, @product_id int,
@quantity int, @list_price decimal(10, 2), @discount_id int
)
AS
DECLARE @product_id_old int,
@quantity_old int, @list_price_old decimal(10, 2), @discount_id_old int
BEGIN
BEGIN TRY
SELECT @product_id_old = product_id, @quantity_old = quantity, @list_price_old = list_price, @discount_id_old = discount_id
FROM Sales.OrderDetails WHERE order_id = @order_id AND item_id = @item_id
--check what's being changed
IF(@order_id IS NULL) --don't change
	PRINT 'Must enter order_id'
ELSE
BEGIN
IF(@product_id IS NULL)
BEGIN
	IF(@quantity IS NULL)
	BEGIN
		IF(@list_price IS NULL)
		BEGIN
			IF(@discount_id IS NULL)
				PRINT 'Enter information to update Order Details table'
			ELSE
			BEGIN
				--save record before changing
				INSERT INTO RecordsLog.OrderDetailsHistory (item_id, order_id, product_id, quantity, list_price, discount_id)
				VALUES (@item_id, @order_id, @product_id_old, @quantity_old, @list_price_old, @discount_id_old)
				--update employee_id
				UPDATE Sales.OrderDetails
				SET discount_id = @discount_id
			END
		END
		ELSE
		BEGIN
			IF(@discount_id IS NULL)
			BEGIN
				--save record before changing
				INSERT INTO RecordsLog.OrderDetailsHistory (item_id, order_id, product_id, quantity, list_price, discount_id)
				VALUES (@item_id, @order_id, @product_id_old, @quantity_old, @list_price_old, @discount_id_old)
				--update employee_id
				UPDATE Sales.OrderDetails
				SET list_price = @list_price
			END
			ELSE
			BEGIN
				--save record before changing
				INSERT INTO RecordsLog.OrderDetailsHistory (item_id, order_id, product_id, quantity, list_price, discount_id)
				VALUES (@item_id, @order_id, @product_id_old, @quantity_old, @list_price_old, @discount_id_old)
				--update employee_id
				UPDATE Sales.OrderDetails
				SET list_price = @list_price, discount_id = @discount_id
			END
		END
	END
	ELSE
	BEGIN
		IF(@list_price IS NULL)
		BEGIN
			IF(@discount_id IS NULL)
			BEGIN
				--save record before changing
				INSERT INTO RecordsLog.OrderDetailsHistory (item_id, order_id, product_id, quantity, list_price, discount_id)
				VALUES (@item_id, @order_id, @product_id_old, @quantity_old, @list_price_old, @discount_id_old)
				--update employee_id
				UPDATE Sales.OrderDetails
				SET quantity = @quantity
			END
			ELSE
			BEGIN
				--save record before changing
				INSERT INTO RecordsLog.OrderDetailsHistory (item_id, order_id, product_id, quantity, list_price, discount_id)
				VALUES (@item_id, @order_id, @product_id_old, @quantity_old, @list_price_old, @discount_id_old)
				--update employee_id
				UPDATE Sales.OrderDetails
				SET quantity = @quantity, discount_id = @discount_id
			END
		END
		ELSE
		BEGIN
			IF(@discount_id IS NULL)
			BEGIN
				--save record before changing
				INSERT INTO RecordsLog.OrderDetailsHistory (item_id, order_id, product_id, quantity, list_price, discount_id)
				VALUES (@item_id, @order_id, @product_id_old, @quantity_old, @list_price_old, @discount_id_old)
				--update employee_id
				UPDATE Sales.OrderDetails
				SET list_price = @list_price, quantity = @quantity
			END
			ELSE
			BEGIN
				--save record before changing
				INSERT INTO RecordsLog.OrderDetailsHistory (item_id, order_id, product_id, quantity, list_price, discount_id)
				VALUES (@item_id, @order_id, @product_id_old, @quantity_old, @list_price_old, @discount_id_old)
				--update employee_id
				UPDATE Sales.OrderDetails
				SET quantity = @quantity, list_price = @list_price, discount_id = @discount_id
			END
		END
	END
END
ELSE --
BEGIN
	IF(@quantity IS NULL)
	BEGIN
		IF(@list_price IS NULL)
		BEGIN
			IF(@discount_id IS NULL)
			BEGIN
				--save record before changing
				INSERT INTO RecordsLog.OrderDetailsHistory (item_id, order_id, product_id, quantity, list_price, discount_id)
				VALUES (@item_id, @order_id, @product_id_old, @quantity_old, @list_price_old, @discount_id_old)
				--update employee_id
				UPDATE Sales.OrderDetails
				SET product_id = @product_id
			END
			ELSE
			BEGIN
				--save record before changing
				INSERT INTO RecordsLog.OrderDetailsHistory (item_id, order_id, product_id, quantity, list_price, discount_id)
				VALUES (@item_id, @order_id, @product_id_old, @quantity_old, @list_price_old, @discount_id_old)
				--update employee_id
				UPDATE Sales.OrderDetails
				SET product_id = @product_id, discount_id = @discount_id
			END
		END
		ELSE
		BEGIN
			IF(@discount_id IS NULL)
			BEGIN
				--save record before changing
				INSERT INTO RecordsLog.OrderDetailsHistory (item_id, order_id, product_id, quantity, list_price, discount_id)
				VALUES (@item_id, @order_id, @product_id_old, @quantity_old, @list_price_old, @discount_id_old)
				--update employee_id
				UPDATE Sales.OrderDetails
				SET product_id = @product_id, list_price = @list_price
			END
			ELSE
			BEGIN
				--save record before changing
				INSERT INTO RecordsLog.OrderDetailsHistory (item_id, order_id, product_id, quantity, list_price, discount_id)
				VALUES (@item_id, @order_id, @product_id_old, @quantity_old, @list_price_old, @discount_id_old)
				--update employee_id
				UPDATE Sales.OrderDetails
				SET product_id = @product_id, list_price = @list_price, discount_id = @discount_id
			END
		END
	END
	ELSE
	BEGIN
		IF(@list_price IS NULL)
		BEGIN
			IF(@discount_id IS NULL)
			BEGIN
				--save record before changing
				INSERT INTO RecordsLog.OrderDetailsHistory (item_id, order_id, product_id, quantity, list_price, discount_id)
				VALUES (@item_id, @order_id, @product_id_old, @quantity_old, @list_price_old, @discount_id_old)
				--update employee_id
				UPDATE Sales.OrderDetails
				SET product_id = @product_id, quantity = @quantity
			END
			ELSE
			BEGIN
				--save record before changing
				INSERT INTO RecordsLog.OrderDetailsHistory (item_id, order_id, product_id, quantity, list_price, discount_id)
				VALUES (@item_id, @order_id, @product_id_old, @quantity_old, @list_price_old, @discount_id_old)
				--update employee_id
				UPDATE Sales.OrderDetails
				SET product_id = @product_id, quantity = @quantity, discount_id = @discount_id
			END
		END
		ELSE
		BEGIN
			IF(@discount_id IS NULL)
			BEGIN
				--save record before changing
				INSERT INTO RecordsLog.OrderDetailsHistory (item_id, order_id, product_id, quantity, list_price, discount_id)
				VALUES (@item_id, @order_id, @product_id_old, @quantity_old, @list_price_old, @discount_id_old)
				--update employee_id
				UPDATE Sales.OrderDetails
				SET product_id = @product_id, list_price = @list_price, quantity = @quantity
			END
			ELSE
			BEGIN
				--save record before changing
				INSERT INTO RecordsLog.OrderDetailsHistory (item_id, order_id, product_id, quantity, list_price, discount_id)
				VALUES (@item_id, @order_id, @product_id_old, @quantity_old, @list_price_old, @discount_id_old)
				--update employee_id
				UPDATE Sales.OrderDetails
				SET product_id = @product_id, quantity = @quantity, list_price = @list_price, discount_id = @discount_id
			END
		END
	END
END
END
END TRY
BEGIN CATCH
	PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')		
END CATCH
END
GO

CREATE OR ALTER PROCEDURE DeleteOrderDetail(@item_id int)
AS
DECLARE @order_id int, @product_id int, @quantity int, @list_price decimal(10, 2), @discount_id int, @result int
BEGIN
BEGIN TRY
EXEC CheckOrderDetailsExists @item_id, @result output
IF (@result = 1)
BEGIN
	SELECT @order_id = order_id, @product_id = product_id, @quantity = quantity, @list_price = list_price, @discount_id = discount_id
	FROM Sales.OrderDetails WHERE item_id = @item_id
	BEGIN TRY
		-- delete record from table
		DELETE FROM Sales.OrderDetails
		WHERE item_id = @item_id
		-- add deleted record to records	
		INSERT INTO RecordsLog.OrderDetailsHistory (item_id, order_id, product_id, quantity, list_price, discount_id)
		VALUES (@item_id, @order_id, @product_id, @quantity, @list_price, @discount_id)
		PRINT 'Order detail deleted'
	END TRY
	BEGIN CATCH
		PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')
	END CATCH
END
ELSE
	PRINT 'Enter a valid item_id'
END TRY
BEGIN CATCH
	PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')		
END CATCH
END
GO
	

