# agents.md

agent instructions for AI coding assistants working in this repository.

## project

spec-md is a static astro site that presents the spec-md format. the content is the spec itself, so most changes are markdown or astro pages.

## commands

```bash
make help      # list make targets
make dev       # start the astro dev server
make build     # build the static site to dist/
make test      # check the site builds; there are no unit tests, a clean build is the check
```

## guidelines

- run `make test` before pushing
- keep `SPEC.md` as the technical blueprint and `README.md` as the user manual; do not mix them
- the only workflow is the deploy on push to `main`; do not add more without a reason, runners cost minutes
- do not commit secrets, tokens or credentials
- no co-author trailers in commits

## structure

- `src/` the astro pages and components
- `template/` and `examples/` the spec-md template and sample documents
- `astro.config.mjs` the astro config
- `.github/workflows/deploy.yml` the deploy
