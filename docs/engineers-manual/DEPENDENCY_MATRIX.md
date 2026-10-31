# Dependency Matrix

| Component | Role | Current source | Runtime required | Manual task status |
| --- | --- | --- | --- | --- |
| Immersive Railroading Reforged | Primary mod and manual owner | local repo branch `port/1.21.1-neoforge` | yes | active |
| NeoForge | Loader | Unimined loader `216`; metadata requires `[21.1.1,)` | yes | reference only |
| Minecraft | Game baseline | `1.21.1` | yes | reference only |
| Java | Toolchain | Java 21 | yes | reference only |
| Universal Mod Core | Runtime abstraction dependency | Maven `cam72cam.universalmodcore:UniversalModCore:1.21.1-neoforge-1.3.0-73ac499` | yes | technical reference excluded |
| TrackAPI | Runtime rail interoperability dependency | Maven `trackapi:TrackAPI:1.21.1-neoforge-1.2-a965c1` | yes | technical reference excluded |
| Immersive Railroading Integration | Optional integration sources | Git submodule branch `1.21.1-neoforge` | build-time source included | active only where actual integration pages are needed |
| CC:Tweaked | Optional integration dependency | `cc.tweaked:cc-tweaked-1.21.1-forge:1.116.2` | optional/integration | planned conditional docs |
| Immersive Engineering | Optional integration dependency | CurseMaven `immersive-engineering-231951:6733669` | optional/integration | planned conditional docs |

## Notes

- Existing dependency jars are copied and verified by `install-mod.ps1`.
- The TrackAPI and UMC technical-reference appendices requested by the Notion prompt are excluded from the active task.
- Runtime dependency verification remains required before declaring a Prism LAB install safe.
