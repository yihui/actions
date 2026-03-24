# actions

Miscellaneous GitHub Actions for R package development.

## Actions

### `setup-r-dependencies`

Installs and caches R package dependencies for an R package repository **using
base R only** (no pak). It reads `DESCRIPTION`, installs all listed dependency
packages, and saves the resulting library to the GitHub Actions cache so that
subsequent runs are faster.

Key features:

- Pure base-R dependency resolution — no extra tooling required.
- Split cache (restore + save as separate steps) so the cache is **always
  saved**, even when a later step in the workflow fails.
- Per-OS inputs for system dependencies so you can supply the correct package
  name for each platform (e.g. `pandoc` vs `r-cran-pandoc`).
- Handles the zstd and tar compatibility issues on Windows that affect
  `actions/cache` (Rtools ships an incompatible `zstd`; Rtools35 ships
  `tar 1.30` which is incompatible with the cache format).

#### Inputs

| Input | Default | Description |
|---|---|---|
| `cache-version` | `1` | Increment to clear the existing cache. |
| `dependencies` | `Depends, Imports, LinkingTo, Suggests` | DESCRIPTION field names to install (comma-separated). |
| `extra-packages` | | Additional R packages to install beyond DESCRIPTION (space- or comma-separated). |
| `working-directory` | `.` | Directory containing the `DESCRIPTION` file. |
| `apt-packages` | | System packages to install via **apt-get** on Linux. |
| `brew-packages` | | System packages to install via **Homebrew** on macOS. |
| `choco-packages` | | System packages to install via **Chocolatey** on Windows. |

#### Example usage

```yaml
- uses: r-lib/setup-r@v2

- uses: yihui/actions/setup-r-dependencies@main
  with:
    # Install pandoc on each platform using the correct package name:
    apt-packages: pandoc
    brew-packages: pandoc
    choco-packages: pandoc
```

Cross-platform system dependencies with different package names:

```yaml
- uses: yihui/actions/setup-r-dependencies@main
  with:
    apt-packages: libcurl4-openssl-dev libssl-dev
    brew-packages: curl openssl
    # Windows typically ships curl; no choco-packages needed here
    extra-packages: rcmdcheck
    cache-version: 2
```

---

### `check-r-package`

Checks an R package using `R CMD build` and `R CMD check` directly — no
`rcmdcheck` package required. Both the build and check flags are fully
customisable.

Key features:

- Runs `R CMD build` followed by `R CMD check` on the produced tarball.
- Sets `_R_CHECK_FORCE_SUGGESTS_=false` and `_R_CHECK_CRAN_INCOMING_=false`
  as sensible defaults (override by passing the flags explicitly in
  `check-args`).
- Shows `testthat` output after the check (even on failure).
- Optionally uploads check results as a workflow artifact.

#### Inputs

| Input | Default | Description |
|---|---|---|
| `build-args` | `--no-build-vignettes` | Arguments passed to `R CMD build`. |
| `check-args` | `--no-manual` | Arguments passed to `R CMD check`. |
| `check-dir` | `check` | Directory for check output (relative to `working-directory`). |
| `working-directory` | `.` | Directory containing the R package source. |
| `upload-results` | `failure` | When to upload check results: `failure`, `always`, or `never`. |
| `artifact-name` | | Override the default artifact name (`<OS>-r-check-results`). |

#### Example usage

```yaml
- uses: r-lib/setup-r@v2

- uses: yihui/actions/setup-r-dependencies@main

- uses: yihui/actions/check-r-package@main
```

Stricter CRAN-style check:

```yaml
- uses: yihui/actions/check-r-package@main
  with:
    build-args: '--no-build-vignettes'
    check-args: '--no-manual --as-cran'
    upload-results: always
```

---

## Full workflow example

```yaml
on: [push, pull_request]

jobs:
  check:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
    steps:
      - uses: actions/checkout@v4

      - uses: r-lib/setup-r@v2

      - uses: yihui/actions/setup-r-dependencies@main
        with:
          apt-packages: pandoc
          brew-packages: pandoc
          choco-packages: pandoc

      - uses: yihui/actions/check-r-package@main
        with:
          check-args: '--no-manual --as-cran'
```

## License

[CC0 1.0 Universal](LICENSE) — public domain dedication.
