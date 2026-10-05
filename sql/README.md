# SQL queries

Queries run on Google BigQuery, dataset `literary_prizes`. Results are saved in `outputs/`, one CSV per query.

## Tables

- prizes (7 rows): one row per prize
- countries (52 rows): laureates' countries, with continent
- authors (847 rows): one row per author
- laureates (942 rows): one row per laureate and session, including 73 sessions with no prize awarded

`00_build_laureates_full.sql` joins the four tables into `laureates_full`, exported to `data/processed/laureates_full.csv` for Tableau.

## Queries

- Q1–Q4: geography (countries, diversity of each prize, continents)
- Q5–Q7: publishers
- Q8–Q11: co-laureates, authors with several prizes, sessions without a prize
- Q12–Q15: time
- Q16–Q18: Akutagawa and Naoki
