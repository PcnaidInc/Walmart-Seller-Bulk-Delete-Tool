# Walmart Seller Bulk Delete Tool

[![CI](https://github.com/PcnaidInc/Walmart-Seller-Bulk-Delete-Tool/actions/workflows/python-ci.yml/badge.svg)](https://github.com/PcnaidInc/Walmart-Seller-Bulk-Delete-Tool/actions/workflows/python-ci.yml)
![Python](https://img.shields.io/badge/Python-3.11%2B-3776AB?logo=python&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-444)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
![Mode](https://img.shields.io/badge/Mode-Direct%20API%20Delete-0071DC)

A resumable Walmart Marketplace SKU deletion script that reads SKUs from CSV or XLSX, deletes them directly through the Walmart API, auto-refreshes tokens during long runs, writes per-SKU logs, and resumes cleanly after interruption.

## Why this repo exists

The path that reliably worked in the real deletion run behind this repo was:

- use a local CSV/XLSX list of SKUs,
- delete directly through the Walmart API,
- log every SKU,
- checkpoint every SKU,
- refresh the token automatically,
- and resume from where the run stopped.

The Seller Center bulk spreadsheet flow was less reliable for larger jobs, so this repo focuses on the direct API approach that actually completed the deletion run.

## Features

- Reads SKUs from **CSV**, **XLSX**, or **XLSM**
- Accepts a sheet name and column selector for spreadsheet input
- Normalizes Excel-style numeric SKU values like `810197101622.00` to `810197101622` when safe
- Deletes one SKU at a time through the Walmart API
- Auto-refreshes the access token on schedule and retries the same SKU after the first `401`
- Saves a **checkpoint after every SKU**
- Appends a **results CSV after every SKU**
- Skips already completed `deleted` and `not_found` SKUs on rerun
- Handles `Ctrl+C` much more cleanly than the earlier non-resumable version

## Repository layout

```text
.
├── walmart_delete_from_csv_or_xlsx_resumable.py
├── requirements.txt
├── .gitignore
├── LICENSE
├── SECURITY.md
├── CONTRIBUTING.md
├── docs/
│   └── troubleshooting.md
├── examples/
│   ├── sample_skus.csv
│   └── windows/
│       └── quickstart.ps1
└── .github/
    └── workflows/
        └── python-ci.yml
```

## Requirements

- Python 3.11 or newer recommended
- Walmart Marketplace API credentials
- `requests`
- `openpyxl` only if you want to read from `.xlsx` / `.xlsm`

Install dependencies:

```powershell
pip install -r requirements.txt
```

## Environment variables

Set these before running the script:

```powershell
$env:WALMART_CLIENT_ID = "YOUR_CLIENT_ID"
$env:WALMART_CLIENT_SECRET = "YOUR_CLIENT_SECRET"
```

Optional:

```powershell
$env:WALMART_WM_SVC_NAME = "Walmart Marketplace"
$env:WALMART_CHANNEL_TYPE = "YOUR_CHANNEL_TYPE_IF_REQUIRED"
```

## Quick start

### 1. Dry run first

```powershell
python .\walmart_delete_from_csv_or_xlsx_resumable.py `
  --in-file ".\examples\sample_skus.csv" `
  --dry-run `
  --log-csv "walmart_delete_results.csv" `
  --summary-txt "walmart_delete_summary.txt" `
  --checkpoint-file "walmart_delete_checkpoint.json"
```

### 2. Delete from CSV

```powershell
python .\walmart_delete_from_csv_or_xlsx_resumable.py `
  --in-file "C:\path\to\cleaned_skus.csv" `
  --log-csv "walmart_delete_results.csv" `
  --summary-txt "walmart_delete_summary.txt" `
  --checkpoint-file "walmart_delete_checkpoint.json" `
  --rate-per-minute 300
```

### 3. Delete from XLSX

```powershell
python .\walmart_delete_from_csv_or_xlsx_resumable.py `
  --in-file "C:\path\to\bulk_sku_deletion_spreadsheet.xlsx" `
  --sheet "Deletable" `
  --column D `
  --log-csv "walmart_delete_results.csv" `
  --summary-txt "walmart_delete_summary.txt" `
  --checkpoint-file "walmart_delete_checkpoint.json" `
  --rate-per-minute 300
```

## Resume behavior

This is the main reason to use this script.

On rerun, it will:

- read the prior log,
- skip SKUs already logged as `deleted` or `not_found`,
- load the last checkpoint,
- and continue from where it left off.

### Resume the same run

Just rerun the same command.

### Manually start at a specific source index

```powershell
python .\walmart_delete_from_csv_or_xlsx_resumable.py `
  --in-file "C:\path\to\cleaned_skus.csv" `
  --start-at 1401 `
  --log-csv "walmart_delete_results_v2.csv" `
  --summary-txt "walmart_delete_summary_v2.txt" `
  --checkpoint-file "walmart_delete_checkpoint_v2.json" `
  --rate-per-minute 300
```

### Force a completely fresh run

```powershell
python .\walmart_delete_from_csv_or_xlsx_resumable.py `
  --in-file "C:\path\to\cleaned_skus.csv" `
  --fresh-run `
  --log-csv "walmart_delete_results_fresh.csv" `
  --summary-txt "walmart_delete_summary_fresh.txt" `
  --checkpoint-file "walmart_delete_checkpoint_fresh.json"
```

## Output files

The script writes three important files:

- `walmart_delete_results.csv` — one row per attempted SKU
- `walmart_delete_summary.txt` — summary counts and run metadata
- `walmart_delete_checkpoint.json` — used to resume after interruption or token expiry

## What “worked” in the original run

For anyone cloning this repo because they are stuck in the same place:

- The direct API delete approach worked.
- A rate of `300` per minute was a good conservative default.
- The resumable script was the version worth keeping.
- Seller Center counts were not always the best live source of truth during the run.
- The results CSV, checkpoint file, and exact SKU spot-checks were more trustworthy than stale UI totals.

## Common commands

The full Windows command set is in:

- [`examples/windows/quickstart.ps1`](examples/windows/quickstart.ps1)

Troubleshooting notes are here:

- [`docs/troubleshooting.md`](docs/troubleshooting.md)

## Script options

```text
--in-file                          Path to CSV or XLSX containing SKUs.
--sheet                            Worksheet name for XLSX input.
--column                           Column name, letter, or index.
--log-csv                          Per-SKU results log.
--summary-txt                      Summary output file.
--checkpoint-file                  Resume checkpoint file.
--rate-per-minute                  Delete rate. Default: 300.
--start-at                         1-based source row to begin from.
--max-count                        Maximum extracted SKUs to process.
--dry-run                          Validate input without deleting.
--fresh-run                        Ignore old log/checkpoint and start over.
--refresh-token-every-minutes      Proactive token refresh interval.
```

## Security

Do **not** commit any of the following to a public repo:

- real Walmart API credentials
- exported seller catalog files
- deletion logs containing your seller data
- checkpoint files from live runs

See [`SECURITY.md`](SECURITY.md).

## License

MIT — see [`LICENSE`](LICENSE).
