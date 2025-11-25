# RAG - Reference & Lookup Library

## Purpose

This RAG (Retrieval-Augmented Generation) document serves as a reference and lookup library for the AxiumGST project. Its primary purpose is to optimize LLM efficiency by maintaining a searchable index of previously conducted research and lookups.

## How It Works

When a search or lookup is performed (either in local `/docs` directory or on the internet), the following information is recorded in this RAG:

1. **Search Query/Text**: The actual search terms or questions used
2. **Reference/Link**: Direct links to sources or file references
3. **Key Findings**: Brief summary of relevant information found
4. **Date**: When the lookup was performed

## Benefits

- **Avoid Redundant Searches**: Prevents the LLM from repeating searches in areas already covered
- **Quick Reference**: Enables fast retrieval of previously found information
- **Knowledge Accumulation**: Builds a growing knowledge base specific to the project
- **Cost Optimization**: Reduces API calls and processing time by reusing existing research

## Usage Guidelines

### Adding Entries

When documenting a new lookup, use the following format:

```markdown
### [Topic/Area]
**Date**: YYYY-MM-DD
**Query**: [Search text or question]
**Source**: [Link or file path]
**Summary**: [Brief description of findings]
```

### Categories

Entries should be organized under relevant categories:
- Local Documentation Searches
- Internet/Web Research
- API Documentation Lookups
- Technical Specifications
- Code Examples & Patterns

---

## Research Entries

### Project Overview: AxiumGST
**Date**: 2025-11-25
**Query**: "Gennemgå @docs/AxGST_Project_Gemini.md og læg summary opslag i @RAG.MD"
**Source**: `docs/AxGST_Project_Gemini.md`
**Summary**: The AxiumGST project aims to create a high-performance, CLI-driven pipeline for converting, compressing, and rendering Gaussian Splats as native assets within the AxiumForge 3D graphics framework. It combines SDF (Signed Distance Field) with Gaussian Splatting to handle complex, "noisy" real-world data effectively. The project uses Haxe (targeting C++/HL), the Heaps engine, and HXSL for shading. Development follows an "Agile Prompt-to-Code" methodology, with Lars as architect, Gemini as AI lead developer, and DevOps for automation. Key deliverables include the AxiumForge CLI for asset manipulation, an AxiumGST Viewer, and specifications for JDA format and AxSL extension. The project is divided into four phases: Core (PoC), Forge (Data Pipeline), View (Advanced Rendering), and Hybrid (Tracer Light & SDF integration).

<!-- New entries are added below this line -->

### PLY File Format Specification
**Date**: 2025-11-25
**Query**: ".ply file format specification (ASCII and Binary)"
**Source**: Multiple web sources (Wikipedia, loaders.gl, mathworks.com, etc. as listed in previous search output)
**Summary**: The PLY (Polygon File Format) stores 3D graphical objects like vertices, faces, and edges. It has both ASCII and binary versions, but the header is always ASCII.
**Header Structure**:
- Starts with `ply`.
- `format ascii 1.0`, `format binary_little_endian 1.0`, or `format binary_big_endian 1.0`.
- `comment` lines for metadata.
- `element <name> <count>`: Defines elements (e.g., `vertex`, `face`) and their number.
- `property <type> <name>`: Defines properties for each element (e.g., `float x`, `uchar red`).
  - Scalar types: `float32`, `int32`, `uchar`, etc.
  - List types: `property list <type_of_count> <type_of_elements> <property_name>` (e.g., `property list uchar int vertex_index`).
- Ends with `end_header`.
**Data Section**: Follows the header, ordered as defined.
- **ASCII**: Human-readable text, whitespace-separated values, one element per line. Easy to read/debug.
- **Binary**: Compact and efficient. `endianness` specified in header. Data types from header determine byte reading.

