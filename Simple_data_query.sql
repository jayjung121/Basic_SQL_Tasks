--*************************************************************************--
-- Title: Assignment03
-- Author: Byung Su Jung
-- Desc: This file demonstrates how to select data from a database
-- Change Log: When,Who,What
-- 2017-06-26,ByungSuJung,Created File
--**************************************************************************--


/********************************* Questions and Answers *********************************/
-- Data Request: 0301
-- Date: 1/1/2020
-- From: Jane Encharge CEO
-- Request: I want a list of customer companies and their contact people
-- Needed By: ASAP

SELECT CompanyName, ContactName
FROM Northwind.dbo.Customers
GO

-- Data Request: 0302
-- Date: 1/2/2020
-- From: Jane Encharge CEO
-- Request: I want a list of customer companies and their contact people, but only the ones in US and Canada
-- Needed By: ASAP

SELECT CompanyName, ContactName, Country
FROM Northwind.dbo.Customers
WHERE Country = 'USA' or Country = 'Canada'
ORDER BY Country, CompanyName;
GO

-- Data Request: 0303
-- Date: 1/2/2020
-- From: Jane Encharge CEO
-- Request: I want a list of products, their standard price and their categories. Order the results by Category Name 
-- and then Product Name, in alphabetical order
-- Needed By: ASAP


SELECT CategoryName, ProductName, [Standard Price] = FORMAT (UnitPrice, 'C', 'en-us')
FROM Northwind.dbo.Products
JOIN Northwind.dbo.Categories
ON Products.CategoryID = Categories.CategoryID
ORDER BY CategoryName, ProductName
GO

-- Data Request: 0304
-- Date: 1/3/2020
-- From: Jane Encharge CEO
-- Request: I want a list of how many customers we have in the US
-- Needed By: ASAP


SELECT [Count] = COUNT(CustomerID), [Country] = 'USA'
FROM Northwind.dbo.Customers
WHERE Country = 'USA'
GO

-- Data Request: 0305
-- Date: 1/4/2020
-- From: Jane Encharge CEO
-- Request: I want a list of how many customers we have in the US and Canada, with subtotals for each
-- Needed By: ASAP

SELECT [Count] = COUNT(CustomerID) ,[Country] = 'USA'
 FROM Northwind.dbo.Customers 
 WHERE Customers.Country = 'USA'
 UNION
 SELECT [Count] = COUNT(CustomerID), [Country] = 'Canada'
 FROM Northwind.dbo.Customers 
 WHERE Customers.Country = 'Canada'
 GO
 


-- Data Request: 0306
-- Date: 1/4/2020
-- From: Jane Encharge CEO
-- Request: I want a list of products ordered by the Price highest to the lowest. Only products that have a price Greater than $100. 
-- Needed By: ASAP

SELECT *
FROM Northwind.dbo.Products
JOIN Northwind.dbo.[Order Details]
ON Products.ProductID = [Order Details].ProductID
WHERE Products.UnitPrice > 100
ORDER BY Products.UnitPrice DESC



/***************************************************************************************/