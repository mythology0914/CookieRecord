下面這份是你可以 直接整段貼進 Codex / Copilot / Cursor 當作專案規格（PROJECT_SPEC.md） 用的版本。
它是為了 Prototype v0 設計的：只做最小可用流程，不追求完整產品。

🧩 SnackKeeper – Prototype v0

Tech stack: Flutter + Drift(SQLite)
Purpose: Build a minimal working mobile app to validate the full flow:
take photo → choose expiry date → save → list → sort

1️⃣ Project Goal

Build a minimal mobile app that allows users to:

Take a photo of a snack

Select an expiry date

Save it locally

Display all saved snacks in a list

Sort the list by expiry date

This version is not a full product.
It is a learning prototype to understand the end-to-end mobile app flow.

2️⃣ What this version will NOT do

This prototype intentionally does NOT include:

OCR

Product name

Quantity

Categories

Notifications

Cloud sync

History / archive

User accounts

3️⃣ Core Features (MVP v0)
A. Add Snack

User can:

Take one photo (snack image)

Pick an expiry date from a date picker

Tap “Save”

Both photo and expiry date are required.

B. Local Storage

The app stores each snack in a local SQLite database using Drift.

Data must persist after app restart.

C. Home Screen (List)

Displays all snacks as a scrollable list:

Each item shows:

Snack photo

Expiry date (YYYY-MM-DD)

The list is sorted by:

Expiry date (ascending: closest expiry first)

4️⃣ Pages
Page 1 — Home

List of snacks

Floating Action Button ( + ) to add new snack

Layout (concept):

[ + ]

-----------------------
| [image] 2026-01-14  |
-----------------------
| [image] 2026-02-01  |
-----------------------

Page 2 — Add Snack

Contains:

Button: Take Photo

Button: Pick Expiry Date

Button: Save

Save button is disabled until:

Photo is taken

Expiry date is selected

5️⃣ Data Model (Drift)

Single table: snacks

snacks
- id INTEGER PRIMARY KEY AUTOINCREMENT
- imagePath TEXT NOT NULL
- expiryDate TEXT NOT NULL   -- ISO format: YYYY-MM-DD


No other fields.

6️⃣ Data Rules

One Add = one row (no merging)

expiryDate is mandatory

imagePath must point to a file stored on device

Records are never auto-deleted

7️⃣ Image Storage

Photos are stored in app local storage

Database only stores file paths

Thumbnails are not required in v0

8️⃣ Sorting

Home list query:

SELECT * FROM snacks ORDER BY expiryDate ASC

9️⃣ UI Rules

Use Material 3

Simple card or list tile layout

No custom theming required

Focus on clarity, not beauty

10️⃣ Tech Requirements

Flutter (latest stable)

Drift

SQLite (via Drift)

Camera plugin (or image_picker)

Date picker

11️⃣ Success Criteria

This prototype is successful when:

You can add 3 snacks

Close the app

Reopen it

See them still listed

Sorted by expiry date

That’s it.
