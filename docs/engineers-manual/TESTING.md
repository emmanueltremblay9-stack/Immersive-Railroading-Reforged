# Engineer Manual Testing

Current validation commands:

```powershell
.\gradlew.bat validateEngineersManual
.\gradlew.bat testEngineersManual
.\gradlew.bat clean build
.\install-mod.ps1
```

Current automated coverage:

- JSON resource parse check.
- Schema JSON parse check.
- Required maintainer docs presence.
- Category/entry id uniqueness.
- Entry category resolution.
- Category parent resolution and cycle detection.
- Landing entry resolution.
- Related entry resolution.
- Widget type and callout style allow-list checks.
- `http`/`https` enforcement for external links.
- `source_feature_ids` to `FEATURE_COVERAGE.csv` checks.
- Covered/scaffolded CSV rows must have real entry resources.
- Manual translation presence for `en_us` and `fr_fr`.
- Manual placeholder marker rejection for new manual strings.
- Feature coverage report generation.
- Localization report generation.
- Manual validation report generation.
- Documentation JSON example verification when JSON examples are present.

Current external resource checks used in this pass:

- Generated `engineers_manual/index.json` was compared against packaged resource files: 18/18 categories and 49/49 entries.

Required later tests:

- Crouch-use still cycles multiblocks.
- Block-use still places selected blueprint.
- Client visual smoke test that normal manual use opens the entry browser.
- Dedicated server starts without manual GUI client class loading.
- GUI scale, keyboard navigation, search, bookmarks, history, and resource reload.
