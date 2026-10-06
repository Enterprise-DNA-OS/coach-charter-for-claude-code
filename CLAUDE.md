# Coach Charter for Claude Code: operating instructions

For the coach operator and dispatcher. Read README.md, docs/cli.md and docs/compliance.md before changing records. Every answer starts with a current CLI read.

## Rules

- The operator supplies names, amounts, history and evidence. Never invent them.
- Read before writing. Resolve ambiguous names by listing candidates.
- Drafts stay in drafts/ or docs-out/. No command sends or takes a payment.
- Never authorise dispatch from a clear report. Check the full work diary, licence class, route, local times and current vehicle condition with the operator.
- Release an allocation only after an explicit instruction. No deletion of business records.
- No live credentials or personal records in Git. Test with disposable data. Do not seed a live database.
- Dates display in UTC, money in currency units. Keep currencies separate.
- Changes use the next numbered migration and meaningful tests. Preserve the one CLI and command library.

## Recurring jobs

- /customers: read `.claude/commands/customers.md`.
- /vehicles: read `.claude/commands/vehicles.md`.
- /drivers: read `.claude/commands/drivers.md`.
- /contracts: read `.claude/commands/contracts.md`.
- /bookings: read `.claude/commands/bookings.md`.
- /movements: read `.claude/commands/movements.md`.
- /invoices: read `.claude/commands/invoices.md`.
- /dispatch: read `.claude/commands/dispatch.md`.
- /unallocated: read `.claude/commands/unallocated.md`.
- /quote-chase: read `.claude/commands/quote-chase.md`.
- /contract-renewals: read `.claude/commands/contract-renewals.md`.
- /arrears: read `.claude/commands/arrears.md`.
- /uninvoiced: read `.claude/commands/uninvoiced.md`.
- /fleet-due: read `.claude/commands/fleet-due.md`.
- /driver-due: read `.claude/commands/driver-due.md`.
- /duty-review: read `.claude/commands/duty-review.md`.
- /work-blocks: read `.claude/commands/work-blocks.md`.
- /quiet-clients: read `.claude/commands/quiet-clients.md`.
- /client-balances: read `.claude/commands/client-balances.md`.
- /quote-ageing: read `.claude/commands/quote-ageing.md`.
- /contract-gaps: read `.claude/commands/contract-gaps.md`.
- /spare-seats: read `.claude/commands/spare-seats.md`.
- /turnarounds: read `.claude/commands/turnarounds.md`.
- /customer-history: read `.claude/commands/customer-history.md`.
- /attention: read `.claude/commands/attention.md`.
- /customer: read `.claude/commands/customer.md`.
- /add: read `.claude/commands/add.md`.
- /update: read `.claude/commands/update.md`.
- /allocate: read `.claude/commands/allocate.md`.
- /unallocate: read `.claude/commands/unallocate.md`.
- /log: read `.claude/commands/log.md`.
- /compliance: read `.claude/commands/compliance.md`.
- /weekly-review: read `.claude/commands/weekly-review.md`.
- /draft-weekly: read `.claude/commands/draft-weekly.md`.
- /draft-confirmation: read `.claude/commands/draft-confirmation.md`.
- /import: read `.claude/commands/import.md`.
- /export: read `.claude/commands/export.md`.
- /documents: read `.claude/commands/documents.md`.
- /views: read `.claude/commands/views.md`.
- /new-view: read `.claude/commands/new-view.md`.
- /customise: read `.claude/commands/customise.md`.

Use npm run charter -- help for the CLI. Database routing lives in scripts/lib/db.mjs; migrations in supabase/migrations; evidence sources in docs/compliance.md. Claude Code reads this file; other agents read AGENTS.md and then this file. Same records and same recipes.

Installed and operated through Omni by Enterprise DNA: https://enterprisedna.co/omni/book?offer=replace-software&utm_campaign=coach-manager&utm_medium=github
