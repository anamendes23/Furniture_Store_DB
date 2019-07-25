USE VarkFinishedFurniture
GO

/******* Table ProductSupport.Products      Stored Procedures	 	********/

--Verify if product exists
CREATE OR ALTER PROCEDURE CheckProductExists(@product_id int, @result int output)
AS
BEGIN
BEGIN TRY
	IF EXISTS(SELECT product_ID FROM ProductSupport.Products WHERE product_ID = @product_id)
		SET @result = 1
	ELSE
		SET @result = 0
END TRY
BEGIN CATCH
	SET @result = 0
END CATCH
END
GO

--Insertion of new product
CREATE OR ALTER PROCEDURE InsertNewProduct
(
@product_name varchar(50), @product_price decimal(8, 2), @product_qty int,
@product_reorderpoint int, @product_unitissue varchar(25)
)
AS
BEGIN
BEGIN TRY
	INSERT INTO ProductSupport.Products (product_name, product_price, product_qty, product_reorderpoint, product_unitissue)
	VALUES (@product_name, @product_price, @product_qty, @product_reorderpoint, @product_unitissue)
END TRY
BEGIN CATCH
	IF @@ERROR = 544
		PRINT 'table Products IDENTITY_INSERT is set to OFF.'
	ELSE
		PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')
END CATCH
END
GO

--Update of current product
CREATE OR ALTER PROCEDURE UpdateProduct 
(
@product_id int, @product_name varchar(50), @product_price decimal(8, 2), @product_qty int,
@product_reorderpoint int, @product_unitissue varChar(25)
)
AS
DECLARE @product_name_old varchar(50), @product_price_old decimal(8, 2), @product_qty_old int,
@product_reorderpoint_old int, @product_unitissue_old varChar(25), @result int
BEGIN
BEGIN TRY
EXEC CheckProductExists @product_id, @result output
IF(@result = 1)
BEGIN
	SELECT @product_name_old = product_name, @product_price_old = product_price, @product_qty_old = product_qty,
	@product_reorderpoint_old = product_reorderpoint, @product_unitissue_old = product_unitissue
	FROM ProductSupport.Products WHERE product_ID = @product_id

	IF(@product_name IS NULL)
	BEGIN
		SET @product_name = @product_name_old
	END
	IF(@product_price IS NULL)
	BEGIN 
		SET @product_price = @product_price_old
	END
	IF(@product_qty IS NULL)
	BEGIN
		SET @product_qty = @product_qty_old
	END
	IF(@product_reorderpoint IS NULL)
	BEGIN
		SET @product_reorderpoint = @product_reorderpoint_old
	END
	IF(@product_unitissue IS NULL)
	BEGIN
		SET @product_unitissue = @product_unitissue_old
	END
	--execute update
	UPDATE ProductSupport.Products
	SET product_name = @product_name, product_price = @product_price, product_qty = @product_qty, 
	product_reorderpoint = @product_reorderpoint, product_unitissue = @product_unitissue
	WHERE product_ID = @product_id

	INSERT INTO RecordsLog.ProductsHistory (product_ID, product_name, product_price, product_qty, product_reorderpoint, product_unitissue)
	VALUES (@product_id, @product_name_old, @product_price_old, @product_qty_old, @product_reorderpoint_old, @product_unitissue_old)
END
ELSE
	PRINT 'Enter a valid product_id'
END TRY
BEGIN CATCH
	PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')		
END CATCH
END
GO

--Deletion of product
CREATE OR ALTER PROCEDURE DeleteProduct(@product_id int)
AS
DECLARE  @product_name_old varchar(50), @product_price_old decimal(8, 2), @product_qty_old int,
@product_reorderpoint_old int, @product_unitissue_old varChar(25), @result int
BEGIN
BEGIN TRY
	EXEC CheckProductExists @product_id, @result output
	IF(@result = 1)
	BEGIN
		-- add deleted record to records
		SELECT @product_name_old = product_name, @product_price_old = product_price, @product_qty_old = product_qty,
		@product_reorderpoint_old = product_reorderpoint, @product_unitissue_old = product_unitissue
		FROM ProductSupport.Products WHERE product_ID = @product_id
		BEGIN TRY
			-- delete record from table
			DELETE FROM ProductSupport.Products
			WHERE product_ID = @product_id

			INSERT INTO RecordsLog.ProductsHistory (product_ID, product_name, product_price, product_qty, product_reorderpoint, product_unitissue)
			VALUES (@product_id, @product_name_old, @product_price_old, @product_qty_old, @product_reorderpoint_old, @product_unitissue_old)
			PRINT 'Product deleted'
		END TRY
		BEGIN CATCH
		IF @@ERROR = 547
			PRINT 'The product #' + CONVERT(varchar(5), @product_id)+ ' exists in an order. Archive the order first, then try again.'
		ELSE
			PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')
		END CATCH
	END
	ELSE
		PRINT 'Enter a valid product_id'
