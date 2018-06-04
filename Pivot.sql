USE AdventureWorks2012
GO

/* 
	Script uses the PIVOT command to convert the output of the following query (long format)
	to a report which has the short format listed below. 
*/

SELECT DATENAME(mm, OrderDate) AS [Month], CustomerID, COUNT(SalesOrderID) AS TotalOrder
FROM Sales.SalesOrderHeader
WHERE CustomerID BETWEEN 30010 AND 30020
GROUP BY CustomerID, DATENAME(mm, OrderDate), MONTH(OrderDate)
ORDER BY MONTH(OrderDate);

/* Hint: Use ORDER BY MONTH([Month]+ ' 1 2018') for sorting */

SELECT * FROM 
(	
	SELECT DATENAME(mm, OrderDate) AS [Month], CustomerID, SalesOrderID
	FROM Sales.SalesOrderHeader
	WHERE CustomerID BETWEEN 30010 AND 30020
	GROUP BY CustomerID, DATENAME(mm, OrderDate), MONTH(OrderDate), SalesOrderID
) AS SourceTable
PIVOT
(
COUNT (SalesOrderID)
FOR CustomerID IN
(
	[30010], [30011], [30012], [30013], [30014], [30015], [30016], [30017], [30018], [30019], [30020] )
) AS PivotTable
ORDER BY MONTH([Month]+ ' 1 2018');

/* 
	We can accomplish the same thing using a common table expression 
*/
WITH CTE
AS
(
	SELECT * FROM 
	(	
		SELECT DATENAME(mm, OrderDate) AS [Month],CustomerID,SalesOrderID
		FROM Sales.SalesOrderHeader
		WHERE CustomerID BETWEEN 30010 AND 30020
		GROUP BY CustomerID, DATENAME(mm, OrderDate), MONTH(OrderDate), SalesOrderID
	) SourceTable
	PIVOT
	(
	COUNT(SalesOrderID)
	FOR CustomerID IN
	( 
		[30010], [30011], [30012], [30013], [30014], [30015], [30016], [30017], [30018], [30019], [300120]  )
	) AS PivotTable
)
SELECT * FROM CTE
-- Ability to use GROUP BY command with CTE
-- GROUP BY CTE.[Month], CTE.[30010], CTE.[30011], CTE.[30012], CTE.[30013], CTE.[30014], CTE.[30015], CTE.[30016], CTE.[30017], CTE.[30018], CTE.[30019], CTE.[300120] 
ORDER BY MONTH([Month] + ' 1 2018');