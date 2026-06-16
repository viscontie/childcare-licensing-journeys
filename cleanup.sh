#!/bin/bash
# cleanup.sh — Remove Claude artifacts, docs, and unused files
# Run from the root of your cloned childcare-licensing-journeys repo
# Usage: bash cleanup.sh

set -e

ROOT="$(pwd)"

echo "🧹 Starting cleanup of $ROOT"
echo ""

# Safety check
if [ ! -f "$ROOT/package.json" ] || [ ! -d "$ROOT/src" ]; then
  echo "❌ This doesn't look like the right repo. Run this from the repo root."
  exit 1
fi

# ── Claude tooling artifacts ──────────────────────────────────────────────────
echo "→ Removing Claude tooling artifacts..."
rm -rf .claude
rm -f .skill
rm -f CLAUDE.md
rm -f AUDIT_REPORT.md
rm -f dependency-rules.json

# ── Docs & research ───────────────────────────────────────────────────────────
echo "→ Removing docs and research files..."
rm -f CHANGELOG.md
rm -f DATA_COLLECTION.md
rm -rf docs/
rm -rf media/
rm -rf reference-data/
rm -f scripts/gen-changelog.mjs

# Remove scripts dir if now empty
[ -d scripts ] && [ -z "$(ls -A scripts)" ] && rmdir scripts && echo "   (removed empty scripts/)"

# ── Changelog data ────────────────────────────────────────────────────────────
echo "→ Removing changelog data..."
rm -f src/lib/data/releases.json

# Remove data dir if now empty
[ -d src/lib/data ] && [ -z "$(ls -A src/lib/data)" ] && rmdir src/lib/data && echo "   (removed empty src/lib/data/)"

# ── Personal pages (original author) ─────────────────────────────────────────
echo "→ Removing contact and methodology pages..."
rm -rf src/routes/contact/
rm -rf src/routes/methodology/

# ── Likely unused UI components (verify before deleting) ─────────────────────
echo ""
echo "⚠️  The following files are likely unused but should be verified first."
echo "   Check that nothing imports them before deleting:"
echo ""

MAYBE_UNUSED=(
  "src/lib/components/TopNavbar.svelte"
  "src/lib/components/ui/sidebar"
  "src/lib/components/RealisticHUD.svelte"
)

for f in "${MAYBE_UNUSED[@]}"; do
  if [ -e "$ROOT/$f" ]; then
    # Search for imports of this file
    NAME=$(basename "$f" .svelte)
    HITS=$(grep -r "$NAME" "$ROOT/src" --include="*.svelte" --include="*.ts" -l 2>/dev/null | grep -v "$f" || true)
    if [ -z "$HITS" ]; then
      echo "   ✅ No imports found for: $f — safe to delete"
      read -p "      Delete it now? [y/N] " confirm
      if [[ "$confirm" =~ ^[Yy]$ ]]; then
        rm -rf "$ROOT/$f"
        echo "      Deleted."
      fi
    else
      echo "   ⚠️  $f is imported by:"
      echo "$HITS" | sed 's/^/        /'
      echo "      Skipping."
    fi
  fi
done

echo ""
echo "✅ Cleanup complete!"
echo ""
echo "Next steps:"
echo "  1. Run 'npm install' to make sure deps are still good"
echo "  2. Run 'npm run dev' to confirm the app still works"
echo "  3. Run 'npm test' to confirm tests still pass"
echo "  4. Commit: git add -A && git commit -m 'chore: remove Claude artifacts and unused files'"