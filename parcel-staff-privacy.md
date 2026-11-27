# Parcel, save-only, privacy, and staff accounting

## Goal
Add three checkout actions, parcel-marked receipts, Home revenue privacy, and separate Staff cost reporting without changing Parcel into an order category.

## Tasks
- [x] Persist an `isParcel` flag with a safe Drift migration and regenerate database code.
- [x] Add bold PARCEL labels to PDF and thermal receipts.
- [x] Add Add Item, Parcel, and Print Bill actions for phone and tablet checkout layouts.
- [x] Hide Home revenue by default and toggle it with a discoverable double-tap gesture.
- [x] Exclude Staff orders from Orders sales totals and show Staff Cost separately with Sales/Staff filters.
- [x] Add focused tests for parcel persistence and staff totals; save-only reuses the same tested order path while bypassing navigation/printing.
- [x] Run formatting, analysis, tests, mobile audit, and build/verify a release APK.

## Done When
- [x] All three actions save correctly, only Parcel/Print Bill print, Parcel receipts are marked, Staff cost is separate, Home revenue toggles, and the release APK verifies.
