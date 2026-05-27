-- Q17: Are H1 (summer) and H2 (winter) sessions different for Japanese prizes?
-- Tests if seasonality affects jury behavior.

SELECT 
  p.name AS prize_name,
  l.session,
  COUNT(*) AS total_sessions,
  COUNTIF(l.author_id IS NULL) AS no_prize_count,
  COUNTIF(l.notes = 'Co-laureate') AS co_laureate_count,
  ROUND(COUNTIF(l.author_id IS NULL) * 100.0 / COUNT(*), 1) AS no_prize_pct
FROM literary_prizes.laureates l
LEFT JOIN literary_prizes.prizes p ON l.prize_id = p.prize_id
WHERE l.prize_id IN ('akutagawa', 'naoki')
GROUP BY p.name, l.session
ORDER BY p.name, l.session;
