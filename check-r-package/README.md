# check-r-package

Checks an R package using `R CMD build` and `R CMD check` directly — no
`rcmdcheck` package required. Both the build and check flags are fully
customizable.

## Key features

- Runs `R CMD build` followed by `R CMD check` on the produced tarball.
- Automatically finds the package source by searching the repository
  recursively when `working-directory` is not set.
- Builds the tarball into the parent directory of the package source and runs
  `R CMD check` from there (no `check-dir` option needed).
- Sets `_R_CHECK_FORCE_SUGGESTS_=false`, `_R_CHECK_CRAN_INCOMING_=false`, and
  `_R_CHECK_TESTS_NLINES_=0` (show full test output) as sensible defaults.
- Fails the job if `R CMD check` produces any WARNINGs or NOTEs (in addition
  to ERRORs), by inspecting the `Status:` line of the check log.
- Uploads the `*.Rcheck` directory as a workflow artifact named
  `<OS>-r-check-results` on failure.

## Inputs

| Input | Default | Description |
|---|---|---|
| `build-args` | | Arguments passed to `R CMD build`. |
| `check-args` | `--no-manual --as-cran` | Arguments passed to `R CMD check`. |
| `working-directory` | | Directory containing the R package source. If empty, the first `DESCRIPTION` found recursively is used. |

## Example usage

Basic usage with default check arguments:

```yaml
- uses: r-lib/setup-r@v2

- uses: yihui/actions/setup-r-dependencies@main

- uses: yihui/actions/check-r-package@main
```

Custom build arguments:

```yaml
- uses: yihui/actions/check-r-package@main
  with:
    build-args: '--no-build-vignettes'
    check-args: '--no-manual --no-vignettes --as-cran'
```
