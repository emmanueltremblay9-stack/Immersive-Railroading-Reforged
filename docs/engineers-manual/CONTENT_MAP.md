# Engineer Manual Content Map

## Active Categories

This is the reconciled category plan for the current IR-only scope. Every listed category has at least one validated entry exported into the Immersive Engineering Engineer's Manual.

| Category | Status | Source basis |
| --- | --- | --- |
| Welcome | complete | `ItemManual`, scope, credits/support |
| Getting Started | complete | manual item, blueprint basics, first stock |
| Track Planning | complete | `TrackGui`, `TrackItems`, gauges |
| Track Construction | complete | `ItemTrackBlueprint`, `ItemRail`, rail blocks |
| Track Types | complete | `TrackItems`, `track/*.json` |
| Gauges and Scale | complete | `rolling_stock/gauges.json` |
| Switches, Tables, and Special Track | complete | `SWITCH`, `TURNTABLE`, `TRANSFERTABLE`, switch key |
| Rail Augments and Automation | complete | `Augment` enum and `TileRailBase` behavior |
| Rolling Stock | complete | `stock.json` categories |
| Steam Locomotives | complete | `LocomotiveSteam`, steam definitions |
| Diesel Locomotives | complete | `LocomotiveDiesel`, diesel definitions |
| Passenger Operations | complete | passenger cars, conductor whistle, boarding permissions |
| Freight and Item Logistics | complete | `Freight`, loaders/unloaders |
| Fluid Logistics | complete | `CarTank`, fluid loaders/unloaders |
| Coupling, Brakes, and Train Handling | complete | hook, couplers, brake controls |
| Controls and Key Bindings | complete | `Keyboard.registerKey` mappings |
| Tools and Equipment | complete | wrench, paint brush, golden spike, radio card |
| Workshop and Multiblocks | complete | five registered multiblocks |
| Manufacturing and Recipes | complete | plates, cast rails, multiblock crafting flows |
| Resource Packs and Custom Rolling Stock | complete | stock JSON/CAML loaders |
| Configuration and Performance | complete | config classes and generated references |
| Commands and Administration | complete | `IRCommand` and permissions |
| Troubleshooting | complete | runtime/startup/resource-pack diagnostics |
| Credits, Legal, and Support | complete | existing license files and project metadata |

## Excluded Categories

These are not part of the active task by user instruction:

- TrackAPI technical reference.
- Universal Mod Core technical reference.

## Resource Entries

Validated resource count after the full IE manual content pass:

- Categories: 24
- Entries: 55
- Audited IR feature rows documented: 66 / 66
- Uncovered player-visible IR feature rows in the current CSV: 0
- IE runtime manual category: `Immersive Railroading Reforged`
- IE runtime manual entries: 55

The runtime IE pages are generated from `docs/engineers-manual/FULL_CONTENT.json`, the source entry JSON, and the locale files.
