# CircleCI Release Policy

CircleCI is the DX ecosystem's preferred remote build workstream while GitHub Actions remains paused. This policy covers binary builds for DX-managed Rust tools. It does not make the editor fork release-qualified by itself.

## Scope

The first release targets are small Rust tools with explicit binary outputs:

- `serializer`: `dx-serialize`
- `check`: `dx-check-web-audit`
- `cli`: `dx`
- `style`: `dx-style`, `analyze_styles`
- `forge`: `forge`

`code`, `www`, and upstream-derived research forks need separate release plans because they have larger dependency graphs, platform packaging requirements, and active dirty-work risk.

## Repository Model

`G:\Dx` is a hub, not a monorepo. Child folders are separate Git repositories. A CircleCI config inside a child repo receives only that child checkout by default, but several DX crates use sibling Cargo path dependencies such as `../serializer` and `../check`.

Production CircleCI configs must therefore prepare the expected DX sibling layout before running Cargo. The approved approach is:

1. Check out the target repository.
2. Clone required sibling repositories beside it.
3. Prefer the current CircleCI branch when it exists.
4. Fall back to `dev`.
5. Run locked source checks or release builds from the target repository.

Private repositories require a CircleCI context secret named `DX_GITHUB_TOKEN`. Public repositories may clone without it.

## Branches

- `dev` is the active integration branch.
- `main` is the release branch.
- Generated CircleCI configs must include both `dev` and `main`.
- Heavy release builds must be opt-in through the `release_artifacts` pipeline parameter.

## Artifact Names

Release artifacts must include the project, platform, architecture, and commit prefix:

```text
<project>-<platform>-<architecture>-<short-sha>.tar.gz
<project>-<platform>-<architecture>-<short-sha>.zip
SHA256SUMS.txt
```

Use:

- `linux-x86_64`
- `windows-x86_64`
- `macos-arm64`

Additional targets can be added only after the first three pass consistently.

## Verification Gates

Default branch checks should stay light:

```powershell
cargo metadata --locked --no-deps --format-version 1
cargo check --locked --all-targets
```

Release jobs may run:

```powershell
cargo build --locked --release --bin <binary>
```

Do not add clippy, full tests, benchmarks, notarization, signing, or packaging installers to the first rollout. Those are separate gates after basic binary production is proven.

## Low-End Machine Rule

Local work should generate and validate CircleCI configuration only. Local cross-platform builds are not required and should not be attempted while CPU load is high.

The safe local verification is:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\test-circleci-rust-release-config.ps1 -SkipCircleCi
```

Run CircleCI validation only when the machine is calm:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\test-circleci-rust-release-config.ps1
```

## Rollout Order

1. Generate and validate configs from the hub.
2. Apply the config to `serializer`.
3. Apply the config to `check`.
4. Apply the config to `cli`.
5. Apply the config to `style`.
6. Apply the config to `forge`.
7. Design separate plans for `www` and `code`.

Never apply a CircleCI config to a dirty child repo unless the dirty files are assigned to the same task and have been reviewed.
