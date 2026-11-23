#!/usr/bin/env bash
# Preview the website locally at http://localhost:4000 (reloads when you edit files).
# First time only:  bundle install
set -euo pipefail
cd "$(dirname "$0")"

# Jekyll 4 needs Ruby >= 3.0. macOS ships Ruby 2.6 in /usr/bin, which is too old.
if ! ruby -e 'exit(RUBY_VERSION.split(".").first.to_i >= 3)' 2>/dev/null; then
  echo "Your shell uses Ruby $(ruby -e 'print RUBY_VERSION' 2>/dev/null) from $(command -v ruby). Jekyll needs Ruby >= 3."
  echo "Fix once:  brew install ruby   and add Homebrew's Ruby to your PATH (see README.md, 'One-time setup')."
  exit 1
fi

# Refresh publication data from the single source of truth, if it is next to this folder.
if [ -f ../academic-records/sync.py ]; then
  python3 ../academic-records/sync.py --no-cv
fi

bundle exec jekyll serve --livereload --destination _site
