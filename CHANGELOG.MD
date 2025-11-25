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

### Changed

### Fixed

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
