-- Q14: Did the Booker Prize become more international after 2014?
-- The prize opened to authors writing in English worldwide in 2014.

SELECT 
  CASE WHEN l.year < 2014 THEN 'Before 2014 (Commonwealth only)' 
       ELSE 'From 2014 (Worldwide English fiction)' END AS period,
  COUNT(*) AS laureates,
  COUNT(DISTINCT a.country_id) AS distinct_countries,
  STRING_AGG(DISTINCT c.name ORDER BY c.name) AS countries_list
FROM literary_prizes.laureates l
LEFT JOIN literary_prizes.authors a ON l.author_id = a.author_id
LEFT JOIN literary_prizes.countries c ON a.country_id = c.country_id
WHERE l.prize_id = 'booker'
  AND l.author_id IS NOT NULL
GROUP BY period
ORDER BY period;
