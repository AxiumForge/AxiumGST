#!/usr/bin/env bash
set -euo pipefail

# Extract text + images from a PDF into docs/refs/<name>/ folder.
# Requires: PyMuPDF (aka fitz) (pip install pymupdf).

ROOT="/Users/larsmathiasen/REPO/AxiumGST/docs/refs"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<EOF
Usage: $(basename "$0") <input.pdf>
Outputs to: $ROOT/<pdf-basename>/index.md and images/ inside that folder.
EOF
}

INPUT="${1:-}"
if [[ -z "$INPUT" ]] || [[ "$INPUT" == "-h" ]] || [[ "$INPUT" == "--help" ]]; then
  usage
  exit 0
fi

if [[ ! -f "$INPUT" ]]; then
  echo "Input PDF not found: $INPUT" >&2
  exit 1
fi

BASE="$(basename "$INPUT")"
NAME="${BASE%.*}"
OUT_DIR="$ROOT/$NAME"
OUT_MD="$OUT_DIR/index.md"
IMG_DIR="$OUT_DIR/images"

python - <<'PY'
try:
    import fitz  # PyMuPDF  # noqa: F401
except Exception as e:
    raise SystemExit("Missing dependency: PyMuPDF (fitz)\nInstall with: pip install pymupdf")
PY

mkdir -p "$OUT_DIR" "$IMG_DIR"

# Extract text and images per page, writing markdown with inline image links.
python - "$INPUT" "$OUT_MD" "$IMG_DIR" <<'PY'
import sys, os, fitz
pdf_path, md_path, img_dir = sys.argv[1], sys.argv[2], sys.argv[3]
doc = fitz.open(pdf_path)

def save_pixmap(pix, out_path):
    # Normalize to RGB, drop alpha if needed, fallback if save fails.
    if pix.n not in (1, 3, 4):
        pix = fitz.Pixmap(fitz.csRGB, pix)
    if pix.alpha and pix.colorspace is not None:
        pix = fitz.Pixmap(pix, 0)
    try:
        pix.save(out_path)
    except ValueError:
        pix = fitz.Pixmap(fitz.csRGB, pix)
        pix.save(out_path)

with open(md_path, "w", encoding="utf-8") as md:
    for page_index, page in enumerate(doc, start=1):
        text = page.get_text("text") or ""
        text = text.replace("\r\n", "\n").replace("\r", "\n").strip()
        md.write(f"<!-- Page {page_index} -->\n")
        md.write(text + "\n\n")

        images = page.get_images(full=True)
        if images:
            md.write(f"#### Page {page_index} Images\n\n")
        for img_index, img in enumerate(images, start=1):
            xref = img[0]
            pix = fitz.Pixmap(doc, xref)
            out_name = f"page{page_index:03d}_img{img_index:02d}.png"
            out_path = os.path.join(img_dir, out_name)
            save_pixmap(pix, out_path)
            md.write(f"![{out_name}](images/{out_name})\n\n")

print(f"Wrote {md_path} with inline image references; images in {img_dir}")
PY
echo "Done."
