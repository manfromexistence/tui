# CircleCI Binary Release Foundation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a safe CircleCI release foundation for DX Rust tools without touching dirty child repos or triggering heavyweight local builds.

**Architecture:** The DX hub remains the governance and automation source. Child repositories receive CircleCI configs only when clean, because they own their own Git history and several depend on sibling repositories through Cargo path dependencies. A hub script generates per-repo CircleCI configs from explicit project profiles so every release job uses the same branch, artifact, dependency checkout, and checksum rules.

**Tech Stack:** PowerShell, CircleCI 2.1 config, Rust/Cargo, GitHub-backed sibling checkout, GitHub/GitLab mirrored branch policy.

---

### Task 1: CircleCI Release Policy

**Files:**
- Create: `G:\Dx\docs\policies\circleci-release-policy.md`
- Modify: `G:\Dx\docs\policies\ci-policy.md`
- Modify: `G:\Dx\README.md`

- [x] **Step 1: Document the release architecture**

Create `docs/policies/circleci-release-policy.md` with the rollout phases, dependency layout, artifact naming, checksum, branch, and context requirements.

- [x] **Step 2: Link the policy from the CI policy**

Add a CircleCI section to `docs/policies/ci-policy.md` that keeps GitHub Actions paused while allowing CircleCI as the active binary-build lane.

- [x] **Step 3: Fix stale editor naming in the hub README**

Update `README.md` from `zed` to `code` for the local editor folder while noting the remote repository may still be named `zed`.

### Task 2: CircleCI Config Generator

**Files:**
- Create: `G:\Dx\scripts\write-circleci-rust-release-config.ps1`

- [x] **Step 1: Add explicit project profiles**

Support the first safe Rust release targets: `serializer`, `check`, `cli`, `style`, and `forge`.

- [x] **Step 2: Generate dependency-aware CircleCI YAML**

Generate a `.circleci/config.yml` that checks out sibling Cargo path dependencies before `cargo check` or release builds.

- [x] **Step 3: Keep release builds opt-in**

Use a `release_artifacts` pipeline parameter so Windows/macOS/Linux release jobs do not run by default.

### Task 3: Lightweight Validation Harness

**Files:**
- Create: `G:\Dx\scripts\test-circleci-rust-release-config.ps1`

- [x] **Step 1: Generate configs into a temp directory**

The test harness must not write into child repos unless the caller explicitly runs the generator separately.

- [x] **Step 2: Validate configs with CircleCI when available**

Run `circleci config validate` for generated configs only when the CLI is present and the machine is not above the CPU safety threshold.

- [x] **Step 3: Support source-only validation**

Allow `-SkipCircleCi` for a no-network/no-CLI syntax smoke path.

### Task 4: Verification And Commit

**Files:**
- Verify the changed hub files only.

- [x] **Step 1: Run lightweight source checks**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\test-circleci-rust-release-config.ps1 -SkipCircleCi
```

Expected: all configured project profiles generate `.circleci/config.yml` files in a temporary directory.

- [ ] **Step 2: Run CircleCI config validation if CPU allows**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\test-circleci-rust-release-config.ps1
```

Expected: generated configs validate with `circleci config validate`.

Status: deferred while the local machine reported 100 percent CPU with active `dx-www` and `rustc` processes. Do not force this until the machine is calm.

- [ ] **Step 3: Commit and sync the hub**

Stage only the new/updated hub files and commit:

```powershell
git add README.md docs/policies/ci-policy.md docs/policies/circleci-release-policy.md docs/superpowers/plans/2026-06-10-circleci-binary-release-foundation.md scripts/write-circleci-rust-release-config.ps1 scripts/test-circleci-rust-release-config.ps1
git commit -m "Add CircleCI release foundation"
git push origin dev
git push gitlab dev
```
