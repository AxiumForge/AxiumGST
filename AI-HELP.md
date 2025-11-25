# AI-Hjælp: Status

## Løst problem (2025-11-25)

- Haxe/Heaps kompileringsfejlene (`Type not found : h3d.scene.Camera` m.fl.) er løst ved at bruge de faktiske Heaps 2.1 API’er (`h3d.Camera`, `h3d.scene.fwd.DirLight`, cast af `LightSystem`) og opdatere viewer-koden.
- Runtime-fejlen "Missing buffer input 'normal'" ved rendering blev løst ved at tilføje `cube.addNormals()` før mesh-oprettelse, så forward-lyssætningen får normale data.
- Forge CLI `Type not found : sys.Sys` fejl er løst ved at korrigere importen til `import Sys;`.

## Nuværende status

- **BLOKERET: Viewer-delen kan ikke kompilere.**
- Forge CLI kompilerer og kører korrekt.
- Problemer med `hxsl`-biblioteket forhindrer kompilering af viewer, hvilket resulterer i:
    - `Type not found : h3d.prim.Quad` (i `ViewerMain.hx`)
    - `Type not found : hxsl.BaseShader` (i `SplatShader.hx`)
    - Interne `hxsl` fejl: `Type name hxsl.Position is redefined` og `You cannot access the flash package while targeting hl`.

**Dette er en kritisk blokering for Phase 3 ("The View").** Se `AI-ISSUES.md` for historik og åbne problemer.
