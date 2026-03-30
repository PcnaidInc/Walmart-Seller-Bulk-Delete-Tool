# Windows PowerShell quick start for Walmart Seller Bulk Delete Tool
# Replace the example paths with your own.

# 1) Install dependencies
pip install -r .\requirements.txt

# 2) Set credentials for the current shell session
$env:WALMART_CLIENT_ID = "YOUR_CLIENT_ID"
$env:WALMART_CLIENT_SECRET = "YOUR_CLIENT_SECRET"
# Optional only if your account requires it:
# $env:WALMART_CHANNEL_TYPE = "YOUR_CHANNEL_TYPE"

# 3) Dry run from CSV
python .\walmart_delete_from_csv_or_xlsx_resumable.py `
  --in-file "C:\path\to\cleaned_skus.csv" `
  --dry-run `
  --log-csv "walmart_delete_results.csv" `
  --summary-txt "walmart_delete_summary.txt" `
  --checkpoint-file "walmart_delete_checkpoint.json"

# 4) Real delete from CSV
python .\walmart_delete_from_csv_or_xlsx_resumable.py `
  --in-file "C:\path\to\cleaned_skus.csv" `
  --log-csv "walmart_delete_results.csv" `
  --summary-txt "walmart_delete_summary.txt" `
  --checkpoint-file "walmart_delete_checkpoint.json" `
  --rate-per-minute 300

# 5) Real delete from XLSX, sheet Deletable, column D
python .\walmart_delete_from_csv_or_xlsx_resumable.py `
  --in-file "C:\path\to\bulk_sku_deletion_spreadsheet.xlsx" `
  --sheet "Deletable" `
  --column D `
  --log-csv "walmart_delete_results.csv" `
  --summary-txt "walmart_delete_summary.txt" `
  --checkpoint-file "walmart_delete_checkpoint.json" `
  --rate-per-minute 300

# 6) Resume the exact same run after interruption or token expiry
python .\walmart_delete_from_csv_or_xlsx_resumable.py `
  --in-file "C:\path\to\cleaned_skus.csv" `
  --log-csv "walmart_delete_results.csv" `
  --summary-txt "walmart_delete_summary.txt" `
  --checkpoint-file "walmart_delete_checkpoint.json" `
  --rate-per-minute 300

# 7) Manual restart from a known source index with new output files
python .\walmart_delete_from_csv_or_xlsx_resumable.py `
  --in-file "C:\path\to\cleaned_skus.csv" `
  --start-at 1401 `
  --log-csv "walmart_delete_results_v2.csv" `
  --summary-txt "walmart_delete_summary_v2.txt" `
  --checkpoint-file "walmart_delete_checkpoint_v2.json" `
  --rate-per-minute 300

# 8) Completely fresh run with new artifacts
python .\walmart_delete_from_csv_or_xlsx_resumable.py `
  --in-file "C:\path\to\cleaned_skus.csv" `
  --fresh-run `
  --log-csv "walmart_delete_results_fresh.csv" `
  --summary-txt "walmart_delete_summary_fresh.txt" `
  --checkpoint-file "walmart_delete_checkpoint_fresh.json" `
  --rate-per-minute 300
