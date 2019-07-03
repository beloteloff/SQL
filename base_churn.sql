SELECT * FROM (

SELECT ((MAX(CASE WHEN (cume_dis >=0.25 and cume_dis <= 0.75) THEN LAGER END)) - (MIN(CASE WHEN cume_dis >=0.25 and cume_dis <= 0.75 THEN LAGER END)))

as InterquartileRange,userid,datediff,AVG(lager) as AverLag,MEDIAN(lager) as MedianLag,STDDEV(lager) as StanDev FROM (

SELECT CUME_DIST() OVER (PARTITION BY userid ORDER BY lager) AS cume_dis,datediff,

lager,userid FROM (SELECT userid,datediff,

(to_date(to_char(daten,'YYYY-MM-DD'),'YYYY-MM-DD') - to_date(LAG (to_char(daten,'YYYY-MM-DD'),1,to_char(daten,'YYYY-MM-DD')) OVER (PARTITION BY userid ORDER BY to_char(daten,'YYYY-MM-DD')),'YYYY-MM-DD'))

as lager FROM db_schema.hdr INNER JOIN (SELECT userid as freshuser,

(CURRENT_DATE - MAX(daten)) as datediff FROM db_schema.cards_info

LEFT JOIN db_schema.b2b_table ON cards_info.cardnumb=b2b_table.DC_NOM

INNER JOIN db_schema.hdr ON cards_info.cardnumb=hdr.userid

WHERE daten >= TO_DATE('2016-01-01','YYYY-MM-DD') AND b2b_table.DC_NOM IS NULL AND agg_type!=3

AND internal_status=1 GROUP BY userid) fresh ON fresh.freshuser=hdr.userid

WHERE daten >= TO_DATE('2015-01-01','YYYY-MM-DD')

AND userid NOT in ('555004232312345678','999100034445568','01010340000540004','010000005420005','46070420303164','11341111'))

WHERE lager > 0) GROUP BY userid,datediff)

WHERE (DATEDIFF > (GREATEST(MEDIANLAG, AVERLAG, INTERQUARTILERANGE) + 3*StanDev) AND STANDEV > 0)
