SELECT 
third.date,
NewUsers, (NumUsers - NewUsers) AS ReturnUsers,subsite_id
FROM
(
SELECT 
mindate,COUNT(user_id) AS NewUsers,sub_id
FROM 
(
SELECT 
min(date_trunc('day', debit_reportable_time)) AS mindate,user_id,subsite_id as sub_id
FROM da.profit.report_all 
WHERE purchase_kind in ('SVOD')
AND not (debit_kind_id = 1 AND trial_id is not null)
AND subsite_id in (10,11,353)
GROUP BY user_id,subsite_id
) first
GROUP BY mindate,sub_id
) second 
LEFT JOIN 
(
SELECT 
	date_trunc('day', debit_reportable_time) as date,
	COUNT(distinct user_id) as NumUsers,subsite_id
FROM da.profit.report_all
WHERE purchase_kind in ('SVOD')
AND not (debit_kind_id = 1 AND trial_id is not null)
AND subsite_id in (10,11,353)
GROUP BY date_trunc('day', debit_reportable_time),subsite_id
) third
ON second.mindate= third.date AND second.sub_id=third.subsite_id 
GROUP BY third.date,NewUsers,ReturnUsers,subsite_id
ORDER BY 1;
