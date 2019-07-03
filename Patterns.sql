with noma as (SELECT distinct cp, segment,seasontype FROM crm_schema.noma_base WHERE /*goodTYPE='Òîâàð'
AND*/ brandid not in (37232,2324,103492))
SELECT COUNT(distinct userid) as Quant,pattern,MonthNumb FROM (
SELECT TO_CHAR(wm_concat(distinct seasontype || '_' || segment)) as pattern,TO_CHAR(daten,'Month') as MonthNumb,userid
FROM crm_schema.ret INNER JOIN noma ON noma.cp=ret.cp
WHERE daten >= TO_DATE('2017-06-23','YYYY-MM-DD') AND flag_b2b=0
GROUP BY TO_CHAR(daten,'Month'),userid )
GROUP BY pattern,MonthNumb ORDER BY Quant desc
