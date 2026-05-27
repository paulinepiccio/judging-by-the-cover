-- Q18: Have Akutagawa or Naoki ever recognized a non-Japanese author?
-- Tests the cultural boundary of Japanese literary prizes.
-- Expected result: empty (these prizes are reserved for works in Japanese).

SELECT 
  p.name AS prize_name,
  l.year,
  l.session,
  a.name AS author,
  c.name AS author_country,
  l.book_title
FROM literary_prizes.laureates l
LEFT JOIN literary_prizes.prizes p ON l.prize_id = p.prize_id
LEFT JOIN literary_prizes.authors a ON l.author_id = a.author_id
LEFT JOIN literary_prizes.countries c ON a.country_id = c.country_id
WHERE l.prize_id IN ('akutagawa', 'naoki')
  AND l.author_id IS NOT NULL
  AND c.name != 'Japan'
ORDER BY l.year;
