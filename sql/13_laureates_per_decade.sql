-- Q13: How many laureates per decade, across all prizes?
-- Shows the global expansion of literary recognition over time.

SELECT 
  FLOOR(l.year / 10) * 10 AS decade,
  COUNT(*) AS total_laureates,
  COUNT(DISTINCT l.prize_id) AS active_prizes
FROM literary_prizes.laureates l
WHERE l.author_id IS NOT NULL
GROUP BY decade
ORDER BY decade;
