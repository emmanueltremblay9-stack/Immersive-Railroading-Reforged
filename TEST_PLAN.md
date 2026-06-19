# Test Plan

The port is not releasable until these checks have evidence. Compilation alone is not sufficient.

## Build and Dependency Checks

- `.\gradlew.bat tasks`
- `.\gradlew.bat clean build --stacktrace --warning-mode all`
- `.\gradlew.bat dependencies`
- `.\gradlew.bat dependencyInsight --dependency neoforge`
- `.\gradlew.bat dependencyInsight --dependency TrackAPI`
- `.\gradlew.bat dependencyInsight --dependency UniversalModCore`
- Inspect final JAR for license/notice files, mod metadata, logo, and absence of local-only files.
- Verify no Forge TrackAPI artifact is present in the NeoForge runtime.

## Automated Tests

- Unit tests for track interpolation, curve arc length, slope interpolation, gauge conversion, coupler distance, braking force, tractive effort, consist mass aggregation, zero-speed direction changes, valid extremes, and NaN/infinity rejection.
- Serialization round-trip tests for rolling stock, inventory, fluids, controls, couplers, multiblocks, and stock definitions.
- Packet bounds tests for invalid arrays, strings, identifiers, coordinates, entity ids, target blocks, selected stock parts, and permissions.
- GameTests for chunk-boundary traversal, save/reload while coupled, switch routing, passenger mount/dismount, and malformed packet rejection where feasible.

## Runtime Smoke Tests

- Client reaches title screen.
- Client creates a new world.
- Dedicated server creates a new world.
- Same mod JAR works on client and server.
- Core mod starts with Immersive Engineering and CC:Tweaked absent.
- Core mod starts with Immersive Engineering present.
- Core mod starts with CC:Tweaked present.

## Gameplay Tests

- Place straight, curved, sloped, switch, and supported crossing/turntable tracks.
- Build or spawn steam locomotive, diesel locomotive, passenger car, freight car, tank car, tender, and hand car.
- Couple/uncouple stock.
- Drive, brake, reverse, horn, bell, and stop.
- Save/reload and verify stock state.
- Test inventory and fluid freight handling.
- Form, operate, persist, and dismantle Steam Hammer, Plate Roller, Rail Roller, Boiler Roller, and Casting multiblocks.

## Rendering and Resource Tests

- Render rails, rail preview, rail gag, multiblocks, stock, custom items, particles, overlays, and controls.
- Reload resources repeatedly.
- Disconnect/reconnect without render-thread crash.
- Load bundled stock.
- Load a small test stock pack.
- Load one licensed representative legacy community pack.
- Feed malformed pack fixtures and verify useful diagnostics.

## Multiplayer Tests

- Two players observe identical stock state.
- Late joiner receives complete rolling-stock and track state.
- Chunk enter/leave tracking does not duplicate stock.
- Client controls cannot target unrelated entities.
- Server restart preserves state.

## Migration Tests

- Old item fixture.
- Old rolling-stock fixture.
- Old coupled-consist fixture.
- Old rail/block-entity fixture.
- Representative old resource pack.
