-- Q10: Which authors won the same prize multiple times?
-- Includes Akutagawa/Naoki (biannual prizes) but also Western prizes
-- where some authors have won twice (Faulkner, Coetzee, Mantel, etc.).

SELECT 
  a.name AS author,
  p.name AS prize,
  COUNT(*) AS wins,
  STRING_AGG(
    CAST(l.year AS STRING) || COALESCE(' ' || l.session, '') 
    ORDER BY l.year
  ) AS sessions
FROM literary_prizes.laureates l
LEFT JOIN literary_prizes.authors a ON l.author_id = a.author_id
LEFT JOIN literary_prizes.prizes p ON l.prize_id = p.prize_id
WHERE l.author_id IS NOT NULL
  AND a.name IS NOT NULL
  AND a.name != '/'
GROUP BY a.name, p.name
HAVING COUNT(*) >= 2
ORDER BY wins DESC, a.name;
