# AxiumGST Project

## Overview

AxiumGST (Gaussian Splat Transform) is a high-performance, CLI-driven pipeline designed to convert, compress, and render Gaussian Splats as native assets within the AxiumForge framework. It combines the strengths of Signed Distance Fields (SDF) and Gaussian Splatting (GST) for superior visual quality and performance.

This project is developed using Haxe, targeting C++ / HashLink for native performance, and leverages the Heaps graphics engine.

## Current Status

The project is currently in **Phase 1: The Core (Proof of Concept)**, with significant progress made.

**Completed Tasks:**
-   **Project Structure:** Established the basic structure for both the CLI (Forge) and the Viewer application.
-   **Binary Format Definition:** Defined the custom `.gst` binary format for Gaussian Splats.
-   **Synthetic Data Generation:** Implemented functionality to generate synthetic Gaussian Splat data (spiral pattern) and save it as a `.gst` file.
-   **Simple Viewer with Point Rendering:** The viewer is capable of loading `.gst` files and rendering Gaussian Splats as colored cubes, with basic camera controls.

**Blocking Issues:**
-   **Forge CLI Compilation Issue (`Type not found : sys.Sys`):** The Forge CLI currently fails to compile with a `Type not found : sys.Sys` error. This issue is environmental, related to the Haxe setup, and is currently blocking further development of the CLI features. Refer to `AI-ISSUES.md` for a detailed technical description.

## How to Build

The project is built using Haxe and its `.hxml` build system.

1.  **Ensure Haxe and Haxelib are installed and configured correctly.**
    *   If experiencing `Type not found` errors, especially for standard libraries like `sys.Sys`, ensure your Haxe installation is not corrupted. Running `haxelib fixrepo` and updating `haxelib` (`haxelib --global update haxelib`) might be necessary, but the Forge CLI currently still faces an environmental compilation issue.

2.  **Compile the project:**
    ```bash
    haxe build.hxml
    ```
    *Note: Currently, the Forge CLI compilation will fail due to the `sys.Sys` error. The Viewer application should compile successfully.*

## How to Run

### Forge CLI (Currently Blocked for Compilation)

Once the compilation issue for the Forge CLI is resolved, you can use it for various tasks:

-   **Generate Spiral Data:**
    ```bash
    /usr/local/bin/hl bin/forge.hl generate-spiral assets/spiral.gst
    ```
-   **Ingest PLY File (converts to GST):**
    ```bash
    /usr/local/bin/hl bin/forge.hl ingest-ply assets/input.ply assets/output.gst
    ```
-   **Compress GST File:**
    ```bash
    /usr/local/bin/hl bin/forge.hl compress assets/input.gst assets/compressed.gst
    ```
-   **Uncompress GST File:**
    ```bash
    /usr/local/bin/hl bin/forge.hl uncompress assets/compressed.gst assets/uncompressed.gst
    ```

### AxiumGST Viewer

The Viewer application can be run successfully (assuming `build.hxml` compiles the viewer target):

```bash
/usr/local/bin/hl bin/viewer.hl
```
**Camera Controls in Viewer:**
-   **Movement:** `W` (forward), `S` (backward), `A` (left), `D` (right), `E` (up), `Q` (down)
-   **Rotation:** `Arrow Keys` (up/down for pitch, left/right for yaw)

## Next Steps (Blocked Development)

Further development on the Forge CLI is blocked by the `Type not found : sys.Sys` compilation error. Once this environment issue is resolved, the planned next steps for **Phase 2: The Forge (Data Pipeline)** include:

-   Implementing compression algorithms (quantization, Zlib) - *Zlib code is implemented but blocked by compilation.*
-   Integrating with the JDA (JSON Digital Asset) format.

Further tasks for **Phase 1: The Core (Proof of Concept)**, such as advanced rendering techniques, will proceed once the environment is stable for both targets.
