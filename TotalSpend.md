# TotalSpend

Add a `TotalSpend` column to the DynamoDB user balance ledger table. This is a running cumulative total of actual spend (after discounts) written onto each `DEDUCTION` transaction row. It mirrors the pattern of `BalanceAfter` — computed by reading the previous row's value and adding the current charge — so no full-history scan is needed. Top-up rows do not carry this field.

**Target repo:** `/Users/robertwoodley/lpcode/lpserver`  
**Working branch:** `Muti-TotalSpend`

## Tasks

### task-1: Add TotalSpend to LedgerTransaction record
- **status:** pending
- **depends on:** (none)
- **description:** Add a nullable `decimal? TotalSpend` parameter to the `LedgerTransaction` record in `Billing/LedgerTransaction.cs`. It is only populated for `Deduction` transactions; top-up rows leave it null.

### task-3: Display TotalSpend in the frontend billing view
- **status:** pending
- **target:** lpfrontend
- **depends on:** task-2
- **description:** In the React frontend, update the billing/transaction history view to display the `totalSpend` field returned on each `DEDUCTION` row from `GET /api/billing/Records`. Show it as a running "Total spent" column alongside the existing balance column.

### task-2: Persist and deserialize TotalSpend in DynamoDbLedgerRepository
- **status:** pending
- **depends on:** task-1
- **description:** In `Billing/DynamoDb/DynamoDbLedgerRepository.cs`:
  1. Add a private helper `ReadCurrentTotalSpendAsync(string userId)` that queries the most recent DEDUCTION row (filter by `type = Deduction`) and returns its `total_spend` value, or `0` if none exists.
  2. In `RecordDeductionAsync`, call the helper to get the previous `TotalSpend`, compute `totalSpend = previousTotalSpend + discountedCost`, and write `total_spend` as an `N` attribute on the new item.
  3. In `ToLedgerTransaction`, read `total_spend` from the item (if present) and pass it into the `LedgerTransaction` constructor.
