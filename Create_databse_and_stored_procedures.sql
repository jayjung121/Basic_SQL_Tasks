--*************************************************************************--
-- Title: Assignment05
-- Author: ByungSuJung
-- Desc: This file demonstrates how to process data in a database
-- Change Log: When,Who,What
-- 2017-01-01,ByungSuJung,Created File
--**************************************************************************--
-- Step 1: Create the assignment database
Use Master;
go

If Exists(Select Name from SysDatabases Where Name = 'Assignment05DB_ByungSuJung')
 Begin 
  Alter Database [Assignment05DB_ByungSuJung] set Single_user With Rollback Immediate;
  Drop Database Assignment05DB_ByungSuJung;
 End
go

Create Database Assignment05DB_ByungSuJung;
go

Use Assignment05DB_ByungSuJung;
go

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [money] NOT NULL
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Alter Table Categories 
 Add Constraint pkCategories 
  Primary Key (CategoryId);
go

Alter Table Categories 
 Add Constraint ukCategories 
  Unique (CategoryName);
go

Alter Table Products 
 Add Constraint pkProducts 
  Primary Key (ProductId);
go

Alter Table Products 
 Add Constraint ukProducts 
  Unique (ProductName);
go

Alter Table Products 
 Add Constraint fkProductsToCategories 
  Foreign Key (CategoryId) References Categories(CategoryId);
go

Alter Table Products 
 Add Constraint ckProductUnitPriceZeroOrHigher 
  Check (UnitPrice >= 0);
go

Alter Table Inventories 
 Add Constraint pkInventories 
  Primary Key (InventoryId);
go

Alter Table Inventories
 Add Constraint dfInventoryDate
  Default GetDate() For InventoryDate;
go

Alter Table Inventories
 Add Constraint fkInventoriesToProducts
  Foreign Key (ProductId) References Products(ProductId);
go

Alter Table Inventories 
 Add Constraint ckInventoryCountZeroOrHigher 
  Check ([Count] >= 0);
go


-- Show the Current data in the Categories, Products, and Inventories Tables
Select * from Categories;
go
Select * from Products;
go
Select * from Inventories;
go

-- Step 2: Add some starter data to the database

/* Add the following data to this database using inserts:
Category	Product	Price	Date		Count
Beverages	Chai	18.00	2017-01-01	61
Beverages	Chang	19.00	2017-01-01	17

Beverages	Chai	18.00	2017-02-01	13
Beverages	Chang	19.00	2017-02-01	12

Beverages	Chai	18.00	2017-03-02	18
Beverages	Chang	19.00	2017-03-02	12
*/

-------------------From here, the SQL statements are all capitals.-------------------------

INSERT INTO [Assignment05DB_ByungSuJung].dbo.Categories
 ([CategoryName])
 VALUES
 ('Beverages')
 ;
GO

INSERT INTO [Assignment05DB_ByungSuJung].dbo.Products
 ([ProductName], [CategoryID], [UnitPrice])
 VALUES
 ('Chai', 1, 18.00),
 ('Chang', 1, 19.00)
;
GO

INSERT INTO [Assignment05DB_ByungSuJung].dbo.Inventories
 ([InventoryDate], [ProductID], [Count])
 VALUES
 ('2017-01-01', 1, 61),
 ('2017-01-01', 2, 17),
 ('2017-02-01', 1, 13),
 ('2017-02-01', 2, 12),
 ('2017-03-02', 1, 18),
 ('2017-03-02', 2, 12)
 ;
GO


-- Step 3: Create transactional stored procedures for each table using the proviced template:


-- Categories --

CREATE PROCEDURE pInsCategories
(@CategoryName nvarchar(100)
)
/* Author: <ByungSuJung>
** Desc: Create transaction stored procedure which inserts data into Categories table.
** Change Log: When,Who,What
** <2018-07-06>,<ByungSuJung>,Created stored procedure.
*/
AS
 BEGIN
  DECLARE @RC int = 0;
  BEGIN TRY
   BEGIN TRANSACTION 
	INSERT INTO Categories
	([CategoryName])
	VALUES
	(@CategoryName)
   COMMIT TRANSACTION
   SET @RC = +1
  END TRY
  BEGIN CATCH
   IF(@@Trancount > 0) ROLLBACK TRANSACTION
   PRINT Error_Message()
   PRINT Error_Number()
   SET @RC = -1
  END CATCH
  RETURN @RC;
 END
