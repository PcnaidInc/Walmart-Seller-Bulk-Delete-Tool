# Security Policy

## Supported use

This repository is intended for sellers who need a resumable way to delete Walmart Marketplace SKUs from a CSV or spreadsheet-driven source list.

## Do not commit secrets

Never commit any of the following to this public repository:

- `WALMART_CLIENT_ID`
- `WALMART_CLIENT_SECRET`
- `WALMART_CHANNEL_TYPE`
- seller catalog exports
- deletion logs from live runs
- checkpoint files from live runs

## If a secret was exposed

Rotate it immediately in Walmart Developer / API credentials and replace it everywhere you used it.

## Safer local workflow

- keep seller data outside the repo when possible
- use environment variables for credentials
- use `.gitignore` to block logs, checkpoints, and exports
- verify your current branch before pushing

## Reporting a security issue

Open a private channel with the repository maintainer instead of opening a public issue that contains credentials or seller data.
