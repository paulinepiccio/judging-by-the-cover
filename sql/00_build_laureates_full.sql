-- Flat table for Tableau, exported to data/processed/laureates_full.csv.

CREATE OR REPLACE TABLE literary_prizes.laureates_full AS
SELECT
  l.laureate_id,
  p.name AS prize_name,
  p.organizing_country AS prize_country,
  p.founding_year AS prize_founding_year,
  l.year,
  l.session,
  a.name AS author,
  c.name AS author_country,
  c.continent AS author_continent,
  l.book_title,
  l.publisher,
  l.notes,
  CASE
    WHEN l.author_id IS NULL THEN 'No prize'
    WHEN l.notes = 'Co-laureate' THEN 'Co-laureate'
    WHEN LOWER(l.notes) LIKE 'refused%' OR LOWER(l.notes) LIKE 'refusé%' THEN 'Refused'
    ELSE 'Standard'
  END AS attribution_type,
  CAST(FLOOR(l.year / 10) * 10 AS INT64) AS decade
FROM literary_prizes.laureates l
LEFT JOIN literary_prizes.prizes p ON l.prize_id = p.prize_id
LEFT JOIN literary_prizes.authors a ON l.author_id = a.author_id
LEFT JOIN literary_prizes.countries c ON a.country_id = c.country_id;