END TRY
BEGIN CATCH
	PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')		
END CATCH
END
GO

/******* Table ProductSupport.Products      Triggers	 	********/

--check reorder point
CREATE OR ALTER TRIGGER CheckProductReorderPointTrigger
ON ProductSupport.Products
AFTER UPDATE
AS
BEGIN
DECLARE @quantity int, @reorderpoint int, @id int
SELECT @id = product_id, @quantity = product_qty, @reorderpoint = product_reorderpoint FROM inserted
IF(@quantity < @reorderpoint)
	PRINT 'Order more products #' + CONVERT(varchar(5),@id)
END
GO

/******* Table ProductSupport.Parts      Stored Procedures	 	********/

--Verify if part exists
CREATE OR ALTER PROCEDURE CheckPartExists(@part_id int, @result int output)
AS
BEGIN
BEGIN TRY
	IF EXISTS(SELECT part_id FROM ProductSupport.Parts WHERE part_id = @part_id)
		SET @result = 1
	ELSE
		SET @result = 0
END TRY
BEGIN CATCH
	SET @result = 0
END CATCH
END
GO

--inserting new part
CREATE OR ALTER PROCEDURE InsertPart
(
@part_name varchar(50), @part_description varchar(50), @part_price decimal(8, 2), @part_qty int,
@part_reorderpoint int, @part_unitissue varChar(25)
)
AS
BEGIN
BEGIN TRY
	INSERT INTO ProductSupport.Parts (part_name, part_description, part_price, part_qty, part_reorderpoint, part_unitissue)
	VALUES (@part_name, @part_description, @part_price, @part_qty, @part_reorderpoint, @part_unitissue)
END TRY
BEGIN CATCH
	IF @@ERROR = 544
		PRINT 'table Orders IDENTITY_INSERT is set to OFF.'
	ELSE
		PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')
END CATCH
END
GO

--check which product have which part
CREATE OR ALTER PROCEDURE CheckProductPart(@part_id int, @result int output)
AS
BEGIN
DECLARE @MyCursor CURSOR, @product_id int, @partlist_id int, @partlist_summary varchar(1000)
EXEC CheckPartExists @part_id, @result output
IF (@result = 1)
BEGIN
	IF exists(SELECT partlist_id FROM ProductSupport.PartList WHERE part_id = @part_id)
	BEGIN
		SET @partlist_summary = 'SUMMARY PARTLIST - your Part is contained in:'

		SET @MyCursor = CURSOR FOR
		SELECT TOP 1000 partlist_id FROM ProductSupport.Partlist
		WHERE part_id = @part_id

		OPEN @MyCursor 
		FETCH NEXT FROM @MyCursor 
		INTO @partlist_id

		WHILE @@FETCH_STATUS = 0
		BEGIN
		  SELECT @product_id = product_id
		  FROM ProductSupport.Partlist WHERE partlist_id = @partlist_id

		  SET @partlist_summary = @partlist_summary + CHAR(13) + 'Partlist_id: ' + CONVERT(varchar(5),@partlist_id) + ' Product_id: ' + 
		  CONVERT(varchar(5), @product_id)

		  FETCH NEXT FROM @MyCursor 
		  INTO @partlist_id
		END

		CLOSE @MyCursor
		DEALLOCATE @MyCursor

		PRINT @partlist_summary

		SET @result = 0 --false, there are products with the part
	END
	ELSE
		SET @result = 1 --there is no product with the part
END
ELSE
BEGIN
	PRINT 'Enter a valid part_id'
END
END
GO

