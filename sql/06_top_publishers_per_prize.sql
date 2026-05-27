-- Q6: Who are the top 3 publishers for each prize?
-- Reveals the dominant editorial ecosystem behind each award.

WITH publisher_ranked AS (
  SELECT 
    p.name AS prize_name,
    l.publisher,
    COUNT(*) AS wins,
    RANK() OVER (PARTITION BY p.name ORDER BY COUNT(*) DESC) AS rank_in_prize
  FROM literary_prizes.laureates l
  LEFT JOIN literary_prizes.prizes p ON l.prize_id = p.prize_id
  WHERE l.publisher IS NOT NULL
  GROUP BY p.name, l.publisher
)
SELECT 
  prize_name,
  publisher,
  wins,
  rank_in_prize
FROM publisher_ranked
WHERE rank_in_prize <= 3
ORDER BY prize_name, rank_in_prize;
