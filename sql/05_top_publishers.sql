-- Q5: Who are the most awarded publishers across all prizes?
-- The economic geography of literary consecration.

SELECT 
  publisher,
  COUNT(*) AS total_wins,
  COUNT(DISTINCT prize_id) AS distinct_prizes,
  COUNT(DISTINCT author_id) AS distinct_authors
FROM literary_prizes.laureates
WHERE publisher IS NOT NULL
GROUP BY publisher
ORDER BY total_wins DESC
LIMIT 15;
