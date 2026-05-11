# Release process

Before creating a new release tag, update all `yihui/actions/...@vX.Y.Z`
references in README and example files to point to the new tag being released.
Files to update:

- `README.md`
- `check-r-package/README.md`
- `setup-r-dependencies/README.md`

External action tags (e.g., `actions/cache`, `actions/upload-artifact`) in
action.yaml files are managed by Dependabot and should not be changed manually
during releases.

# Testing

The test workflow (`.github/workflows/test.yml`) runs on every push and PR. It
uses a minimal R package at `tests/pkg/` to exercise both actions across all
three platforms (ubuntu, macos, windows). The test package covers dependency
installation (Imports + Suggests), tests, and vignette building.
