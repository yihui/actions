# setup-r-dependencies

Installs and caches R package dependencies for an R package repository **using
base R only** (no pak, no rcmdcheck). It reads `DESCRIPTION`, installs all
listed dependency packages, and saves the resulting library to the GitHub
Actions cache so that subsequent runs are faster.

## Key features

- Pure base-R dependency resolution — no extra packages required (e.g., pak, rcmdcheck, sessioninfo).
- Split cache (restore + save as separate steps) so the cache is **always
  saved**, even when a later step in the workflow fails.
- Automatically finds the `DESCRIPTION` file by searching the repository
  recursively when `working-directory` is not set.
- `system-packages` input installs the same package list on all platforms;
  OS-specific inputs are available when names differ between platforms.
- Also updates any outdated packages already in the cache library.

## Inputs

| Input | Default | Description |
|---|---|---|
| `dependencies` | `Depends, Imports, LinkingTo, Suggests` | DESCRIPTION field names to install (comma-separated). Dependencies specified in the `Remotes` field of the package `DESCRIPTION` will be installed via `remotes::install_github()`. |
| `extra-packages` | | Additional R packages to install beyond DESCRIPTION (space- or comma-separated). The special value `.` means to install the package in this repository. Values containing `/` will be treated as GitHub packages and installed via `remotes::install_github()`. |
| `r-universe` | | Space- or comma-separated names of r-universe, e.g. `cran bioc-release`. If provided, values are used to set `options(repos)` to the corresponding r-universe.dev repositories. |
| `working-directory` | | Directory containing the `DESCRIPTION` file. If empty, the first `DESCRIPTION` found recursively is used. |
| `system-packages` | | System packages to install on **all** platforms via apt-get / Homebrew / Chocolatey (space-separated). |
| `apt-packages` | | Additional system packages for Linux only (apt-get). |
| `brew-packages` | | Additional system packages for macOS only (Homebrew). |
| `choco-packages` | | Additional system packages for Windows only (Chocolatey). |
| `cache-key-suffix` | | Optional suffix appended to the cache key (with a `-` separator) to allow separate caches for the same OS and R version (e.g., container image, CPU architecture). |

## Example usage

Basic usage — installs all packages from `DESCRIPTION` automatically:

```yaml
- uses: r-lib/setup-r@v2

- uses: yihui/actions/setup-r-dependencies@main
```

Install extra R packages and use r-universe repositories:

```yaml
- uses: yihui/actions/setup-r-dependencies@main
  with:
    extra-packages: mime tinyimg
    r-universe: cran bioc-release yihui
```

Install a system dependency that has the same name on all platforms:

```yaml
- uses: yihui/actions/setup-r-dependencies@main
  with:
    system-packages: pandoc
```

Install a system dependency with different names on different platforms:

```yaml
- uses: yihui/actions/setup-r-dependencies@main
  with:
    apt-packages: libxml2-dev
    brew-packages: libxml2
```
