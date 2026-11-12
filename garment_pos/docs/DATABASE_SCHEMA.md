# Database Schema — Garment POS (SQLite + Drift)

Database file: `garment_pos.sqlite` (app documents folder).
All money columns are **integer paise**. All quantity/stock columns
are integers. Every business table carries `id`, `created_at`,
`updated_at` (plus `created_by`/`updated_by`/`is_deleted` where the
phase requires them).

## Schema version 1 (Phase 1 — current)

### app_settings
Key-value store for shop/app configuration.

| Column | Type | Notes |
|---|---|---|
| key | TEXT | Primary key, e.g. `shop_name`, `language_code` |
| value | TEXT | Value stored as text; typed access via `SettingsRepository` |
| updated_at | INTEGER | Epoch milliseconds |

## Planned tables by phase (added only via migrations)

- **v2 (Phase 2):** users, roles, permissions, user_permissions,
  audit_logs, number_sequences
- **v3 (Phase 3):** categories, brands, products, product_variants,
  product_sizes, product_colors, price_tiers, tax_rates,
  stock_movements, stock_adjustments, product_sets, product_set_items
- **v4 (Phase 4):** customers, suppliers, agents, customer_ledger,
  supplier_ledger (opening entries)
- **v5 (Phase 5):** sales, sale_items, sale_item_variants,
  sale_payments, held_carts
- **v6 (Phase 6):** invoice settings on sales (transport/LR fields)
- **v7 (Phase 7):** purchases, purchase_items, purchase_payments
- **v8 (Phase 8):** sale_returns, sale_return_items,
  purchase_returns, purchase_return_items

Planned indexes: barcode (unique), invoice_no (unique per financial
year), customer_id, supplier_id, product_id, transaction_date.

## Migration rules

1. Version numbers only increase, one step at a time.
2. An upgrade never drops or recreates a business table.
3. Every step ships with a regression test: create DB at old
   version → insert representative rows → migrate → rows unchanged.
