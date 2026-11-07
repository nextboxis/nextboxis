#!/usr/bin/env bash
# Run from the root of your Pishentry clone. Stops tracking large generated
# artifacts (they stay on disk) and ignores them going forward.
set -euo pipefail

cat >> .gitignore << 'IGN'

# generated / large artifacts
*.pkl
*.webm
tests/playwright_reports/
reports/*.pdf
*.pdf
IGN

git rm -r --cached --ignore-unmatch \
  tests/playwright_reports \
  tests/*.pkl training/*.pkl \
  frai-8-1496580.pdf reports/*.pdf

git commit -m "chore: stop tracking generated models, videos and PDFs"
echo "Done. Publish trained models as GitHub Release assets instead (and load via a download script)."
echo "Note: history still contains these files (.git is ~42 MB); use git filter-repo only if you want to shrink it."
