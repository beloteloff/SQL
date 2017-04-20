with watchers as (
SELECT
distinct wi_id as watchers_id
FROM hive.groot.events
WHERE dt >= '2017-03-01' 
AND dt <  '2017-04-01' 
AND name in ('content_watch')
AND subsite=353
--AND lib not in ('notifications','pusher')
)
SELECT 
--name,ev_name,
--100*COUNT(*)*1.0/SUM(COUNT(*)) OVER (partition by 1),
COUNT(wi_id),is_new_session,next_act
--CASE WHEN next_act = 1 or next_act is NULL
-- THEN 1 ELSE 0 END as last_no
FROM (
SELECT *,
lead(is_new_session)OVER
                  (PARTITION BY wi_id ORDER BY ts) as next_act
FROM (
SELECT *,
  CASE WHEN date_diff('minute',laste.last_event,laste.ts)>=30
         OR laste.last_event IS NULL
       THEN 1 ELSE 0 END AS is_new_session
  FROM (
        SELECT 
--e.name,ev_name,
id,e.ts,e.wi_id,
               LAG(e.ts,1) OVER
                  (PARTITION BY e.wi_id ORDER BY e.ts)
                  AS last_event
	FROM hive.groot.events e
--INNER JOIN (
--SELECT event_id,dt,name as ev_name 
--FROM hive.groot.event_properties
--WHERE dt >='2017-03-01'
--AND dt < '2017-03-23'
--AND subsite_id = 10
--) as ev_prop ON ev_prop.dt=e.dt AND e.id=ev_prop.event_id
--INNER JOIN hive.groot.event_properties ON e.dt=event_properties.dt AND event_properties.event_id=e.id
	WHERE e.dt>='2017-03-01'
	AND e.dt <  '2017-04-01'
	--AND e.name !='notification_send'
	AND subsite=353
--AND (os is null or browser is null)
AND lib not in ('notifications','pusher','profit')
--AND name='watchcontent_click'
--AND subsite=10
--AND subsite=11
       ) laste
LEFT OUTER 
JOIN watchers
         ON laste.wi_id = watchers.watchers_id
WHERE watchers.watchers_id is null
)
)
--WHERE next_act is null OR next_act=1
GROUP BY 2,3
ORDER BY 1 DESC
;