--deletePart
CREATE OR ALTER PROCEDURE DeletePart (@part_id int)
AS
BEGIN
DECLARE @result int
BEGIN TRY
EXEC CheckProductPart @part_id, @result output
IF(@result = 1)
BEGIN
	--all clear, delete
	DECLARE @part_name_old varchar(50), @part_description_old varchar(50), @part_price_old decimal(8, 2), @part_qty_old int,
	@part_reorderpoint_old int, @part_unitissue_old varChar(25)

	SELECT @part_name_old = part_name, @part_description_old = part_description, @part_price_old = part_price,
	@part_qty_old = part_qty, @part_reorderpoint_old = part_reorderpoint, @part_unitissue_old = part_unitissue
	FROM ProductSupport.Parts WHERE part_id = @part_id
	--delete
	DELETE FROM ProductSupport.Parts
	WHERE part_id = @part_id

	PRINT 'Part deleted'
	--update log
	INSERT INTO RecordsLog.PartsHistory (part_id, part_name, part_description, part_price, part_qty, part_reorderpoint, part_unitissue)
	VALUES (@part_id, @part_name_old, @part_description_old, @part_price_old, @part_qty_old, @part_reorderpoint_old, @part_unitissue_old)
END
ELSE
	PRINT 'Fix these issues and try again.'
END TRY
BEGIN CATCH
SELECT
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_LINE() AS ErrorLine
        ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
END
GO

--Update of current part
CREATE OR ALTER PROCEDURE UpdatePart 
(
@part_id int, @part_name varchar(50), @part_description varchar(50), @part_price decimal(8, 2), @part_qty int,
@part_reorderpoint int, @part_unitissue varChar(25)
)
AS
DECLARE @part_name_old varchar(50), @part_description_old varchar(50), @part_price_old decimal(8, 2), @part_qty_old int,
@part_reorderpoint_old int, @part_unitissue_old varChar(25), @result int
BEGIN
BEGIN TRY
EXEC CheckPartExists @part_id, @result output
IF(@result = 1)
BEGIN
	SELECT @part_name_old = part_name, @part_description_old = part_description, @part_price_old = part_price,
	@part_qty_old = part_qty, @part_reorderpoint_old = part_reorderpoint, @part_unitissue_old = part_unitissue
	FROM ProductSupport.Parts WHERE part_id = @part_id

	IF(@part_name IS NULL)
	BEGIN
		SET @part_name = @part_name_old
	END
	IF(@part_description IS NULL)
	BEGIN 
		SET @part_description = @part_description_old
	END
	IF(@part_price IS NULL)
	BEGIN
		SET @part_price = @part_price_old
	END
	IF(@part_qty IS NULL)
	BEGIN
		SET @part_qty = @part_qty_old
	END
	IF(@part_reorderpoint IS NULL)
	BEGIN
		SET @part_reorderpoint = @part_reorderpoint_old
	END
	IF(@part_unitissue IS NULL)
	BEGIN
		SET @part_unitissue = @part_unitissue_old
	END
	--execute update
	UPDATE ProductSupport.Parts
	SET part_name = @part_name, part_description = @part_description, part_price = @part_price,
	part_qty = @part_qty, part_reorderpoint = @part_reorderpoint, part_unitissue = @part_unitissue
	WHERE part_id = @part_id

	INSERT INTO RecordsLog.PartsHistory (part_id, part_name, part_description, part_price, part_qty, part_reorderpoint, part_unitissue)
	VALUES (@part_id, @part_name_old, @part_description_old, @part_price_old, @part_qty_old, @part_reorderpoint_old, @part_unitissue_old)
END
ELSE
	PRINT 'Enter a valid part_id'
END TRY
BEGIN CATCH
	PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')		
END CATCH
END
GO

/******* Table ProductSupport.Parts      Triggers	 	********/

--check reorder point
CREATE OR ALTER TRIGGER CheckPartReorderPointTrigger
ON ProductSupport.Parts
AFTER UPDATE
AS
BEGIN
DECLARE @quantity int, @reorderpoint int, @id int
SELECT @id = part_id, @quantity = part_qty, @reorderpoint = part_reorderpoint FROM inserted
IF(@quantity < @reorderpoint)
	PRINT 'Order more products #' + CONVERT(varchar(5),@id)
END
GO

/******* Table ProductSupport.Hardware     Stored Procedures	 	********/

