MATCH (u1:USER { _id: $id })-[r1:INTERACTIVE]->(m:MOVIE)
WITH u1, avg(r1.score) AS u1_mean

MATCH (u1:USER)-[r1:INTERACTIVE]->(m:MOVIE)<-[r2:INTERACTIVE]-(u2:USER)
WITH u1, u1_mean, u2, collect({ r1: r1, r2: r2 }) AS iteractions WHERE size(iteractions) > 1

MATCH (u2)-[r:INTERACTIVE]->(m:MOVIE)
WITH u1, u1_mean, u2, avg(r.score) AS u2_mean, iteractions

UNWIND iteractions AS r

WITH sum( (r.r1.score - u1_mean) * (r.r2.score - u2_mean) ) AS nom,
     sqrt( sum((r.r1.score - u1_mean) ^ 2) * sum((r.r2.score - u2_mean) ^ 2) ) AS denom,
     u1, u2 WHERE denom <> 0

WITH u1, u2, nom / denom AS pearson
  ORDER BY pearson DESC LIMIT 15

MATCH (u2)-[r:INTERACTIVE]->(m:MOVIE), (m)-[:HAS_SHOW_TIME]->(st:SHOW_TIME)<-[:HAS_SHOW_TIME]-(t:THEATRE)
  WHERE NOT exists( (u1)-[:INTERACTIVE]->(m) )
WITH m, pearson, r, datetime({ epochMillis: st.start_time }) as startTime,
     datetime({ epochMillis: st.end_time }) as endTime,
     datetime.truncate('hour', datetime(), { minute: 0, second: 0, millisecond: 0, microsecond: 0 }) as startOfDay
  WHERE
  distance(point({ latitude: $lat, longitude: $lng }), t.location) < $max_distance
  AND startTime >= startOfDay
  AND endTime <= startOfDay + duration({ days: 4 })

RETURN m._id AS _id, sum(pearson * r.score) AS recommendation, pearson, r.score AS score, null AS cats
  ORDER BY recommendation DESC LIMIT 24

UNION ALL

MATCH (u:USER { _id: $id })-[r:INTERACTIVE]->(m:MOVIE)
WITH u, avg(r.score) AS mean

MATCH (u)-[r:INTERACTIVE]->(m:MOVIE)-[:IN_CATEGORY]->(cat:CATEGORY)
  WHERE r.score > mean

WITH u, cat, COUNT(*) AS score

MATCH (cat)<-[:IN_CATEGORY]-(rec:MOVIE), (rec)-[:HAS_SHOW_TIME]->(st:SHOW_TIME)<-[:HAS_SHOW_TIME]-(t:THEATRE)
  WHERE NOT exists((u)-[:INTERACTIVE]->(rec))
WITH rec, score, cat,
     datetime({ epochMillis: st.start_time }) AS startTime,
     datetime({ epochMillis: st.end_time }) AS endTime,
     datetime.truncate('hour', datetime(), { minute: 0, second: 0, millisecond: 0, microsecond: 0 }) AS startOfDay
  WHERE
  distance(point({ latitude: $lat, longitude: $lng }), t.location) < $max_distance
  AND startTime >= startOfDay
  AND endTime <= startOfDay + duration({ days: 4 })

WITH sum(score) as score, rec, cat
RETURN rec._id AS _id, score AS recommendation, null AS pearson, score, collect(DISTINCT cat.name) AS cats
  ORDER BY recommendation DESC LIMIT 24