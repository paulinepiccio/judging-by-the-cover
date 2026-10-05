-- Q15: Which years had the most laureates across all prizes?

SELECT
  l.year,
  COUNT(*) AS total_awards,
  COUNT(DISTINCT l.prize_id) AS distinct_prizes_active,
  STRING_AGG(DISTINCT p.name ORDER BY p.name) AS prizes_list
FROM literary_prizes.laureates l
LEFT JOIN literary_prizes.prizes p ON l.prize_id = p.prize_id
WHERE l.author_id IS NOT NULL
GROUP BY l.year
ORDER BY total_awards DESC, l.year DESC
LIMIT 10;
