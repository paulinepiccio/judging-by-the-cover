-- Q12: How old is each prize?

SELECT 
  name AS prize_name,
  organizing_country,
  founding_year,
  EXTRACT(YEAR FROM CURRENT_DATE()) - founding_year AS age_in_years
FROM literary_prizes.prizes
ORDER BY founding_year;