--Verify if hardware exists
CREATE OR ALTER PROCEDURE CheckHardwareExists(@hardware_id int, @result int output)
AS
BEGIN
BEGIN TRY
	IF EXISTS(SELECT hardware_id FROM ProductSupport.Hardware WHERE hardware_id = @hardware_id)
		SET @result = 1
	ELSE
		SET @result = 0
END TRY
BEGIN CATCH
	SET @result = 0
END CATCH
END
GO

CREATE OR ALTER PROCEDURE CheckHardwarePart(@hardware_id int, @result int output)
AS
BEGIN
DECLARE @MyCursor CURSOR, @product_id int, @partlist_id int, @partlist_summary varchar(1000)
EXEC CheckHardwareExists @hardware_id, @result output
IF (@result = 1)
BEGIN
	IF exists(SELECT product_id FROM ProductSupport.PartList WHERE hardware_id = @hardware_id)
	BEGIN
		SET @partlist_summary = 'SUMMARY PARTLIST - your Hardware is contained in:'

		SET @MyCursor = CURSOR FOR

		SELECT TOP 1000 partlist_id FROM ProductSupport.Partlist
		WHERE hardware_id = @hardware_id

		OPEN @MyCursor 
		FETCH NEXT FROM @MyCursor 
		INTO @partlist_id

		WHILE @@FETCH_STATUS = 0
		BEGIN
		  SELECT @product_id = product_id
		  FROM ProductSupport.Partlist WHERE partlist_id = @partlist_id
		  SET @partlist_summary = @partlist_summary + CHAR(13) + 'Partlist_id: ' + CONVERT(varchar(5),@partlist_id) + ' Product_id: ' + 
		  CONVERT(varchar(5), @product_id)
		  FETCH NEXT FROM @MyCursor 
		  INTO @partlist_id
		END

		CLOSE @MyCursor
		DEALLOCATE @MyCursor

		PRINT @partlist_summary

		SET @result = 0 --false, there are products with the hardware
	END
	ELSE
		SET @result = 1 --there is no product with the hardware
END
ELSE
BEGIN    
	PRINT 'Enter a valid hardware_id'
END
END
GO

--Insertion of new hardware
CREATE OR ALTER PROCEDURE InsertNewHardware
(
@hardware_name varchar(50), @hardware_description varchar(100), @hardware_price decimal(6, 2),
@hardware_qty int, @hardware_reorderpoint int, @hardware_unitissue varchar(25)
)
AS
BEGIN
BEGIN TRY
	INSERT INTO ProductSupport.Hardware (hardware_name, hardware_description, hardware_price, hardware_qty, hardware_reorderpoint, hardware_unitissue)
	VALUES (@hardware_name, @hardware_description, @hardware_price, @hardware_qty, @hardware_reorderpoint, @hardware_unitissue)
END TRY
BEGIN CATCH
	IF @@ERROR = 544
		PRINT 'table Hardware IDENTITY_INSERT is set to OFF.'
	ELSE
		PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')
END CATCH
END
GO

--Deletion of hardware
CREATE OR ALTER PROCEDURE DeleteHardware(@hardware_id int)
AS
BEGIN
BEGIN TRY
DECLARE @result int
	EXEC CheckHardwarePart @hardware_id, @result output
	IF(@result = 1)
	BEGIN
		--all clear, delete
		DECLARE @hardware_name_old varchar(50), @hardware_description_old varchar(100), @hardware_price_old decimal(6, 2),
		@hardware_qty_old int, @hardware_reorderpoint_old int, @hardware_unitissue_old varchar(25)

		SELECT @hardware_name_old = hardware_name, @hardware_description_old = hardware_description, @hardware_price_old = hardware_price,
		@hardware_qty_old = hardware_qty, @hardware_reorderpoint_old = hardware_reorderpoint, @hardware_unitissue_old = hardware_unitissue
		FROM ProductSupport.Hardware WHERE hardware_id = @hardware_id
		--delete
		DELETE FROM ProductSupport.Hardware
		WHERE hardware_id = @hardware_id

		INSERT INTO RecordsLog.HardwareHistory(hardware_id, hardware_name, hardware_description, hardware_price, hardware_qty, hardware_reorderpoint, hardware_unitissue)
		VALUES (@hardware_id, @hardware_name_old, @hardware_description_old, @hardware_price_old, @hardware_qty_old, @hardware_reorderpoint_old, @hardware_unitissue_old)
		PRINT 'Hardware deleted'
	END
	ELSE
		PRINT 'Fix these issues and try again.'
