# SQL Analysis Queries

This folder contains 18 analytical queries executed on Google BigQuery 
within the `literary_prizes` dataset of the `judging-by-the-cover` project.

## Dataset structure

The queries run on a relational schema of 4 tables:

- **prizes** (7 rows): one row per literary prize
- **countries** (54 rows): countries of origin of laureates
- **authors** (846 rows): one row per unique laureate
- **laureates** (941 rows): fact table linking prizes, authors, year, and edition

## Themes covered

The 18 queries are organized in 5 analytical themes:

- **A. Geography of consecration** (Q1–Q4): which countries produce 
  the most laureates, and how diverse is each prize.
- **B. Economy of publishing** (Q5–Q7): which publishers dominate 
  the prize ecosystem.
- **C. Representation and diversity** (Q8–Q11): co-laureates, 
  multi-prize authors, non-attribution patterns.
- **D. Temporality and evolution** (Q12–Q15): chronology and 
  cumulative dynamics.
- **E. Japanese specificity** (Q16–Q18): comparison of Akutagawa 
  and Naoki prizes.
