# TotalSpend

Add a `total_spend` field to every `DEDUCTION` transaction item written to the `user-balance-ledger` DynamoDB table. The field is a running cumulative total of actual spend after discounts, mirroring the `balance_after` pattern so no full-history scan is ever required. The field is exposed through the existing `GET /api/billing/Records` API response (per-row on deduction items) and through `GET /api/billing/Balance` (as a summary `totalSpendUsd` field). The frontend Billing page displays a lifetime spend summary alongside the current balance.

### Impacted components

- **lpserver** — `Billing` project (write path, DTO, interface) and `Web.Api` (`BillingController`)
- **lpclient** — `Billing.jsx` (display summary stat; per-row column appears automatically from API response)

---

## Tasks

### task-1

**status:** done
**target:** lpserver
**description:**
Write `total_spend` to DEDUCTION items and expose it through `LedgerTransaction`.

- `Billing/LedgerTransaction.cs` — add `decimal? TotalSpend` to the `LedgerTransaction` positional record.
- `Billing/DynamoDb/DynamoDbLedgerRepository.cs`:
  - Add `ReadCurrentTotalSpendAsync(string userId)` private helper — query `TX#USER#{userId}` descending with limit 20, return the first item's `total_spend` attribute value, or `null` if none found.
  - In `RecordDeductionAsync`: call the helper, compute `totalSpend = (previousTotalSpend ?? 0m) + discountedCost`, and write `total_spend` as a DynamoDB `N` attribute on the new item.
  - In `ToLedgerTransaction`: read `total_spend` from the item (if present) and populate `TotalSpend` on the returned `LedgerTransaction`.

**dependencies:** none

---

### task-2

**status:** done
**target:** lpserver
**description:**
Expose `totalSpendUsd` in the `GET /api/billing/Balance` response.

- `Billing/IUserLedgerRepository.cs` — add `Task<decimal?> GetCurrentTotalSpendAsync(string userId)`.
- `Billing/DynamoDb/DynamoDbLedgerRepository.cs` — implement `GetCurrentTotalSpendAsync` by delegating to `ReadCurrentTotalSpendAsync`.
- `Web.Api/Controllers/BillingController.cs` — in `GetBalance`, call `GetCurrentTotalSpendAsync` and return `{ balanceUsd, totalSpendUsd }`.

**dependencies:** task-1

---

### task-3

**status:** done
**target:** lpclient
**description:**
Display lifetime total spend on the Billing page.

- `src/pages/Billing.jsx` — read `totalSpendUsd` from the `getBillingBalance` response in the existing `init` effect and store it in local state. Render it below the current balance display (e.g. "Lifetime spend: $X.XX"). The per-row `totalSpend` column in the transaction table will appear automatically since columns are derived from `Object.keys(records[0])` and `formatValue` already formats keys containing `"total"` as dollar amounts.

**dependencies:** task-2
