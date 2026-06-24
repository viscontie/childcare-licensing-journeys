# NYC Data

This folder contains the cleaned CSV files for New York City childcare licensing journeys.

## Files to upload here

- `nodes.csv` 
- `journeys.csv` 

## How to update the data

1. Add or edit the csv files 
2. Run `node scripts/csv-to-json.mjs` from the repo root
3. This will overwrite `static/data/journeys.json` with the new data
