# Case Study: Where Is Public EV Charging Falling Behind in India?

**Author:** Mudra Berde | **Tools:** Python, SQL (SQLite), Tableau Public | **Data:** two official Government of India tables

## 1. The problem

India has more than 10 million registered electric vehicles, and public charging has to keep up. Anyone deciding where to build charging stations (an operator, an infrastructure investor or a state policy team) needs to know **which states are most under-served relative to their EV adoption** and whether new stations are going to the right places.

**Questions:** Which states have the most EVs per charging station? Which combine high adoption with thin charging? Did stations installed after March 2024 move towards the states that needed them? Are the stations that exist actually working?

## 2. The data

- **EVs registered by state**, April 2019 to March 2024, with total vehicles sold (Ministry of Heavy Industries, based on Vahan data): 3,639,617 EVs.
- **Public charging stations by state and year**, FY2020-21 to 1 March 2026, installed by the three Oil Marketing Companies (Rajya Sabha reply, March 2026): 27,737 stations, 22,753 operational.

Both came as tables inside government documents, so I transcribed them to CSV and **checked every total against the published figures**. All matched. State names needed cleaning (for example Jharkhand and Puducherry were spelled differently in the two tables, and Leh and Ladakh were listed separately). Telangana had no EV figure and was left out.

## 3. Approach

1. **Compared like with like.** EVs registered up to March 2024 were compared with stations installed up to March 2024. Stations installed after that were analysed separately.
2. **Built simple metrics:** EV penetration, EVs per station, each state's share of EVs versus share of stations, and the share of stations that are operational.
3. **Classified states** with at least 20,000 EVs against the national figures (3.38% EV penetration, 254 EVs per station). States above both are "priority gap" states.
4. **Wrote 8 SQL queries** (CTEs, window functions, pivots, subqueries) to answer the questions and cross-check the Python results.
5. **Published a Tableau dashboard** with a map, a ranking, a scatter plot and the build-out charts.

## 4. What I found

- **Delhi is the most stretched:** about 940 EVs per station against 254 nationally. Next are Bihar (554), Assam (429), Maharashtra (392) and Goa (370).
- **Ten states are "priority gap" states:** Delhi, Bihar, Assam, Maharashtra, Goa, Tripura, Uttar Pradesh, Kerala, Uttarakhand and Karnataka.
- **Later stations did not close the gap in the largest markets.** Uttar Pradesh has 18.3% of EVs but received 10.1% of stations installed after March 2024. Bihar (5.9% of EVs, 3.1% of new stations) and Assam (4.1% and 1.5%) show the same pattern.
- **Some states are speeding up.** Delhi's yearly installs went from 100 to 344, Karnataka's rose 116% and Bihar's 100%.
- **Concentration:** the five states with the most EVs hold 52.7% of EVs but 47.2% of stations.
- **Working stations matter as much as new ones.** Tamil Nadu has the most non-operational stations (609 of 2,286), and Puducherry has only 41% of its stations operational.
- **Overall growth was fast:** from 290 stations installed in FY2020-21 to 10,516 in FY2024-25.

## 5. What I would recommend

1. **Prioritise Delhi, Bihar, Assam, Maharashtra and Uttar Pradesh** for new stations: they combine high pressure with large markets or large shortfalls in the new build-out.
2. **Treat Goa, Tripura and Uttarakhand as small, high-pressure markets.** Their ratios are high but absolute numbers are small, so they are lower priority by volume.
3. **Repair before building** in states such as Tamil Nadu and Puducherry, where a large share of installed stations is not operational.
4. **Verify with all-operator data before committing capital.** This analysis only sees stations installed by oil companies.

## 6. Limitations (what I would not claim)

- The station data covers oil-company stations only (27,737 of about 52,718 reported nationwide), so gaps may look larger than they are, especially where private networks are strong.
- EV registrations end in March 2024. Later stations are compared with each state's March 2024 share of EVs, which assumes that share stayed roughly stable.
- EVs of all types are counted together. Many two- and three-wheelers charge at home, so "EVs per public station" shows pressure on public charging, not total demand.
- The 20,000-EV cut-off and the national benchmarks are simple choices. Other choices would change which states are labelled "priority gap".
- The sharp drop in stations installed in FY2025-26 (to 1 March) may reflect reporting timing, so I do not interpret it.

## 7. What I would do next

Add stations from all operators, update EV registrations to 2026, split EVs by vehicle type, and add highway corridors and population density.

**Links:** [Live dashboard](PASTE-YOUR-TABLEAU-PUBLIC-LINK-HERE) | [Code and notebooks](https://github.com/Mudra04/india-ev-charging-gap)
