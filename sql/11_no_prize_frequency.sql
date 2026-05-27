-- Q11: How often is each prize not awarded?

SELECT 
  p.name AS prize_name,
  COUNT(*) AS total_sessions,
  COUNTIF(l.author_id IS NULL) AS no_prize_count,
  ROUND(COUNTIF(l.author_id IS NULL) * 100.0 / COUNT(*), 1) AS no_prize_pct
FROM literary_prizes.laureates l
LEFT JOIN literary_prizes.prizes p ON l.prize_id = p.prize_id
GROUP BY p.name
ORDER BY no_prize_pct DESC;
