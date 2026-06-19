# Artifact Policy

The DX root contains source repositories, pinned tools, generated files, runtime receipts, and quarantine payloads. Names alone are not enough to decide what can be moved or ignored.

## Classes

- `source-repo`: a Git working tree or bare repository that owns source history.
- `rebuildable-artifact`: generated output that can be recreated from source and documented commands.
- `receipt-record`: logs, screenshots, JSON receipts, or smoke output that validate a prior run.
- `pinned-tool`: installed tooling intentionally kept for reproducible local workflows.
- `trash-payload`: quarantined content that must stay recoverable until reviewed.
- `junction-reference`: a filesystem link that should be stored as link metadata, not followed content.

## Rules

- Classify with validation: Git marker, manifest entry, package metadata, timestamps, and owner docs.
- Do not delete or move by folder name alone.
- Keep rebuildable artifacts out of Git unless a child repo explicitly requires fixtures.
- Keep receipt records small and structured when they need backup.
- Keep pinned tools outside source commits and document their provenance when possible.
