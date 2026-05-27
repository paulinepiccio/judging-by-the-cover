-- Q16: Akutagawa vs Naoki: comparative analysis of Japan's twin prizes.
-- Both awarded biannually by Bungei Shunju, but with different missions.

SELECT 
  p.name AS prize_name,
  COUNT(*) AS total_sessions,
  COUNTIF(l.author_id IS NOT NULL) AS sessions_with_laureate,
  COUNTIF(l.author_id IS NULL) AS sessions_without_laureate,
  COUNTIF(l.notes = 'Co-laureate') AS co_laureate_count,
  ROUND(COUNTIF(l.author_id IS NULL) * 100.0 / COUNT(*), 1) AS no_prize_pct,
  ROUND(COUNTIF(l.notes = 'Co-laureate') * 100.0 / COUNTIF(l.author_id IS NOT NULL), 1) AS co_laureate_pct
FROM literary_prizes.laureates l
LEFT JOIN literary_prizes.prizes p ON l.prize_id = p.prize_id
WHERE l.prize_id IN ('akutagawa', 'naoki')
GROUP BY p.name
ORDER BY p.name;
