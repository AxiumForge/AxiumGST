# AxiumGST Project Overview

This document provides a comprehensive overview of the AxiumGST project, its goals, technologies, and development practices, intended as a living context for future interactions and development.

## Project Purpose

**AxiumGST (Gaussian Splat Transform)** is a high-performance, CLI-driven pipeline designed to convert, compress, and render Gaussian Splats as native assets within the AxiumForge framework. The project aims to address the limitations of polygon-based rendering for complex, "noisy" real-world data by combining the strengths of Signed Distance Fields (SDF) and Gaussian Splatting (GST) within a unified Haxe/C++ pipeline. This hybrid approach seeks to achieve superior visual quality and performance, managed through a robust Command Line Interface (CLI).

## Technologies and Architecture

*   **Primary Language:** Haxe (targeting C++ / HashLink for native performance).
*   **Graphics Engine:** Heaps (a high-performance 2D/3D framework).
*   **Shading Language:** HXSL (Haxe Shader Language), compiling to GLSL/HLSL.
*   **Data Formats:** Custom Binary Formats (Big Endian/Little Endian streams) encapsulated within AxiumForge's proprietary JSON Digital Asset (JDA) format. The project also defines a new `.gst` binary format for Gaussian Splats.
*   **Core Principle:** A CLI-driven "Forge" acts as the central tool for asset ingestion, conversion, and optimization, enabling headless operation and seamless integration into custom game engine pipelines.

## Development Methodology

The project follows an **Agile "Prompt-to-Code"** methodology, emphasizing iterative development and close collaboration:

*   **Lars (Architect/User):** Defines architecture, data structures (JDA), and success criteria.
*   **Gemini (AI Lead Developer):** Responsible for core code generation (Haxe/C++/Shaders), mathematical problem-solving, and ensuring best-practice implementation.
*   **DevOps (Integrated Role):** Ensures build via scripts (`.hxml`) and integrates the CLI as the "glue" for the pipeline.

**Development Loop:**
1.  Feature description by Lars.
2.  Full, runnable source code generation by Gemini (CLI + Viewer).
3.  Compilation and execution by Lars (Build & Run).
4.  Feedback and optimization loop.

## Building and Running

The project leverages Haxe's compilation capabilities and a dedicated CLI tool.

### Building
The project is built using Haxe's compilation system, typically via `.hxml` scripts. The specific build commands will be defined as development progresses, likely involving `haxe build.hxml` or similar commands for different targets (e.g., C++, HashLink).

### Running the AxiumForge CLI
The primary interface for interacting with the AxiumGST pipeline will be the `AxiumForge CLI` (referred to as "The Forge"). This compiled binary will expose commands for various operations:

*   **Ingestion:** `forge ingest <source_data>` (e.g., `forge ingest <video>`)
*   **Conversion:** `forge convert <input_file> <output_file>` (e.g., `forge convert <ply_file>.ply <jda_file>.jda`)
*   **Optimization:** `forge optimize <quality_level>`

### Running the AxiumGST Viewer
A Heaps-based application will serve as the viewer for Gaussian Splats. This viewer will include:

*   `GSTRenderer.hx`: Handles batching and GPU data uploads.
*   `SplatShader.hx`: Contains the core mathematical implementation for visual rendering.

The specific command to run the viewer will be established during its development, but it will be a compiled application capable of displaying the generated `.gst` and `.jda` assets.

## Project Phases

The project is structured into distinct phases:

*   **Phase 1: The Core (Proof of Concept):** Establish project structure (CLI vs. Viewer), define `.gst` binary format, generate synthetic test data, and implement a simple viewer with point rendering.
*   **Phase 2: The Forge (Data Pipeline):** Implement CLI commands for ingesting external formats (e.g., `.ply`), compression (quantization, Zlib), and JDA integration.
*   **Phase 3: The View (Advanced Rendering):** Develop splatting shaders, implement correct Gaussian math for alpha-fading, and integrate CPU/GPU-based Radix Sort for transparency.
*   **Phase 4: The Hybrid (Tracer Light & SDF):** Implement Spherical Harmonics (SH) for realistic lighting, integrate the GST viewer into AxiumForge's existing SDF Raymarcher, and ensure correct depth compositing between Splats and SDF geometry.

## Deliverables

The project will produce:

1.  **AxiumForge CLI:** A compiled binary (`.exe` / native binary) acting as a "Swiss Army Knife" for asset manipulation.
2.  **AxiumGST Viewer:** A Heaps-based application (`GSTRenderer.hx`, `SplatShader.hx`) for rendering Gaussian Splats.
3.  **Specifications:**
    *   JDA Format Spec (v1): Documentation for the JSON structure and Base64 payload.
    *   AxSL Extension: Enhancements to the Haxe Shader Language to support `sampleSplatField()`.

This `GEMINI.md` will serve as the foundational context for all future interactions and development within the AxiumGST project.