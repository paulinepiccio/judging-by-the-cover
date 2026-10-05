-- Q5: Which publishers have won the most prizes?

SELECT
  publisher,
  COUNT(*) AS total_wins,
  COUNT(DISTINCT prize_id) AS distinct_prizes,
  COUNT(DISTINCT author_id) AS distinct_authors
FROM literary_prizes.laureates
WHERE publisher IS NOT NULL
GROUP BY publisher
ORDER BY total_wins DESC, publisher
LIMIT 15;
