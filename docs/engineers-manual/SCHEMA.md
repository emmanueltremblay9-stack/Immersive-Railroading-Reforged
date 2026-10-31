# Engineer Manual Schema

The current schema contract is documented in:

```text
docs/engineers-manual/schema/engineers-manual.schema.json
```

The Gradle task `validateEngineersManual` currently validates the first-party contract:

- `book.json` exists.
- Required maintainer documentation files exist.
- `docs/engineers-manual/schema/engineers-manual.schema.json` parses as JSON.
- Each category has required identity and translation fields.
- Each entry has required identity, category, pages, and feature coverage fields.
- Entry categories resolve.
- Duplicate ids are rejected.
- The landing entry resolves.
- Related entry links resolve.
- Category parent references resolve and do not form cycles.
- Widget types are allow-listed.
- Callout styles are allow-listed.
- External URLs use `http` or `https`.
- Every `source_feature_ids` value exists in `FEATURE_COVERAGE.csv`.
- Every CSV row marked `scaffolded`, `documented`, or `generated` has a real entry resource.
- All manual translation keys exist in both `en_us.lang` and `fr_fr.lang`.
- Manual translation values must not contain placeholder markers such as `TODO`, `TBD`, `lorem ipsum`, `placeholder`, or `[Need translate]`.

The current Gradle validation mirrors the schema manually because the build has no dedicated JSON Schema validator dependency. Runtime validation still needs to be implemented with the future in-game manual loader.
