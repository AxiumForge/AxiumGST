# Changelog

All notable changes to the AxiumGST project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Added
- Initial project structure with documentation framework
- RAG.MD: Reference & Lookup Library system
  - Purpose: Optimize LLM efficiency by maintaining searchable index of previous research
  - Prevents redundant searches in local `/docs` and internet sources
  - Template format for documenting search queries, references, and findings
  - Organized categories for different types of lookups
- TODO.md: Phase-based Task Management system
  - DevOps iterative approach: one phase at a time
  - Dynamic task sourcing from `/docs` project documents
  - Iterative loop: Plan → Implement → Test → Review → Deploy → Retrospective
  - Living document that evolves with project understanding
- `screenshot.sh`: Bundet Mac-script til at capture første vindue for Heaps-proces og gemme i `sc/` (valg af procesnavn via `HEAPS_APP`)
- `bin/pdf2md.py` and `bin/pdf2md.sh`: PDF extractor that writes per-PDF folders under `docs/refs/<name>/` with `index.md` (per-page text + inline image links) and extracted images in `images/`. Requires `pymupdf` (fitz).

### Changed
- `screenshot.sh`: auto-detects running process (`Heaps`/`hl`/`viewer` or `HEAPS_APP` override) before grabbing window
- `screenshot.sh`: added `--help` usage text and clearer guidance when no viewer process is running
- `screenshot.sh`: falls back to multi-display capture if no window id is found; can target a display via `HEAPS_DISPLAY` and now brings the process frontmost before trying the window capture

### Fixed
- Viewer build/runtime:
  - Updated viewer to match Heaps 2.1 API (`h3d.Camera`, `h3d.scene.fwd.DirLight`, cast `LightSystem`)
  - Added `cube.addNormals()` to avoid forward renderer error “Missing buffer input 'normal'”
- Forge CLI: corrected `Sys` import for successful `haxe build.hxml`; confirmed `generate-spiral` produces `assets/spiral.gst` and CLI runs headless (use viewer to inspect output)
- Viewer HXSL build failure:
  - Dropped external `-lib hxsl` to use Heaps-bundlet HXSL and rewrote `viewer/SplatShader.hx` to extend `hxsl.Shader` with `static var SRC`
  - Simplified splat rendering: spawn capped set of `Grid` meshes with per-splat shader params (center/color/scale) and camera/screen uniforms updated per-frame; `haxe build.hxml` now succeeds for viewer

### Notes
- **Development Environment:** Currently developing on a Mac Intel i9 16GB (2019). The initial development will be "light" to establish a working pipeline.
- **Target Environment:** The future target is an Ubuntu AMD AI9 365 with 128GB shared RAM (2025). Once the pipeline is functional, development will transition to Ubuntu to leverage full GPU, NPU, and AMU capabilities.

---

## [0.1.0] - 2025-11-25

### Added
- Initial repository setup
- Project documentation structure (CHANGELOG.MD, RAG.MD, TODO.md)
- Documentation directory (`docs/`)
- Published to GitHub under AxiumForge organization
