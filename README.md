# 📚 Judging by the Cover

A data analysis of how seven major literary prizes (Nobel, Goncourt, Renaudot, Booker, Pulitzer, Akutagawa and Naoki) have crowned literature from 1901 to today. Based on **869 laureate entries** across **942 prize sessions**, for **847 authors** from **52 countries**.

---

## 🎯 Research question

> **What do literary prizes tell us about how nations crown their literature?**

Literary prizes are often presented as neutral judgments of quality. But each prize is run by a national institution, with its own rules, its own juries and its own publishing ecosystem. This project compares them side by side to see what they reveal about national literary cultures.

The analysis focuses on four sub-questions :
- How open is each prize to authors from other countries?
- Which publishers benefit from literary consecration?
- How do juries behave : do they share prizes, or refuse to award them?
- Do the Japanese prizes, awarded twice a year, follow different rules from the Western ones?

---

## 🗂️ Project at a glance

| Element | Detail |
|---------|--------|
| **Prizes analyzed** | Nobel (Sweden) · Goncourt, Renaudot (France) · Booker (UK) · Pulitzer (USA) · Akutagawa, Naoki (Japan) |
| **Time period** | 1901–2025 |
| **Dataset** | 942 prize sessions · 869 laureate entries · 847 unique authors · 52 countries |
| **Data source** | Wikipedia (French and English laureate lists), scraped |
| **Tools** | Python, pandas, BeautifulSoup, Google BigQuery (SQL), Tableau, Google Colab |

---

## ⚠️ Methodological limitations

- **Unequal volumes** : the Akutagawa and Naoki are awarded twice a year, so Japan mechanically leads every raw count. The Pulitzer only rewards American authors by rule. Most analyses therefore use proportions or diversity ratios rather than absolute numbers.
- **Nationality** is the author's legal nationality at the time of the prize. The Goncourt and Renaudot pages give no nationality, so it is inferred from the notes, which under-represents naturalized and overseas authors. Dual nationals keep only their first listed nationality.
- **Missing fields** : no publishers for the Naoki and no book titles for the Nobel, which is awarded for a body of work.
- **Pulitzer coverage** starts in 1948, when the Pulitzer Prize for the Novel became the Pulitzer Prize for Fiction.
- **Wikipedia as a single source** : every correction made to the scraped data is documented in the [data cleaning log](docs/data_cleaning_log.md).

---

## 🧭 Methodology

The pipeline runs in four stages :

1. **`prizes01_data_collection.ipynb`** : Scraping the laureate lists of the 7 prizes from French and English Wikipedia (`pandas.read_html`, `BeautifulSoup`), with manual fixes for parsing errors.
2. **`prizes02_data_cleaning.ipynb`** : Harmonizing the 7 schemas, normalizing country names, inferring and checking nationalities, then building a relational model loaded into Google BigQuery.
3. **`sql/`** : 18 BigQuery queries in five themes : geography, publishing, representation, time, and the Japanese case. Results are saved in `outputs/`.
4. **Tableau** : an interactive dashboard built on `data/processed/laureates_full.csv` *(in progress)*.

### Harmonizing seven sources

The seven Wikipedia pages share almost nothing. Country names came as French names ("Empire allemand"), ISO codes ("ENG", "RSA") or not at all, and were all mapped to modern English names. Historical states were mapped to their modern equivalent (USSR → Russia, Czechoslovakia → Czech Republic). The Japanese prizes are split into H1 and H2 sessions. Every prize session is kept, including those where no prize was awarded, so that juries' refusals can be counted.

The result is a relational model of four tables in BigQuery : `prizes` (7), `countries` (52), `authors` (847) and `laureates` (942), joined into a flat table for Tableau.

### A correction worth mentioning

The first version of query Q18 asked whether the Akutagawa or the Naoki had ever crowned a non-Japanese author. It returned an empty result, which looked like a clean confirmation of a closed national prize. In fact, the scraper had hardcoded `author_country = 'Japan'` for every laureate. Checking each author one by one revealed **9 foreign laureates** : Taiwanese, Korean and Chinese authors writing in Japanese.

Reviewing the whole pipeline also surfaced three silent errors :
- **A missing laureate** : Shōtarō Yasuoka (Akutagawa 1953) had been deleted by a notebook cell that broke when run twice.
- **Inconsistent co-laureate flags** : shared Booker and Nobel prizes were not flagged, so the Booker showed 0% shared prizes instead of 10%.
- **A "ghost" Nobel laureate named `/`** : it actually carried the second nationality of five dual-national laureates.

