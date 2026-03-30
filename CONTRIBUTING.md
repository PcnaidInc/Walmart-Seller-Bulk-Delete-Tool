# Contributing

Thanks for improving this project.

## Ground rules

- Keep changes practical and copy-paste friendly.
- Preserve the resumable behavior.
- Do not add credential values, real seller exports, or live logs.
- Prefer small, reviewable pull requests.

## Suggested workflow

1. Create a branch.
2. Make the change.
3. Run the local checks.
4. Open a pull request with a clear summary and example command if behavior changed.

## Local check

```powershell
python -m py_compile .\walmart_delete_from_csv_or_xlsx_resumable.py
```
