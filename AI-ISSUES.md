# AI-uløste problemer

Ingen åbne problemer lige nu.

---
## Historik (Løste problemer)

## [Løst 2025-11-25] Haxe-miljøkonfiguration (`Type not found : sys.Sys` for Forge CLI)

- **Symptom:** `Type not found : sys.Sys` ved build af Forge CLI.
- **Årsag:** Forkert import; `Sys` er top-level (`import Sys;`) og ikke `sys.Sys`.
- **Løsning:** Opdateret import i `src/forge/ForgeMain.hx`. `haxe build.hxml` kører nu uden fejl for både Forge og Viewer.

## [Løst 2025-11-25] Haxe/Heaps API-mismatch

- **Symptom:** `Type not found : h3d.scene.Camera` (m.fl.) ved build af viewer.
- **Årsag:** Viewer brugte gamle/fejlagtige Heaps-API-referencer (`h3d.Camera`, `h3d.scene.fwd.DirLight`, cast af `LightSystem`) ift. installeret Heaps 2.1.
- **Løsning:** Opdateret viewer til `h3d.Camera`, `h3d.scene.fwd.DirLight`, cast af `LightSystem`. Build virker med `haxe build.hxml`.

## [Løst 2025-11-25] Missing buffer input 'normal'

- **Symptom:** Runtime-fejl "Missing buffer input 'normal'" ved render.
- **Årsag:** `h3d.prim.Cube` blev instansieret uden normals til forward-lyssætning.
- **Løsning:** Tilføjet `cube.addNormals()` før mesh-oprettelse i `ViewerMain`. Viewer kører (`hl bin/viewer.hl`).
