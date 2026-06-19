# DX Production Hardening Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make `G:\Dx` a professional, tracked, recoverable ecosystem hub while preserving child repository work and avoiding heavy local builds.

**Architecture:** `G:\Dx` becomes a small governance repository that tracks root docs, policies, and lightweight audit scripts. Child folders remain independent repositories and are ignored by the hub Git repository.

**Tech Stack:** Git, GitHub CLI, PowerShell, GitHub Actions, Rust/Cargo metadata, Node package metadata.

---

### Task 1: Hub Tracking

**Files:**
- Create: `G:\Dx\.gitignore`
- Create: `G:\Dx\.gitattributes`
- Create: `G:\Dx\.rgignore`
- Create: `G:\Dx\README.md`
- Create: `G:\Dx\CURRENT_STATUS.md`

- [ ] Create ignore rules that exclude child repositories, `.dx`, `trash`, and rebuildable artifacts.
- [ ] Add a concise root README that states the hub model and first-ten-minute workflow.
- [ ] Add current status with root counts, dirty repos, and safe next actions.
- [ ] Initialize `G:\Dx` as a Git repository on `main`.
- [ ] Commit the hub governance files.
- [ ] Create a private GitHub repository named `dx-platform-hub`.
- [ ] Push `main`, create `dev`, push `dev`, and leave the local checkout on `dev`.

### Task 2: Archive And Restore Policy

**Files:**
- Create: `G:\Dx\docs\policies\archive-policy.md`
- Create: `G:\Dx\docs\policies\restore-runbook.md`

- [ ] Document that `trash` is a quarantine area, not a deletion queue.
- [ ] Define archive folder naming, required manifest fields, and deletion approval rules.
- [ ] Document restore order: clone repos, pull LFS, restore tool artifacts, rebuild generated outputs.
- [ ] Commit archive and restore policy docs.

### Task 3: Source-Control And CI Policy

**Files:**
- Create: `G:\Dx\docs\policies\source-control-policy.md`
- Create: `G:\Dx\docs\policies\ci-policy.md`
- Create: `G:\Dx\.github\workflows\hub-audit.yml`

- [ ] Define `dev` as integration and `main` as release for DX-owned repos.
- [ ] Define `origin` as cloud primary, `upstream` as external source, and local filesystem remotes as mirrors.
- [ ] Define a standard lightweight CI gate for Rust repos.
- [ ] Add a hub workflow that validates root docs and scripts without checking child repos.
- [ ] Commit source-control and CI policy docs.

### Task 4: Maintainability Guardrails

**Files:**
- Create: `G:\Dx\docs\policies\maintainability-policy.md`
- Create: `G:\Dx\scripts\audit-hub.ps1`
- Create: `G:\Dx\scripts\check-maintainability.ps1`

- [ ] Document file-size, naming, placeholder, and test-organization rules.
- [ ] Add a read-only hub audit script that reports child repo status without running builds.
- [ ] Add a read-only maintainability script with thresholds and professional naming checks.
- [ ] Commit maintainability docs and scripts.

### Task 5: Dirty Repo Triage

**Files:**
- Modify only child repos after checking each repo status and diff.

- [ ] Triage `www` and `flow` first because they have the highest blast radius.
- [ ] For each dirty repo, classify changes as user work, generated output, move fallout, or commit candidate.
- [ ] Commit only coherent changes with explicit path staging.
- [ ] Push only after targeted verification.

### Task 6: Child Repo CI Standardization

**Files:**
- Create `.github/workflows/ci.yml` only in child repos that lack CI and have a clear lightweight command set.

- [ ] Start with clean DX-owned Rust repos.
- [ ] Add branch triggers for `main` and `dev`.
- [ ] Use lightweight GitHub Actions checks; avoid local heavy builds during this pass.
- [ ] Commit and push one repo at a time.

### Task 7: Naming And Oversized File Remediation

**Files:**
- Rename or split only after repository-specific inspection.

- [ ] Replace `forge vibe-demo` with a professional command name and compatibility alias if needed.
- [ ] Split oversized files only behind focused tests or source guards.
- [ ] Preserve public compatibility unless a repo already documents a breaking-change window.

### Verification

- [ ] Run `pwsh .\scripts\audit-hub.ps1`.
- [ ] Run `pwsh .\scripts\check-maintainability.ps1`.
- [ ] Run `git status -sb` in the hub and changed child repos.
- [ ] Run targeted repo checks only when CPU is low and the check is needed for the change.
