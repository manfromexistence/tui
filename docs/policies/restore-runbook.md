# Restore Runbook

This runbook defines how to recover the DX ecosystem from source control and documented local artifacts.

## Source Restore Order

1. Clone the hub repository.
2. Read `README.md` and `CURRENT_STATUS.md`.
3. Clone child repositories listed in the hub status.
4. Check out `dev` for active integration work.
5. Pull Git LFS objects where configured.
6. Restore pinned local tools only from documented tool repos or manifests.
7. Restore quarantined folders from `G:\Dx\.dx\manifests` entries, without following junction targets.
8. Rebuild generated outputs from source instead of restoring `target`, `node_modules`, `.next`, or cache folders.

If a manifest reports a stale worktree pointer, restore the files first and repair Git metadata separately. Do not run `git worktree prune` as part of restore.

## Multi-Remote Policy

- GitHub is the primary cloud source for active DX-managed repositories.
- GitLab and Bitbucket mirrors may be added as read-only or push mirrors after GitHub state is clean.
- Google Drive, Mega, and similar cloud drives are for encrypted archive bundles and manifests, not active Git working trees.

## Mirror Verification

1. Fresh clone GitHub, GitLab, and Bitbucket mirrors into temporary restore folders.
2. Verify `main`, `dev`, tags, and expected commit SHAs match the hub manifest.
3. Run `git fsck --full`.
4. Run `git lfs pull` and `git lfs fsck` for LFS repositories.
5. Confirm generated artifact folders are not tracked surprises.
6. Verify offline bundles with `git bundle verify` before trusting Drive, Mega, or zip backups.

## Rebuildable Exclusions

Do not back up these as source:

- `target`
- `node_modules`
- `.next`
- `dist`
- `build`
- `.tmp`
- transient `.dx` cache subtrees

Keep receipts and manifests when they are needed for audit history.
