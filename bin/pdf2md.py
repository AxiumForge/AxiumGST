#!/usr/bin/env python3
"""
pdf2md: Extract text from a PDF into a Markdown-friendly .md file.
Requires the pure-Python `pypdf` package (`pip install pypdf`).
"""

import argparse
from pathlib import Path
import sys


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Extract text from a PDF and write it to a Markdown file."
    )
    parser.add_argument("pdf", help="Input PDF file")
    parser.add_argument(
        "-o",
        "--output",
        help="Output .md file (defaults to the input name with .md extension)",
    )
    args = parser.parse_args()

    pdf_path = Path(args.pdf).expanduser().resolve()
    if not pdf_path.is_file():
        parser.error(f"Input PDF not found: {pdf_path}")

    if args.output:
        out_path = Path(args.output).expanduser().resolve()
    else:
        out_path = pdf_path.with_suffix(".md")

    try:
        import pypdf  # type: ignore
    except ImportError:
        sys.stderr.write(
            "Missing dependency: pypdf\n"
            "Install with: pip install pypdf\n"
        )
        return 1

    reader = pypdf.PdfReader(str(pdf_path))

    chunks = []
    for page_index, page in enumerate(reader.pages, start=1):
        text = page.extract_text() or ""
        normalized = text.replace("\r\n", "\n").replace("\r", "\n").strip()
        chunks.append(f"<!-- Page {page_index} -->\n{normalized}\n")

    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text("\n\n".join(chunks), encoding="utf-8")
    print(f"Wrote {out_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
