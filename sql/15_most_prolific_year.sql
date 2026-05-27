-- Q15: Which year saw the most simultaneous prizes awarded?
-- Identifies the years where the global literary calendar was densest.

SELECT 
  l.year,
  COUNT(*) AS total_awards,
  COUNT(DISTINCT l.prize_id) AS distinct_prizes_active,
  STRING_AGG(DISTINCT p.name ORDER BY p.name) AS prizes_list
FROM literary_prizes.laureates l
LEFT JOIN literary_prizes.prizes p ON l.prize_id = p.prize_id
WHERE l.author_id IS NOT NULL
GROUP BY l.year
ORDER BY total_awards DESC
LIMIT 10;