END TRY
BEGIN CATCH
SELECT
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_LINE() AS ErrorLine
        ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
END
GO

--Update of current hardware
CREATE OR ALTER PROCEDURE UpdateHardware 
(
@hardware_id int, @hardware_name varchar(20), @hardware_description varchar(100), 
@hardware_price decimal(8,2), @hardware_qty int, @hardware_reorderpoint int, @hardware_unitissue varchar(25)
)
AS
DECLARE @hardware_name_old varchar(20), @hardware_description_old varchar(100), @hardware_price_old decimal(8,2), @hardware_qty_old int, 
@hardware_reorderpoint_old int, @hardware_unitissue_old varchar(25), @result int
BEGIN
BEGIN TRY
EXEC CheckHardwareExists @hardware_id, @result output
IF(@result = 1)
BEGIN --check if enter is NULL. if yes, use old value
	SELECT @hardware_name_old = hardware_name, @hardware_description_old = hardware_description, @hardware_price_old = hardware_price,
	@hardware_qty_old = hardware_qty, @hardware_reorderpoint_old = hardware_reorderpoint, @hardware_unitissue_old = hardware_unitissue
	FROM ProductSupport.Hardware WHERE hardware_id = @hardware_id
	
	IF(@hardware_name IS NULL)
	BEGIN
		SET @hardware_name = @hardware_name_old
	END
	IF(@hardware_description IS NULL)
	BEGIN 
		SET @hardware_description = @hardware_description_old
	END
	IF(@hardware_price IS NULL)
	BEGIN
		SET @hardware_price = @hardware_price_old
	END
	IF(@hardware_qty IS NULL)
	BEGIN
		SET @hardware_qty = @hardware_qty_old
	END
	IF(@hardware_reorderpoint IS NULL)
	BEGIN
		SET @hardware_reorderpoint = @hardware_reorderpoint_old
	END
	IF(@hardware_unitissue IS NULL)
	BEGIN 
		SET @hardware_unitissue = @hardware_unitissue_old
	END
	--execute update
	UPDATE ProductSupport.Hardware
	SET hardware_name = @hardware_name, hardware_description = @hardware_description, hardware_price = @hardware_price, hardware_qty = @hardware_qty,
	hardware_reorderpoint = @hardware_reorderpoint, hardware_unitissue = @hardware_unitissue
	WHERE hardware_id = @hardware_id

	INSERT INTO RecordsLog.HardwareHistory(hardware_id, hardware_name, hardware_description, hardware_price, hardware_qty, hardware_reorderpoint, hardware_unitissue)
	VALUES (@hardware_id, @hardware_name, @hardware_description, @hardware_price, @hardware_qty, @hardware_reorderpoint, @hardware_unitissue)	
END
ELSE
		PRINT 'Enter a valid hardware_id'
END TRY
BEGIN CATCH
	PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')		
END CATCH
END
GO

/******* Table ProductSupport.Hardware      Triggers	 	********/

--check reorder point
CREATE OR ALTER TRIGGER CheckHardwareReorderPointTrigger
ON ProductSupport.Hardware
AFTER UPDATE
AS
BEGIN
DECLARE @quantity int, @reorderpoint int, @id int
SELECT @id = hardware_id, @quantity = hardware_qty, @reorderpoint = hardware_reorderpoint FROM inserted
IF(@quantity < @reorderpoint)
	PRINT 'Order more products #' + CONVERT(varchar(5),@id)
END
GO

/******* Table ProductSupport.Partlist       Stored Procedures	 	********/

--Verify if part exists
CREATE OR ALTER PROCEDURE CheckPartListExists(@partlist_id int, @result int output)
AS
BEGIN
BEGIN TRY
	IF EXISTS(SELECT partlist_id FROM ProductSupport.PartList WHERE partlist_id = @partlist_id)
		SET @result = 1
	ELSE
		SET @result = 0
END TRY
BEGIN CATCH
	SET @result = 0
END CATCH
END
GO

