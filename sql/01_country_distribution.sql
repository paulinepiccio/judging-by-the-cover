-- Q1: Which countries produce the most laureates across all prizes?
-- Identifies the geographical concentration of literary recognition worldwide.

SELECT 
  c.name AS country,
  c.continent,
  COUNT(*) AS total_laureates
FROM literary_prizes.laureates l
LEFT JOIN literary_prizes.authors a ON l.author_id = a.author_id
LEFT JOIN literary_prizes.countries c ON a.country_id = c.country_id
WHERE l.author_id IS NOT NULL
GROUP BY c.name, c.continent
ORDER BY total_laureates DESC
LIMIT 15;
