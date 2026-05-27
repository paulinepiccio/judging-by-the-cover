-- Q2: How geographically diverse is each prize?
-- Compares the number of distinct countries each prize has recognized.

SELECT 
  p.name AS prize_name,
  COUNT(DISTINCT a.country_id) AS distinct_countries,
  COUNT(DISTINCT l.author_id) AS distinct_laureates,
  ROUND(COUNT(DISTINCT a.country_id) * 100.0 / COUNT(DISTINCT l.author_id), 1) AS diversity_ratio
FROM literary_prizes.laureates l
LEFT JOIN literary_prizes.prizes p ON l.prize_id = p.prize_id
LEFT JOIN literary_prizes.authors a ON l.author_id = a.author_id
WHERE l.author_id IS NOT NULL
GROUP BY p.name
ORDER BY distinct_countries DESC;