### Haxe multi-target projektstruktur (CLI + GUI)
**Date**: 2025-11-25
**Query**: "Bedste praksis for Haxe-projektstruktur med flere output (CLI og GUI)."
**Source**:
- https://haxe.org/manual/compiler-usage-hxml.html
- https://haxe.org/manual/target-specific-condition-compilation.html
**Summary**: Anbefaler fælles `common.hxml` med `-cp src`, delte libs og optimeringsflag (`-dce full`, `-D analyzer-optimize`), samt særskilte `cli.hxml`/`gui.hxml` for output/entry (`-main`, `-hl`/`-cpp`). Hold domænelag separat fra UI/CLI, og brug conditional compilation (`#if hl`/`#if cpp`) til mål-specifikke adapters. Output-mapper deles i `bin/cli` og `bin/gui` for at undgå artefakt-blanding.

### Heaps.io projektopsætning
**Date**: 2025-11-25
**Query**: "Opsætning af et Heaps.io-projekt."
**Source**:
- https://heaps.io/documentation/starting.html
- https://github.com/HeapsIO/heaps/tree/master/samples
**Summary**: Installer Heaps via `haxelib install heaps` og kør `haxelib run heaps setup` for HashLink runtime. Standard byggekommando: `haxe -lib heaps -hl bin/app.hl -main Main` (eller `-cpp bin/cpp`). Apps starter fra `hxd.App`, loader assets med `hxd.Res.initLocal()` og bruger HL/SDL window loop; samples viser fungerende `build.hxml` og asset-struktur.

### Haxe CLI udviklingsstandarder
**Date**: 2025-11-25
**Query**: "Standarder for udvikling af Haxe CLI-applikationer."
**Source**:
- https://haxe.org/manual/std-sys.html
- https://github.com/wikiti/hxargs
- https://github.com/haxetink/tink_cli
**Summary**: Brug `Sys.args()` sammen med parser-lib (hxargs/tink_cli) for subcommands/help. Kompiler med optimering (`-dce full -D analyzer-optimize`) og HL for hurtig startup (`-hl bin/app.hl`). Skriv til stderr for fejl (`Sys.stderr().writeString`) og afslut med `Sys.exit(code)`. Test hurtigt med `--interp` før native build, og overvej `-D cli` for conditional features.

### Eksempler: Haxe-projekter med CLI + Heaps-app
**Date**: 2025-11-25
**Query**: "Eksempler på Haxe-projekter med både en CLI- og en Heaps-applikation."
**Source**:
- LDtk headless eksport: https://ldtk.io/docs/general/headless/
- LDtk repository: https://github.com/deepnight/ldtk
**Summary**: LDtk (Level Designer Toolkit) kører editoren i Heaps og tilbyder headless CLI (`--headless --export`) til automatiserede JSON/tileset-eksporter i CI. Samme kodebase bruger særskilte HXML-profiler til GUI (HL/SDL) og CLI (headless HL), så domænelogik kan deles mens frontend/output varierer.

### Kodedeling mellem Haxe build-mål
**Date**: 2025-11-25
**Query**: "Hvordan man deler kode mellem forskellige Haxe-build-mål."
**Source**:
- https://haxe.org/manual/lf-condition-compilation.html
- https://haxe.org/manual/types-abstract.html
**Summary**: Strukturér shared moduler uden target-afhængigheder, og isolér platform-specifikke dele bag interfaces/abstracts. Brug conditional compilation (`#if hl`, `#if cpp`, `#if gui`) for mål-variationer og del et fælles `common.hxml` med per-target overrides. Det gør det let at genbruge samme kildetræ til både CLI og Heaps-applikation.