The lesson is the same as in my [previous project](https://github.com/paulinepiccio/cinema-and-war) : a result that confirms an expectation too neatly deserves as much scrutiny as an anomaly.

---

## 📊 Key results

### Volume is not openness

| Prize | Laureates | Distinct countries | Share from the home country |
|-------|----------:|-------------------:|----------------------------:|
| Nobel | 122 | 41 | 6.6% (Sweden) |
| Booker | 60 | 11 | 53.3% (UK) |
| Goncourt | 123 | 9 | 91.1% (France) |
| Renaudot | 100 | 6 | 94.0% (France) |
| Akutagawa | 189 | 4 | 97.9% (Japan) |
| Naoki | 203 | 3 | 97.5% (Japan) |
| Pulitzer | 72 | 1 | 100% (USA, by rule) |

Japan (385 laureates) and France (222) lead the raw count only because their prizes are domestic, and the Japanese ones are awarded twice a year. Measured by the number of countries crowned, the ranking flips : the Nobel has rewarded authors from 41 countries, and France is its most-crowned country (16 laureates), ahead of the USA (12) and the UK (11).

### A European Nobel, a British Booker

74% of Nobel laureates are European. The share has fallen since 1991 (66%, against 77% before), with more African and Asian laureates. The Booker, built around the Commonwealth, is less European (60%) but still dominated by British authors (53%).

The Booker opened to all fiction written in English in 2014. The 13 winners since then come from 8 countries, as many as in the 47 years before. The United States entered the list (2016, 2017), while India, New Zealand and Nigeria have not won since.

### The economy of publishing

Gallimard has won 39 of the 123 Goncourts (32%), with a peak in the 1950s (7 out of 10). It won only 1 in the 1980s, and 2 to 4 per decade since. Grasset leads the Renaudot (20 wins, ahead of Gallimard's 19). In Japan, consecration goes through literary magazines rather than publishing houses : a third of Akutagawa-winning works first appeared in the magazine *Bungakukai* (63 of 188).

### Jury habits : sharing and withholding

| Prize | Laureates sharing the prize | Sessions without a prize |
|-------|----------------------------:|-------------------------:|
| Naoki | 58.1% | 12.9% |
| Akutagawa | 49.7% | 14.5% |
| Booker | 10.0% | 0% |
| Nobel | 6.6% | 3.2% |
| Pulitzer | 2.8% | 8.9% |
| Goncourt | 0% | 0% |
| Renaudot | 0% | 0% |

The two Japanese juries behave very differently from the Western ones : half of their laureates share the prize, and about one session in seven ends with no winner at all. The French juries have never shared or withheld a prize.

### The Japanese prizes are not only for the Japanese

Both prizes reward works written in Japanese, not Japanese nationals. Nine laureates were foreign citizens when they won :
- **Taiwan** : Kyū Eikan (Naoki 1955, the first foreign laureate of either prize), Chin Shunshin (Naoki 1968), Higashiyama Akira (Naoki 2015), Li Kotomi (Akutagawa 2021)
- **Korea** : Lee Hoesung (Akutagawa 1971), Tsuka Kōhei (Naoki 1981), Yū Miri (Akutagawa 1996), Kaneshiro Kazuki (Naoki 2000), all Zainichi Korean authors
- **China** : Yang Yi (Akutagawa 2008), the first laureate whose native language is not Japanese

All come from countries that were part of the former Japanese empire, or next to it.

### Bridges between prizes

15 authors have won two different prizes of the corpus. Five Booker winners went on to win the Nobel (Naipaul, Gordimer, Golding, Coetzee, Ishiguro), and four Pulitzer winners are also Nobel laureates (Faulkner, Hemingway, Bellow, Morrison). Annie Ernaux waited 38 years between her Renaudot (1984) and her Nobel (2022).

---

## 🎯 What the data ultimately tells us

Seen together, seven prizes and 125 years of laureates look less like a single literary world than a set of national systems, each with its own idea of what it means to crown a book.

The French prizes are national and stable : they reward French-language novels, almost always by French authors, never share their prize and never skip a year, and they remain closely tied to a handful of Parisian publishers. The Japanese prizes are just as national in language, but more open in nationality than their reputation suggests, and their juries are far more willing to divide a prize or to withhold it entirely. The Pulitzer is national by rule. The Booker has moved from a Commonwealth prize to a prize for all of English-language fiction, without yet changing its map. And the Nobel, the only truly international prize of the corpus, remains largely European, though less so since the 1990s.

What these prizes ultimately reveal is not only which books were judged the best, but how each literary culture decides who belongs to it.
