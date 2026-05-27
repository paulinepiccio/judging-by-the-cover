-- Q7: Has Gallimard's dominance over the Goncourt evolved over time?
-- A century of editorial hegemony in French literature, by decade.

SELECT 
  FLOOR(l.year / 10) * 10 AS decade,
  COUNT(*) AS total_prizes,
  SUM(CASE WHEN l.publisher = 'Gallimard' THEN 1 ELSE 0 END) AS gallimard_wins,
  ROUND(SUM(CASE WHEN l.publisher = 'Gallimard' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS gallimard_pct
FROM literary_prizes.laureates l
WHERE l.prize_id = 'goncourt' AND l.publisher IS NOT NULL
GROUP BY decade
ORDER BY decade;
