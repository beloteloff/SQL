with first as (SELECT userid as clid, store as shop, SUM(reven) ClShopAmount FROM schema.sale

INNER JOIN schema.store_base ON store_base.storeid=sale.storeid

INNER JOIN (SELECT distinct goodcode as cp FROM schema.noma_base WHERE Goodtype !='Ðåêëàìà' and brand not in (2372,42358,1032392) ) toward ON toward.cp=sale.code_good

WHERE daten >= TO_DATE('2017-04-01','YYYY-MM-DD') AND daten < TO_DATE('2018-04-01','YYYY-MM-DD') AND b2b_flag =0

GROUP BY store_base.store, userid),

second as (SELECT shop, COUNT(distinct clid) as totcard, SUM(ClShopAmount) as totSum FROM first GROUP BY shop)

SELECT store,shop,SUM(ClShopAmount) as ClientShopAmount,COUNT(distinct clid) as len,totcard,totsum FROM (

SELECT basic.shop as store, first.shop, first.ClShopAmount, second.totcard, second.totsum, first.clid, basic.ClShopAmount AS totSumCl

FROM first basic

INNER JOIN first ON basic.clid = first.clid

INNER JOIN second ON basic.shop = second.shop)

GROUP BY store, shop, totcard, totsum
