# actions

Miscellaneous GitHub Actions for R package development.

## Actions

### `setup-r-dependencies`

Installs and caches R package dependencies for an R package repository **using
base R only** (no pak). It reads `DESCRIPTION`, installs all listed dependency
packages, and saves the resulting library to the GitHub Actions cache so that
subsequent runs are faster.

Key features:

- Pure base-R dependency resolution — no extra packages required (e.g., pak, rcmdcheck, sessioninfo).
- Split cache (restore + save as separate steps) so the cache is **always
  saved**, even when a later step in the workflow fails.
- Per-OS inputs for system dependencies so you can supply the correct package
  name for each platform (e.g. `libxml2-dev` on Linux vs `libxml2` on macOS).

#### Inputs

| Input | Default | Description |
|---|---|---|
| `dependencies` | `Depends, Imports, LinkingTo, Suggests` | DESCRIPTION field names to install (comma-separated). |
| `extra-packages` | | Additional R packages to install beyond DESCRIPTION (space- or comma-separated). |
| `working-directory` | | Directory containing the `DESCRIPTION` file. If empty, the first `DESCRIPTION` found recursively is used. |
| `system-packages` | | System packages to install on **all** platforms via apt-get / Homebrew / Chocolatey (space-separated). |
| `apt-packages` | | System packages for Linux only (apt-get). |
| `brew-packages` | | System packages for macOS only (Homebrew). |
| `choco-packages` | | System packages for Windows only (Chocolatey). |

#### Example usage

```yaml
- uses: r-lib/setup-r@v2

- uses: yihui/actions/setup-r-dependencies@main
  with:
    extra-packages: mime tinyimg
```

---

### `check-r-package`

Checks an R package using `R CMD build` and `R CMD check` directly — no
`rcmdcheck` package required. Both the build and check flags are fully
customisable.

Key features:

- Runs `R CMD build` followed by `R CMD check` on the produced tarball.
- Sets `_R_CHECK_FORCE_SUGGESTS_=false`, `_R_CHECK_CRAN_INCOMING_=false`, and
  `_R_CHECK_TESTS_NLINES_=0` (show full test output) as sensible defaults.
- Uploads the `*.Rcheck` directory as a workflow artifact on failure.

#### Inputs

| Input | Default | Description |
|---|---|---|
| `build-args` | | Arguments passed to `R CMD build`. |
| `check-args` | `--no-manual --as-cran` | Arguments passed to `R CMD check`. |
| `working-directory` | | Directory containing the R package source. If empty, the first `DESCRIPTION` found recursively is used. |

#### Example usage

```yaml
- uses: r-lib/setup-r@v2

- uses: yihui/actions/setup-r-dependencies@main

- uses: yihui/actions/check-r-package@main
```

## License

[CC0 1.0 Universal](LICENSE) — public domain dedication.
