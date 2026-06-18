# Campaign A/B Test Analysis
### Which campaign converts customers more efficiently?

---

## Overview

This project analyzes two marketing campaigns — **Control Campaign** and **Test Campaign**, using A/B testing methodology to determine which campaign is more efficient at converting customers through the marketing funnel.

The analysis was performed using **SQL Server** for data preparation and aggregation, and **Python (Jupyter Notebook)** for statistical testing and visualization.

**Dataset:** [A/B Testing Dataset — Kaggle](https://www.kaggle.com/datasets/amirmotefaker/ab-testing-dataset?resource=download)

---

## Business Question

> *Which campaign converts customers more efficiently, and where in the funnel does it win or lose?*

---

## Key Findings

| KPI | Control Campaign | Test Campaign | Winner |
|-----|-----------------|---------------|--------|
| CTR | 4.86% | 8.25% | Test |
| CPC | $0.433 | $0.426 | Test (marginal) |
| CPA | $4.41 | $5.02 | **Control** |
| CPM | $21.03 | $35.13 | **Control** |

- **Test Campaign wins on engagement** (CTR nearly double), but **Control Campaign wins on efficiency** (lower cost per acquisition)
- The difference in purchase conversion rates is **statistically significant** (Chi-square p-value ≈ 0.0)
- The difference in **average daily purchases is NOT significant** (Mann-Whitney U p-value = 0.816) — both campaigns produce similar daily purchase volumes
- **Biggest insight:** Test Campaign attracts more clicks but lower-quality traffic — a classic volume vs. quality tradeoff

---

## Project Structure

```
├── campaign_ab_analysis.ipynb     # Main Python analysis notebook
├── SQL file/
│   ├── campaign_ab_analysis.sql   # SQL data preparation queries
├── SQL exported tables/
│   ├── summary_table.csv          # Per-campaign raw totals
│   ├── KPIs.csv                   # CTR, CPC, CPA, CPM per campaign
│   ├── stage_conversion_funnel.csv # Stage-to-stage conversion rates
│   └── compare_daily.csv          # Daily totals with rolling spend
├── visualizations/
│   ├── CTR.png
│   ├── CPC.png
│   ├── CPA.png
│   ├── CPM.png
│   ├── funnel_conversion.png
│   ├── funnel_volume.png
│   ├── daily_purchases.png
│   ├── daily_rolling_spend.png
│   └── plot.png                   # Correlation heatmap
├── Original Dataset/
│   ├── control_group.csv
│   ├── test_group.csv
```

---

## Methodology

### Data Preparation (SQL)
- Combined Control and Test campaign tables into a unified `all_groups` table
- Removed a date anomaly (`2019-08-05`) present in both tables
- Aggregated campaign totals and calculated KPIs (CTR, CPC, CPA, CPM)
- Built a daily breakdown table with rolling spend and day-over-day purchase change using window functions (`PARTITION BY`, `LAG`)

### Statistical Analysis (Python)
- **Chi-Square Test** — tested whether the difference in purchase conversion rates between campaigns is statistically significant
- **Mann-Whitney U Test** — tested whether average daily purchases differ significantly between campaigns; distribution normality was verified via histograms before selecting this non-parametric test
- **Correlation Heatmap** — identified relationships between funnel metrics

### Visualizations (Python — Seaborn/Matplotlib)
- KPI bar charts (CTR, CPC, CPA, CPM)
- Funnel volume chart (absolute drop-off at each stage)
- Funnel conversion rate chart (stage-to-stage efficiency)
- Time series — daily purchases and rolling spend over time
- Daily purchase distribution histograms (Control and Test)
- Correlation heatmap

---

## Statistical Results

### Chi-Square Test (Purchase Conversion)
- **Chi-square statistic:** 2000.99
- **p-value:** ~0.0 (significant at p < 0.05)
- **Conclusion:** The difference in purchase conversion between campaigns is real, not due to random chance

### Mann-Whitney U Test (Daily Purchase Distribution)
- **Note:** Histograms of daily purchases for both campaigns showed non-normal distributions, making the T-Test inappropriate. The Mann-Whitney U Test was used as the correct non-parametric alternative.
- **U-statistic:** 436.0
- **p-value:** 0.816 (not significant)
- **Conclusion:** Both campaigns produce similar daily purchase volumes — the difference in total purchases is driven by campaign reach and budget, not day-to-day performance differences

---

## Tools & Libraries

| Tool | Purpose |
|------|---------|
| SQL Server (SSMS) | Data cleaning, aggregation, KPI calculation |
| Python 3 | Analysis and visualization |
| Pandas | Data manipulation |
| Seaborn / Matplotlib | Visualizations |
| Scipy | Chi-square test, Mann-Whitney U test |
| NumPy | Numerical calculations |

---

## Recommendation

**The Control Campaign is the more efficient investment.** Despite lower CTR, it achieves a lower cost per acquisition ($4.41 vs $5.02) and lower CPM ($21.03 vs $35.13). The Test Campaign attracts more clicks but at higher cost and lower conversion quality, indicating the Test Campaign's creative may be driving curiosity clicks rather than purchase intent.
