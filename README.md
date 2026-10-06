# Coach Charter for Claude Code

Charter bookings, school contracts, coach and driver allocations, recorded balances and evidence checks in a database you own. Free MIT code from Enterprise DNA. Works with Claude Code, Codex, OpenCode or Cursor.

| Do it yourself | We customise it | We run it for you |
|---|---|---|
| Free code installed and operated by you. Hosting and agent costs remain yours. | Your fields, dispatch rules, screens and Coach Manager export mapping. [Discuss your version](https://enterprisedna.co/omni/book?offer=replace-software&utm_campaign=coach-manager&utm_medium=github). | Installed and operated through Omni by Enterprise DNA. One setup fee, then a retainer. [See the offer](https://enterprisedna.co/omni/instead-of/coach-manager?utm_source=github&utm_medium=readme&utm_campaign=coach-manager). |

## Quick start

Node 20 or newer. Use fictional records first; never seed a live database.

```bash
git clone https://github.com/Enterprise-DNA-OS/coach-charter-for-claude-code.git
cd coach-charter-for-claude-code
npm install
npm run demo
npm test
npm run charter -- dispatch
npm run charter -- attention
npm run view
npm run docs
```

No database server is needed for the local PGlite demo. DATABASE_URL selects your PostgreSQL database for shared use. One tenant per database. Use a trusted operator role, restricted network access and tested backups. Row-level security is enabled without public policies. No browser login or public API is supplied.

## What works today

Ten record types and five views cover client history, quotes, bookings, school contracts, individual movements, allocations, invoice snapshots and work/rest evidence. Each movement has one vehicle and one driver. Multiple movements form a return journey or a multi-coach booking. Allocation rejects collisions, insufficient seats, unavailable resources and expired recorded credentials. Adjacent reservations are allowed; reserve depot travel and route buffers yourself. Every display uses UTC, so check the operator's local time before issuing work.

Compliance flags recorded exceptions and missing evidence. It does not replace a complete work diary, verify licence class, calculate every fatigue rule or authorise dispatch. Read [the exact rule scope](docs/compliance.md). Australian fatigue regimes are always referred for operator review.

The sample import is a mapped CSV contract. A vendor-native export schema could not be verified publicly. [The replacement guide](docs/replace-coach-manager.md) explains what to request, map and reconcile. Matching repeat imports are idempotent; changed records are rejected for deliberate reconciliation. No payments, allocations or verified credentials are inferred.

## Ten questions to ask

Coach Manager already offers financial and operational reporting. These are questions this base answers today, not claims that the vendor cannot produce an equivalent report. Ownership lets you change the question and the rule together.

1. Which confirmed journeys still need a coach and driver? (`unallocated`)
2. Which quotes are overdue and when did we last speak to the client? (`quote-ageing`)
3. Which school contracts need a review this month? (`contract-renewals`)
4. Which confirmed or completed charters have no recorded invoice? (`uninvoiced`)
5. Which clients have overdue balances and upcoming journeys? (`client-balances`)
6. Which allocated coaches have spare passenger seats? (`spare-seats`)
7. Which coach or driver turnarounds leave less than an hour? (`turnarounds`)
8. Which active contracts have no future confirmed movement? (`contract-gaps`)
9. Which clients with open work have gone quiet? (`quiet-clients`)
10. Which recorded duty periods need an evidence review? (`duty-review`)

## Weekly command recipes

41 recipes live in .claude/commands. Start with /dispatch, /quote-chase, /contract-renewals, /arrears and /compliance. /weekly-review combines dispatch, attention and evidence. /add, /update, /allocate and /log record operator instructions. /draft-confirmation writes a draft only. /customise changes the database and tests together. See [the CLI contract](docs/cli.md) for every field and mutation.

## Documents and reports

npm run docs renders draft work tickets, charter confirmations, balance statements and contract reviews from current records. brand.json sets the business name, logo and colours. npm run view renders three read-only HTML reports. These are static output files, not a driver portal or a live dispatch application. [Why there is no front end](docs/why-no-front-end.md) explains the scope.

## Your first hour: ten things to ask for

1. Add our depot name and logo.
2. Rename the school contract review report.
3. Add wheelchair capacity to coaches.
4. Add a depot turnaround buffer.
5. Record a verified passenger endorsement expiry.
6. Import a trial charter export.
7. Add a pickup contact field.
8. Show overdue balances beside future charters.
9. Change the quote follow-up interval.
10. Draft next Monday's dispatch review.

## Validation and operation

npm test creates a disposable database and exercises all commands, seed idempotence, collisions, failed imports, rollback, ambiguous names, evidence checks and generated documents. It ignores inherited production connection settings. TEST_DATABASE_URL is solely for a disposable CI PostgreSQL database. Windows and Linux workflows run the same suite. A workflow definition is not proof that a remote run passed.

Money is integer cents. Displayed values are currency units and totals stay separated by currency. Invoice balances are external ledger snapshots, not payment processing or a full sales ledger. Documents are drafts, not tax invoices. JSON export is a consistent portable snapshot; restoration still needs a tested backup process.

No email, payment, public publication or automated dispatch occurs. Keep work records, passenger details, exports and credentials out of Git. MIT. Independent project; Coach Manager is a Distinctive Systems product and is not affiliated with this project.
