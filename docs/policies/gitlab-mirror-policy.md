# GitLab Mirror Policy

GitLab is a secondary recovery mirror for DX repositories. GitHub remains the
primary `origin` remote unless the source-control policy is changed explicitly.

## Mirror Shape

- Keep `origin` pointed at GitHub.
- Add GitLab as a separate remote named `gitlab`.
- Keep `main` as the stable branch and `dev` as the active integration branch.
- Create GitLab projects as private by default.
- Push Git LFS objects for repositories that use LFS.

## Authentication

Use a GitLab personal access token or project/group token through environment
variables only:

```powershell
$env:GITLAB_TOKEN = '<token>'
$env:GITLAB_NAMESPACE = '<username-or-group>'
```

Do not store tokens inside Git remotes. The mirror script uses a temporary
askpass helper so `gitlab` remotes stay clean HTTPS URLs.

## Operating Rules

Run a dry pass first:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\sync-gitlab-mirrors.ps1 -DryRun
```

For an auditable dry-run report:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\sync-gitlab-mirrors.ps1 -DryRun -OutputPath .\.dx\manifests\gitlab-mirror-dry-run.json
```

Then mirror one clean batch:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\sync-gitlab-mirrors.ps1 -PushLfs -OutputPath .\.dx\manifests\gitlab-mirror-sync.json
```

Dirty repositories should be reviewed before mirroring. Use `-AllowDirty` only
when the goal is to back up committed history immediately while separately
tracking uncommitted local work.

## Verification

After a mirror pass, verify each repository has:

- GitHub `origin`
- GitLab `gitlab`
- `main` pushed to GitLab when present
- `dev` pushed to GitLab when present
- Git LFS objects pushed when the repository uses LFS

Run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verify-gitlab-mirrors.ps1 -OutputPath .\.dx\manifests\gitlab-mirror-verify.json
```

Do not enable GitLab CI until the DX CI policy is reopened.