GO

CREATE PROCEDURE pUpdCategories
(@CategoryID int
,@CategoryName nvarchar(100)
)
/* Author: <ByungSuJung>
** Desc: Create transaction stored procedure which update data into Categories table.
** Change Log: When,Who,What
** <2018-07-06>,<ByungSuJung>,Created stored procedure.
*/
AS
 BEGIN
  DECLARE @RC int = 0;
  BEGIN TRY
   BEGIN TRANSACTION 
	UPDATE Categories
	 SET 
	  [CategoryName] = @CategoryName
	 WHERE [CategoryID] = @CategoryID
   COMMIT TRANSACTION
   SET @RC = +1
  END TRY
  BEGIN CATCH
   IF(@@Trancount > 0) ROLLBACK TRANSACTION
   PRINT Error_Message()
   PRINT Error_Number()
   SET @RC = -1
  END CATCH
  RETURN @RC;
 END
GO

CREATE PROCEDURE pDelCategories
(@CategoryID int
)
/* Author: <ByungSuJung>
** Desc: Create transaction stored procedure which delete data into Categories table.
** Change Log: When,Who,What
** <2018-07-06>,<ByungSuJung>,Created stored procedure.
*/
AS
 BEGIN
  DECLARE @RC int = 0;
  BEGIN TRY
   BEGIN TRANSACTION 
	DELETE FROM Categories
	 WHERE CategoryID = @CategoryID
   COMMIT TRANSACTION
   SET @RC = +1
  END TRY
  BEGIN CATCH
   IF(@@Trancount > 0) ROLLBACK TRANSACTION
   PRINT Error_Message()
   PRINT Error_Number()
   SET @RC = -1
  END CATCH
  RETURN @RC;
 END
GO

-- Products --

CREATE PROCEDURE pInsProducts
(@ProductName nvarchar(100)
,@CategoryID int
,@UnitPrice money
)
/* Author: <ByungSuJung>
** Desc: Create transaction stored procedure which insert data into Products table.
** Change Log: When,Who,What
** <2018-07-06>,<ByungSuJung>,Created stored procedure.
*/
AS
 BEGIN
  DECLARE @RC int = 0;
  BEGIN TRY
   BEGIN TRANSACTION 
	INSERT INTO Products
	([ProductName], [CategoryID], [UnitPrice])
	VALUES
	(@ProductName, @CategoryID, @UnitPrice)
   COMMIT TRANSACTION
   SET @RC = +1
  END TRY
  BEGIN CATCH
   IF(@@Trancount > 0) ROLLBACK TRANSACTION
   PRINT Error_Message()
   PRINT Error_Number()
   SET @RC = -1
  END CATCH
  RETURN @RC;
 END
GO


CREATE PROCEDURE pUpdProducts
(@ProductID int
,@ProductName nvarchar(100)
,@CategoryID int
,@UnitPrice money
)
/* Author: <ByungSuJung>
** Desc: Create transaction stored procedure which update data into Products table.
** Change Log: When,Who,What
** <2018-07-06>,<ByungSuJung>,Created stored procedure.
*/
AS
 BEGIN
  DECLARE @RC int = 0;
  BEGIN TRY
   BEGIN TRANSACTION 
	UPDATE Products
	 SET
	  [ProductName] = @ProductName
	 ,[CategoryID] = @CategoryID
	 ,[UnitPrice] = @UnitPrice
	 WHERE [ProductID] = @ProductID
   COMMIT TRANSACTION
   SET @RC = +1
  END TRY
  BEGIN CATCH
   IF(@@Trancount > 0) ROLLBACK TRANSACTION
   PRINT Error_Message()
   PRINT Error_Number()
   SET @RC = -1
  END CATCH
  RETURN @RC;
 END
GO


