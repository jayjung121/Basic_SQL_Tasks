--*************************************************************************--
-- Title: Assignment04
-- Author: Byung Su Jung
-- Desc: This file demonstrates how to process data in a database
-- Change Log: When,Who,What
-- 2017-01-01,Byung Su JUng,Created File
--**************************************************************************--
Use Master;
go

If Exists(Select Name from SysDatabases Where Name = 'Assignment04DB_ByungSuJung')
 Begin 
  Alter Database [Assignment04DB_ByungSuJung] set Single_user With Rollback Immediate;
  Drop Database Assignment04DB_ByungSuJung;
 End
go

Create Database Assignment04DB_ByungSuJung;
go

Use Assignment04DB_ByungSuJung;
go

-- Add Your Code Below ---------------------------------------------------------------------


-- Data Request: 0301
-- Request: I want a list of customer companies and their contact people
/*
  -- Columns
  c.CompanyName
  c.ContactName

  -- Tables
  Northwind.dbo.Customers
*/

Create View vCustomerContacts
As
Select
 c.CompanyName,
 c.ContactName
From Northwind.dbo.Customers As c;
Go

Select * from vCustomerContacts
Order By CompanyName;
Go
-- Data Request: 0302
-- Request: I want a list of customer companies and their contact people, but only the ones in US and Canada
/*
  -- Columns
  c.CompanyName
  c.ContactName
  c.Country

  -- Tables
  Northwind.dbo.Customers
*/

Create --Drop
View vUSAandCanadaCustomerContacts
As
Select
  c.CompanyName,
  c.ContactName,
  c.Country
From Northwind.dbo.Customers As c
Where c.Country = 'USA' Or c.Country = 'Canada'
;
Go

Select * from vUSAandCanadaCustomerContacts
Order By Country, CompanyName;
Go
  
-- Data Request: 0303
-- Request: I want a list of products, their standard price and their categories. 
-- Order the results by Category Name and then Product Name, in alphabetical order.
/*
  -- Columns 
  c.CategoryName
  p.ProductName
  p.UnitPrice

  -- Tables
  Northwind.dbo.Products 
  Northwind.dbo.Categories

  -- Connections
  ???
*/

Create -- Drop
View vProductPricesByCategories
As
Select
  [CategoryName] = c.CategoryName,
  [ProductName] =  p.ProductName,
  [StandardPrice] = Format(p.UnitPrice, 'c', 'en-us')
From Northwind.dbo.Products As p
Join Northwind.dbo.Categories As c
On p.CategoryID = c.CategoryID
;
Go

Select * from vProductPricesByCategories
Order By CategoryName, ProductName;
Go

-- Data Request: 0323
-- Request: I want a list of products, their standard price and their categories. 
-- Order the results by Category Name and then Product Name, in alphabetical order but only for the seafood category
/*
  -- Columns 
  c.CategoryName
  p.ProductName
  p.UnitPrice

  -- Tables
  Northwind.dbo.Products 
  Northwind.dbo.Categories

  -- Connections
  ???
*/

Create -- Drop
Function dbo.fProductPricesByCategories(@CategoryName nvarchar(100))
 Returns Table
  As
	Return(
	 Select
		[Category Name] = c.CategoryName, 
	    [Product Name] = p.ProductName, 
		[Standard Price] = Format(p.UnitPrice, 'c', 'en-us')
	  From Northwind.dbo.Products As p
	  Join Northwind.dbo.Categories As c
	  ON p.CategoryID = c.CategoryID
	 Where CategoryName = @CategoryName
	  );
Go

Select * from dbo.fProductPricesByCategories('Seafood')
Order By [Category Name], [Product Name];
Go
-- Data Request: 0317
-- Request: I want a list of how many orders our customers have placed each year
/*
  -- Columns
  c.CompanyName
  od.OrderID
  o.OrderDate

  -- Tables
  Northwind.dbo.Customers
  Northwind.dbo.Orders

  -- Connections
  ???

  -- Functions
  Year()
  Count() 
*/

Create -- Drop
View vCustomerOrderCounts
As
Select
  [CompanyName] = c.CompanyName,
  [NumberOfOrders] = Count(o.OrderID),
  [Order Year] = Year(o.OrderDate)
From Northwind.dbo.Orders as o
Join Northwind.dbo.Customers as c
On o.CustomerID = c.CustomerID
Group By 
 CompanyName,
 Year(o.OrderDate)
;

Select * from vCustomerOrderCounts
Order By CompanyName;
Go

-- Data Request: 0318
-- Request: I want a list of total order dollars our customers have placed each year
/*
  -- Columns
  c.CompanyName
  od.OrderID
  od.Quantity
  od.UnitPrice
  o.OrderDate

  -- Tables
  Northwind.dbo.Customers
  Northwind.dbo.Orders
  Northwind.dbo.[Order Details]

  -- Connections
  ???

  -- Functions
  Year()
  Count() 
  Sum()
  Format()
*/

Create -- Drop
View vCustomerOrderDollars
As
Select
  [CompanyName] = c.CompanyName,
  [Total Dollars] = Format(Sum((od.Quantity * od.UnitPrice)), 'c', 'en-us'),
  [Order Year] = Year(o.OrderDate)
From Northwind.dbo.Orders as o
Join Northwind.dbo.Customers as c
On o.CustomerID = c.CustomerID
Join Northwind.dbo.[Order Details] as od
On o.OrderID = od.OrderID
Group By c.CompanyName, Year(o.OrderDate)
;
Go

Select * from vCustomerOrderDollars
Order By CompanyName;

