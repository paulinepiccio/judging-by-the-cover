-- Q9: Which authors have won multiple distinct prizes?
-- The pantheon of internationally consecrated writers.

SELECT 
  a.name AS author,
  c.name AS country,
  COUNT(DISTINCT l.prize_id) AS prizes_won,
  STRING_AGG(DISTINCT p.name ORDER BY p.name) AS prize_names,
  MIN(l.year) AS first_win,
  MAX(l.year) AS last_win
FROM literary_prizes.laureates l
LEFT JOIN literary_prizes.authors a ON l.author_id = a.author_id
LEFT JOIN literary_prizes.countries c ON a.country_id = c.country_id
LEFT JOIN literary_prizes.prizes p ON l.prize_id = p.prize_id
WHERE l.author_id IS NOT NULL
GROUP BY a.name, c.name
HAVING COUNT(DISTINCT l.prize_id) >= 2
ORDER BY prizes_won DESC, a.name;
