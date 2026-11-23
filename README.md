# fraboeni-website (private source)

Source of https://franziska-boenisch.de. Layout based on Adam's site (Jalpc theme).
This repo stays **private**. Only the built site goes to the public repo `fraboeni.github.io`.

```text
Code/
|-- academic-records/      publications.bib + talks.bib (single source of truth)
|-- fraboeni-website/      this repo: source, drafts, scripts
`-- fraboeni.github.io/    public repo: built HTML only (written by deploy.sh)
```

## One-time setup

macOS ships Ruby 2.6, which is too old for Jekyll (`bundle install` fails with "requires ruby version >= 3.0").
Install a current Ruby with Homebrew and put it first on your PATH:

```bash
brew install ruby
echo 'export PATH="$(brew --prefix ruby)/bin:$PATH"' >> ~/.zshrc
echo 'export PATH="$(ruby -e "print Gem.bindir"):$PATH"' >> ~/.zshrc
source ~/.zshrc
ruby -v                    # should now print 3.x or 4.x
```

Then, in this folder:

```bash
gem install bundler
bundle install             # installs Jekyll (see Gemfile)
git init && git add -A && git commit -m "initial"   # then add a PRIVATE GitHub remote if you like
```

## Daily use

| Command | What it does |
|---|---|
| `bash serve.sh` | syncs publications, then live preview at http://localhost:4000 |
| `bash build.sh` | syncs publications, builds the final site into `docs/` (nothing is pushed) |
| `bash deploy.sh` | build, replace the content of `../fraboeni.github.io` with `docs/`, show the diff, **ask** before commit + push |

## Where to change what

| What | File |
|---|---|
| Bio text, email, social links | `_config.yml` (`author.desc` etc.) |
| Order / visibility of homepage sections | `_data/landing.yml` (talks section is commented out) |
| Experience | `_data/index/experience.yml` |
| Teaching samples (cards) | `_data/teaching.yml`; pages in `teaching/`, files in `static/assets/teaching/` |
| Publications | **not here**: edit `../academic-records/publications.bib`, the scripts sync it |
| Selected publications on the homepage | `selected = {true}` in `publications.bib` |
| Styles | `static/css/custom.scss` (additions at the bottom) |
| Impressum | `impressum.md` |

Old URLs are kept: `/trees/`, `/lstms/`, `/diffie-hellman/`, `/datamodel/` and the PDFs under `/files/`.

## GitHub Pages

`deploy.sh` writes `CNAME` (franziska-boenisch.de) and `.nojekyll` into the public repo, so GitHub serves the
built files as they are. Keep the Pages setting of `fraboeni.github.io` on "Deploy from a branch: master / (root)".
