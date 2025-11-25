Her er et formelt projektdokument for **AxiumGST**, skræddersyet til samarbejdet mellem Lars (Arkitekt/User), DevOps (System/Pipeline) og Gemini (Lead Coder).

Dokumentet definerer rammen for udviklingen af Gaussian Splatting modulet i AxiumForge økosystemet.

---

# Projektdokument: AxiumGST (Gaussian Splat Transform)

**Projekt:** AxiumGST – En del af AxiumForge Frameworket
**Dato:** 25. November 2025
**Team:**
* **Lars:** Product Owner, Arkitekt & Lead User.
* **Gemini:** AI Lead Developer (Code Generation, Algorithms, Optimization).
* **DevOps:** Automation, Build Pipelines, CLI Integration.

---

## 1. Indsigt (Insight)
**Baggrund:**
Moderne 3D-grafik bevæger sig væk fra ren polygon-baseret rendering mod hybride løsninger. AxiumForge er allerede etableret som et SDF (Signed Distance Field) og CSG (Constructive Solid Geometry) framework. Der mangler dog en effektiv måde at håndtere "støjende", virkelige data (f.eks. scanninger, røg, ild, komplekse organiske overflader), som SDF har svært ved at repræsentere billigt.

**Problemet:**
Eksisterende Gaussian Splatting tools er ofte monolitiske, Python-tunge og svære at integrere i en custom game-engine pipeline. Rå `.ply` filer er for tunge til runtime-brug, og der mangler en bro til AxiumForges JSON Digital Asset (JDA) format.

**Erkendelse:**
Ved at kombinere SDF (til hård geometri/struktur) med Gaussian Splatting (til detaljer/volumen) i en samlet Haxe/C++ pipeline, kan vi opnå en visuel kvalitet og performance, der overgår standardløsninger, styret af en stærk CLI.

---

## 2. Hensigt (Intent)
**Vision:**
At skabe **AxiumGST** – en højtydende, CLI-drevet pipeline, der konverterer, komprimerer og renderer Gaussian Splats som native assets i AxiumForge.

**Mål:**
1.  **Pipeline Kontrol:** Erstatte tunge eksterne værktøjer med en letvægts CLI ("The Forge"), der kan scriptes og køres headless.
2.  **Data Ejerskab:** Definere og implementere `.gst` og `.jda` (JSON Digital Assets) som proprietære formater optimeret til Heaps/Haxe.
3.  **Hybrid Rendering:** Muliggøre en viewer, der kan vise Gaussian Splats korrekt sorteret og belyst (Tracer Light/SH) side om side med SDF geometri.
4.  **Hastighed:** Udnytte Haxe's evne til at kompilere til C++ for maksimal I/O og regnekraft.

---

## 3. Metode (Method)
Vi arbejder efter en **Agil "Prompt-to-Code"** metode.

**Arbejdsfordeling:**
* **Lars** definerer arkitekturen, datastrukturerne (JDA) og succeskriterierne.
* **Gemini** skriver kernen af koden (Haxe/C++/Shaders), troubleshooter matematikken og sikrer best-practice implementering.
* **DevOps** (integreret rolle) sikrer, at værktøjerne kan bygge via scripts (`.hxml`), og at CLI'en virker som "limen" i pipelinen.

**Teknisk Stack:**
* **Sprog:** Haxe (Target: C++ / HL).
* **Engine:** Heaps (High Performance Graphics).
* **Shading:** HXSL (Haxe Shader Language) kompileret til GLSL/HLSL.
* **Data:** Custom Binary Formats (Big Endian/Little Endian streams) pakket i JDA JSON containere.

**Udviklings-Loop:**
1.  Lars beskriver en feature (f.eks. "Vi skal pakke farver som bytes").
2.  Gemini genererer den fulde, kørbare kildekode (CLI + Viewer).
3.  Lars kompilerer og kører (Build & Run).
4.  Feedback loop -> Optimering.

---

## 4. Faser (Phases)

### Fase 1: The Core (Proof of Concept) – *Status: I gang*
* Etablering af projektstruktur (CLI vs. Viewer).
* Definition af binært format (`.gst`).
* Generering af syntetiske test-data (Tornado/Spiral).
* Simpel Viewer med Point Rendering.
* **Leverance:** En app der viser en roterende punktsky.

### Fase 2: The Forge (Data Pipeline)
* **Ingest:** Implementere CLI kommandoer til at læse eksterne formater (`.ply`).
* **Compression:** Implementere quantization (floats til bytes) og Zlib komprimering.
* **JDA Integration:** Pakke binær data ind i AxiumForge JSON formatet med SDF Bounds.
* **Leverance:** `AxiumForge.exe` der kan konvertere en 500MB `.ply` fil til en 50MB `.jda` fil.

### Fase 3: The View (Advanced Rendering)
* **Splatting Shader:** Skifte fra punkter til Quads/Billboards.
* **Gaussian Math:** Implementere korrekt alpha-fading baseret på covariance (rund/oval form).
* **Sorting:** Implementere CPU eller GPU-baseret Radix Sort (kritisk for transparens).
* **Leverance:** En viewer der viser "bløde", sammenhængende objekter, ikke bare prikker.

### Fase 4: The Hybrid (Tracer Light & SDF)
* **Lighting:** Implementere Spherical Harmonics (SH) support i data og shader for realistisk lys.
* **Integration:** Flette GST vieweren ind i AxiumForges eksisterende SDF Raymarcher.
* **Depth Composite:** Sikre at Splats og SDF-figurer klipper hinanden korrekt via Depth Bufferen.
* **Leverance:** Fuld AxiumForge demo med SDF-maskiner og GST-røg/effekter.

---

## 5. Produkter (Deliverables)

Projektet resulterer i følgende konkrete artefakter:

### A. AxiumForge CLI (The Tool)
En kompileret binary (`.exe` / native binary), der fungerer som "Swiss Army Knife".
* `forge ingest <video>`
* `forge convert <ply> <jda>`
* `forge optimize <quality_level>`

### B. AxiumGST Viewer (The Engine)
En Heaps-baseret applikation (kan integreres i hovedspillet), der indeholder:
* `GSTRenderer.hx`: Håndterer batches og GPU-upload.
* `SplatShader.hx`: Den matematiske kerne for visualiseringen.

### C. Specifikationer
* **JDA Format Spec (v1):** Dokumentation af JSON strukturen og Base64 payloaden.
* **AxSL Extension:** Udvidelse af shader-sproget til at understøtte `sampleSplatField()`.

---

**Næste Skridt:**
Skal vi fortsætte direkte med **Fase 1 (kode implementering)** og få bygget det binære skelet, som vi aftalte i forrige prompt?