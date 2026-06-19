# Backup Exclusion Policy

Git remotes are the primary backup for source. Cloud drives and zip snapshots are secondary recovery layers and should not store rebuildable bulk by default.

## Exclude By Default

- `trash`
- `node_modules`
- `target`
- `target-*`
- `.next`
- `dist`
- `coverage`
- `.cache`
- `.tmp`
- `.turbo`
- `.pytest_cache`
- `__pycache__`
- `.dx\cache`
- `.dx\runtime`
- `.dx\smoke`
- `.dx\tmp`

## Include By Default

- Git repositories through their remotes.
- Root hub governance files.
- `docs\policies`
- `scripts`
- `AGENTS.md`
- `CURRENT_STATUS.md`
- `DX_MANAGER_MEMORY.md`
- `.dx\launch-workspace.toml`
- `.dx\manifests`
- Small JSON, JSONL, TOML, and Markdown receipts that identify exact commits and restore steps.

## Cloud Drive Rule

Back up source as Git history first. Use Google Drive, Mega, and zip archives for manifests, receipts, and encrypted/offline snapshots. Do not mirror raw dirty working trees into cloud drives.
