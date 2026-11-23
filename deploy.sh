#!/usr/bin/env bash
# Publish the website.
#
#   1. builds the site into docs/ (via build.sh)
#   2. copies ONLY the built files into the public repo ../fraboeni.github.io
#      (everything else there is replaced; .git and CNAME are kept)
#   3. shows what changed and asks before committing and pushing anything
#
# This private source repo (drafts, scripts, data) never reaches the public repo.
set -euo pipefail
cd "$(dirname "$0")"
SRC="$(pwd)"
PUBLIC="${PUBLIC_REPO:-../fraboeni.github.io}"
DOMAIN="franziska-boenisch.de"
STAMP=$(date "+%Y-%m-%d %H:%M")

[ -d "$PUBLIC/.git" ] || { echo "Public repo not found at $PUBLIC"; exit 1; }

bash build.sh

echo
echo "Copying docs/ -> $PUBLIC"
# remove the previous public content (except .git), then copy the fresh build
find "$PUBLIC" -mindepth 1 -maxdepth 1 ! -name .git -exec rm -rf {} +
cp -R docs/. "$PUBLIC"/
echo "$DOMAIN" > "$PUBLIC/CNAME"
touch "$PUBLIC/.nojekyll"          # serve the files as they are, no second Jekyll run on GitHub

cd "$PUBLIC"
git add -A
if git diff --cached --quiet; then
  echo "Public site unchanged. Nothing to publish."
  exit 0
fi
echo
git diff --cached --stat | tail -n 25
echo
read -r -p "Commit and push these changes to $(git remote get-url origin)? [y/N] " ok
if [[ "$ok" =~ ^[Yy]$ ]]; then
  git commit -q -m "deploy $STAMP"
  git push origin HEAD
  echo "Published. GitHub Pages updates in about a minute."
else
  echo "Not pushed. The changes are staged in $PUBLIC; run 'git reset' there to undo."
fi

# Optionally also commit the private source repo
cd "$SRC"
if [ -d .git ] && [ -n "$(git status --porcelain)" ]; then
  read -r -p "Also commit (and push) the private source repo? [y/N] " ok2
  if [[ "$ok2" =~ ^[Yy]$ ]]; then
    git add -A && git commit -q -m "deploy $STAMP"
    git remote get-url origin >/dev/null 2>&1 && git push || echo "(no remote configured, committed locally)"
  fi
fi
