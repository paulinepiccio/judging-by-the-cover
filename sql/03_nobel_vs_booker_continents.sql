-- Q3: How do Nobel and Booker compare in continental distribution?
-- Two prizes claiming international reach, but with different actual footprints.

SELECT 
  p.name AS prize_name,
  c.continent,
  COUNT(*) AS laureates,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY p.name), 1) AS pct
FROM literary_prizes.laureates l
LEFT JOIN literary_prizes.prizes p ON l.prize_id = p.prize_id
LEFT JOIN literary_prizes.authors a ON l.author_id = a.author_id
LEFT JOIN literary_prizes.countries c ON a.country_id = c.country_id
WHERE p.prize_id IN ('nobel', 'booker')
  AND l.author_id IS NOT NULL
GROUP BY p.name, c.continent
ORDER BY p.name, laureates DESC;
