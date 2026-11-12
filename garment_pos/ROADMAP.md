# Garment POS — Development Roadmap

Development happens in 10 phases. A phase only starts after the
previous phase is completed, tested and approved. Status column is
updated at the end of every phase.

| Phase | Name | Main features | Depends on | Complexity | Status |
|---|---|---|---|---|---|
| 1 | Foundation & Architecture | Flutter setup, feature-first folders, Material 3, responsive layout, bn/en localization, Drift+SQLite schema v1, migration skeleton, navigation, dashboard shell | — | Medium | ✅ Done (v0.1.0) |
| 2 | Authentication, Security & Settings | Admin setup, password/PIN login, PBKDF2 salted hash, recovery key, roles & permission matrix, auto lock, audit log, shop settings, Retail Mode switch, financial-year invoice sequence | 1 | High | ✅ Done (v0.2.0) |
| 3 | Product Master & Inventory | Category/brand, product CRUD, size×colour variant matrix, per-variant barcode, size sets/bundles/cartons, price tiers, opening stock, adjustments, low-stock alerts, CSV import/export | 1, 2 | Very High | ✅ Done (v0.3.0) |
| 4 | Customer, Supplier & Parties | Customer/supplier/agent CRUD, customer types, credit limit, opening balances, basic ledgers, search | 1, 2 | Medium–High | ⏳ Pending |
| 5 | Wholesale POS & Sales Engine | Barcode POS, variant selection, wholesale min qty, price tiers, Retail Mode rules, cart, discounts, min-price override, hold/resume, split payment, credit sales, transactional stock deduction | 2, 3, 4 | Very High | ⏳ Pending |
| 6 | GST Invoice, Challan & Printing | GST config, CGST/SGST/IGST, HSN, round-off, amount in words, UPI QR, A4 + 58/80mm thermal, challan, transport/LR, PDF share, duplicate invoice | 5 | Very High | ⏳ Pending |
| 7 | Purchase & Supplier Management | Purchase entry with variant matrix, purchase payments, supplier due, stock inward, supplier ledger | 3, 4 | High | ⏳ Pending |
| 8 | Returns & Ledger Settlement | Sales/purchase returns, credit notes, refunds, invoice cancellation, stock reversal, payment collection, due tracker, WhatsApp reminder templates | 5, 6, 7 | Very High | ⏳ Pending |
| 9 | Accounts, Dashboard & Analytics | Expenses, cash/bank/UPI accounts, transfers, daily closing, owner capital/drawings, P&L, GST summary, reports (PDF/CSV), dashboard charts, product analytics | 5, 7, 8 | Very High | ⏳ Pending |
| 10 | Backup, Restore & Final QA | Manual/auto backup, retention, restore with safety backup, integrity checks, performance, security review, full docs, release build | 1–9 | Very High | ⏳ Pending |

## Standing rules for every phase

1. Money is always integer paise; never `double` for finance.
2. Invoices are never deleted — cancelled with a reason + audit log.
3. Retail Mode on/off never changes historical data.
4. GST rates are configurable, never hardcoded.
5. Financial writes happen inside database transactions.
6. Migrations always preserve existing data.
7. Each phase ends with: `flutter analyze`, `flutter test`, an
   updated CHANGELOG and a Bengali completion report.
