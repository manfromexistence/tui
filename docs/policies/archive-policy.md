# Archive Policy

`G:\Dx\trash` is a quarantine and recovery area. It is not a deletion queue and it is not part of the active source tree.

## Rules

- Move questionable folders into timestamped quarantine folders only after writing a manifest.
- Preserve folder contents exactly when moving active or dirty repositories.
- Never delete a repository, worktree, or large artifact without an inventory and explicit approval.
- Keep archive names factual: `root-folder-removals-YYYYMMDD-HHMMSS`, `worktree-snapshots-YYYYMMDD-HHMMSS`, or `artifact-quarantine-YYYYMMDD-HHMMSS`.
- Do not run broad search or build tools through `trash` unless the task is specifically archive review.
- Treat stale `.git` files, missing worktree backing directories, and junction targets as facts to record, not cleanup permission.
- Do not classify a folder by name alone. A folder named `build`, `bin`, `tmp`, or `tools` can still be source or pinned tooling.

## Required Manifest Before Deletion

Before any delete decision, create a manifest with:

- original path
- archive path
- date moved
- reason moved
- Git status if the item is a repository
- approximate size
- restore command
- deletion approval status

## Backup Rule

Cloud backups should exclude `trash` by default. Archive manifests should be backed up; raw archive payloads should be kept locally until reviewed.

## Junction Rule

Junctions and other reparse points should be backed up as link records. Do not follow them during archive inventory, backup packaging, or deletion review.
