/* 
	When we do ETL, a common requirement is to normalize the raw data so that
    the normalized data can be used for further processing and/or analysis.
    The SQL UNPIVOT command is frequently used for this task.
*/


CREATE DATABASE SQLUNPIVOT;
GO

USE SQLUNPIVOT;

-- Create lab table
CREATE TABLE [dbo].[Products](
	[ProductID] [int] NULL,
	[Name] [varchar](50) NULL,
	[UnitPrice] [money] NULL,
	[Color1] [varchar](20) NULL,
	[Color2] [varchar](20) NULL,
	[Color3] [varchar](20) NULL,
	[Color4] [varchar](20) NULL,
	[Color5] [varchar](20) NULL
	) ON [PRIMARY]
GO

-- Insert data into the lab table

INSERT [dbo].[Products] ([ProductID], [Name], [UnitPrice], [Color1], [Color2], [Color3], [Color4], [Color5]) VALUES (520, N'LL Touring Seat Assembly', 133.3400, N'Yellow', N'Red', N'Green', NULL, NULL)
GO
INSERT [dbo].[Products] ([ProductID], [Name], [UnitPrice], [Color1], [Color2], [Color3], [Color4], [Color5]) VALUES (680, N'HL Road Frame - Black, 58', 1431.5000, N'Black', N'White', N'Red', N'Purple', N'Brown')
GO
INSERT [dbo].[Products] ([ProductID], [Name], [UnitPrice], [Color1], [Color2], [Color3], [Color4], [Color5]) VALUES (720, N'HL Road Frame - Red, 52', 1431.5000, N'Red', N'Pink', N'Black', N'Green', NULL)
GO
INSERT [dbo].[Products] ([ProductID], [Name], [UnitPrice], [Color1], [Color2], [Color3], [Color4], [Color5]) VALUES (760, N'Road-650 Red, 60', 782.9900, N'Red', N'Yellow', N'Purple', N'Silver', N'Green')
GO
INSERT [dbo].[Products] ([ProductID], [Name], [UnitPrice], [Color1], [Color2], [Color3], [Color4], [Color5]) VALUES (800, N'Road-550-W Yellow, 44', 1120.4900, N'Yellow', N'White', N'Black', NULL, NULL)
GO
INSERT [dbo].[Products] ([ProductID], [Name], [UnitPrice], [Color1], [Color2], [Color3], [Color4], [Color5]) VALUES (840, N'HL Road Frame - Black, 52', 1431.5000, N'Black', N'Red', N'Yellow', N'Pink', N'Brown')
GO
INSERT [dbo].[Products] ([ProductID], [Name], [UnitPrice], [Color1], [Color2], [Color3], [Color4], [Color5]) VALUES (880, N'Hydration Pack - 70 oz.', 54.9900, N'Silver', N'White', N'Red', N'Green', N'Black')
GO
INSERT [dbo].[Products] ([ProductID], [Name], [UnitPrice], [Color1], [Color2], [Color3], [Color4], [Color5]) VALUES (920, N'LL Mountain Frame - Silver, 52', 264.0500, N'Silver', N'Black', N'Gold', N'Purple', N'Red')
GO
INSERT [dbo].[Products] ([ProductID], [Name], [UnitPrice], [Color1], [Color2], [Color3], [Color4], [Color5]) VALUES (960, N'Touring-3000 Blue, 62', 742.3500, N'Blue', N'Yellow', N'Red', N'Silver', NULL)
GO

-- Lab Question

/* 
	Write SQL code to extract data from [dbo].[Products] and create two new tables,
	Product and Color, which contain the normalized data. 
*/

SELECT * FROM [Products];

-- Create Color table
CREATE TABLE [dbo].[Color]
	(
		[ProductID] [int] NULL,
		[Color] [varchar](20) NULL
	)
GO

-- Create Product table
CREATE TABLE [dbo].[Product]
	(
		[ProductID] [int] NULL,
		[ProductName] [varchar](50) NULL,
		[UnitPrice] [money] NULL,
	)
GO

-- Use SQL UNPIVOT to produce a (normalized) report and insert into table
INSERT INTO Color ([ProductID], [Color])
SELECT [ProductID], [Color]
FROM
(
  SELECT [ProductID], [Color1], [Color2], [Color3], [Color4], [Color5]
  FROM [dbo].[Products]
) AS Color
UNPIVOT 
(
  [Color] FOR Col IN ([Color1], [Color2], [Color3], [Color4], [Color5])
  /* Create a new row for every value found in the columns 
     Color1, Color2, Color3, Color4 and Color5 */

) AS ColorList;
GO

-- Use SQL UNPIVOT to produce a (normalized) report and insert into table
INSERT INTO Product ([ProductID], [ProductName], [UnitPrice])
SELECT [ProductID], [ProductName], [UnitPrice]
FROM
(
  SELECT [ProductID], [Name], [UnitPrice]
  FROM [dbo].[Products]
) AS Product
UNPIVOT 
(
  [ProductName] FOR Names IN ([Name])
) AS ProductList;
GO

-- Do housekeeping

USE Master;

DROP DATABASE SQLUNPIVOT;