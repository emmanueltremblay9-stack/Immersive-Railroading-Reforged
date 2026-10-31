# Engineer Manual Localization

Required locales:

- `en_us`
- `fr_fr`

Manual keys use:

```text
manual.immersiverailroading.
```

Validation:

```powershell
.\gradlew.bat reportEngineersManualLocalization
```

Report output:

```text
build/reports/engineers-manual/localization-coverage.json
```

Existing `fr_fr.lang` contains non-manual `[Need translate]` markers. This pass only requires newly added manual keys to be present in both locales.

Current validated manual localization report:

- `en_us` manual keys: 283
- `fr_fr` manual keys: 283
- Missing manual keys in either required locale: 0
- Manual placeholder markers rejected by `validateEngineersManual`
