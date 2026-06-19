# Source-Control Policy

`G:\Dx` is a hub repository. Child folders are independent repositories.

## Branches

- `main` is the release branch.
- `dev` is the integration branch.
- Feature branches should use meaningful names such as `codex/archive-policy` or `codex/ci-standardization`.

## Remotes

- `origin` should point to the primary GitHub repository under `millercarla211-ctrl` for DX-managed work.
- `gitlab` should point to the GitLab mirror after the GitHub state is clean.
- `bitbucket` should point to the Bitbucket mirror after the GitHub state is clean.
- `upstream` should point to the external project for forks and should be treated as fetch-first.
- `legacy` should point to old personal or historical remotes that must not be the default push target.
- Local filesystem remotes should be named `local-mirror` and treated as recovery references, not release targets.

Consumer cloud drives such as Google Drive and Mega should not sync active `.git` directories. Use them for tested bundles, manifests, receipts, and encrypted disaster-recovery archives.

## Mirror Order

1. Make the GitHub `origin` clean and complete.
2. Push `main`, `dev`, tags, and Git LFS objects to GitHub.
3. Add GitLab and Bitbucket mirrors one clean repo at a time.
4. Verify a fresh clone from each mirror before marking the mirror trusted.
5. Create `git bundle` and zip/offline snapshots only after the repo state is known.

Use [`gitlab-mirror-policy.md`](gitlab-mirror-policy.md) and
`scripts/sync-gitlab-mirrors.ps1` for GitLab mirror creation.

## Dirty Worktrees

- Do not run broad reset or checkout commands.
- Do not stage unrelated files.
- Commit only coherent changes that belong to one task.
- If a repo is dirty and behind its remote, integrate through a clean worktree or explicit patch plan.
- Do not rename remotes, push mirrors, or create cloud-drive archives from dirty high-blast-radius repos until a WIP preservation snapshot exists.

## Release Rule

No repo is release-qualified until:

- working tree is clean or intentionally documented
- `dev` has passed required checks
- `main` is promoted from verified `dev`
- release tag or receipt identifies the promoted commit
