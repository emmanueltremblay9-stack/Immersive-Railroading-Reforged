# Immersive Railroading Reforged Train Pack Template

This is a minimal resource-pack template for adding external rolling stock without modifying the base mod.

It intentionally does not include copied third-party train assets. The example definition references a small template-owned placeholder OBJ so the structure can be validated safely.

Install for manual testing by copying this folder or a zip of this folder into Minecraft's `resourcepacks` directory, then enable it in the client before loading the mod.

Validate from the project root:

```powershell
.\gradlew.bat validateExternalTrainPackTemplate
```

The important files are:

- `assets/immersiverailroading/rolling_stock/stock.json`
- `assets/irr_template/rolling_stock/freight/example_flatcar.json`
- `assets/irr_template/models/rolling_stock/freight/example_flatcar/template_flatcar.obj`

The stock index uses the original IR namespace as the discovery point and points at a namespaced external definition:

```json
"freight": ["irr_template:example_flatcar"]
```
