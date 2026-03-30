# Troubleshooting

## 401 unauthorized after a long run

The script is built to refresh the token and retry the same SKU after the first `401`.

If you still hit a persistent `401`:

1. rerun the same command,
2. make sure your environment variables are still set,
3. confirm your credentials are valid,
4. if needed, start again with a new log/checkpoint set using `--fresh-run`.

## I interrupted the script with Ctrl+C

The resumable version saves progress and checkpoint state. Re-run the same command and it should continue.

## Seller Center counts look stale

During the original working run, the most reliable live indicators were:

- the script's `deleted (200)` output,
- the results CSV,
- the checkpoint file,
- exact SKU searches.

Top-level Seller Center counts were not always the best real-time indicator while the run was active.

## My source file is XLSX and the SKUs are in column D

Use:

```powershell
python .\walmart_delete_from_csv_or_xlsx_resumable.py `
  --in-file "C:\path\to\your_file.xlsx" `
  --sheet "Deletable" `
  --column D
```

## Excel turned my numeric SKUs into values ending in .00

That is expected in some source files. The script strips `.0` and `.00` when the left side is all digits.

Examples:

- `810197101622.00` -> `810197101622`
- `PCN-841280110979` stays `PCN-841280110979`

## I want to retry from a specific point

Use `--start-at` with a new results/checkpoint set if you want a clean manual restart window.

```powershell
python .\walmart_delete_from_csv_or_xlsx_resumable.py `
  --in-file "C:\path\to\cleaned_skus.csv" `
  --start-at 1401 `
  --log-csv "walmart_delete_results_v2.csv" `
  --summary-txt "walmart_delete_summary_v2.txt" `
  --checkpoint-file "walmart_delete_checkpoint_v2.json"
```
