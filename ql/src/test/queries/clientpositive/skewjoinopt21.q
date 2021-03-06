set hive.mapred.mode=nonstrict;
set hive.optimize.skewjoin.compiletime = true;

CREATE TABLE T1_n63(key STRING, val STRING)
SKEWED BY (key) ON ((2)) STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '../../data/files/T1.txt' INTO TABLE T1_n63;

CREATE TABLE T2_n38(key STRING, val STRING)
SKEWED BY (key) ON ((3)) STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '../../data/files/T2.txt' INTO TABLE T2_n38;

-- a simple join query with skew on both the tables on the join key
-- adding a order by at the end to make the results deterministic

EXPLAIN
SELECT a.*, b.*
FROM 
  (SELECT key as k, val as v FROM T1_n63) a
  JOIN
  (SELECT key as k, val as v FROM T2_n38) b
ON a.k = b.k;

SELECT a.*, b.*
FROM 
  (SELECT key as k, val as v FROM T1_n63) a
  JOIN
  (SELECT key as k, val as v FROM T2_n38) b
ON a.k = b.k
ORDER BY a.k, b.k, a.v, b.v;
