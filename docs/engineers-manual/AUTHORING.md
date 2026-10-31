# Engineer Manual Authoring

First-party manual resources live under:

```text
src/main/resources/assets/immersiverailroading/engineers_manual/
```

Add a category:

1. Create `categories/<name>.json`.
2. Use a stable `id`.
3. Add `title` and `description` translation keys in both `en_us.lang` and `fr_fr.lang`.
4. Run `.\gradlew.bat validateEngineersManual`.

Add an entry:

1. Create `entries/<category>/<entry>.json`.
2. Set `category` to an existing category id.
3. Add at least one page.
4. Add `source_feature_ids` matching `FEATURE_COVERAGE.csv`.
5. Add all translation keys in both required locales.
6. Ensure every `related_entries` id resolves to another entry.
7. Use only allow-listed widgets from `WIDGETS.md`.
8. Run `.\gradlew.bat testEngineersManual`.

Do not add visible placeholder entries. If an entry is not ready, leave its coverage row as `planned`.

External URLs must be explicit support/credits links and need confirmation in the future screen implementation.
Only `http` and `https` URLs pass validation.
