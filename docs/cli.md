# Charter CLI

Run npm run charter -- help. All read and mutation commands accept --json. Use quotes around names with spaces. References match exact code, exact name, UUID prefix or a case-insensitive name fragment. More than one match lists candidates and exits 1. An exact code takes precedence only when the result is unique.

## Write records

```bash
npm run charter -- add customers --data=imports/client.json
npm run charter -- update bookings CH100 --data=imports/change.json
npm run charter -- allocate M101 BUS01 ANA
npm run charter -- unallocate M101 --yes
npm run charter -- log KOWHAI --author="Dispatcher" --text="Confirmed pickup location" --date=2026-10-06
```

Supply a JSON object using these fields. Required fields are enforced by the database. Identity and relationship fields cannot be changed after creation; add a new record if a relationship was wrong. Do not change a booking's currency after recording its invoice. paid_cents is a cumulative snapshot from the external accounting ledger, not a payment instruction or an increment.

| Type | Fields |
|---|---|
| customers | code, name, email, phone, last_contact, notes |
| vehicles | code, name, seats, country, status, inspection_due, service_due, evidence |
| drivers | code, name, country, licence_due, passenger_due, fatigue_scheme, evidence, active |
| contracts | code, name, customer_id, starts_on, ends_on, review_on, notes |
| bookings | code, name, customer_id, contract_id, status, currency, amount_cents, quote_due, notes |
| movements | code, name, booking_id, starts_at, ends_at, pickup, destination, passengers, notes |
| invoices | code, name, booking_id, issued_on, due_on, amount_cents, paid_cents, notes |
| work_blocks | code, name, driver_id, starts_at, ends_at, kind, cumulative_day, evidence |

All codes and names are nonempty text. country is NZ or AU; currency is NZD or AUD. Vehicle status is available, workshop or retired. Booking status is quote, confirmed, completed or cancelled. Work kind is work or rest. Money is integer cents; other counts are positive integers. Dates are YYYY-MM-DD; timestamps require a timezone. The database and displays use UTC. Include depot travel and turnaround in reserved movement times as appropriate for your operation. Work blocks record actual work/rest separately, including other employment. Gaps are unknown, not inferred rest.

For example, imports/client.json can contain {"code":"NEW01","name":"Example School"}. A booking requires customer_id (code or name accepted), currency, amount_cents and name/code. Create parent records first. Before changing an allocated movement's time or passenger count, or changing a booking status, release its allocation with an explicit --yes, make the change and allocate again. Re-run dispatch and compliance.

## Drafts and snapshots

weekly-review and draft-weekly save evidence in drafts/. draft-confirmation CH100 saves a draft for that booking. No command sends. npm run docs renders confirmation, work ticket, balance statement and contract review drafts using brand.json. npm run view renders three read-only reports.

export --out=exports/snapshot.json writes all ten collections from one consistent database snapshot. An existing file is never overwritten. Keep exports private. This is not a database restore command. import coach-manager is documented in replace-coach-manager.md.

Use PostgreSQL with a trusted operator role for shared use. Row-level security is enabled without anonymous policies: ordinary non-owner roles see no records unless a reviewed policy or role is added. The embedded single-operator database is not a tenant isolation service. Do not put its connection string in a browser.