CREATE PROCEDURE pDelProducts
(@ProductID int
)
/* Author: <ByungSuJung>
** Desc: Create transaction stored procedure which delete data into Products table.
** Change Log: When,Who,What
** <2018-07-06>,<ByungSuJung>,Created stored procedure.
*/
AS
 BEGIN
  DECLARE @RC int = 0;
  BEGIN TRY
   BEGIN TRANSACTION 
	DELETE FROM Products
	 WHERE ProductID = @ProductID
   COMMIT TRANSACTION
   SET @RC = +1
  END TRY
  BEGIN CATCH
   IF(@@Trancount > 0) ROLLBACK TRANSACTION
   PRINT Error_Message()
   PRINT Error_Number()
   SET @RC = -1
  END CATCH
  RETURN @RC;
 END
GO
-- Inventories --

CREATE PROCEDURE pInsInventories
(@InventoryDate date
,@ProductID int
,@Count int
)
/* Author: <ByungSuJung>
** Desc: Create transaction stored procedure which inserts data into Inventories table.
** Change Log: When,Who,What
** <2018-07-06>,<ByungSuJung>,Created stored procedure.
*/
AS
 BEGIN
  DECLARE @RC int = 0;
  BEGIN TRY
   BEGIN TRANSACTION 
	INSERT INTO Inventories
	 ([InventoryDate], [ProductID], [Count])
	VALUES
	 (@InventoryDate, @ProductID, @Count)
   COMMIT TRANSACTION
   SET @RC = +1
  END TRY
  BEGIN CATCH
   IF(@@Trancount > 0) ROLLBACK TRANSACTION
   PRINT Error_Message()
   PRINT Error_Number()
   SET @RC = -1
  END CATCH
  RETURN @RC;
 END
GO


CREATE PROCEDURE pUpdInventories
(@InventoryID int
,@inventoryDate date
,@ProductID int
,@Count int
)
/* Author: <ByungSuJung>
** Desc: Create transaction stored procedure which update data into Inventories table.
** Change Log: When,Who,What
** <2018-07-06>,<ByungSuJung>,Created stored procedure.
*/
AS
 BEGIN
  DECLARE @RC int = 0;
  BEGIN TRY
   BEGIN TRANSACTION
    UPDATE Inventories
	 SET
      [InventoryDate] = @inventoryDate
     ,[ProductID] = @ProductID
     ,[Count] = @Count
	 WHERE [InventoryID] = @InventoryID
   COMMIT TRANSACTION
   SET @RC = +1
  END TRY
  BEGIN CATCH
   IF(@@Trancount > 0) ROLLBACK TRANSACTION
   PRINT Error_Message()
   PRINT Error_Number()
   SET @RC = -1
  END CATCH
  RETURN @RC;
 END
GO


CREATE PROCEDURE pDelInventories
(@InventoryID int
)
/* Author: <ByungSuJung>
** Desc: Create transaction stored procedure which update data into Inventories table.
** Change Log: When,Who,What
** <2018-07-06>,<ByungSuJung>,Created stored procedure.
*/
AS
 BEGIN
  DECLARE @RC int = 0;
  BEGIN TRY
   BEGIN TRANSACTION
	DELETE FROM Inventories
	 WHERE InventoryID = @InventoryID
   COMMIT TRANSACTION
   SET @RC = +1
  END TRY
  BEGIN CATCH
   IF(@@Trancount > 0) ROLLBACK TRANSACTION
   PRINT Error_Message()
   PRINT Error_Number()
   SET @RC = -1
  END CATCH
  RETURN @RC;
 END
GO
-- Step 4: Create code to test each transactional stored procedure. 

------------------------------Insert----------------------------------
-- CATEGORIES --
DECLARE @Status int, @CurrentCategoryID int, @CurrentProductID int;
EXEC @Status = pInsCategories
	 @CategoryName  = 'CAT-A';
SELECT CASE @Status
 WHEN +1 THEN 'Insert was successful'
 WHEN -1 THEN 'Insert failed. Commom issues: Duplicate Data'
 END AS [Status]

SELECT * FROM Categories;