### Gaussian Splatting references (latest)
**Date**: 2025-11-25
**Query**: "nyeste referencer til gaussian splatting/splatter tracing (C++/Haxe, realtime rendering)"
**Source**:
- arXiv: [2308.04079](http://arxiv.org/abs/2308.04079) — 3D Gaussian Splatting for Real-Time Radiance Field Rendering (Kerbl et al., 2023)
- GitHub: https://github.com/graphdeco-inria/gaussian-splatting — official C++/OpenGL reference implementation
- arXiv: [2405.15125](http://arxiv.org/abs/2405.15125) — HDR-GS: Efficient High Dynamic Range Novel View Synthesis via Gaussian Splatting (2024)
- arXiv: [2407.09510](http://arxiv.org/abs/2407.09510) — 3DGS.zip survey on Gaussian Splatting compression (2024)
- arXiv: [2409.12518](http://arxiv.org/abs/2409.12518) — Hier-SLAM with Hierarchically Categorical Gaussian Splatting (2024)
- arXiv: [2411.08279](http://arxiv.org/abs/2411.08279) — MBA-SLAM: Motion Blur Aware Gaussian Splatting SLAM (2024)
**Local copies**:
- `docs/refs/kerbl_2023_3d_gaussian_splatting.pdf`
- `docs/refs/hdr_gs_2024.pdf`
- `docs/refs/3dgs_zip_compression_survey_2024.pdf`
- `docs/refs/hier_slam_gaussian_splatting_2024.pdf`
- `docs/refs/mba_slam_motion_blur_gaussian_splatting_2024.pdf`
**Summary**: Latest public references confirm the 2023 Kerbl et al. paper as the canonical method and provide an official C++/OpenGL codebase. 2024 work expands coverage: HDR-GS focuses on HDR novel view synthesis and reports large speedups; 3DGS.zip surveys compression options for splat assets; Hier-SLAM and MBA-SLAM integrate Gaussian Splatting into SLAM pipelines (semantic hierarchy and motion-blur robustness). These are the most recent accessible sources for implementation details and optimizations relevant to both C++ renderers and Haxe/Heaps bindings.

### C++ Gaussian Splatting libraries/examples
**Date**: 2025-11-25
**Query**: "C++ Gaussian Splatting (gaussian splatter tracing) libraries and code examples"
**Source**:
- GitHub: https://github.com/graphdeco-inria/gaussian-splatting — canonical C++/OpenGL implementation from Kerbl et al. (instanced splats + CUDA preprocessing)
- GitHub: https://github.com/pierotofy/OpenSplat — production-oriented C++ with CPU/GPU backends (Vulkan/Metal/DirectX targets; CLI + viewer)
- GitHub: https://github.com/buaacyw/GaussianEditor — C++ Gaussian editing/renderer (OpenGL) with UI for painting/editing splats
- GitHub: https://github.com/Anttwo/SuGaR — surface-aligned Gaussian Splatting (C++/CUDA + PyTorch training, includes C++ renderer)
**Summary**: The official GraphDECO repo remains the cleanest reference for C++/OpenGL splat rasterization and accumulation. OpenSplat provides a more production-ready, cross-platform renderer with CPU/GPU paths and is useful for integration patterns. GaussianEditor offers UI-driven editing atop an OpenGL renderer. SuGaR includes C++/CUDA rendering code aligned to surface reconstruction; useful for examples of surface-aware splats and hybrid pipelines.

### Heaps API (Camera/Lighting)
**Date**: 2025-11-25
**Query**: "Locate Heaps camera + dir light classes for installed version"
**Source**: `/Users/larsmathiasen/REPO/AXIUMFORGE_EDITOR_HEAPS/.haxelib/heaps/2,1,0/h3d/Camera.hx`, `/Users/larsmathiasen/REPO/AXIUMFORGE_EDITOR_HEAPS/.haxelib/heaps/2,1,0/h3d/scene/fwd/DirLight.hx`, `/Users/larsmathiasen/REPO/AXIUMFORGE_EDITOR_HEAPS/.haxelib/heaps/2,1,0/h3d/scene/fwd/LightSystem.hx`
**Summary**: Heaps 2.1 exposes `h3d.Camera` (no `h3d.scene.Camera`) and movement helpers but no `lookAt/move/pitch/yaw`. Directional lights live in `h3d.scene.fwd.DirLight`, and ambient lighting is available via the forward `LightSystem.ambientLight`; `s3d.lightSystem` needs casting to the forward type before accessing ambient.

### Viewer normals/runtime fix
**Date**: 2025-11-25
**Query**: "Runtime error 'Missing buffer input normal' when rendering cubes in viewer"
**Source**: `src/viewer/ViewerMain.hx`
**Summary**: The forward renderer requires normals; `h3d.prim.Cube` instances must call `addNormals()` before creating the mesh. After adding, `hl bin/viewer.hl` runs without the missing-buffer error.***
