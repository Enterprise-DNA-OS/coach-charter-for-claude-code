# Bring Coach Manager records across

Start with a small copy of your history. Keep Coach Manager and its backups until booking counts, movement counts, money and future allocations have been reconciled.

## Get the source data

Ask your authorised Coach Manager administrator or Distinctive Systems support for a client, booking and movement export or a report that can be saved as CSV. We found no public vendor specification for those export column names on 6 October 2026. Do not assume that a generic menu exists or that an account can produce the sample format unchanged. The [vendor's product page](https://www.distinctive-systems.com/au/products/coach-manager) documents bookings, movements, driver tickets and financial reports, not this CSV contract.

The included CSV is a fictional mapping example, not a claimed native export. If the vendor supplies a workbook, save the relevant sheet as UTF-8 CSV. If it supplies only a database backup, have the authorised administrator extract the required records before using this importer.

## Map and run

One row represents one movement. Include Booking Reference, Movement Reference, Client Reference, Client Name, Description, Start, End, Pickup, Destination, Passengers, Currency, Booking Amount and Status. References must be stable and unique. Booking Amount is the total booking value repeated on each movement, never a per-leg amount. Repeated values must agree. Start and End require an ISO timestamp with an explicit timezone. Currency is NZD or AUD. Status is quote, confirmed, completed or cancelled. Reconcile tax treatment with your ledger; amounts are stored as supplied without calculating tax.

```bash
npm run charter -- import coach-manager --file=examples/coach-manager-mapped.csv --dry-run
npm run charter -- import coach-manager --file=examples/coach-manager-mapped.csv
```

For other headers add --map=imports/columns.json, for example {"booking_code":"Hire No","starts_at":"Departure ISO"}. Supported mapping keys are booking_code, movement_code, customer_code, customer_name, name, starts_at, ends_at, pickup, destination, passengers, currency, amount and status. Mapping changes header names only: convert dates, currencies and statuses explicitly before import. Unknown mapping keys, invalid dates, duplicates, inconsistent amounts and unknown statuses fail the whole transaction. A dry run rolls back everything.

Imports are idempotent when the content and references match. Existing records that differ fail the whole file so that a repeat export cannot silently change dispatched work. Reconcile the difference, then use the update command deliberately. No allocation is inferred.

## Check what carried over

Clients, booking descriptions and values, status, movement dates, route endpoints and passenger counts carry over. Contracts, vehicle and driver evidence, work/rest logs, notes, attachments, payment history, accounting links, live locations and portal credentials do not. Add verified records separately with the documented add command. Importing an invoice history is a separate mapping job; never infer payments from booking status.

Compare bookings and movements, inspect unallocated journeys, reconcile balances to the accounting system and check local times. Keep a separate tested database backup. The JSON export is a portable snapshot, not an automated restore mechanism. The one-command import begins after column mapping; a complete same-day switch is not promised without inspecting the actual export and required connections.

Enterprise DNA handles export mapping, trial migration and reconciliation as part of your custom version. Software remains in use until the operator accepts the result.