-- PRODUCTS --
SELECT @CurrentCategoryID = MAX(Categories.CategoryID) FROM Categories;
EXEC @Status = pInsProducts
	 @ProductName = 'PROD-A',
	 @CategoryID = @CurrentCategoryID,
	 @UnitPrice = 20.00;
SELECT CASE @Status
 WHEN +1 THEN 'Insert was successful'
 WHEN -1 THEN 'Insert failed. Commom issues: Duplicate Data'
 END AS [Status]

SELECT * FROM Products;

-- INVENTORIES --
SELECT @CurrentProductID = MAX(Products.ProductID) FROM Products;
EXEC @Status = pInsInventories
	 @InventoryDate = '2018-11-25',
	 @ProductID = @CurrentProductID,
	 @Count = 55;
SELECT CASE @Status
 WHEN +1 THEN 'Insert was successful'
 WHEN -1 THEN 'Insert failed. Commom issues: Duplicate Data'
 END AS [Status]

SELECT * FROM Inventories;
GO

-------------------------Update-------------------------------

-- CATEGORIES --
DECLARE @Status int, @CurrentCategoryID  int, @CurrentProductID int, @CurrentInventoryID int;
SELECT @CurrentCategoryID = MAX(Categories.CategoryID) FROM Categories;
EXEC @Status = pUpdCategories
	 @CategoryID = @CurrentCategoryID,
	 @CategoryName = 'CAT-B';
SELECT CASE @Status
 WHEN +1 THEN 'Update was successful'
 WHEN -1 THEN 'Update failed. Commom issues: incorrect type of Data'
 END AS [Status]

SELECT * FROM Categories;

-- PRODUCTS --
SELECT @CurrentProductID = MAX(Products.ProductID) FROM Products;
EXEC @Status = pUpdProducts
	 @ProductID = @CurrentProductID,
	 @ProductName = 'PROD-B',
	 @CategoryID = @CurrentCategoryID,
	 @UnitPrice = 23.00;
SELECT CASE @Status
 WHEN +1 THEN 'Update was successful'
 WHEN -1 THEN 'Update failed. Commom issues: incorrect type of Data'
 END AS [Status]

SELECT * FROM Products;

-- INVENTORIES -- 
SELECT @CurrentInventoryID = MAX(Inventories.InventoryID) FROM Inventories;
EXEC @Status = pUpdInventories
	 @InventoryID = @CurrentInventoryID,
	 @InventoryDate = '2018-03-03',
	 @ProductID = @CurrentProductID,
	 @Count = 100;
SELECT CASE @Status
 WHEN +1 THEN 'Update was successful'
 WHEN -1 THEN 'Update failed. Commom issues: incorrect type of Data'
 END AS [Status]

SELECT * FROM Inventories;
GO

---------------------------Delete-------------------------------
-- INVENTORIES -- 
DECLARE @Status int, @CurrentCategoryID  int, @CurrentProductID int, @CurrentInventoryID int;
SELECT @CurrentInventoryID = MAX(Inventories.InventoryID) FROM Inventories;
EXEC @Status = pDelInventories
	 @InventoryID = @CurrentInventoryID;
SELECT CASE @Status
 WHEN +1 THEN 'Delete was successful'
 WHEN -1 THEN 'Delete failed. Check your code!'
 END AS [Status]

SELECT * FROM Inventories;

-- PRODUCTS --
SELECT @CurrentProductID = MAX(Products.ProductID) FROM Products;
EXEC @Status = pDelProducts
	 @ProductID = @CurrentProductID
SELECT CASE @Status
 WHEN +1 THEN 'Delete was successful'
 WHEN -1 THEN 'Delete failed. Check your code!'
 END AS [Status]

SELECT * FROM Products;

-- CATEGORIES --
SELECT @CurrentCategoryID = MAX(Categories.CategoryID) FROM Categories;
EXEC @Status = pDelCategories
	 @CategoryID = @CurrentCategoryID;
SELECT CASE @Status
 WHEN +1 THEN 'Delete was successful'
 WHEN -1 THEN 'Delete failed. Check your code!'
 END AS [Status]

SELECT * FROM Categories;
GO