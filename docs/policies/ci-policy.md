# CI Policy

GitHub Actions are currently paused for the DX ecosystem. Do not dispatch, enable, or add active workflows until the user explicitly reopens remote CI.

The target state remains that each active DX-managed repository has a lightweight GitHub Actions workflow that runs on `main`, `dev`, and pull requests once CI is reopened.

CircleCI is the active candidate for cross-platform binary builds while GitHub Actions stays paused. The release rules, artifact naming, sibling-repository checkout model, and rollout order live in [`circleci-release-policy.md`](circleci-release-policy.md).

## Rust Repositories

Recommended gates:

- `cargo fmt --all -- --check`
- `cargo check --locked --all-targets --all-features`
- `cargo clippy --locked --all-targets --all-features -- -D warnings`
- `cargo test --locked --all-features`

When onboarding CI for an existing repo with known formatting or lint debt, `cargo check` and `cargo test` should be the first blocking gates. Formatting and clippy may run as advisory steps until the debt is cleared, then they should become blocking gates.

If a repository has no `Cargo.lock`, either commit one for applications or document why the repository is a publishable library.

## JavaScript And TypeScript Repositories

Recommended gates:

- install with the lockfile command: `npm ci`, `pnpm install --frozen-lockfile`, or `bun install --frozen-lockfile`
- run `typecheck` when present
- run `lint` when present
- run targeted tests when present

## Branches

DX-managed workflows should trigger on both `main` and `dev`. Upstream forks may preserve upstream branch names, but any DX-specific workflow must include `dev`.

CircleCI release jobs must keep heavyweight Windows and macOS builds opt-in until the project is ready to spend remote credits deliberately. The default branch workflow should run a Linux source check only.

## Runner Policy

Custom runners must have a documented hosted-runner fallback smoke check. A production gate that only works on a private runner is not portable enough for the hub.
