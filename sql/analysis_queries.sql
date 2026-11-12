-- India EV Adoption and Charging Gap Analysis: analysis queries (SQLite)

-- Query 1 - States with the most EVs per charging station
SELECT state,
       ev_total,
       chargers_to_fy24,
       ROUND(evs_per_charger_fy24, 0) AS evs_per_charger
FROM states
WHERE in_analysis_set = 1
ORDER BY evs_per_charger_fy24 DESC
LIMIT 10;

-- Query 2 - Combined adoption and charging-pressure ranking
WITH base AS (
    SELECT state, ev_penetration_pct, evs_per_charger_fy24
    FROM states
    WHERE in_analysis_set = 1
),
ranked AS (
    SELECT state,
           ev_penetration_pct,
           evs_per_charger_fy24,
           RANK() OVER (ORDER BY ev_penetration_pct DESC) AS adoption_rank,
           RANK() OVER (ORDER BY evs_per_charger_fy24 DESC) AS pressure_rank
    FROM base
)
SELECT state,
       ROUND(ev_penetration_pct, 2) AS ev_penetration_pct,
       ROUND(evs_per_charger_fy24, 0) AS evs_per_charger,
       adoption_rank,
       pressure_rank,
       adoption_rank + pressure_rank AS combined_score
FROM ranked
ORDER BY combined_score, state
LIMIT 10;

-- Query 3 - Priority-gap states (high adoption and thinly served)
WITH nat AS (
    SELECT 100.0 * SUM(ev_total) / SUM(vehicles_total) AS nat_penetration,
           1.0 * SUM(ev_total) / SUM(chargers_to_fy24) AS nat_ratio
    FROM states
)
SELECT s.state,
       ROUND(s.ev_penetration_pct, 2) AS ev_penetration_pct,
       ROUND(s.evs_per_charger_fy24, 0) AS evs_per_charger,
       ROUND(nat.nat_penetration, 2) AS national_penetration,
       ROUND(nat.nat_ratio, 0) AS national_evs_per_charger
FROM states s, nat
WHERE s.in_analysis_set = 1
  AND s.ev_penetration_pct >= nat.nat_penetration
  AND s.evs_per_charger_fy24 >= nat.nat_ratio
ORDER BY s.evs_per_charger_fy24 DESC;

-- Query 4 - States that received less than their share of new stations
SELECT state,
       ROUND(ev_share_pct, 1) AS ev_share_pct,
       ROUND(new_charger_share_pct, 1) AS new_charger_share_pct,
       ROUND(new_vs_ev_share_pp, 1) AS gap_points,
       new_chargers_after_fy24
FROM states
WHERE in_analysis_set = 1
  AND new_vs_ev_share_pp < 0
ORDER BY new_vs_ev_share_pp
LIMIT 10;

-- Query 5 - Yearly installs, growth and running total
WITH yearly AS (
    SELECT fiscal_year, SUM(chargers_installed) AS installed
    FROM installs
    GROUP BY fiscal_year
)
SELECT fiscal_year,
       installed,
       CASE WHEN fiscal_year LIKE '%to 1 Mar%' THEN NULL
            ELSE ROUND(100.0 * (installed - LAG(installed) OVER (ORDER BY fiscal_year))
                       / LAG(installed) OVER (ORDER BY fiscal_year), 1)
       END AS growth_vs_previous_year_pct,
       SUM(installed) OVER (ORDER BY fiscal_year) AS cumulative_installed
FROM yearly
ORDER BY fiscal_year;

-- Query 6 - Lowest operational rate (states with 50+ stations)
SELECT state,
       total_installed_net AS installed,
       operational,
       ROUND(operational_rate_pct, 1) AS operational_rate_pct
FROM states
WHERE total_installed_net >= 50
ORDER BY operational_rate_pct
LIMIT 8;

-- Query 7 - Change in installs, FY2023-24 to FY2024-25 (states with 100+ in FY2023-24)
WITH pivoted AS (
    SELECT state,
           SUM(CASE WHEN fiscal_year = 'FY2023-24' THEN chargers_installed ELSE 0 END) AS fy23_24,
           SUM(CASE WHEN fiscal_year = 'FY2024-25' THEN chargers_installed ELSE 0 END) AS fy24_25
    FROM installs
    GROUP BY state
)
SELECT state,
       fy23_24,
       fy24_25,
       ROUND(100.0 * (fy24_25 - fy23_24) / fy23_24, 1) AS change_pct
FROM pivoted
WHERE fy23_24 >= 100
ORDER BY change_pct DESC
LIMIT 10;

-- Query 8 - Top 5 EV states: share of EVs vs share of charging stations
SELECT ROUND(100.0 * SUM(CASE WHEN state IN (SELECT state FROM states ORDER BY ev_total DESC LIMIT 5)
                              THEN ev_total ELSE 0 END) / SUM(ev_total), 1) AS top5_share_of_evs_pct,
       ROUND(100.0 * SUM(CASE WHEN state IN (SELECT state FROM states ORDER BY ev_total DESC LIMIT 5)
                              THEN chargers_to_fy24 ELSE 0 END) / SUM(chargers_to_fy24), 1) AS top5_share_of_stations_pct
FROM states;
