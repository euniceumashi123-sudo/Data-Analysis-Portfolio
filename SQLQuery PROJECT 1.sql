-- Question 1
Select Top 10
c.FirstName + ' '+ c.LastName AS FULLNAME,
a.City,
a.CountryRegion AS COUNTRY,
SUM(d.OrderQty * d.UnitPrice) AS
REVENUE 
FROM SalesLT.Customer AS c
INNER JOIN SalesLT.SalesOrderHeader AS h
ON c.CustomerID = h.CustomerID
INNER JOIN SalesLT.SalesOrderDetail AS d
ON h.SalesOrderID = d.SalesOrderID
INNER JOIN SalesLT.Address AS a
ON h.ShipToAddressID = a.AddressID
GROUP BY c.FirstName, c.LastName, a.City, a.CountryRegion
ORDER BY REVENUE DESC;

-- QUESTION 2
Select
c.CustomerID,
c.CompanyName,
SUM(d.OrderQty * d.UnitPrice) AS TotalRevenue,
CASE
WHEN SUM(d.OrderQty * d.UnitPrice)>= 10000 THEN 'DiamondStar'
WHEN SUM(d.OrderQty * d.UnitPrice) BETWEEN 5000 AND 9999 THEN 'PremiumGold'
WHEN SUM(d.OrderQty * d.UnitPrice) BETWEEN 1000 AND 4999 THEN 'PremuimSilver'
ELSE 'Bronze'
END AS Segment
FROM SalesLT.Customer c
INNER JOIN SalesLT.SalesOrderHeader h ON c.CustomerID = h.CustomerID
INNER JOIN SalesLT.SalesOrderDetail d ON h.SalesOrderID = d.SalesOrderID
GROUP BY c.CustomerID, c.CompanyName
ORDER BY TOTALREVENUE DESC;

-- QUESTION 3
WITH LastOrderDate AS
 (SELECT MAX(OrderDate) AS LastOrderDate
FROM SalesLT.SalesOrderHeader)
SELECT
h.CustomerID,
p.ProductID,
p.Name AS ProductName,
pc.Name AS CategoryName,
h.OrderDate
FROM SalesLT.SalesOrderHeader h
INNER JOIN SalesLT.SalesOrderDetail d ON h.SalesOrderID = d.SalesOrderID
INNER JOIN SalesLT.Product p ON d.ProductID = p.ProductID
INNER JOIN SalesLT.ProductCategory  pc ON p.ProductCategoryID = pc.ProductCategoryID
WHERE h.OrderDate = (SELECT OrderDate FROM LastOrderDate)
ORDER BY h.CustomerID;
-- QUESTION 4
Create View
CustomerSegment As
Select
c.CustomerID,
c.CompanyName,
Sum(d.OrderQty * d.UnitPrice) As TotalRevenue,
Case
When Sum(d.OrderQty * d.UnitPrice)>= 10000 Then 'DiamondStar'
When Sum(d.OrderQty * d.UnitPrice) Between 5000 And 9999.99 Then 'PremiumGold'
When Sum(d.OrderQty * d.UnitPrice) Between 1000 And 4999.99 Then 'PremiumSilver'
Else 'Bronze'
End As Segment
From SalesLT.Customer c
JOIN SalesLT.SalesOrderHeader h On c.CustomerID = h.CustomerID
JOIN SalesLT.SalesOrderDetail d On h.SalesOrderID = d.SalesOrderID
GROUP BY c.CustomerID, c.CompanyName;

-- Question 5
With ProductRevenue As (
Select
pc.Name As CategoryName,
p.Name As ProductName,
Sum(d.OrderQty * d.UnitPrice) As Revenue
From SalesLT.SalesOrderDetail d
INNER JOIN SalesLT.Product p On d.ProductID = p.ProductID
INNER JOIN SalesLT.ProductCategory pc On p.ProductCategoryID = pc.ProductCategoryID
Group By pc.Name, p.Name
),
RankedProducts As (
Select *,
Rank() Over (Partition By CategoryName Order By Revenue DESC) As 
RankNum
From ProductRevenue
)
Select
CategoryName,
ProductName,
Revenue,
RankNum
From RankedProducts
Where RankNum <=3
Order By CategoryName, RankNum;



