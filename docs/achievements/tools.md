# DX Tools Achievements

`tools` is the DX external-tool payload repository. It keeps bulky third-party
runtime helpers out of the main source story while still making those helpers
recoverable through Git and Git LFS.

## Position

Tools should be the operational payload workstream for DX: a place to preserve
browser automation engines, database CLIs, helper binaries, and generated shell
completions without mixing those artifacts into source-code achievement wording.

Professional positioning:

> Tools is a clean, separate Git repository for large external tool payloads,
> with Git LFS rules for Playwright and Turso artifacts, a small Playwright
> screenshot helper package, Turso database CLI material, and Turso cloud CLI
> binaries/completions.

That positioning is intentionally about custody and organization. It does not say
the bundled binaries were executed, security-audited, production-approved, or
part of the repository-level archive.

## What Tools Has Already Achieved

| Area | Achievement |
| --- | --- |
| Separate repository | Keeps external payloads in `G:\Dx\tools` with its own `origin` remote, `main`, and `dev` branches so the root hub can reference it without absorbing binary churn. |
| Clean branch model | The `dev` branch is clean and aligned with `origin/dev`; `main`, `origin/main`, and `origin/dev` point at the initial tools artifact snapshot. |
| LFS boundary | Tracks `ms-playwright/**`, `turso-cli/**`, and `turso-cloud-cli/**` through Git LFS according to `.gitattributes`. |
| Browser automation payload | Preserves Playwright Chromium, Chromium headless shell, FFmpeg, WinLDD, installation markers, and dependency-validation markers under `ms-playwright`. |
| Screenshot helper package | Keeps `node-screenshot/package.json` as a small module dependency surface for Playwright-based screenshot work. |
| Turso database CLI payload | Preserves Turso Database CLI material including `README.md`, `CHANGELOG.md`, `LICENSE.md`, `tursodb.exe`, and `turso_cli.zip`. |
| Turso cloud CLI payload | Preserves a Linux `turso` binary, release tarball, and Bash/Fish/Zsh completion scripts under `turso-cloud-cli`. |
| Production caution | Keeps Turso's own beta/not-production-ready warning visible in the retained README rather than presenting the database payload as DX production infrastructure. |
| Source archive boundary | Gives DX a clear place to exclude bulky rebuildable or third-party payloads from repository-level backup archives while still retaining a restorable tools snapshot. |

## validation To Check

Use these files and commands before repeating exact wording:

| validation | Purpose |
| --- | --- |
| `tools/.gitattributes` | Confirms Git LFS tracking for Playwright and Turso payload folders. |
| `git -C G:\Dx\tools lfs ls-files` | Confirms the current tracked artifact set is in LFS. |
| `tools/node-screenshot/package.json` | Confirms the small Playwright dependency package. |
| `tools/ms-playwright/*/INSTALLATION_COMPLETE` | Confirms Playwright payload installation markers exist in this snapshot. |
| `tools/turso-cli/README.md` | Documents Turso Database purpose, MCP mode, and beta/not-production-ready warning. |
| `tools/turso-cli/tursodb.exe` and `tools/turso-cli/turso_cli.zip` | Windows Turso database CLI payloads present in this checkout. |
| `tools/turso-cloud-cli/turso` and `tools/turso-cloud-cli/turso-cli_Linux_x86_64.tar.gz` | Linux Turso cloud CLI payloads present in this checkout. |
| `tools/turso-cloud-cli/completions/*.bash|*.fish|*.zsh` | Shell completion payloads present in this checkout. |

No binary was executed during this documentation pass. The validation is about
tracked presence, branch cleanliness, LFS custody, and documentation boundaries.

## Public Positioning Boundary

Safe internal statement:

> Tools preserves external DX helper payloads in a clean, LFS-backed repository
> so browser automation and database CLI artifacts can be restored without
> polluting repository-level documentation or archive wording.

Safe public wording after refreshed checks:

> A tools statement may describe which artifacts are tracked, which paths are LFS
> managed, which branch and remote hold the snapshot, and which binaries were
> explicitly executed or verified in a separate receipt.

Unsafe statement without more verification:

> The tool binaries are secure, current, production-ready, working on this
> machine, covered by DX tests, or appropriate for repository-level backup archives.

The strongest current achievement is storage discipline: DX can keep useful
external payloads available while keeping the main source ecosystem honest about
what is code, what is third-party binary material, and what must be excluded
from rebuildable/repository-level archive wording.

## Documentation Status

The active source/tool folder documentation pass is complete. Operational
folders such as `.dx`, `.github`, `docs`, `scripts`, and `trash` are covered in
the ecosystem register rather than separate achievement pages. Future passes
should only add new pages when new root folders become active repository-managed DX
workspaces.
