# Data sources

All data in this project comes from official Government of India documents. The tables were transcribed into CSV files and checked against the totals published in the same documents (see Step 2 of `notebooks/01_prepare_and_analyse.ipynb`).

## 1. EVs registered by state (`data/raw/ev_registrations_by_state_fy2019_24.csv`)

- **Document:** "Promotion of Electric Vehicles", Press Information Bureau, Ministry of Heavy Industries, 13 December 2024 (Release ID 2084148), written reply in the Rajya Sabha.
- **Table:** Annexure, "State-wise data of the total number of Electric Vehicles (EVs) registered as percentage of the total number of vehicles registered during 01/04/2019 till 31/03/2024". Source stated in the document: Vahan data.
- **Link:** https://www.pib.gov.in/PressReleseDetailm.aspx?PRID=2084148&reg=48&lang=2
- **Check:** total EVs 36,39,617 and total vehicles 10,75,31,040, as published.

## 2. Public EV charging stations by state and year (`data/raw/ev_charging_stations_omc_by_state_mar2026.csv`)

- **Document:** Rajya Sabha Unstarred Question No. 3910, "Status and Expansion of EV Charging Infrastructure", answered 27 March 2026, Ministry of Heavy Industries.
- **Table:** Annexure, state-wise details of EV public charging stations installed and operationalised by Oil Marketing Companies (OMCs) as on 01.03.2026, by financial year.
- **Link:** https://www.heavyindustries.gov.in/sites/default/files/2026-03/rsauq3910.pdf
- **Check:** yearly totals 314 / 2,344 / 4,658 / 7,649 / 11,246 / 1,547, decommissioned 21, total installed 27,737, operational 22,753, as published.

## 3. Context only (not used in any calculation)

- Lok Sabha Unstarred Question No. 1956, answered 30 July 2026, Ministry of Road Transport and Highways: 1,00,23,396 EVs registered as on 26-07-2026 (Vahan), and 52,718 EV charging stations as on 31.03.2026 (BHEL portal).
- Link: https://sansad.in/getFile/lsapps/loksabhaquestions/annex/188/AU1956_NQ8q4A.pdf

## Known limitations of the data

- **Charging stations cover Oil Marketing Companies only** (27,737 installed), not all public chargers in India (52,718 reported by the BHEL portal as on 31.03.2026). States where private operators or state utilities built many chargers look more under-served here than they really are.
- **Periods differ.** EV registrations stop at 31 March 2024. Stations are compared with EVs up to the same date (FY2020-21 to FY2023-24); later stations are analysed separately.
- **The station table starts at FY2020-21**, while EV registrations start in April 2019.
- **Telangana** has no figure in the EV table (it runs its own registration system), so it is left out of the comparison.
- **Leh** is listed separately from Ladakh in the station table and was added to Ladakh. **Sikkim** is shown as "-" for EVs and is treated as 0.
- EV counts include all vehicle types (two-wheelers, three-wheelers, cars, buses), and many two- and three-wheelers charge at home or swap batteries, so "EVs per public station" measures pressure on public charging, not total demand.
- Before reusing or redistributing these documents, check the reuse terms on the PIB and Ministry websites.
