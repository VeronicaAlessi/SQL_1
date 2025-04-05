use AdventureWorksDW
-- es. 1
D.productkey
, D.EnglishProductName
, S.productsubcategorykey
, S.EnglishProductSubcategoryName
from dimproduct as D 
inner join dimproductsubcategory as S
on D.productsubcategorykey = S.productsubcategorykey

-- es.2
 
select
D.productkey
, D.EnglishProductName
, S.productsubcategorykey
, S.EnglishProductSubcategoryName
from dimproduct as D 
left outer join dimproductsubcategory as S
on D.productsubcategorykey = S.productsubcategorykey

-- es.3

select
D.productkey
, D.EnglishProductName
, S.productsubcategorykey
, S.EnglishProductSubcategoryName
, C.productcategorykey
, C.EnglishProductCategoryName
from dimproduct as D 
inner join dimproductsubcategory as S
on D.productsubcategorykey = S.productsubcategorykey
inner join dimproductcategory as C
on S.productcategorykey = C.productcategorykey;

-- es.4

select 
D.EnglishProductName
, D.ProductKey
from dimproduct as D
inner join factresellersales as S
on D.productkey = S.productkey

-- es.5

select 
D.productkey
, D.EnglishProductName
, D.FinishedGoodsFlag
from dimproduct as D
left outer join factresellersales as S
on D.productkey = S.productkey
where D.FinishedGoodsFlag = 1 
and S.productkey is null;

-- es.6 

select 
D.productkey
, D.EnglishProductName
, S.*
from dimproduct as D
inner join factresellersales as S
on D.productkey = S.productkey;

-- es.7

select 
D.productkey
, D.EnglishProductName
, C.productcategorykey
, C.EnglishProductSubcategoryName
, S.productcategorykey
, S.EnglishProductSubcategoryName
, F.*
from dimproduct as D
inner join dimproductsubcategory as S
on D.ProductSubcategoryKey = S.ProductSubcategoryKey
inner join factresellersales as F
on D.productkey = F.productkey
inner join dimproductsubcategory as C
on S.productcategorykey = C.productcategorykey
where year (orderdate) between 2019 and 2020

-- es.8

select 
S.ResellerKey
, S.GeographyKey
, S.ResellerName
, G.EnglishCountryRegionName
, G.City
, T.*
from dimreseller as S
left join dimgeography as G
on S.GeographyKey = G.GeographyKey
LEFT JOIN 
dimsalesterritory AS T
ON T.SalesTerritoryKey = G.SalesTerritoryKey;

-- es.9

SELECT
A.*
, A.SalesAmount - A.TotalProductCost AS Markup
, PC.EnglishProductCategoryName AS ProductCategory
, R.ResellerName
, G.EnglishCountryRegionName
FROM (
SELECT 
P.ProductKey
, P.ProductSubcategoryKey
, RS.SalesOrderNumber
, SalesOrderLineNumber
, RS.OrderDate
, RS.UnitPrice
, RS.OrderQuantity
-- , RS.TotalProductCost
, CASE WHEN RS.TotalProductCost IS NULL THEN P.StandardCost*RS.OrderQuantity 
		ELSE RS.TotalProductCost END AS TotalProductCost
, RS.SalesAmount
, RS.ResellerKey
/*, P.StandardCost
, RS.TotalProductCost/RS.OrderQuantity
, (RS.TotalProductCost/RS.OrderQuantity)-P.StandardCost AS DIFF*/
FROM factresellersales AS RS
LEFT OUTER JOIN 
dimproduct AS P 
ON RS.ProductKey = P.ProductKey
) as A
left join dimproductsubcategory AS PS
ON PS.ProductSubcategoryKey = A.ProductSubcategoryKey 
left join dimproductcategory AS PC
ON PC.ProductCategoryKey = PS.ProductCategoryKey
LEFT JOIN dimreseller R
ON R.ResellerKey= A.ResellerKey
LEFT JOIN dimgeography AS G
ON G.GeographyKey = R.GeographyKey
