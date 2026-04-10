# TotalSpend — Running cumulative spend on DEDUCTION ledger rows

Add a `total_spend` field to each `DEDUCTION` transaction item in the `user-balance-ledger` DynamoDB table. The field is a running cumulative total of actual spend (after discounts): computed by reading the previous DEDUCTION row's `total_spend` and adding the current `discountedCost`. This mirrors the `balance_after` pattern — no full-history scan is needed. Top-up rows (`TOPUP_STRIPE`, `TOPUP_ADMIN`) do not carry this field.

**Repo:** `lpserver` (`/Users/robertwoodley/lpcode/lpserver`)
**Branch:** `Muti-TotalSpend`

---

## Tasks

### task-1
**status:** pending
**description:** Add `TotalSpend` field to `DeductionInfo` record (`Billing/LedgerTransaction.cs`) and populate it from the DynamoDB item in `ToLedgerTransaction` in `DynamoDbLedgerRepository.cs`. The field is `decimal?` (nullable to handle historical rows that pre-date this feature). Use `total_spend` as the DynamoDB attribute name.
**dependencies:** none

### task-2
**status:** pending
**description:** Compute and persist `total_spend` in `RecordDeductionAsync` (`Billing/DynamoDb/DynamoDbLedgerRepository.cs`). Add a private helper `ReadLastTotalSpendAsync(userId)` that queries TX items in reverse order (ScanIndexForward=false) with a small page size (e.g. Limit=10) and returns the `total_spend` value from the first item that has that attribute. In `RecordDeductionAsync`, call this helper, compute `totalSpend = previousTotalSpend + discountedCost`, and write `total_spend` onto the new DEDUCTION item.
**dependencies:** task-1

### task-3
**status:** pending
**description:** Update `Documents/StripeImplementation.md` to document `total_spend` as a DEDUCTION-only field in the TX item schema, and add it to the DEDUCTION item field list under "DynamoDB Tables → user-balance-ledger".
**dependencies:** task-2
