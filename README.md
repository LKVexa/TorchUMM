## TorchUMM Overhaul (Junkyard Chop Shop)

This release applies a compatibility, reliability, and packaging-focused cleanup pass across the project.

### What Changed

- Repacked the repository after removing generated cache artifacts (`__pycache__`, `.pyc`, build noise) from distributed payloads.
- Hardened configuration loading and override parsing for safer, more predictable CLI behavior.
- Fixed text-to-image RNG handling so a caller-provided generator is no longer overridden.
- Added stricter validation for multimodal inference inputs (shapes, payload types, required fields).
- Improved batcher validation to reject invalid `batch_size` values (non-integers like bool/float/string).
- Refined CLI command resolution for `infer`, `eval`, and `train` flows with clearer errors and safer route handling.
- Added atomic JSON write behavior for safer output persistence.
- Updated packaging metadata and project config:
  - `pyproject.toml` (versioning, package metadata/discovery/data rules)
  - `MANIFEST.in`
- Added supporting files:
  - `.github/workflows/test.yml`
  - `docs/development.md`
  - `src/umm/cli/check.py`

### Verification

- **Tests:** 55 passed (`39` subtests)
- **Build/install checks:** wheel + sdist build and install smoke checks passed
- **Scope:** Changes are local repo/package stability and CLI/runtime reliability; GPU/distributed/model-checkpoint-heavy paths were not fully exercised in this pass.
