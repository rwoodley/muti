# TotalSpend

Add a `total_spend` field to every `DEDUCTION` transaction item written to the `user-balance-ledger` DynamoDB table. The field is a running cumulative total of actual spend after discounts, mirroring the `balance_after` pattern so no full-history scan is ever required.

## Implementation notes

- `total_spend = previousDeduction.total_spend + discountedCost`
- Only `DEDUCTION` items carry this field; `TOPUP_STRIPE` and `TOPUP_ADMIN` do not.
- To read the previous `total_spend` without a full scan, query the user's TX partition `ScanIndexForward=false` with a small page size and walk forward until a `DEDUCTION` item (with `total_spend`) is found, defaulting to 0 for new users.
- The field is surfaced in `DeductionInfo` and flows out through `GET /api/billing/Records`.

## Components

- **lpserver** — `Billing/DynamoDb/DynamoDbLedgerRepository.cs`, `Billing/LedgerTransaction.cs`
- **lpclient** — billing page receives `totalSpend` in each deduction row from `GET /api/billing/Records` and should display it

---

## Tasks

### task-1
**status:** pending  
**description:** Add `TotalSpend` field to `DeductionInfo` record in `Billing/LedgerTransaction.cs`.  
**dependencies:** none

### task-2
**status:** pending  
**description:** In `DynamoDbLedgerRepository`, add a private `ReadCurrentTotalSpendAsync(string userId)` method that queries the TX partition `ScanIndexForward=false` in pages of 10, returning the `total_spend` value from the first DEDUCTION item found, or `0m` if the user has no prior deductions.  
**dependencies:** none

### task-3
**status:** pending  
**description:** In `RecordDeductionAsync`, call `ReadCurrentTotalSpendAsync`, compute `totalSpend = previousTotalSpend + discountedCost`, and write `total_spend` as a DynamoDB Number attribute on the DEDUCTION item.  
**dependencies:** task-1, task-2

### task-4
**status:** pending  
**description:** In `ToLedgerTransaction`, read the `total_spend` attribute from the DynamoDB item when mapping a DEDUCTION row, and populate the new `TotalSpend` field on `DeductionInfo`.  
**dependencies:** task-1

### task-5
**status:** pending  
**description:** Build the solution (`dotnet build`) and verify no compile errors.  
**dependencies:** task-3, task-4

### task-6
**status:** pending  
**target:** lpclient  
**description:** On the billing page, display `totalSpend` from each deduction row returned by `GET /api/billing/Records`. Show it as a running cumulative spend figure (e.g. "Total spent: $X.XX") so the user can see their lifetime spend at a glance.  
**dependencies:** none
