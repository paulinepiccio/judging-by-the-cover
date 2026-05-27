# Data Cleaning Log

This document tracks the data quality issues encountered during the project and the corrections I applied. 

## Phase 1 — Scraping fixes (during data collection)

### Nobel Prize: missing co-laureates

The parser missed two pairs of Nobel co-laureates due to ambiguous Wikipedia formatting where additional text (language indication, footnote) interfered with the parsing of laureate names.

**Manual fixes applied during scraping:**
- **1966**: Added Nelly Sachs (Sweden) as co-laureate with Samuel Joseph Agnon. The original parser captured "hébreu" (Hebrew, the writing language) as the author name.
- **1974**: Added Harry Martinson (Sweden) as co-laureate with Eyvind Johnson. The original parser merged both names into a single string.

### Naoki Prize: concatenated co-laureate names

Wikipedia EN lists Naoki co-laureates without explicit separators (no comma or "and"), resulting in two names being concatenated into a single string (e.g., "Toko Sawada Norikazu Sato").

**Manual fixes applied:**
- 59 sessions identified where the `author` field contained two concatenated names
- Each session split into two separate rows, with the `notes` field set to "Co-laureate"
- All splits validated against Japanese Wikipedia for accuracy

### Naoki Prize: 6 missing years

During scraping, 6 entries from the Naoki Prize had `year = NaN` due to a parsing issue with the page structure.

**Manual fixes applied:**
- Identified via cross-reference with the official prize chronology
- Corrected to: 1986 H1, 1986 H2, 1987 H1, 1987 H2, 1996 H1, 1996 H2

### Pulitzer Prize 2023: ex æquo not parsed

The 2023 Pulitzer Prize for Fiction was awarded to two co-laureates (Barbara Kingsolver and Hernan Diaz), but the FR Wikipedia listing used the French expression "ex æquo" which broke the regex pattern.

**Manual fixes applied:**
- Original entry deleted (placeholder with "ex æquo" as title)
- Two new entries added: Barbara Kingsolver (*Demon Copperhead*) and Hernan Diaz (*Trust*), both marked as "Co-laureate"

### Renaudot footnote markers

Three Renaudot laureates had footnote markers `[34]`, `[35]`, `[36]` attached to their names from Wikipedia. Cleaned via regex post-scraping.

---

## Phase 2 — Cleaning and harmonization

### Country normalization

The 7 source CSVs used different country naming conventions:
- Nobel (FR Wikipedia): French names ("Allemagne", "Empire allemand", "Royaume d'Espagne")
- Booker (EN Wikipedia): ISO 3-letter codes ("ENG", "AUS", "RSA")
- Pulitzer, Akutagawa, Naoki: English names (hardcoded)
- Goncourt, Renaudot: no country column (added through note parsing)

**Decisions applied:**
- All country names normalized to **modern English names**
- Historical states mapped to their modern equivalents: "Empire allemand" → Germany, "USSR" → Russia, "Yugoslavia" → Serbia, "Czechoslovakia" → Czech Republic
- For Booker laureates with dual nationality ("UK TTO", "CAN SRI"), the first listed nationality was retained
- Final dataset: 47 unique countries

### Goncourt and Renaudot: inferred nationalities

The Goncourt and Renaudot prizes do not provide an explicit `author_country` field on Wikipedia. A two-step approach was applied:

1. All laureates initially assigned to **France** as the default nationality
2. Non-French nationalities identified by parsing the `notes` field for explicit mentions

**Result:** 11 Goncourt laureates and 6 Renaudot laureates identified as non-French.

**Known limitation:** This approach captures the legal nationality at the time of the prize but may underrepresent:
- Naturalized French citizens of foreign origin (e.g., Andreï Makine, Russian-born, naturalized French)
- Authors from French overseas territories (e.g., Patrick Chamoiseau, Martinique)
- Dual-nationality laureates (e.g., John-Antoine Nau, born in San Francisco but Francophone author all his life)

These authors were retained as "France" to reflect their legal status at the time of the prize.

---

## Phase 3 — Post-upload corrections in BigQuery

### Ghost laureate A0421 (Nobel)

During Nobel Prize scraping, the parser misinterpreted a "/" character in 5 Wikipedia entries as a co-laureate separator, creating a fictional author with `name = "/"` linked to 5 non-existent co-laureate rows.

**Impacted years:** 1980, 1981, 2008, 2009, 2010 (all years where the Nobel had a single laureate, not co-laureates).

**Verified real laureates for those years:**
- 1980: Czesław Miłosz (Poland)
- 1981: Elias Canetti (Bulgaria, naturalized British)
- 2008: J.M.G. Le Clézio (France)
- 2009: Herta Müller (Romania, then Germany)
- 2010: Mario Vargas Llosa (Peru)

**Correction applied:** 5 rows deleted from `laureates`, 1 row deleted from `authors`.

**Result:** `laureates` table went from 946 to 941 rows.

### Akutagawa Prize: missing Co-laureate markers

Co-laureate rows from the Akutagawa Prize had been correctly split into separate rows during scraping but were not marked with `notes = 'Co-laureate'` (unlike the Naoki Prize, where the marker was applied).

**Correction applied via UPDATE in BigQuery:** All Akutagawa rows belonging to sessions with multiple laureates were updated to set `notes = 'Co-laureate'`.

**Result:** 94 Akutagawa rows marked as Co-laureate, restoring symmetry with the Naoki Prize and ensuring comparable statistics.

---

## Known remaining limitations

### Naoki Prize: missing publisher information

The EN Wikipedia page for the Naoki Prize does not consistently include the publisher of each winning work. As a result, the `publisher` column is largely empty for Naoki entries (233 rows with NULL). This limits Naoki-specific analyses on the publishing economy.

### Nobel Prize: no book title

The Nobel Prize in Literature is awarded for a body of work, not a single book. The `book_title` field is therefore NULL for all 126 Nobel entries by design.
