# actions

Miscellaneous GitHub Actions for R package development.

## Actions

- [**setup-r-dependencies**](setup-r-dependencies/) — Installs and caches R
  package dependencies using base R only (no pak). Reads `DESCRIPTION`,
  installs all listed dependency packages, and saves the resulting library to
  the GitHub Actions cache.

- [**check-r-package**](check-r-package/) — Checks an R package using
  `R CMD build` and `R CMD check` directly (no rcmdcheck). Both build and
  check flags are fully customizable.

- [**litedown-site**](litedown-site/) — Builds an R package documentation
  site with litedown, including the description, news, manuals, vignettes,
  citation, and an interactive playground.

## Quick start

```yaml
- uses: actions/checkout@v4
- uses: r-lib/setup-r@v2
- uses: yihui/actions/setup-r-dependencies@v1.1.6
- uses: yihui/actions/check-r-package@v1.1.6
```

## License

[CC0 1.0 Universal](LICENSE) — public domain dedication.
