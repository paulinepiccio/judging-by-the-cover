-- Q8: How often is each prize shared between co-laureates?
-- Reveals jury habits: solo consecration vs collective recognition.

SELECT 
  p.name AS prize_name,
  COUNTIF(l.notes = 'Co-laureate') AS co_laureate_count,
  COUNT(*) AS total_laureates,
  ROUND(COUNTIF(l.notes = 'Co-laureate') * 100.0 / COUNT(*), 1) AS co_laureate_pct
FROM literary_prizes.laureates l
LEFT JOIN literary_prizes.prizes p ON l.prize_id = p.prize_id
WHERE l.author_id IS NOT NULL
GROUP BY p.name
ORDER BY co_laureate_pct DESC;
