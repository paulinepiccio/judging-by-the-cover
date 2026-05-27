-- Q4: Which laureates come from "rare" countries (1 single win)?
-- Identifies cultural outliers in the global landscape of literary prizes.

WITH country_counts AS (
  SELECT 
    a.country_id,
    COUNT(*) AS wins
  FROM literary_prizes.laureates l
  LEFT JOIN literary_prizes.authors a ON l.author_id = a.author_id
  WHERE l.author_id IS NOT NULL
  GROUP BY a.country_id
)
SELECT 
  a.name AS author,
  c.name AS country,
  c.continent,
  p.name AS prize,
  l.year
FROM literary_prizes.laureates l
LEFT JOIN literary_prizes.authors a ON l.author_id = a.author_id
LEFT JOIN literary_prizes.countries c ON a.country_id = c.country_id
LEFT JOIN literary_prizes.prizes p ON l.prize_id = p.prize_id
INNER JOIN country_counts cc ON a.country_id = cc.country_id AND cc.wins = 1
WHERE l.author_id IS NOT NULL
ORDER BY l.year DESC;
