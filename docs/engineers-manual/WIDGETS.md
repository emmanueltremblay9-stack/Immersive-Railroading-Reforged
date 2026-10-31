# Engineer Manual Widgets

Initial allow-listed widget types:

- `heading`
- `text`
- `callout`
- `link`
- `item_stack`
- `table`
- `procedure`

The current resource scaffold uses only `heading`, `text`, and `callout`.
`validateEngineersManual` rejects any first-party entry that uses a widget outside the current allow-list. `callout` styles are limited to `info`, `tip`, `warning`, and `danger`.

Future UI work must reject unknown widget types safely and preserve the previously valid manual model on catastrophic reload failure.
