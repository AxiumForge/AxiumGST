#!/usr/bin/env bash
set -euo pipefail

# Bound screenshot helper for the Heaps app window only.
# Default process name is "Heaps"; override with HEAPS_APP env var (comma-separated list allowed).

usage() {
  cat <<'EOF'
Usage: ./screenshot.sh

Tager et screenshot af det første vindue for en kørende Heaps/HL viewer.

Options:
  -h, --help   Vis denne hjælp

Env:
  HEAPS_APP     Komma-separeret liste af procesnavne at matche (default: Heaps,hl,viewer)
  HEAPS_DISPLAY Skærmnummer til fallback capture (1=primær). Brug hvis vindues-id ikke findes.

Note: Start viewer først, fx: hl bin/viewer.hl
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

# Build candidate process names: env override, then common fallbacks for HL/Heaps
IFS=',' read -r -a APP_CANDIDATES <<< "${HEAPS_APP:-Heaps}"
APP_CANDIDATES+=("hl" "viewer" "Heaps")
APP_NAME=""

# Pick the first running candidate
for cand in "${APP_CANDIDATES[@]}"; do
  if pgrep -x "${cand}" >/dev/null 2>&1; then
    APP_NAME="${cand}"
    break
  fi
done

if [[ -z "${APP_NAME}" ]]; then
  echo "No running process found (checked: ${APP_CANDIDATES[*]}). Start viewer (hl bin/viewer.hl) or set HEAPS_APP." >&2
  exit 1
fi

# Bring the process frontmost to ensure the window is in current workspace
osascript -e 'tell application "System Events" to set frontmost of process "'"${APP_NAME}"'" to true' >/dev/null 2>&1 || true
sleep 0.3

OUT_DIR="/Users/larsmathiasen/REPO/AxiumGST/sc" # forced output dir
STAMP="$(date +"%Y%m%d-%H%M%S")"
OUT_FILE="${OUT_DIR}/heaps-${STAMP}.png"

mkdir -p "${OUT_DIR}"

# Grab the first window id of the Heaps process
WIN_ID="$(osascript -e 'tell application "System Events" to get the id of first window of process "'"${APP_NAME}"'"' 2>/dev/null || true)"
if [[ -n "${WIN_ID}" ]]; then
  echo "Capturing window ${WIN_ID} from process ${APP_NAME} -> ${OUT_FILE}"
  screencapture -x -l "${WIN_ID}" "${OUT_FILE}"
  echo "Saved screenshot: ${OUT_FILE}"
  exit 0
fi

DISPLAY_ID="${HEAPS_DISPLAY:-}"
if [[ -n "${DISPLAY_ID}" ]]; then
  echo "No window id found for process: ${APP_NAME}; capturing display ${DISPLAY_ID}." >&2
  screencapture -x -D "${DISPLAY_ID}" "${OUT_FILE}"
  echo "Saved screenshot: ${OUT_FILE}"
  exit 0
fi

echo "No window id found for process: ${APP_NAME}; capturing displays (fallback)." >&2
CAPTURED=false
for d in 1 2 3; do
  TMP_OUT="${OUT_FILE%.png}-D${d}.png"
  if screencapture -x -D "${d}" "${TMP_OUT}" >/dev/null 2>&1; then
    echo "Saved display ${d}: ${TMP_OUT}"
    CAPTURED=true
  fi
done

if [[ "${CAPTURED}" != true ]]; then
  echo "Failed to capture specific displays; capturing main display." >&2
  screencapture -x -m "${OUT_FILE}"
  echo "Saved screenshot: ${OUT_FILE}"
fi
