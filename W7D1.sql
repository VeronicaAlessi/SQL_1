use AdventureWorksDW

/*Scrivi una query per verificare che il campo ProductKey nella tabella DimProduct sia una chiave primaria. 
Quali considerazioni/ragionamenti è necessario che tu faccia?*/

select 
productkey
, count(*)
from dimproduct
group by productkey
having count(*)>1;

/* Scrivi una query per verificare che la combinazione dei campi SalesOrderNumber e SalesOrderLineNumber sia una PK.*/

select SalesOrderNumber
, SalesOrderLineNumber
, count(*)
from factresellersales
group by SalesOrderNumber, SalesOrderLineNumber
having count(*)>1;

/*Conta il numero transazioni SalesOrderLineNumber) realizzate ogni giorno a partire dal 1 Gennaio 2020.*/

select 
OrderDate as 'Data'
, count(OrderDate) as Ordini_Giornalieri
from   
        (select 
        R.SalesOrderNumber
        , R.SalesOrderLineNumber
        , R.OrderDate
        from factresellersales as R
		where R.OrderDate >= '2020-01-01'
        union 
        select I.SalesOrderNumber
        , I.SalesOrderLineNumber
        , I.OrderDate
        from factinternetsales as I
        where I.OrderDate >= '2020-01-01') as vendite
group by OrderDate

-- test 1
select SalesorderNumber
, SalesOrderLineNumber
from factresellersales
where orderdate = '2020-01-01'
union
select SalesorderNumber
, SalesOrderLineNumber
from factinternetsales
where orderdate = '2020-01-01';

-- test 2
select SalesorderNumber
, SalesOrderLineNumber
from factresellersales
where orderdate = '2020-01-02'
union 
select SalesorderNumber
, SalesOrderLineNumber
from factinternetsales
where orderdate = '2020-01-02';

/*Calcola il fatturato totale FactResellerSales.SalesAmount), 
la quantità totale venduta    FactResellerSales.OrderQuantity) 
e il prezzo medio di vendita  FactResellerSales.UnitPrice) per prodotto DimProduct) a partire dal 1 Gennaio 2020. 
Il result set deve esporre pertanto il nome del prodotto, il fatturato totale, 
la quantità totale venduta e il prezzo medio di vendita. I campi in output devono essere parlanti!*/

select S.ProductKey as ID
 , P.EnglishProductName as Prodotto
 , sum(SalesAmount) as Totale_Fatturato
 , sum(OrderQuantity) as Quantità_Totale_Di_Vendita
 , avg(UnitPrice) as Prezzo_Medio_Vendita
 , sum(SalesAmount)/sum(OrderQuantity) as Rapporto_Fatturato_Vendite 
 from factresellersales as S
 inner join dimproduct as P
 on S.ProductKey = P.ProductKey
 where OrderDate >= '2020-01-01'
 group by P.EnglishProductName, S.ProductKey
 ;


/*Calcola il fatturato totale FactResellerSales.SalesAmount) e la quantità totale venduta FactResellerSales.OrderQuantity)
 per Categoria prodotto DimProductCategory). Il result set deve esporre pertanto il nome della categoria prodotto, 
 il fatturato totale e la quantità totale venduta. I campi in output devono essere parlanti!
*/

select 
EnglishProductCategoryName
, sum(R.SalesAmount) as Totale_Fatturato
, sum(R.OrderQuantity) as Totale_Quantità
FROM dimproductcategory as C
inner join dimproductsubcategory as S
on C.ProductCategoryKey = S.ProductCategoryKey
inner join dimproduct as P
on S.ProductSubcategoryKey = P.ProductSubcategoryKey
inner join factresellersales as R
on P.productkey = R.productkey
group by C.EnglishProductCategoryName;

/*Calcola il fatturato totale per area città DimGeography.City) 
realizzato a partire dal 1 Gennaio 2020.
 Il result set deve esporre lʼelenco delle città con fatturato realizzato superiore a 60K.
*/


select G.City
, sum(F.SalesAmount)
from dimgeography as G
INNER JOIN dimreseller as R
ON R.geographykey = G.GeographyKey
INNER JOIN factresellersales as F
ON F.resellerkey = R.ResellerKey
where F.OrderDate > "2020-01-01"
group by G.City
HAVING sum(F.SalesAmount)>60000;



