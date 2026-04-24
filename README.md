# 🛒 Brazilian E-Commerce Analytics — BigQuery + Looker Studio

An end-to-end data analytics project built on Google Cloud Platform analyzing 100,000+ real orders from Olist, Brazil's largest e-commerce marketplace.

**Live Dashboard →** https://datastudio.google.com/s/loqxB0kJmHw

---

## 📊 Project Overview

This project demonstrates a complete data pipeline:

```
Kaggle Dataset → Google Cloud Storage → BigQuery → SQL Transforms → Looker Studio Dashboard
```

**Dataset**: [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)  
**Tools:** BigQuery · Looker Studio · Google Cloud Storage · SQL  
**Records:** ~100,000 orders · 9 relational tables · 2016–2018

---

## 🏗️ Architecture

```
┌─────────────┐     ┌─────────────────┐     ┌──────────────────────┐     ┌───────────────────┐
│   Kaggle    │────▶│  Cloud Storage  │────▶│      BigQuery        │────▶│   Looker Studio   │
│  9 CSV files│     │  olist-raw-data │     │  olist_raw dataset   │     │   4-page dashboard│
└─────────────┘     └─────────────────┘     └──────────────────────┘     └───────────────────┘
```

---
