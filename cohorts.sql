SELECT TO_CHAR(date_trunc('day', date), 'YYYY-mm-dd') as daily_date,numb,
COUNT(distinct user_id) as users,
ROUND(SUM(b2c),2.0) as tot_money,
subsite_id
FROM (
SELECT
debit_reportable_time as date,
user_id,SUM(debit_b2c) as b2c,subsite_id,
row_number()
OVER(partition by user_id ORDER BY debit_reportable_time) as numb
FROM da.profit.report_all 
WHERE purchase_kind in ('SVOD')
AND not (debit_kind_id = 1 AND trial_id is not null)
AND subsite_id in (10,11,353)
AND debit_b2c > 0 GROUP BY debit_reportable_time,user_id,debit_id,subsite_id
) T
GROUP BY date_trunc('day', date),numb,subsite_id
ORDER BY TO_CHAR(date_trunc('day', date), 'YYYY-mm-dd');