--insert new product line into partlist
CREATE OR ALTER PROCEDURE InsertPartList(@product_id int, @hardware_id int, @part_id int, @partlist_qty int, @hardwarelist_qty int)
AS
BEGIN
BEGIN TRY
	INSERT INTO ProductSupport.Partlist(product_id, hardware_id, part_id, partlist_qty, hardwarelist_qty) 
	VALUES (@product_id, @hardware_id, @part_id, @partlist_qty, @hardwarelist_qty)
END TRY
BEGIN CATCH
	IF @@ERROR = 544
		PRINT 'table PartList IDENTITY_INSERT is set to OFF.'
	ELSE
		PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')
END CATCH
END
GO

--delete product from partlist
CREATE OR ALTER PROCEDURE DeleteProductPartlist (@partlist_id int)
AS
BEGIN
DECLARE @result int
BEGIN TRY
EXEC CheckPartListExists @partlist_id, @result output
IF(@result = 1)
BEGIN
	--all clear, delete
	DECLARE @product_id_old int, @hardware_id_old int, @part_id_old int, @partlist_qty_old int, @hardwarelist_qty_old int

	SELECT @product_id_old = product_id, @hardware_id_old = hardware_id, @part_id_old = part_id,
	@partlist_qty_old = partlist_qty, @hardwarelist_qty_old = hardwarelist_qty
	FROM ProductSupport.PartList WHERE partlist_id = @partlist_id
	--delete
	DELETE FROM ProductSupport.PartList
	WHERE partlist_id = @partlist_id

	PRINT 'Part deleted'
	--update log
	INSERT INTO RecordsLog.PartlistHistory (partlist_id, product_id, hardware_id, part_id, partlist_qty, hardwarelist_qty)
	VALUES (@partlist_id, @product_id_old, @hardware_id_old, @part_id_old, @partlist_qty_old, @hardwarelist_qty_old)
END
ELSE
	PRINT 'Enter a valid partlist_id'
END TRY
BEGIN CATCH
SELECT
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_LINE() AS ErrorLine
        ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
END
GO

--Update of current product
CREATE OR ALTER PROCEDURE UpdatePartList 
(
@partlist_id int, @product_id int, @hardware_id int, @part_id int, @partlist_qty int, @hardwarelist_qty int
)
AS
DECLARE @product_id_old int, @hardware_id_old int, @part_id_old int, @partlist_qty_old int, @hardwarelist_qty_old int, @result int
BEGIN
BEGIN TRY
EXEC CheckPartListExists @partlist_id, @result output
IF(@result = 1)
BEGIN
	SELECT @product_id_old = product_id, @hardware_id_old = hardware_id, @part_id_old = part_id,
	@partlist_qty_old = partlist_qty, @hardwarelist_qty_old = hardwarelist_qty
	FROM ProductSupport.PartList WHERE partlist_id = @partlist_id

	IF(@product_id IS NULL)
	BEGIN
		SET @product_id = @product_id_old
	END
	IF(@hardware_id IS NULL)
	BEGIN 
		SET @hardware_id = @hardware_id_old
	END
	IF(@part_id IS NULL)
	BEGIN
		SET @part_id = @part_id_old
	END
	IF(@partlist_qty IS NULL)
	BEGIN
		SET @partlist_qty = @partlist_qty_old
	END
	IF(@hardwarelist_qty IS NULL)
	BEGIN
		SET @hardwarelist_qty = @hardwarelist_qty_old
	END
	--execute update
	UPDATE ProductSupport.Partlist
	SET product_id = @product_id, hardware_id = @hardware_id, part_id = @part_id, partlist_qty = @partlist_qty, hardwarelist_qty = @hardwarelist_qty
	WHERE partlist_id = @partlist_id
	--update log
	INSERT INTO RecordsLog.PartlistHistory (partlist_id, product_id, hardware_id, part_id, partlist_qty, hardwarelist_qty)
	VALUES (@partlist_id, @product_id_old, @hardware_id_old, @part_id_old, @partlist_qty_old, @hardwarelist_qty_old)
END
ELSE
	PRINT 'Enter a valid partlist_id'
END TRY
BEGIN CATCH
	PRINT 'Error Line #'+convert(varchar,ERROR_LINE()) + ' of procedure '+isnull(ERROR_PROCEDURE(),'(Main)')		
END CATCH
END
GO