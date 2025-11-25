# AI-uløste problemer

## Problem 1: Haxe/HXSL Kompileringsfejl for Viewer

**Beskrivelse:**
Kompilering af `viewer`-målet fejler kritisk på grund af problemer relateret til `hxsl`-biblioteket og dets interaktion med HashLink-target. Dette forhindrer al videre udvikling af avancerede renderingsteknikker i vieweren.

**Fejlmeddelelser (eksempler):**
- `src/viewer/ViewerMain.hx:18: characters 8-21 : Type not found : h3d.prim.Quad`
- `src/viewer/SplatShader.hx:3: characters 8-23 : Type not found : hxsl.BaseShader`
- `hxsl/Shader.hx:26: characters 8-17 : Type name hxsl.Position is redefined`
- `hxsl/ShaderTypes.hx:31: characters 19-55 : You cannot access the flash package while targeting hl`

**Teknisk Kontekst:**
- Fejlene indikerer en alvorlig inkompatibilitet eller korruption i `hxsl`-biblioteket eller dets opsætning i forhold til Haxe og HashLink-target.
- Specifikt forsøger `hxsl` at tilgå Flash-specifikke pakker under kompilering til HashLink, hvilket er uforeneligt.
- `hxsl`-biblioteket er installeret (`haxelib install hxsl` er kørt), men det løser ikke problemet.
- `Type not found` for `hxsl.BaseShader` og `h3d.prim.Quad` fortsætter, selv med eksplicitte imports og bibliotekslink i `build.hxml`.

**Opgave til ny AI-model eller udvikler:**
Diagnosticer og løs `hxsl`-relaterede kompileringsproblemer for `viewer`-målet. Dette kan involvere:
- Afklaring af kompatibilitetsmatrix mellem Haxe-version, Heaps-version, HXSL-version og HashLink-target.
- Manuel inspektion af `hxsl`-bibliotekets kildekode for at identificere Flash-specifikke afhængigheder, der forårsager fejlen.
- Potentiel opdatering eller nedgradering af `heaps` eller `hxsl` til en kompatibel version.
- Fejlrapportering til Heaps-fællesskabet, hvis problemet er en ukendt bug.

**Acceptkriterie:**
Projektet skal kunne kompileres uden fejl for både `forge`- og `viewer`-målene ved at køre `haxe build.hxml`.

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
