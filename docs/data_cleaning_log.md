# Data cleaning log

Data quality issues found during the project and how they were corrected.

## 1. Scraping fixes (notebook 01)

### Nobel: missing co-laureates

Extra text on the Wikipedia page (language, footnote) broke the parsing of two shared prizes.

- 1966: added Nelly Sachs (Sweden), co-laureate with Samuel Joseph Agnon. The parser had taken "hébreu" (the writing language) as the author name.
- 1974: added Harry Martinson (Sweden), co-laureate with Eyvind Johnson. The parser had merged both names.

### Naoki: merged co-laureate names

English Wikipedia lists Naoki co-laureates with no separator, so two names ended up in one string (e.g. "Toko Sawada Norikazu Sato"). 59 sessions were split into two rows, marked "Co-laureate", and checked against Japanese Wikipedia.

### Naoki: 6 missing years

Six rows had no year after scraping. They were corrected from the official list: 1986 H1 and H2, 1987 H1 and H2, 1996 H1 and H2.

### Pulitzer 2023: shared prize not parsed

The French page lists the 2023 winners as "ex æquo", which broke the regex. The placeholder row was replaced by two rows: Barbara Kingsolver (Demon Copperhead) and Hernan Diaz (Trust), both marked "Co-laureate".

### Renaudot: footnote markers

Three author names kept Wikipedia footnote markers ([34], [35], [36]). Removed with a regex.

## 2. Cleaning and harmonization (notebook 02)

### Country names

The sources used different conventions: French names for the Nobel ("Allemagne", "Empire allemand"), ISO codes for the Booker ("ENG", "RSA"), English names for the Pulitzer, Akutagawa and Naoki, and no country at all for the Goncourt and Renaudot.

- All countries use modern English names.
- Historical states are mapped to their modern equivalent: German Empire to Germany, USSR to Russia, Yugoslavia to Serbia, Czechoslovakia to Czech Republic.
- Dual nationals keep the first listed nationality (Booker "UK TTO", "CAN SRI"; Nobel, see the ghost laureate below).
- Guatemala is in North America, like Mexico and the Caribbean (it was first mapped to South America).
- Result: 52 countries.

### Goncourt and Renaudot: inferred nationalities

Wikipedia gives no nationality for these two prizes. All laureates were set to France, then foreign nationalities were taken from the notes column. 11 Goncourt and 6 Renaudot laureates are non-French.

This keeps the legal nationality at the time of the prize, so naturalized authors (Andreï Makine), authors from overseas territories (Patrick Chamoiseau) and dual nationals (John-Antoine Nau) are counted as France.

### Akutagawa and Naoki: nationalities

The scraper set every laureate to Japan. Both prizes reward works written in Japanese, not Japanese nationals, so this hid the foreign laureates and made Q18 return nothing. Using the same rule (nationality at the time of the prize), 9 laureates were corrected:

- Naoki 1955 H2, Kyū Eikan: Taiwan. First foreign Naoki laureate, naturalized Japanese in 1980.
- Naoki 1968 H2, Chin Shunshin: Taiwan. PRC nationality in 1973, Japanese in 1990.
- Akutagawa 1971 H2, Lee Hoesung: South Korea. First foreign Akutagawa laureate.
- Naoki 1981 H2, Tsuka Kōhei: South Korea. Never naturalized.
- Akutagawa 1996 H2, Yū Miri: South Korea.
- Naoki 2000 H1, Kaneshiro Kazuki: South Korea.
- Akutagawa 2008 H1, Yang Yi: China.
- Naoki 2015 H1, Higashiyama Akira: Taiwan.
- Akutagawa 2021 H1, Li Kotomi: Taiwan.

Checked and kept as Japan: Lee Yangji (Akutagawa 1988 H2, naturalized as a child) and Tachihara Masaaki (Naoki 1966 H1, naturalized in 1947).

Lee Hoesung held Chōsen-seki status in 1972, which refers to undivided Korea and is not a nationality. He is coded as South Korea, the nationality he took in 1998.

Sources: English and Japanese Wikipedia biographies, Nikkei obituary of Lee Hoesung (January 2025).

### Nobel: declined prizes

The notes were empty for Boris Pasternak (1958, forced to decline by the Soviet authorities) and Jean-Paul Sartre (1964). Both were added, so that the four refusals in the data (with Julien Gracq, Goncourt 1951, and Takagi Taku, Akutagawa 1940 H1) are counted as "Refused". Gracq's French note ("Refusé par l'auteur") was previously counted as a standard prize.

### Akutagawa 1953 H1: missing laureate

Shōtarō Yasuoka won for two works, scraped as two rows. The cell merging them matched on the second title, which the merged row also contained, so running it twice deleted Yasuoka. It now matches the exact title and can be re-run safely.

## 3. Corrections moved from BigQuery to notebook 02

These corrections were first made by hand in the BigQuery console. They are now in the notebook, so re-running it rebuilds the tables from the raw files.

### Ghost laureate "/"

The Nobel parser read a "/" as a co-laureate separator in 5 years with a single, dual-national laureate. The text after the "/" was the second nationality:

- 1980, Czesław Miłosz: Poland (second nationality USA)
- 1981, Elias Canetti: UK (Bulgaria)
- 2008, J. M. G. Le Clézio: France (Mauritius)
- 2009, Herta Müller: Germany (Romania)
- 2010, Mario Vargas Llosa: Peru (Spain)

The 5 ghost rows and the ghost author are deleted. Bulgaria, Mauritius and Romania no longer have any laureate and are removed from the countries table.

### Co-laureates

Shared sessions were flagged inconsistently: both rows for the Naoki and Pulitzer 2023, no row for the Akutagawa, one row out of two for the Nobel (1904, 1917, 1966, 1974), and no row for the Booker ties (1974, 1992, 2019). Every laureate of a shared session is now marked "Co-laureate": 228 rows in total.

### Final tables

prizes: 7 rows. countries: 52. authors: 847. laureates: 942 (869 with a laureate, 73 sessions without a prize).

`sql/00_build_laureates_full.sql` joins them into `laureates_full`, the table used for Tableau.

## Known limitations

- Naoki: no publisher on English Wikipedia, so the column is empty for this prize.
- Naoki: when co-laureates were split, both rows kept the two winning titles (e.g. 2003 H2). Analyses by title would need a manual split.
- Nobel: no book title, since the prize rewards a body of work.
- Gen Getsu (Akutagawa 1999 H2), a Zainichi Korean author, is kept as Japan: no reliable source on his nationality at the time was found.
- Dual nationals keep only their first listed nationality.
