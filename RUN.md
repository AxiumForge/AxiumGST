# Running AxiumGST Binaries

This document provides instructions on how to run the compiled HashLink binaries for the AxiumGST project.

## Prerequisites

To run HashLink binaries (`.hl` files), you need the HashLink runtime installed and accessible in your system's PATH. On this system, the executable is `hl`.

**Installation (if `hl` command is not found):**
1.  **Download:** Visit the official HashLink website (https://hashlink.io/) and download the appropriate version for your operating system.
2.  **Install:** Follow the installation instructions provided on the HashLink website. This typically involves extracting the archive and adding the directory containing the `hl` executable to your system's PATH environment variable.
    *   **On macOS/Linux:** You might add a line like `export PATH="/path/to/hashlink:$PATH"` to your `~/.bashrc`, `~/.zshrc`, or equivalent shell configuration file, and then run `source ~/.bashrc` (or `~/.zshrc`) to apply the changes.
    *   **On Windows:** You can add the HashLink installation directory to your system's PATH through the System Properties.

## Running the Forge CLI

The Forge CLI (`forge.hl`) is responsible for tasks like generating synthetic data.

To generate the spiral Gaussian splats:
```bash
/usr/local/bin/hl bin/forge.hl
```
After running this command, a file named `spiral.gst` should be created in the `assets/` directory.

## Running the Viewer Application

The Viewer application (`viewer.hl`) is used to display Gaussian Splats.

To run the viewer:
```bash
/usr/local/bin/hl bin/viewer.hl
```
*Note: The viewer application currently contains only a basic Heaps setup and will not display any Gaussian splats yet. This functionality will be implemented in later steps.*
