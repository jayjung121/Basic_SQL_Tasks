--*************************************************************************--
-- Title: Info 340 - Module 02: Writing SQL code
-- Author: Byung Su Jung
-- Desc: This file creates database with orders, products and orderproducts(bridge)
--		 categories and subcategories tables.
-- Change Log: When,Who,What
-- 2018-06-24,Byung Su Jung,Created File
--**************************************************************************--


Create Database Assignment02DB_ByungSuJung;
Go

Use Assignment02DB_ByungSuJung;
Go

Create -- Drop
Table dbo.Orders(
	OrderID int Identity (1,1) Not Null,
	[OrderDate] datetime Not Null
	Constraint pkOrders Primary Key Clustered(
		OrderID
	)
	Constraint ckDateIsTodayOrLesser Check ([OrderDate] <= getdate())
	Constraint dfToday Default (getdate())
);
Go

Create -- Drop
Table dbo.Products(
	ProductID int Identity (1,1) Not Null,
	ProductSubcategoryID int Not Null,
	ProductName nvarchar (50) Not Null
	Constraint pkProducts Primary Key Clustered(
		ProductID
	)
);
Go

Alter Table dbo.Products
	Add	Constraint fkProducts_ProductSubcategories Foreign Key(
		ProductSubcategoryID
	) References dbo.ProductSubcategories(
		ProductSubcategoryID
	);
Go

Create -- Drop
Table dbo.ProductCategories(
	ProductCategoryID int Identity (1,1) Not Null,
	ProductCategory nvarchar (100) Not Null
	Constraint pkProductCategories Primary Key Clustered(
		ProductCategoryID
	)
);
Go

Create -- Drop
Table dbo.ProductSubcategories(
	ProductSubcategoryID int Identity (1,1) Not Null,
	ProductCategoryID int Not Null,
	ProductSubcategory nvarchar (100) Not Null,
	Constraint pkProductSubcategories Primary Key Clustered(
		ProductSubcategoryID
	)
);
Go

Alter Table dbo.ProductSubcategories
	Add Constraint fkProductSubcategories_ProductCategories Foreign Key(
		ProductCategoryID
	) References dbo.ProductCategories(
		ProductCategoryID
	)
Go

Create -- Drop
Table dbo.OrderProducts(
	OrderID int Not Null,
	ProductID int Not Null,
	Quantity smallint Not Null
	Constraint pkOrderProducts Primary Key Clustered(
		OrderID,
		ProductID
	)
	Constraint dfQuantity Default (1)
	Constraint ckQuantity Check (Quantity >= 1)
);
Go
Alter Table dbo.OrderProducts
	Add Constraint fkOrderProducts_Orders Foreign Key(
		OrderID
	) References dbo.Orders(
		OrderID
	);
Go

Alter Table dbo.OrderProducts
	Add Constraint fkOrderProducts_Products Foreign Key(
		ProductID
	) References dbo.Products(
		ProductID
	);
Go


Insert Into ProductCategories Values ('Bike')
Insert Into ProductSubcategories Values (1,'Road Bikes')
Insert Into Products Values (1, 'Road-150 Red, 62')
Insert Into Orders Values (2005-07-01)
Insert Into OrderProducts Values (1,1,1)
Go

Create View dbo.vOrders
As
Select [OrderID] 
	  ,[OrderDate]
From dbo.Orders;
Go

Create View dbo.vProducts
As
Select [ProductID]
      ,[ProductSubcategoryID]
      ,[ProductName]
From dbo.Products;
Go

Create View dbo.vOrderProducts
As
Select [OrderID]
      ,[ProductID]
      ,[Quantity]
From dbo.OrderProducts;
Go

Create View dbo.vProductCategories
As
Select [ProductCategoryID]
      ,[ProductCategory]
From dbo.ProductCategories;
Go

Create View dbo.vProductSubcategories
As
Select [ProductSubcategoryID]
      ,[ProductCategoryID]
      ,[ProductSubcategory]
From dbo.ProductSubcategories;
Go