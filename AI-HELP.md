# AI-Hjælp: Status

## Løst problem (2025-11-25)

- Haxe/Heaps kompileringsfejlene (`Type not found : h3d.scene.Camera` m.fl.) er løst ved at bruge de faktiske Heaps 2.1 API’er (`h3d.Camera`, `h3d.scene.fwd.DirLight`, cast af `LightSystem`) og opdatere viewer-koden.
- Runtime-fejlen "Missing buffer input 'normal'" ved rendering blev løst ved at tilføje `cube.addNormals()` før mesh-oprettelse, så forward-lyssætningen får normale data.

## Nuværende status

- Viewer- og Forge-delene kompilerer og kører nu korrekt (`haxe build.hxml` OK).
- Forge-fejlen `Type not found : sys.Sys` var et import-issue; rettet til `import Sys;` i `src/forge/ForgeMain.hx`.
- Forge er en CLI og åbner ikke et vindue; brug viewer (`hl bin/viewer.hl`) for at se `.gst`-filer som den genererede `assets/spiral.gst`.

Ingen åbne blokeringer p.t. Se `AI-ISSUES.md` for historik.
