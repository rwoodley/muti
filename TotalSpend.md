# TotalSpend

Add a `total_spend` field to every `DEDUCTION` transaction item written to the `user-balance-ledger` DynamoDB table. The field is a running cumulative total of actual spend after discounts: `total_spend = previousDeduction.total_spend + discountedCost`. It mirrors the `balance_after` pattern — no full-history scan is required. `TOPUP_STRIPE` and `TOPUP_ADMIN` rows do not carry this field.

**Scope:** `lpserver` backend only. The field surfaces automatically to the frontend via the existing `GET /api/billing/Records` endpoint once `LedgerTransaction` / `DeductionInfo` are updated.

**Key files:**
- `Billing/LedgerTransaction.cs` — `DeductionInfo` record, `LedgerTransaction` record
- `Billing/DynamoDb/DynamoDbLedgerRepository.cs` — `RecordDeductionAsync`, `ToLedgerTransaction`

---

## Tasks

### task-1: Add `TotalSpend` to the `DeductionInfo` model
- status: pending
- dependencies: none
- Add a `decimal TotalSpend` positional parameter to the `DeductionInfo` record in `Billing/LedgerTransaction.cs`.

### task-2: Compute and store `total_spend` in `RecordDeductionAsync`
- status: pending
- dependencies: task-1
- In `DynamoDbLedgerRepository.RecordDeductionAsync`, add a private helper `ReadLastDeductionTotalSpendAsync(string userId)` that queries the TX partition in reverse (ScanIndexForward=false) with a `FilterExpression` on `#t = :deduction`, paginates until a DEDUCTION item with a `total_spend` attribute is found, and returns its value (or `0m` if none exists).
- Compute `totalSpend = previousTotalSpend + discountedCost` and write `total_spend` as a Number attribute to the DynamoDB item.

### task-3: Map `total_spend` in `ToLedgerTransaction`
- status: pending
- dependencies: task-1
- In `DynamoDbLedgerRepository.ToLedgerTransaction`, read `total_spend` from the DynamoDB item when `type == Deduction` (default `0m` if absent for backward compatibility) and pass it as the `TotalSpend` argument to `DeductionInfo`.
