#!/usr/bin/env bash
# Build the website into docs/ (exactly what deploy.sh publishes). Nothing is pushed.
# Open docs/index.html or run serve.sh to look at it.
set -euo pipefail
cd "$(dirname "$0")"

# Jekyll 4 needs Ruby >= 3.0. macOS ships Ruby 2.6 in /usr/bin, which is too old.
if ! ruby -e 'exit(RUBY_VERSION.split(".").first.to_i >= 3)' 2>/dev/null; then
  echo "Your shell uses Ruby $(ruby -e 'print RUBY_VERSION' 2>/dev/null) from $(command -v ruby). Jekyll needs Ruby >= 3."
  echo "Fix once:  brew install ruby   and add Homebrew's Ruby to your PATH (see README.md, 'One-time setup')."
  exit 1
fi

if [ -f ../academic-records/sync.py ]; then
  python3 ../academic-records/sync.py --no-cv
fi

rm -rf docs
JEKYLL_ENV=production bundle exec jekyll build --destination docs
echo
echo "Built into $(pwd)/docs  ($(du -sh docs | cut -f1))"
